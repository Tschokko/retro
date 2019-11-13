#import "VKFrame.h"

#include <Xm/Frame.h>
#include <Xm/Label.h>
#include <Xm/LabelG.h>
#include <assert.h>

@implementation VKFrame
+ (id)newWithName:(NSString *)aName parent:(VKComponent *)aParent {
  return [[self alloc] initWithName:aName parent:aParent];
}

- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent {
  NSLog(@"VKFrame init entered");

  self = [super init];
  assert(self);

  Arg args[1];
  XtSetArg(args[0], XmNshadowType, XmSHADOW_IN);

  _widget = XmCreateFrame([aParent widget], (char *)[aName cString], args, 1);

  XtManageChild(_widget);

  NSLog(@"VKFrame init finished");
  return self;
}

- (void)dealloc {
  NSLog(@"VKFrame dealloc entered");
  [super dealloc];
  NSLog(@"VKFrame dealloc finished");
}
@end
