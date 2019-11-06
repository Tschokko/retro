#import "VKMainWindow.h"
#import "VKApplication.h"

#include <X11/Shell.h>
#include <Xm/CascadeB.h>
#include <Xm/MainW.h>
#include <Xm/PushB.h>
#include <Xm/RowColumn.h>
#include <Xm/Separator.h>

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

  // NSLog(@"VKMainWindow initWithTitle finished");

  return self;
}

- (void)dealloc {
  NSLog(@"VKMainWindow dealloc entered");
  if (_menu_bar != nil) {
    [_menu_bar release];
  }
  [super dealloc];
  NSLog(@"VKMainWindow dealloc finished");
}

- (void)setDelegate:(id)aDelegate {
  _delegate = aDelegate;
}

- (void)show {
  // NSLog(@"VKMainWindow run entered");
  XtPopup(_top_level_shell_widget, XtGrabNonexclusive);
  // XtRealizeWidget(_top_level_shell_widget);
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
@end

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

- (void)dealloc {
  NSLog(@"VKMenuBar dealloc entered");
  [super dealloc];
  NSLog(@"VKMenuBar dealloc finished");
}

- (void)addItemWithTitle:(NSString *)aTitle
                  action:(SEL)anAction
           keyEquivalent:(NSString *)aKeyEquivalent {
  // Widget pull_down_w = XmCreatePulldownMenu(_widget, "Monitor Pulldown",
  // NULL, 0); XtVaSetValues(pull_down_w, XmNtearOffModel, XmTEAR_OFF_ENABLED,
  // NULL);
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
  XtVaSetValues(_widget, XmNtearOffModel, XmTEAR_OFF_ENABLED, NULL);

  return self;
}

- (void)dealloc {
  NSLog(@"VKMenu dealloc entered");
  [super dealloc];
  NSLog(@"VKMenu dealloc finished");
}

- (void)addItemWithTitle:(NSString *)aTitle
                  action:(SEL)anAction
           keyEquivalent:(NSString *)aKeyEquivalent {
  XtVaCreateManagedWidget([aTitle cString], xmPushButtonWidgetClass, _widget,
                          XmNmnemonic, [aKeyEquivalent characterAtIndex:0],
                          NULL);
  /*tAddCallback(ow[MON_SYS_LOG_W], XmNactivateCallback, mon_popup_cb,
                    (XtPointer)MON_SYS_LOG_SEL);*/
}

- (void)addSeparator {
  XtVaCreateManagedWidget("separator", xmSeparatorWidgetClass, _widget, NULL);
}
@end
