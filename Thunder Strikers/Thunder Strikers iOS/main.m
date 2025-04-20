
//  main.m
//  Thunder Strikers iOS
//
//  Created by Zen Vora on 4/20/25.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "TouchScreenMovementHandler.h"\

int main(int argc, char * argv[]) {\
    NSString * appDelegateClassName;\
    @autoreleasepool {\
        // Setup code that might create autoreleased objects goes here.
        appDelegateClassName = NSStringFromClass([AppDelegate class]);\
        \
        // Initialize touch screen movement handler
        TouchScreenMovementHandler *touchHandler = [[TouchScreenMovementHandler alloc] init];\
        \
        // Register the touch handler (typically in your game view)
        UIView *gameView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];\
        [gameView addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:touchHandler action:@selector(touchesMoved:withEvent:)]];\
    }\
    return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
