#import "GTKApplication.h"

/*void __objc_GTKApplication_destroy_cb(GtkWidget *widget, gpointer data) {
  NSLog(@"GTKApplication destroy callback entered");
  gtk_main_quit();
  NSLog(@"GTKApplication destroy callback finished");
}*/

GTKApplication *GTKApp;

@implementation GTKApplication
+ (id)newWithArgc:(int)argc argv:(char **)argv {
  if (GTKApp == nil) {
    GTKApp = [[self alloc] initWithArgc:argc argv:argv];
  }
  return GTKApp;
}

- (id)initWithArgc:(int)argc argv:(char **)argv {
  NSLog(@"GTKApplication initWithArgc entered");

  self = [super init];
  if (self) {
    gtk_init(&argc, &argv);
    NSLog(@"GTKApplication initWithArgc gkt_init called");
  }

  NSLog(@"GTKApplication initWithArgc finished");

  return self;
}

- (void)dealloc {
  NSLog(@"GTKApplication dealloc entered");
  [super dealloc];
  NSLog(@"GTKApplication dealloc finished");
}

- (void)setDelegate:(id)aDelegate {
  _delegate = aDelegate;
}

- (void)run /*:(GTKWindow *)window*/ {
  NSLog(@"GTKApplication run entered");
  // g_signal_connect([window widget], "destroy",
  //                 G_CALLBACK(__objc_GTKApplication_destroy_cb), self);
  // [window showAll];
  SEL action = @selector(applicationDidFinishLaunching);
  if (_delegate != nil && [_delegate respondsToSelector:action] == YES) {
    [_delegate performSelector:action];
  }
  gtk_main();
  NSLog(@"GTKApplication run finished");
}

- (void)quit {
  NSLog(@"GTKApplication quit entered");
  gtk_main_quit();
  NSLog(@"GTKApplication quit finished");
}
@end
