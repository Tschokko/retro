#import <Foundation/Foundation.h>
#import <X11/IntrinsicP.h>
#import <X11/ShellP.h>
#import <Xm/MainW.h>
#import <Xm/PushB.h>
#include <stdio.h>

// typedef void (^BlockCallback)();
// static void callback(Widget widget, XtPointer clientData, XtPointer callData)
// { VKComponent *theBlock =
//       (VKComponent)clientData; // cast the void * back to a block
// theBlock();                  // and call the block
// printf("Callback called... \n");
//}

/*******************************************************************************
  VKComponent
*******************************************************************************/
/*static void onDestroyCallback(Widget widget, XtPointer clientData,
                              XtPointer callData);*/

@interface VKComponent : NSObject {
  NSString *_name;
  Widget _widget;
  VKComponent *_parent;
}
- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent;
- (NSString *)name;
- (void)setName:(NSString *)aName;
- (VKComponent *)parent;
- (void)setParent:(VKComponent *)aParent;
- (Widget)widget;
- (void)manage;
@end

@implementation VKComponent
- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent {
  NSLog(@"VKComponent:initWithName called");
  self = [super init];

  [self setName:aName];
  [self setParent:aParent];

  // XtAddCallback(_widget, XmNdestroyCallback, onDestroyCallback, self);
  // NSLog(@"Callback installed for %@", [self name]);

  NSLog(@"VKComponent:initWithName finished: name='%@', parent=%@", [self name],
        [self parent]);

  return self;
}

- (NSString *)name {
  return _name;
}

- (void)setName:(NSString *)aName {
  [_name autorelease];
  _name = [aName retain];
}

- (VKComponent *)parent {
  return _parent;
}

- (void)setParent:(VKComponent *)aParent {
  _parent = aParent;
}

- (Widget)widget {
  return _widget;
}

- (void)setWidget:(Widget)aWidget {
  _widget = aWidget;
}

- (void)manage {
  XtManageChild(_widget);
}
@end

/*void onDestroyCallback(Widget widget, XtPointer clientData,
                       XtPointer callData) {
  NSLog(@"onDestroyCallback called: %@ %@", clientData, callData);
  // VKPushButton *pushBtn = (VKPushButton *)clientData;
  // [pushBtn onClick];
}*/

/*******************************************************************************
  VKApplicationShell
*******************************************************************************/
@interface VKApplicationShell : VKComponent {
  XtAppContext _appContext;
}
- (VKApplicationShell *)initWithName:(NSString *)aName
                                argc:(int)argc
                                argv:(char **)argv;
- (void)run;
@end

@implementation VKApplicationShell
- (VKApplicationShell *)initWithName:(NSString *)aName
                                argc:(int)argc
                                argv:(char **)argv {
  self = [super initWithName:aName parent:NULL];

  XtSetLanguageProc(NULL, NULL, NULL);
  Widget widget =
      XtOpenApplication(&_appContext, [[self name] cString], NULL, 0, &argc,
                        argv, NULL, applicationShellWidgetClass, NULL, 0);
  [self setWidget:widget];

  /* For demo purpose only */
  short unsigned int x, y;
  XtMakeResizeRequest([self widget], 640, 480, &x, &y);

  // XtAddCallback(_topLevelWidget, XmNdestroyCallback, callback, NULL);
  // NSLog(@"Callback installed for top-level widget");

  return self;
}

- (void)run {
  XtRealizeWidget(_widget);
  XtAppMainLoop(_appContext);
}
@end

/*******************************************************************************
  VKMainWindow
*******************************************************************************/
@interface VKMainWindow : VKComponent {
}
- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent;
@end

@implementation VKMainWindow
- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent {
  NSLog(@"VKMainWindow:initWithName called");
  self = [super initWithName:aName parent:aParent];

  Widget widget =
      XtVaCreateManagedWidget([[self name] cString], xmMainWindowWidgetClass,
                              [[self parent] widget], NULL);
  [self setWidget:widget];

  NSLog(@"VKMainWindow:initWithName finished");
  return self;
}
@end

/*******************************************************************************
  VKPushButton
*******************************************************************************/
static void onClickCallback(Widget widget, XtPointer clientData,
                            XtPointer callData);
@interface VKPushButton : VKComponent {
  NSString *_label;
}
- (id)initWithName:(NSString *)aName
            parent:(VKComponent *)aParent
             label:(NSString *)aLabel;
- (NSString *)label;
- (void)setLabel:(NSString *)aLabel;
- (void)onClick;
@end

@implementation VKPushButton
- (id)initWithName:(NSString *)aName
            parent:(VKComponent *)aParent
             label:(NSString *)aLabel {
  NSLog(@"VKPushButton:initWithName called");
  self = [super initWithName:aName parent:aParent];

  XmString labelStr = XmStringCreateLocalized((char *)[[self label] cString]);
  Widget widget = XtVaCreateManagedWidget(
      [[self name] cString], xmPushButtonWidgetClass, [[self parent] widget],
      XmNlabelString, labelStr, NULL);
  XmStringFree(labelStr);
  [self setWidget:widget];

  XtAddCallback([self widget], XmNactivateCallback, onClickCallback, self);

  NSLog(@"VKPushButton:initWithName finished");
  return self;
}

- (NSString *)label {
  return _label;
}

- (void)setLabel:(NSString *)aLabel {
  [_label autorelease];
  _label = [aLabel retain];
}

- (void)onClick {
  NSLog(@"onClick called");
}
@end

void onClickCallback(Widget widget, XtPointer clientData, XtPointer callData) {
  printf("onClickCallback called");
  VKPushButton *pushBtn = (VKPushButton *)clientData;
  [pushBtn onClick];
}

/*******************************************************************************
  HelloWorldWindow
*******************************************************************************/
@interface HelloWorldWindow : VKMainWindow {
}
- (id)initWithParent:(VKComponent *)aParent;
@end

@implementation HelloWorldWindow
- (id)initWithParent:(VKComponent *)aParent {
  NSLog(@"HelloWorldWindow:initWithParent called");
  self = [super initWithName:@"HelloWorldWin" parent:aParent];

  VKComponent *pushBtn = [[VKPushButton alloc] initWithName:@"PushBtn"
                                                     parent:self
                                                      label:@"Say Hello"];
  [pushBtn manage];
  [pushBtn autorelease];

  NSLog(@"HelloWorldWindow:initWithParent finished");
  return self;
}
@end

/*******************************************************************************
  main
*******************************************************************************/
int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  VKApplicationShell *shell =
      [[VKApplicationShell alloc] initWithName:@"HelloWorld"
                                          argc:argc
                                          argv:argv];
  [shell autorelease];

  NSLog(@"Alloc and init HelloWorldWindow");
  HelloWorldWindow *mainWin = [[HelloWorldWindow alloc] initWithParent:shell];
  [mainWin autorelease];

  [shell run];

  NSLog(@"exit app");

  /*[pushBtn2 release];
  [pushBtn release];
  [mainWin release];
  [appShell release];*/

  [pool drain];
  return 0;
}
