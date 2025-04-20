//
//  main.m
//  Thunder Strikers tvOS
//
//  Created by Zen Vora on 4/20/25.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ArrowKeyMovementHandler.h"

int main(int argc, char * argv[]) {
    NSString * appDelegateClassName;
    @autoreleasepool {
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);
        
        // Initialize movement handler for tvOS
        ArrowKeyMovementHandler *movementHandler = [[ArrowKeyMovementHandler alloc] init];
        
        // Register key commands (tvOS-specific)
        [[UIKeyCommand keyCommandWithInput:UIKeyInputLeftArrow modifierFlags:0 action:@selector(keyCommandHandler:)] addToResponder:movementHandler];
        [[UIKeyCommand keyCommandWithInput:UIKeyInputRightArrow modifierFlags:0 action:@selector(keyCommandHandler:)] addToResponder:movementHandler];
        [[UIKeyCommand keyCommandWithInput:UIKeyInputUpArrow modifierFlags:0 action:@selector(keyCommandHandler:)] addToResponder:movementHandler];
        [[UIKeyCommand keyCommandWithInput:UIKeyInputDownArrow modifierFlags:0 action:@selector(keyCommandHandler:)] addToResponder:movementHandler];
    }
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}