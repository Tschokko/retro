#import "GTKToggleButton.h"

static void __objc_GTKToggleButton_toggled_cb(GtkWidget *widget, gpointer data);
@implementation GTKToggleButton
+ (id)newWithLabel:(NSString *)aLabel {
  return [[self alloc] initWithLabel:aLabel];
}

- (id)initWithLabel:(NSString *)aLabel {
  NSLog(@"GtkToggleButton initWithLabel entered");

  self = [super init];
  if (self) {
    _widget = gtk_toggle_button_new_with_label([aLabel cString]);
    g_signal_connect(GTK_OBJECT(_widget), "toggled",
                     G_CALLBACK(__objc_GTKToggleButton_toggled_cb), self);
    GdkColor red = {0, 0xffff, 0x0000, 0x0000};
    GdkColor green = {0, 0x0000, 0xffff, 0x0000};
    GdkColor blue = {0, 0x0000, 0x0000, 0xffff};
    gtk_widget_modify_bg(GTK_WIDGET(_widget), GTK_STATE_NORMAL, &red);
    gtk_widget_modify_bg(GTK_WIDGET(_widget), GTK_STATE_PRELIGHT, &green);
    gtk_widget_modify_bg(GTK_WIDGET(_widget), GTK_STATE_ACTIVE, &blue);

    NSLog(@"GtkToggleButton initWithLabel gtk_toggle_button_new_with_label "
          @"called: "
          @"_widget=%ld",
          _widget);
  }

  NSLog(@"GtkToggleButton initWithLabel finished");

  return self;
}

- (void)dealloc {
  NSLog(@"GtkToggleButton dealloc entered");
  [super dealloc];
  NSLog(@"GtkToggleButton dealloc finished");
}

- (BOOL)isActive {
  return gtk_toggle_button_get_active([super widget]);
}

/*- (SEL)action {
  return _action;
}

- (void)setAction:(SEL)aAction {
  _action = aAction;
  NSLog(@"GtkToggleButton setAction called: %@", NSStringFromSelector(_action));
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
  NSLog(@"GtkToggleButton setTarget called: %@", aTarget);
}*/
@end

void __objc_GTKToggleButton_toggled_cb(GtkWidget *widget, gpointer data) {
  if (data != NULL) {
    GtkToggleButton *button = (GtkToggleButton *)data;
    [button performAction];
  }
}
