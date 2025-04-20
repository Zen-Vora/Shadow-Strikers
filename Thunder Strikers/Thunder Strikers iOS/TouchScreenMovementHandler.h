#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TouchScreenMovementHandler : NSObject

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event;

@end