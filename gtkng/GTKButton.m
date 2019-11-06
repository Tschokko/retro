#import "GTKButton.h"

static void __objc_GTKButton_clicked_cb(GtkWidget *widget, gpointer data);
@implementation GTKButton
+ (id)newWithLabel:(NSString *)aLabel {
  return [[self alloc] initWithLabel:aLabel];
}

- (id)initWithLabel:(NSString *)aLabel {
  NSLog(@"GTKButton initWithLabel entered");

  self = [super init];
  if (self) {
    _widget = gtk_button_new_with_label([aLabel cString]);
    g_signal_connect(GTK_OBJECT(_widget), "clicked",
                     G_CALLBACK(__objc_GTKButton_clicked_cb), self);
    // GdkColor red = {0, 0xffff, 0x0000, 0x0000};
    GdkColor red;
    gdk_color_parse("red", &red);
    GdkColor green = {0, 0x0000, 0xffff, 0x0000};
    GdkColor blue = {0, 0x0000, 0x0000, 0xffff};
    gtk_widget_modify_base(GTK_WIDGET(_widget), GTK_STATE_NORMAL, &red);
    gtk_widget_modify_base(GTK_WIDGET(_widget), GTK_STATE_PRELIGHT, &green);
    gtk_widget_modify_base(GTK_WIDGET(_widget), GTK_STATE_ACTIVE, &blue);

    NSLog(@"GTKButton initWithLabel gtk_button_new_with_label called: "
          @"_widget=%ld",
          _widget);
  }

  NSLog(@"GTKButton initWithLabel finished");

  return self;
}

- (void)dealloc {
  NSLog(@"GTKButton dealloc entered");
  [super dealloc];
  NSLog(@"GTKButton dealloc finished");
}

- (SEL)action {
  return _action;
}

- (void)setAction:(SEL)aAction {
  _action = aAction;
  NSLog(@"GTKButton setAction called: %@", NSStringFromSelector(_action));
}

- (id)performAction {
  if (_target == nil || _action == 0) {
    return nil;
  }
  if ([_target respondsToSelector:_action] == NO) {
    return nil;
  }
  return [_target performSelector:_action withObject:self];
}

- (id)target {
  return _target;
}

- (void)setTarget:(id)aTarget {
  _target = aTarget;
  NSLog(@"GTKButton setTarget called: %@", aTarget);
}
@end

void __objc_GTKButton_clicked_cb(GtkWidget *widget, gpointer data) {
  if (data != NULL) {
    GTKButton *button = (GTKButton *)data;
    [button performAction];
  }
}
