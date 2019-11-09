#import <Foundation/Foundation.h>

#include <X11/Intrinsic.h>

#import "VKComponent.h"

@interface VKOpenGLDrawingArea : VKComponent {
  id _delegate;
}
+ (id)newWithName:(NSString *)aName parent:(VKComponent *)aParent;
- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent;
- (void)drawRect:(NSRect)aRect;
- (void)resize:(NSRect)aRect;
@end
