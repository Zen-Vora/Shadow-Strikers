//
//  main.m
//  Thunder Strikers macOS
//
//  Created by Zen Vora on 4/20/25.
//

#import <Cocoa/Cocoa.h>
#import "ArrowKeyMovementHandler.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        // Initialize movement handler
        ArrowKeyMovementHandler *movementHandler = [[ArrowKeyMovementHandler alloc] init];
        
        // Register key event handlers
        NSEvent * (^keyDownHandler)(NSEvent *) = ^NSEvent * (NSEvent *event) {
            [movementHandler keyDown:event];
            return event;
        };
        [NSEvent addLocalMonitorForEventsMatchingMask:NSEventMaskKeyDown handler:keyDownHandler];
    }
    return NSApplicationMain(argc, argv);
}