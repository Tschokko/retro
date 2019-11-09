#import <Foundation/Foundation.h>

#include <X11/Intrinsic.h>

#import "VKComponent.h"

@interface VKApplication : VKComponent {
  XtAppContext _app_context;
  id _delegate;
  NSMutableArray *_windows;
}
+ (id)openWithName:(NSString *)aName argc:(int)argc argv:(char **)argv;
- (id)initWithName:(NSString *)aName argc:(int)argc argv:(char **)argv;
- (void)setDelegate:(id)aDelegate;
- (void)addWindow:(id)aWindow;
- (void)run;
- (void)quit;
- (Display *)display;
@end

extern VKApplication *VKApp;
