#import "TouchScreenMovementHandler.h"

@implementation TouchScreenMovementHandler

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInView:touch.view];
        [self movePlayerTo:location];
    }
}

- (void)movePlayerTo:(CGPoint)location {
    NSLog(@"Player moving to position: %@", NSStringFromCGPoint(location));
}

@end