#if os(iOS)
import UIKit
#elseif os(macOS)
import AppKit
#endif
import SwiftUI
import RealityKit
import Combine


// MARK: - Main View

struct GameView: View {
    #if os(iOS)
    @State private var joystickDirection: SIMD2<Float> = .zero
    #elseif os(macOS)
    @State private var keyDirection: SIMD2<Float> = .zero
    #endif

    var body: some View {
        ZStack {
            RealityKitContainer(
                #if os(iOS)
                direction: joystickDirection
                #elseif os(macOS)
                direction: keyDirection
                #endif
            )
            .ignoresSafeArea()

            #if os(iOS)
            JoystickView(direction: $joystickDirection)
            #elseif os(macOS)
            Text("Use ←↑→ keys to move")
                .foregroundColor(.white)
                .padding()
                .background(Color.black.opacity(0.5))
                .cornerRadius(8)
                .position(x: 150, y: 50)
                .onReceive(KeyDirectionPublisher.shared.publisher) {
                    keyDirection = $0
                }
            #endif
        }
    }
}

// MARK: - Cross-Platform RealityKitContainer

#if os(iOS)
typealias PlatformViewRepresentable = UIViewRepresentable
#elseif os(macOS)
typealias PlatformViewRepresentable = NSViewRepresentable
#endif

struct RealityKitContainer: PlatformViewRepresentable {
    var direction: SIMD2<Float>

    #if os(iOS)
    func makeUIView(context: Context) -> GameContainer {
        context.coordinator.container
    }
    func updateUIView(_ uiView: GameContainer, context: Context) {
        uiView.direction = direction
    }
    #elseif os(macOS)
    func makeNSView(context: Context) -> GameContainer {
        context.coordinator.container
    }
    func updateNSView(_ nsView: GameContainer, context: Context) {
        nsView.direction = direction
    }
    #endif

    func makeCoordinator() -> Coordinator {
        Coordinator(direction: direction)
    }

    class Coordinator {
        let container: GameContainer
        init(direction: SIMD2<Float>) {
            container = GameContainer()
            container.direction = direction
        }
    }
}

// MARK: - GameContainer Core Game Logic

class GameContainer:
#if os(iOS)
    UIView
#elseif os(macOS)
    NSView
#endif
{
    let arView: ARView
    var player: ModelEntity!
    var camera: Entity!
    var direction: SIMD2<Float> = .zero
    var subscriptions = Set<AnyCancellable>()

    override init(
        #if os(iOS)
        frame: CGRect = .zero
        #elseif os(macOS)
        frame: NSRect = .zero
        #endif
    ) {
        arView = ARView(frame: frame, cameraMode: .nonAR, automaticallyConfigureSession: false)
        super.init(frame: frame)
        setupView()
        Task { await setupScene() }
        setupLoop()

        #if os(iOS)
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTap(_:)))
        arView.addGestureRecognizer(tap)
        #elseif os(macOS)
        NSEvent.addLocalMonitorForEvents(matching: [.keyDown]) { [weak self] event in
            KeyDirectionPublisher.shared.update(with: event)
            return event
        }
        NSEvent.addLocalMonitorForEvents(matching: [.keyUp]) { _ in
            KeyDirectionPublisher.shared.reset()
            return nil
        }
        #endif
    }

    required init?(coder: NSCoder) { fatalError("not supported") }

    func setupView() {
        addSubview(arView)
        arView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            arView.leadingAnchor.constraint(equalTo: leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: trailingAnchor),
            arView.topAnchor.constraint(equalTo: topAnchor),
            arView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])
    }

    @MainActor
    func setupScene() async {
        let anchor = AnchorEntity(world: .zero)
        arView.scene.addAnchor(anchor)

        if let model = try? await Entity.loadModel(named: "Player") {
            player = model
        } else {
            player = ModelEntity(
                mesh: .generateCapsule(height: 1, radius: 0.3),
                materials: [SimpleMaterial(color: .blue, isMetallic: false)]
            )
        }

        player.name = "Player"
        player.scale = SIMD3(repeating: 0.5)
        player.generateCollisionShapes(recursive: true)
        player.position = [0, 0.6, 0]
        anchor.addChild(player)

        let ground = ModelEntity(
            mesh: .generatePlane(width: 20, depth: 20),
            materials: [SimpleMaterial(color: .green, isMetallic: false)]
        )
        ground.generateCollisionShapes(recursive: true)
        anchor.addChild(ground)

        for i in 0..<5 {
            let b = ModelEntity(
                mesh: .generateBox(size: [1,2,1]),
                materials: [SimpleMaterial(color: .red, isMetallic: true)]
            )
            b.name = "EnemyBuilding_\(i)"
            b.position = [Float(i)*2.5 - 5, 1, -5]
            b.generateCollisionShapes(recursive: true)
            anchor.addChild(b)
        }

        camera = PerspectiveCamera()
        camera.name = "FollowCamera"
        camera.position = [0, 2, -4]
        anchor.addChild(camera)
    }

    func setupLoop() {
        arView.scene.subscribe(to: SceneEvents.Update.self) { [weak self] evt in
            self?.gameLoop(deltaTime: Float(evt.deltaTime))
        }.store(in: &subscriptions)
    }

    func gameLoop(deltaTime: Float) {
        moveRotate(deltaTime: deltaTime)
        followCam(deltaTime: deltaTime)
    }

    func moveRotate(deltaTime: Float) {
        guard let p = player, length(direction) > 0.05 else { return }

        let target = atan2(direction.x, direction.y)
        let currQ = simd_quatf(p.orientation)
        let currYaw = currentYaw(from: currQ)
        let diff = angleWrap(target - currYaw)
        let turnSpeed: Float = 6
        let clamped = max(min(diff, turnSpeed * deltaTime), -turnSpeed * deltaTime)
        p.orientation = simd_quatf(angle: currYaw + clamped, axis: [0, 1, 0])

        let forward = -normalize(SIMD3(p.transform.matrix.columns.2.x, 0, p.transform.matrix.columns.2.z))
        p.position += forward * 3 * deltaTime
    }

    func followCam(deltaTime: Float) {
        guard let p = player, let cam = camera else { return }
        let col2 = p.transform.matrix.columns.2
        let forward = SIMD3(col2.x, 0, col2.z) * -1
        let desired = p.position + forward * -4 + SIMD3(0, 2, 0)
        cam.position += (desired - cam.position) * min(5 * deltaTime, 1)
        cam.look(at: p.position, from: cam.position, relativeTo: nil)
    }

    func currentYaw(from q: simd_quatf) -> Float {
        atan2(2 * (q.imag.y * q.real), 1 - 2 * (q.imag.y * q.imag.y))
    }

    func angleWrap(_ a: Float) -> Float {
        var x = a
        while x > .pi { x -= 2 * .pi }
        while x < -.pi { x += 2 * .pi }
        return x
    }

    #if os(iOS)
    @objc func didTap(_ g: UITapGestureRecognizer) {
        if let en = arView.hitTest(g.location(in: arView)).first?.entity,
           en.name.starts(with: "EnemyBuilding") {
            destroy(entity: en)
        }
    }
    #endif

    func destroy(entity: Entity) {
        guard let m = entity as? ModelEntity else { return }
        m.model?.materials = [SimpleMaterial(color: .gray, isMetallic: false)]
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            entity.removeFromParent()
        }
    }
}

// MARK: - macOS Key Handling Support

#if os(macOS)
class KeyDirectionPublisher {
    static let shared = KeyDirectionPublisher()
    private let subject = PassthroughSubject<SIMD2<Float>, Never>()
    var publisher: AnyPublisher<SIMD2<Float>, Never> { subject.eraseToAnyPublisher() }

    private var currentDirection: SIMD2<Float> = .zero {
        didSet {
            subject.send(currentDirection)
        }
    }

    func update(with event: NSEvent) {
        switch event.keyCode {
        case 123: currentDirection = SIMD2(-1, 0)  // ←
        case 124: currentDirection = SIMD2(1, 0)   // →
        case 126: currentDirection = SIMD2(0, 1)   // ↑
        default: break
        }
    }

    func reset() {
        currentDirection = .zero
    }
}
#endif
