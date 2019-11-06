#import <Foundation/Foundation.h>

#include <X11/Intrinsic.h>

#import "VKComponent.h"

@interface VKApplication : VKComponent {
  XtAppContext _app_context;
  id _delegate;
}
+ (id)openWithArgc:(int)argc argv:(char **)argv;
- (id)initWithArgc:(int)argc argv:(char **)argv;
- (void)setDelegate:(id)aDelegate;
- (void)run;
- (void)quit;
@end

extern VKApplication *VKApp;
