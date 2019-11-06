#import "GTKWindow.h"

static void __objc_GTKWindow_destroy_cb(GtkWidget *widget, gpointer data);

@implementation GTKWindow
+ (id) new {
  return [[self alloc] init];
}

- (id)init {
  NSLog(@"GTKWindow init entered");

  self = [super init];
  if (self) {
    _widget = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    g_signal_connect(_widget, "destroy",
                     G_CALLBACK(__objc_GTKWindow_destroy_cb), self);
    GdkColor red;
    gdk_color_parse("red", &red);
    GdkColor green = {0, 0x0000, 0xffff, 0x0000};
    GdkColor blue = {0, 0x0000, 0x0000, 0xffff};
    gtk_widget_modify_base(GTK_WIDGET(_widget), GTK_STATE_NORMAL, &red);
    gtk_widget_modify_base(GTK_WIDGET(_widget), GTK_STATE_PRELIGHT, &green);
    gtk_widget_modify_base(GTK_WIDGET(_widget), GTK_STATE_ACTIVE, &blue);

    NSLog(@"GTKWindow init gtk_window_new called: _widget=%ld", _widget);
  }

  NSLog(@"GTKWindow init finished");

  return self;
}

- (void)dealloc {
  NSLog(@"GTKWindow dealloc entered");
  /*if (_child) {
    [_child autorelease];
    NSLog(@"GTKWindow autorelease child: %@", _child);
  }*/
  [super dealloc];
  NSLog(@"GTKWindow dealloc finished");
}

- (void)setDelegate:(id)aDelegate {
  _delegate = aDelegate;
}

- (void)showAll {
  NSLog(@"GTKWindow showAll entered: _widget=%ld", _widget);
  gtk_widget_show_all(_widget);
  NSLog(@"GTKWindow showAll finished");
}

- (void)performDestroy {
  NSLog(@"GTKWindow performDestroy entered");
  SEL action = @selector(windowWillDestroy);
  if (_delegate != nil && [_delegate respondsToSelector:action] == YES) {
    [_delegate performSelector:action];
  }
  NSLog(@"GTKWindow performDestroy entered");
}
@end

void __objc_GTKWindow_destroy_cb(GtkWidget *widget, gpointer data) {
  NSLog(@"GTKWindow destroy callback entered");
  if (data != NULL) {
    GTKWindow *window = (GTKWindow *)data;
    [window performDestroy];
  }
  NSLog(@"GTKWindow destroy callback finished");
}
