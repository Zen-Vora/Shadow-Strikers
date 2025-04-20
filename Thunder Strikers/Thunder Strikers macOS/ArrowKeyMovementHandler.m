#import "ArrowKeyMovementHandler.h"
#import "GameController.h"

@interface ArrowKeyMovementHandler ()

@property (weak, nonatomic) GameController *gameController;

@end

@implementation ArrowKeyMovementHandler

- (instancetype)initWithGameController:(GameController *)controller {
    self = [super init];
    if (self) {
        _gameController = controller;
    }
    return self;
}

// macOS Key Down Event Handling
- (void)keyDown:(NSEvent *)event {
    switch ([event keyCode]) {
        case 123: // Left arrow key
            [self.gameController movePlaneByX:-1 y:0];
            break;
        case 124: // Right arrow key
            [self.gameController movePlaneByX:1 y:0];
            break;
        case 126: // Up arrow key
            [self.gameController movePlaneByX:0 y:1];
            break;
        case 125: // Down arrow key
            [self.gameController movePlaneByX:0 y:-1];
            break;
        default:
            break;
    }
}
@end
