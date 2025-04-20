//
//  GameController.m
//  Thunder Strikers Shared
//
//  Created by Zen Vora on 4/20/25.
//

#import "GameController.h"

@interface GameController ()

@property (strong, nonatomic) SCNNode *shipNode;

@end

@implementation GameController

- (instancetype)initWithSceneRenderer:(id<SCNSceneRenderer>)sceneRenderer {
    self = [super init];
    if (self) {
        self.sceneRenderer = sceneRenderer;
        self.sceneRenderer.delegate = self;

        // create a new scene
        SCNScene *scene = [SCNScene sceneNamed:@"Art.scnassets/ship.scn"];

        // retrieve the ship node
        self.shipNode = [scene.rootNode childNodeWithName:@"ship" recursively:YES];
        self.scene = scene;
        self.sceneRenderer.scene = scene;
    }
    return self;
}

// Method to move the plane
- (void)movePlaneByX:(CGFloat)x y:(CGFloat)y {
    SCNVector3 position = self.shipNode.position;
    position.x += x;
    position.y += y;
    self.shipNode.position = position;
}
@end
