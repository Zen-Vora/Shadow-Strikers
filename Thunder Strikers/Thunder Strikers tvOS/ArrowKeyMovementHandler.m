#import "ArrowKeyMovementHandler.h"

@implementation ArrowKeyMovementHandler

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
