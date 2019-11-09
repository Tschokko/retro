#import "VKPushButton.h"

#include <Xm/PushB.h>
#include <assert.h>

static void __objc_VKPushButton_clicked_cb(Widget widget, XtPointer client_data,
                                           XtPointer call_data);
@implementation VKPushButton
+ (id)newWithName:(NSString *)aName
           parent:(VKComponent *)aParent
            label:(NSString *)aLabel {
  return [[self alloc] initWithName:aName parent:aParent label:aLabel];
}

- (id)initWithName:(NSString *)aName
            parent:(VKComponent *)aParent
             label:(NSString *)aLabel {
  NSLog(@"VKPushButton init entered");

  self = [super init];
  assert(self);

  Arg args[2];
  XmString label_str = XmStringCreateLocalized((char *)[aLabel cString]);
  XtSetArg(args[0], XmNlabelString, label_str);

  _widget =
      XmCreatePushButton([aParent widget], (char *)[aName cString], args, 1);

  XmStringFree(label_str);

  XtAddCallback(_widget, XmNactivateCallback, __objc_VKPushButton_clicked_cb,
                (XtPointer)self);

  XtManageChild(_widget);

  NSLog(@"VKPushButton init finished");
  return self;
}

- (void)dealloc {
  NSLog(@"VKPushButton dealloc entered");
  [super dealloc];
  NSLog(@"VKPushButton dealloc finished");
}

- (SEL)action {
  return _action;
}

- (void)setAction:(SEL)aAction {
  _action = aAction;
  NSLog(@"VKPushButton setAction called: %@", NSStringFromSelector(_action));
}

- (id)target {
  return _target;
}

- (void)setTarget:(id)aTarget {
  _target = aTarget;
  NSLog(@"VKPushButton setTarget called: %@", aTarget);
}

- (id)performAction {
  NSLog(@"VKPushButton performAction called");
  if (_target == nil || _action == 0) {
    return nil;
  }
  if ([_target respondsToSelector:_action] == NO) {
    return nil;
  }
  return [_target performSelector:_action withObject:self];
}
@end

void __objc_VKPushButton_clicked_cb(Widget widget, XtPointer client_data,
                                    XtPointer call_data) {
  NSLog(@"__objc_VKPushButton_clicked_cb called");
  if (client_data != NULL) {
    VKPushButton *button = (VKPushButton *)client_data;
    [button performAction];
  }
}
