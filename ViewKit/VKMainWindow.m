#import "VKMainWindow.h"
#import "VKApplication.h"

#include <X11/Shell.h>
#include <Xm/CascadeB.h>
#include <Xm/MainW.h>
#include <Xm/PushB.h>
#include <Xm/RowColumn.h>
#include <Xm/Separator.h>
#include <assert.h>

#import "VKPushButton.h"

void __objc_VKMainWindow_destroy_cb(Widget w, XtPointer clientData,
                                    XtPointer callData) {
  // NSLog(@"VKMainWindow destroy callback entered");
  assert(VKApp);
  [VKApp quit];
  // NSLog(@"VKMainWindow destroy callback finished");
}

@implementation VKMainWindow
+ (id)newWithName:(NSString *)aName title:(NSString *)aTitle {
  return [[self alloc] initWithName:aName title:aTitle];
}

- (id)initWithName:(NSString *)aName title:(NSString *)aTitle {
  // NSLog(@"VKMainWindow initWithTitle entered");

  self = [super init];
  assert(self);

  // Ensure that we can access our shared application component
  assert(VKApp);

  // Put our main window into a popup top level shell
  NSString *shellName = [aName stringByAppendingString:@"_shell"];

  _top_level_shell_widget = XtVaCreatePopupShell(
      (char *)[shellName cString], topLevelShellWidgetClass, [VKApp widget],
      XmNtitle, [aTitle cString], NULL);

  // Create a new main window widget
  _widget = XmCreateMainWindow(_top_level_shell_widget, (char *)[aName cString],
                               NULL, 0);
  XtAddCallback(_widget, XmNdestroyCallback, __objc_VKMainWindow_destroy_cb,
                NULL);
  XtManageChild(_widget);

  // Add the new window to the application window list
  [VKApp addWindow:self];

  // NSLog(@"VKMainWindow initWithTitle finished");
  return self;
}

- (void)dealloc {
  NSLog(@"VKMainWindow dealloc entered");
  if (_menu_bar != nil) {
    [_menu_bar release];
  }

  // TODO Remove window from the application window list

  [_message_area release];

  [super dealloc];
  NSLog(@"VKMainWindow dealloc finished");
}

- (void)setDelegate:(id)aDelegate {
  _delegate = aDelegate;
}

- (void)show {
  // NSLog(@"VKMainWindow run entered");
  XtPopup(_top_level_shell_widget, XtGrabNonexclusive);
  // NSLog(@"VKMainWindow run finished");
}

- (VKMenuBar *)addMenuBarWithName:(NSString *)aName {
  assert(!_menu_bar && "menu bar already added");
  _menu_bar = [VKMenuBar newWithName:aName parent:self];
  return _menu_bar;
}

- (void)setFrame:(NSRect)aFrameRect {
  [self setFrameOrigin:aFrameRect.origin];
  [self setFrameSize:aFrameRect.size];
}

- (void)setFrameOrigin:(NSPoint)aOrigin {
  NSLog(@"aOrigin=%@", NSStringFromPoint(aOrigin));
  Cardinal argc = 0;
  Arg args[3];
  XtSetArg(args[argc], XmNx, aOrigin.x);
  argc++;
  XtSetArg(args[argc], XmNy, aOrigin.y);
  argc++;
  XtSetValues(_top_level_shell_widget, args, argc);
}

- (void)setFrameSize:(NSSize)aSize {
  Cardinal argc = 0;
  Arg args[3];
  XtSetArg(args[argc], XmNwidth, aSize.width);
  argc++;
  XtSetArg(args[argc], XmNheight, aSize.height);
  argc++;
  XtSetValues(_top_level_shell_widget, args, argc);
}

- (void)setMessageArea:(VKComponent *)aMessageArea {
  [_message_area release];
  _message_area = [aMessageArea retain];

  // XtVaSetValues(_widget, XmNmessageWindow, frame, NULL);*/
  XtVaSetValues(_widget, XmNmessageWindow, [_message_area widget], NULL);
}

- (VKComponent *)messageArea {
  return _message_area;
}

- (void)setWorkArea:(VKComponent *)aWorkArea {
  [_work_area release];
  _work_area = [aWorkArea retain];

  XtVaSetValues(_widget, XmNworkWindow, [_work_area widget], NULL);
}

- (VKComponent *)workArea {
  return _work_area;
}
@end // VKMainWindow

@implementation VKMenuBar
+ (id)newWithName:(NSString *)aName parent:(VKComponent *)aParent {
  return [[self alloc] initWithName:aName parent:aParent];
}

- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent {
  self = [super init];
  assert(self);

  _widget =
      XmVaCreateSimpleMenuBar([aParent widget], (char *)[aName cString], NULL);
  XtManageChild(_widget);

  return self;
}

- (void)setTarget:(id)aTarget {
  _target = aTarget;
}

- (void)dealloc {
  NSLog(@"VKMenuBar dealloc entered");
  [super dealloc];
  NSLog(@"VKMenuBar dealloc finished");
}

- (void)addItemWithTitle:(NSString *)aTitle
                  action:(SEL)anAction
           keyEquivalent:(NSString *)aKeyEquivalent {
  XtVaCreateManagedWidget([aTitle cString], xmCascadeButtonWidgetClass, _widget,
                          XmNmnemonic, [aKeyEquivalent characterAtIndex:0],
                          NULL);
}

- (VKMenu *)addMenuWithTitle:(NSString *)aTitle
               keyEquivalent:(NSString *)aKeyEquivalent {
  VKMenu *menu = [[VKMenu newWithName:aTitle parent:self] autorelease];
  XtVaCreateManagedWidget([aTitle cString], xmCascadeButtonWidgetClass, _widget,
                          XmNmnemonic, [aKeyEquivalent characterAtIndex:0],
                          XmNsubMenuId, [menu widget], NULL);
  return menu;
}
@end

@implementation VKMenu
+ (id)newWithName:(NSString *)aName parent:(VKComponent *)aParent {
  return [[self alloc] initWithName:aName parent:aParent];
}

- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent {
  self = [super init];
  assert(self);

  _widget =
      XmCreatePulldownMenu([aParent widget], (char *)[aName cString], NULL, 0);
  // XtVaSetValues(_widget, XmNtearOffModel, XmTEAR_OFF_ENABLED, NULL);

  _items = [[NSMutableArray alloc] init];

  return self;
}

- (void)setTarget:(id)aTarget {
  _target = aTarget;
}

- (void)dealloc {
  NSLog(@"VKMenu dealloc entered");
  for (id item in _items) {
    [item release];
  }
  [_items release];
  [super dealloc];
  NSLog(@"VKMenu dealloc finished");
}

- (void)addItemWithTitle:(NSString *)aTitle
                  action:(SEL)anAction
           keyEquivalent:(NSString *)aKeyEquivalent {
  VKPushButton *item =
      [VKPushButton newWithName:aTitle parent:self label:aTitle];
  [item setAction:anAction];
  [item setTarget:_target];

  [_items addObject:item];
}

- (void)addSeparator {
  XtVaCreateManagedWidget("separator", xmSeparatorWidgetClass, _widget, NULL);
}
@end
