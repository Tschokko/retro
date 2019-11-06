#import <Foundation/Foundation.h>

#include <X11/Intrinsic.h>

@interface VKComponent : NSObject {
  Widget _widget;
}
// + (id)openWithArgc:(int)argc argv:(char **)argv;
- (id)init;
- (Widget)widget;
@end
