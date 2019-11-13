#import <Foundation/Foundation.h>

#include <X11/Intrinsic.h>

#import "VKComponent.h"

@interface VKFrame : VKComponent {
}
+ (id)newWithName:(NSString *)aName parent:(VKComponent *)aParent;
- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent;
@end
