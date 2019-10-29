#import <Foundation/Foundation.h>

#include <X11/Intrinsic.h>

@interface VKComponent : NSObject {
  NSString *name;
  Widget widget;
}
- (VKComponent *)initWithName:(NSString *)newName;
- (NSString *)name;
- (void)setName:(NSString *)newName;
- (Widget)widget;
- (void)realize:(VKComponent *)parent;
- (void)manage;
- (void)unmanage;
@end

@implementation VKComponent
- (VKComponent *)initWithName:(NSString *)newName {
  self = [super init];
  [self setName:newName];
  return self;
}

- (NSString *)name {
  return name;
}

- (void)setName:(NSString *)newName {
  if (newName != name) {
    [name release];
    name = [newName retain];
  }
}

- (Widget *)widget {
  return widget;
}

- (void)realize:(VKComponent *)parent {
}

- (void)manage {
  XtManageChild(widget);
}

- (void)unmanage {
  XtUnmanageChild(widget);
}
@end

int main(void) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];

  VKComponent *c = [[VKComponent alloc] initWithName:@"test_widget"];

  NSLog(@"VKComponent name:  %@", [c name]);

  [c release];

  [pool drain];
  return 0;
}
