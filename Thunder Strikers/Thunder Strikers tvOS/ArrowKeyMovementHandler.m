#import "ArrowKeyMovementHandler.h"

@implementation ArrowKeyMovementHandler

// macOS Key Down Event Handling
- (void)keyDown:(NSEvent *)event {
    switch ([event keyCode]) {
        case 123: // Left arrow key
            [self movePlayerLeft];
            break;
        case 124: // Right arrow key
            [self movePlayerRight];
            break;
        case 126: // Up arrow key
            [self movePlayerUp];
            break;
        case 125: // Down arrow key
            [self movePlayerDown];
            break;
        default:
            break;
    }
}

// tvOS Key Command Handling
- (void)keyCommandHandler:(UIKeyCommand *)keyCommand {
    if ([keyCommand.input isEqualToString:UIKeyInputLeftArrow]) {
        [self movePlayerLeft];
    } else if ([keyCommand.input isEqualToString:UIKeyInputRightArrow]) {
        [self movePlayerRight];
    } else if ([keyCommand.input isEqualToString:UIKeyInputUpArrow]) {
        [self movePlayerUp];
    } else if ([keyCommand.input isEqualToString:UIKeyInputDownArrow]) {
        [self movePlayerDown];
    }
}

- (void)movePlayerLeft {
    NSLog(@"Player moving left");
}

- (void)movePlayerRight {
    NSLog(@"Player moving right");
}

- (void)movePlayerUp {
    NSLog(@"Player moving up");
}

- (void)movePlayerDown {
    NSLog(@"Player moving down");
}

@end