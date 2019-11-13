#import "VKLabel.h"

#include <Xm/Frame.h>
#include <Xm/Label.h>
#include <Xm/LabelG.h>
#include <assert.h>

@implementation VKLabel
+ (id)newWithName:(NSString *)aName
           parent:(VKComponent *)aParent
            label:(NSString *)aLabel {
  return [[self alloc] initWithName:aName parent:aParent label:aLabel];
}

- (id)initWithName:(NSString *)aName
            parent:(VKComponent *)aParent
             label:(NSString *)aLabel {
  NSLog(@"VKLabel init entered");

  self = [super init];
  assert(self);

  Arg args[1];
  XmString label_str = XmStringCreateLocalized((char *)[aLabel cString]);
  XtSetArg(args[0], XmNlabelString, label_str);

  _widget = XmCreateLabel([aParent widget], (char *)[aName cString], args, 1);

  XmStringFree(label_str);

  XtManageChild(_widget);

  NSLog(@"VKLabel init finished");
  return self;
}

- (void)dealloc {
  NSLog(@"VKLabel dealloc entered");
  [super dealloc];
  NSLog(@"VKLabel dealloc finished");
}
@end
