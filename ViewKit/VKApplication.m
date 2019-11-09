#import "VKApplication.h"

#include <X11/Shell.h>
#include <assert.h>

VKApplication *VKApp;

@implementation VKApplication
+ (id)openWithName:(NSString *)aName argc:(int)argc argv:(char **)argv {
  if (VKApp == nil) {
    VKApp = [[self alloc] initWithName:aName argc:argc argv:argv];
  }
  return VKApp;
}

- (id)initWithName:(NSString *)aName argc:(int)argc argv:(char **)argv {
  // NSLog(@"VKApplication initWithArgc entered");

  self = [super init];
  assert(self);

  _windows = [[NSMutableArray alloc] init];

  _widget = XtOpenApplication(&_app_context, [aName cString], NULL, 0, &argc,
                              argv, NULL, sessionShellWidgetClass, NULL, 0);

  // NSLog(@"VKApplication initWithArgc finished");
  return self;
}

- (void)dealloc {
  // NSLog(@"VKApplication dealloc entered");
  [_windows release];
  [super dealloc];
  // NSLog(@"VKApplication dealloc finished");
}

- (void)setDelegate:(id)aDelegate {
  _delegate = aDelegate;
}

- (void)addWindow:(id)aWindow {
  [_windows addObject:aWindow];
}

- (void)run {
  // NSLog(@"VKApplication run entered");

  // Tell the delegate that we are about to start the application main loop
  SEL action = @selector(applicationDidFinishLaunching);
  if (_delegate != nil && [_delegate respondsToSelector:action] == YES) {
    [_delegate performSelector:action];
  }

  // Run the X application main loop
  XtAppMainLoop(_app_context);

  // NSLog(@"VKApplication run finished");
}

- (void)quit {
  // NSLog(@"VKApplication quit entered");

  // Tell our main loop to exit
  XtAppSetExitFlag(_app_context);

  // NSLog(@"VKApplication quit finished");
}

- (Display *)display {
  return XtDisplay(_widget);
}
@end
