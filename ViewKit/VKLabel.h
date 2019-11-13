#import <Foundation/Foundation.h>

#include <X11/Intrinsic.h>

#import "VKComponent.h"

@interface VKLabel : VKComponent {
}
+ (id)newWithName:(NSString *)aName
           parent:(VKComponent *)aParent
            label:(NSString *)aLabel;
- (id)initWithName:(NSString *)aName
            parent:(VKComponent *)aParent
             label:(NSString *)aLabel;
@end
