#import <Foundation/Foundation.h>
#import <gtk/gtk.h>

/*@interface GTKComponent : NSObject {
  GtkWidget *_w;
}
- (id)init;
- (void)dealloc;
- (GtkWidget *)gtkWidget;
- (void)setGtkWidget:(GtkWidget *)aGtkWidget;
- (void)showAll;
@end

@implementation GTKComponent
- (id)init {
  NSLog(@"GTKComponent:init entered");

  self = [super init];
  if (self) {
    [self setGtkWidget:NULL];
  }

  NSLog(@"GTKComponent:init finished: gtkWidget=%@", [self gtkWidget]);
  return self;
}

- (void)dealloc {
  NSLog(@"GTKComponent:dealloc entered");
  [super dealloc];
  NSLog(@"GTKComponent:dealloc finished");
}

- (GtkWidget *)gtkWidget {
  return _w;
}

- (void)setGtkWidget:(GtkWidget *)aGtkWidget {
  _w = aGtkWidget;
}

- (void)showAll {
  gtk_widget_show_all([self gtkWidget]);
}
@end

@interface GTKContainer : GTKComponent {
}
- (void)setBorderWidth:(uint)aBorderWidth;
- (void)addComponent:(GTKComponent *)aComponent;
@end

@implementation GTKContainer
- (void)setBorderWidth:(uint)aBorderWidth {
  gtk_container_set_border_width(GTK_CONTAINER([self gtkWidget]), 20);
}
- (void)addComponent:(GTKComponent *)aComponent {
  gtk_container_add(GTK_CONTAINER([self gtkWidget]), [aComponent gtkWidget]);
}
@end

@interface GTKWindow : GTKContainer {
}
- (id)init;
@end

@implementation GTKWindow
- (id)init {
  NSLog(@"GTKWindow:init entered");

  self = [super init];
  if (self) {
    GtkWidget *window = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    [self setGtkWidget:window];
  }

  NSLog(@"GTKWindow:init finished");
  return self;
}
@end

@interface GTKButton : GTKComponent {
}
- (id)initWithLabel:(NSString *)aLabel;
@end

@implementation GTKButton
- (id)initWithLabel:(NSString *)aLabel {
  NSLog(@"GTKButton:init entered");
  self = [super init];

  if (self) {
    GtkWidget *button = gtk_button_new_with_label([aLabel cString]);
    [self setGtkWidget:button];
  }

  [aLabel autorelease];

  NSLog(@"GTKButton:init finished");
  return self;
}
@end

@interface HelloWorldWindow : GTKWindow {
}
- (id)init;
@end

@implementation HelloWorldWindow
- (id)init {
  NSLog(@"HelloWorldWindow:init entered");
  self = [super init];

  if (self) {
    [self setBorderWidth:20];

    GTKButton *button = [[GTKButton alloc] initWithLabel:@"Click Me!"];
    [self addComponent:button];

    [button autorelease];
  }

  NSLog(@"HelloWorldWindow:init finished");
  return self;
}
@end

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  gtk_init(&argc, &argv);

  HelloWorldWindow *window = [[HelloWorldWindow alloc] init];
  [window showAll];
  [window autorelease];

  gtk_main();

  [pool drain];
  return 0;
}*/

/*@protocol GTKContainer;
@protocol GTKPresentable
- (GtkWidget *)widget;
- (id<GTKContainer>)parent;
- (void)show;
- (void)showAll;
@end

@protocol GTKContainer <GTKPresentable>
- (void)addChild:(id<GTKPresentable>)aChild;
@end

@interface GTKWidget : NSObject <GTKPresentable> {
  GtkWidget *_widget;
  id<GTKContainer> _parent;
}
- (GtkWidget *)widget;
- (id<GTKContainer>)parent;
- (void)show;
- (void)showAll;
@end
@implementation GTKWidget
- (GtkWidget *)widget {
  return _widget;
}

- (id<GTKContainer>)parent {
  return _parent;
}
- (void)show {
  // Do something!
}

- (void)showAll {
  // Do something!
}
@end

@interface GTKBin : GTKWidget <GTKContainer> {
  id<GTKPresentable> _child;
}
- (void)removeChild;
@end
@implementation GTKBin
- (void)addChild:(id<GTKPresentable>)aChild {
  [self removeChild]; // Remove an existing child
  _child = aChild;
  gtk_container_add(GTK_CONTAINER([self widget]), [_child widget]);
}
- (void)removeChild {
  if (_child) {
    gtk_container_remove(GTK_CONTAINER([self widget]), [_child widget]);
    // [_child dealloc];
    _child = NULL;
  }
}
@end*/

@interface GTKComponent : NSObject {
  GtkWidget *_widget;
}
- (GtkWidget *)widget;
@end
@implementation GTKComponent
- (GtkWidget *)widget {
  return _widget;
}
@end

static void __objc_GTKButton_action_cb(GtkWidget *widget, gpointer data);
@interface GTKButton : GTKComponent {
  SEL _action;
  id _target;
}
- (id)initWithLabel:(NSString *)aLabel;
- (SEL)action;
- (void)setAction:(SEL)aAction;
- (id)target;
- (void)setTarget:(id)aTarget;
@end
@implementation GTKButton
- (id)initWithLabel:(NSString *)aLabel {
  NSLog(@"GTKButton initWithLabel entered");

  self = [super init];
  if (self) {
    _widget = gtk_button_new_with_label([aLabel cString]);
    g_signal_connect(GTK_OBJECT(_widget), "clicked",
                     G_CALLBACK(__objc_GTKButton_action_cb), self);
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

- (id)target {
  return _target;
}

- (void)setTarget:(id)aTarget {
  _target = aTarget;
  NSLog(@"GTKButton setTarget called: %@", aTarget);
}
@end

void __objc_GTKButton_action_cb(GtkWidget *widget, gpointer data) {
  if (data != NULL) {
    GTKButton *button = (GTKButton *)data;
    if ([button target] != NULL &&
        [[button target] respondsToSelector:[button action]]) {
      [[button target] performSelector:[button action] withObject:button];
    }
  }
}

@interface GTKWindow : GTKComponent {
  GTKComponent *_child;
}
- (id)init;
- (void)showAll;
- (void)addChild:(GTKComponent *)aChild;
@end
@implementation GTKWindow
- (id)init {
  NSLog(@"GTKWindow init entered");

  self = [super init];
  if (self) {
    _widget = gtk_window_new(GTK_WINDOW_TOPLEVEL);
    NSLog(@"GTKWindow init gtk_window_new called: _widget=%ld", _widget);
  }

  NSLog(@"GTKWindow init finished");

  return self;
}

- (void)dealloc {
  NSLog(@"GTKWindow dealloc entered");
  if (_child) {
    [_child autorelease];
    NSLog(@"GTKWindow autorelease child: %@", _child);
  }
  [super dealloc];
  NSLog(@"GTKWindow dealloc finished");
}

- (void)showAll {
  NSLog(@"GTKWindow showAll entered: _widget=%ld", _widget);
  gtk_widget_show_all(_widget);
  NSLog(@"GTKWindow showAll finished");
}

- (void)addChild:(GTKComponent *)aChild {
  [_child autorelease];
  _child = [aChild retain];
  NSLog(@"GTKWindow retain child: %@", _child);
  gtk_container_add(GTK_CONTAINER([self widget]), [aChild widget]);
}
@end

@interface GTKApplication : NSObject {
}
- (id)initWithArgc:(int)argc argv:(char **)argv;
- (void)run:(GTKWindow *)window;
@end

void __objc_GTKApplication_destroy_cb(GtkWidget *widget, gpointer data) {
  NSLog(@"GTKApplication destroy callback entered");
  gtk_main_quit();
  NSLog(@"GTKApplication destroy callback finished");
}

@implementation GTKApplication
- (id)initWithArgc:(int)argc argv:(char **)argv {
  NSLog(@"GTKApplication initWithArgc entered");

  self = [self init];
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

- (void)run:(GTKWindow *)window {
  NSLog(@"GTKApplication run entered: window=%@", window);
  g_signal_connect([window widget], "destroy",
                   G_CALLBACK(__objc_GTKApplication_destroy_cb), self);
  [window showAll];
  gtk_main();
}
@end

@interface HelloWorldWindow : GTKWindow {
}
- (id)init;
- (void)sayHello:(id)sender;
@end
@implementation HelloWorldWindow
- (id)init {
  NSLog(@"HelloWorldWindow init entered");

  self = [super init];
  if (self) {
    GTKButton *btn =
        [[[GTKButton alloc] initWithLabel:@"Click me!"] autorelease];
    [btn setAction:@selector(sayHello:)];
    [btn setTarget:self];
    [self addChild:btn];
  }

  NSLog(@"HelloWorldWindow init finished");

  return self;
}

- (void)dealloc {
  NSLog(@"HelloWorldWindow dealloc entered");
  [super dealloc];
  NSLog(@"HelloWorldWindow dealloc finished");
}

- (void)sayHello:(id)sender {
  NSLog(@"HelloWorldWindow sayHello called: sender=%@", sender);
}
@end

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  GTKApplication *app =
      [[[GTKApplication alloc] initWithArgc:argc argv:argv] autorelease];

  HelloWorldWindow *win = [[[HelloWorldWindow alloc] init] autorelease];

  [app run:win];

  [pool drain];
  return 0;
}