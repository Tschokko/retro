#import "VKApplication.h"

#include <X11/Shell.h>

/*void __objc_GTKApplication_destroy_cb(GtkWidget *widget, gpointer data) {
  // NSLog(@"GTKApplication destroy callback entered");
  gtk_main_quit();
  // NSLog(@"GTKApplication destroy callback finished");
}*/

VKApplication *VKApp;

@implementation VKApplication
+ (id)openWithArgc:(int)argc argv:(char **)argv {
  if (VKApp == nil) {
    VKApp = [[self alloc] initWithArgc:argc argv:argv];
  }
  return VKApp;
}

- (id)initWithArgc:(int)argc argv:(char **)argv {
  // NSLog(@"VKApplication initWithArgc entered");

  self = [super init];
  assert(self);

  // gtk_init(&argc, &argv);
  _widget = XtOpenApplication(&_app_context, "motif4", NULL, 0, &argc, argv,
                              NULL, sessionShellWidgetClass, NULL, 0);

  // NSLog(@"VKApplication initWithArgc finished");

  return self;
}

- (void)dealloc {
  // NSLog(@"VKApplication dealloc entered");
  [super dealloc];
  // NSLog(@"VKApplication dealloc finished");
}

- (void)setDelegate:(id)aDelegate {
  _delegate = aDelegate;
}

- (void)run {
  // NSLog(@"VKApplication run entered");
  // g_signal_connect([window widget], "destroy",
  //                 G_CALLBACK(__objc_GTKApplication_destroy_cb), self);
  // [window showAll];

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
@end
