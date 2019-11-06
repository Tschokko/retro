#import "VKPushButton.h"

#include <assert.h>
#include <Xm/PushB.h>

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

  XtManageChild(_widget);

  NSLog(@"VKPushButton init finished");
  return self;
}

- (void)dealloc {
  NSLog(@"VKPushButton dealloc entered");
  [super dealloc];
  NSLog(@"VKPushButton dealloc finished");
}
@end
