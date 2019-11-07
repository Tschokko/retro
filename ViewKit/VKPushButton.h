#import <Foundation/Foundation.h>

#include <X11/Intrinsic.h>

#import "VKComponent.h"

@interface VKPushButton : VKComponent {
  SEL _action;
  id _target;
}
+ (id)newWithName:(NSString *)aName
           parent:(VKComponent *)aParent
            label:(NSString *)aLabel;
- (id)initWithName:(NSString *)aName
            parent:(VKComponent *)aParent
             label:(NSString *)aLabel;
- (SEL)action;
- (void)setAction:(SEL)aAction;
- (id)target;
- (void)setTarget:(id)aTarget;
@end
