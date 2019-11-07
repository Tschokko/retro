#import "NXWidget.h"

#import <Xm/PushB.h>
#import <assert.h>

//------------------------------------------------------------------------------
// NXWidget
//------------------------------------------------------------------------------
@implementation NXWidget
+ (id)newWithName:(NSString *)aName widgetClass:(WidgetClass)aWidgetClass {
  return [[self alloc] initWithName:aName widgetClass:aWidgetClass];
}

+ (id)newWithName:(NSString *)aName
      widgetClass:(WidgetClass)aWidgetClass
           parent:(NXWidget *)aParent {
  return
      [[self alloc] initWithName:aName widgetClass:aWidgetClass parent:aParent];
}

- (id)initWithName:(NSString *)aName {
  NSLog(@"NXWidget init (name=%@)", aName);

  self = [super init];
  assert(self);

  _name = [aName retain];

  return self;
}

- (id)initWithName:(NSString *)aName widgetClass:(WidgetClass)aWidgetClass {
  return [self initWithName:aName widgetClass:aWidgetClass parent:nil];
}

- (id)initWithName:(NSString *)aName
       widgetClass:(WidgetClass)aWidgetClass
            parent:(NXWidget *)aParent {
  NSLog(@"NXWidget init (name=%@)", aName);

  self = [super init];
  assert(self);

  _name = [aName retain];
  _parent = [aParent retain];

  /*Widget parent_w = NULL;
  if (_parent != nil) {
    parent_w = [_parent baseWidget];
  }*/

  _w = XtVaCreateWidget([_name cString], aWidgetClass, [_parent baseWidget],
                        NULL);
  return self;
}

- (void)manageChild {
  NSLog(@"NXWidget manageChild (name=%@)", _name);
  assert(_w);
  XtManageChild(_w);
}

- (void)realize {
  NSLog(@"NXWidget realize (name=%@)", _name);
  assert(_w);
  XtRealizeWidget(_w);
}

- (NSString *)name {
  return _name;
}

- (Widget)baseWidget {
  return _w;
}

- (void)dealloc {
  NSLog(@"NXWidget dealloc (name=%@)", _name);
  [_name release];
  [_parent release];
  [super dealloc];
}
@end

//------------------------------------------------------------------------------
// NXApplication
//------------------------------------------------------------------------------
@implementation NXApplication
+ (id)newWithName:(NSString *)aName argc:(int)argc argv:(char **)argv {
  return [[self alloc] initWithName:aName argc:argc argv:argv];
}

- (id)initWithName:(NSString *)aName argc:(int)argc argv:(char **)argv {
  NSLog(@"NXApplication initWithName (name=%@)", aName);

  self = [super initWithName:aName];
  assert(self);

  _w = XtOpenApplication(&_app_context, [aName cString], NULL, 0, &argc, argv,
                         NULL, sessionShellWidgetClass, NULL, 0);

  return self;
}

- (void)run {
  XtAppMainLoop(_app_context);
}

- (void)dealloc {
  NSLog(@"NXApplication dealloc (name=%@)", _name);
  [super dealloc];
}

- (NSString *)title {
  return _title;
}

- (void)setTitle:(NSString *)aTitle {
  [_title release];
  _title = [aTitle retain];
  XtVaSetValues([self baseWidget], XmNtitle, [_title cString], NULL);
}
@end

//------------------------------------------------------------------------------
// NXPushButton
//------------------------------------------------------------------------------
@implementation NXPushButton
+ (id)newWithName:(NSString *)aName
           parent:(NXWidget *)aParent
            label:(NSString *)aLabel {
  return [[self alloc] initWithName:aName parent:aParent label:aLabel];
}

- (id)initWithName:(NSString *)aName
            parent:(NXWidget *)aParent
             label:(NSString *)aLabel {
  NSLog(@"NXPushButton initWithName (name=%@)", aName);
  self = [super initWithName:aName
                 widgetClass:xmPushButtonWidgetClass
                      parent:aParent];
  assert(self);

  [self setLabel:aLabel];

  return self;
}

- (NSString *)label {
  return _label;
}

- (void)setLabel:(NSString *)aLabel {
  [_label release];
  _label = [aLabel retain];

  XmString label_s = XmStringCreateLocalized((char *)[_label cString]);
  XtVaSetValues([self baseWidget], XmNlabelString, label_s, NULL);
  XmStringFree(label_s);
}

- (void)dealloc {
  NSLog(@"NXPushButton dealloc (name=%@)", _name);
  [_label release];
  [super dealloc];
}
@end
