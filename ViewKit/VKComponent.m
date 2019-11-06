
#import "VKComponent.h"

@implementation VKComponent
- (id)init {
  // NSLog(@"VKComponent init entered");

  self = [super init];
  assert(self);

  // NSLog(@"VKComponent init finished");
  return self;
}

- (void)dealloc {
  // NSLog(@"VKComponent dealloc entered");
  [super dealloc];
  // NSLog(@"VKComponent dealloc finished");
}

- (Widget)widget {
  return _widget;
}
@end
