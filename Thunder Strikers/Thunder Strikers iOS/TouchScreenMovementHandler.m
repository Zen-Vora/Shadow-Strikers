#import "TouchScreenMovementHandler.h"
#import "GameController.h"

@interface TouchScreenMovementHandler ()

@property (weak, nonatomic) GameController *gameController;

@end

@implementation TouchScreenMovementHandler

- (instancetype)initWithGameController:(GameController *)controller {
    self = [super init];
    if (self) {
        _gameController = controller;
    }
    return self;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint currentLocation = [touch locationInView:touch.view];
    CGPoint previousLocation = [touch previousLocationInView:touch.view];

    CGFloat deltaX = currentLocation.x - previousLocation.x;
    CGFloat deltaY = currentLocation.y - previousLocation.y;

    // Update the plane position
    [self.gameController movePlaneByX:deltaX y:deltaY];
}
@end
