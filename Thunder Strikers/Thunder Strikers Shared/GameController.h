//
//  GameController.h
//  Thunder Strikers Shared
//
//  Created by Zen Vora on 4/20/25.
//

#import <SceneKit/SceneKit.h>


@interface GameController : NSObject <SCNSceneRendererDelegate>

@property (strong, readonly) SCNScene *scene;
@property (strong, readonly) id <SCNSceneRenderer> sceneRenderer;

- (instancetype)initWithSceneRenderer:(id <SCNSceneRenderer>)sceneRenderer;

- (void)highlightNodesAtPoint:(CGPoint)point;

@end
