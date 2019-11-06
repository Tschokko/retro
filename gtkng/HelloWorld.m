#import "GTKApplication.h"
#import "GTKButton.h"
#import "GTKToggleButton.h"
#import "GTKWindow.h"

@interface HelloWorldController : NSObject {
  GTKWindow *_main_window;
}
- (id)init;
// - (void)applicationDidFinishLaunching;
// - (void)sayHello:(id)sender;
@end
@implementation HelloWorldController
- (id)init {
  NSLog(@"HelloWorldWindow init entered");

  self = [super init];
  if (self) {
    _main_window = [GTKWindow new];
    [_main_window setBorderWidth:10];
    [_main_window setDelegate:self];

    GTKButton *btn = [[GTKButton newWithLabel:@"Toogle me!"] autorelease];
    [btn setAction:@selector(sayHello:)];
    [btn setTarget:self];
    [_main_window addChild:btn];
  }

  NSLog(@"HelloWorldWindow init finished");

  return self;
}

- (void)dealloc {
  NSLog(@"HelloWorldWindow dealloc entered");
  [_main_window release];
  [super dealloc];
  NSLog(@"HelloWorldWindow dealloc finished");
}

- (void)applicationDidFinishLaunching {
  [_main_window showAll];
}

- (void)windowWillDestroy {
  [GTKApp quit];
}

- (void)sayHello:(id)sender {
  NSLog(@"HelloWorldWindow sayHello called: sender=%@", sender);
  // [GTKApp quit];
}
@end

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  GTKApplication *app =
      [[GTKApplication newWithArgc:argc argv:argv] autorelease];

  HelloWorldController *ctrl =
      [[[HelloWorldController alloc] init] autorelease];

  [app setDelegate:ctrl];
  [app run];

  [pool release]; // In the future call drain
  return 0;
}
