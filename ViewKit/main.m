#import "NXWidget.h"
#import "VKApplication.h"
#import "VKMainWindow.h"
#import "VKPushButton.h"

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  VKApplication *app =
      [[VKApplication openWithArgc:argc argv:argv] autorelease];

  /*HelloWorldController *ctrl =
      [[[HelloWorldController alloc] init] autorelease];

  [app setDelegate:ctrl];*/

  VKMainWindow *win =
      [[VKMainWindow newWithName:@"main_win" title:@"Hello World"] autorelease];
  [win setFrame:NSMakeRect(100, 100, 640, 480)];
  VKMenuBar *menu_bar = [win addMenuBarWithName:@"main_menu"];
  VKMenu *file_menu = [menu_bar addMenuWithTitle:@"File" keyEquivalent:@"F"];
  [file_menu addItemWithTitle:@"Open..." action:0 keyEquivalent:@"O"];
  [file_menu addItemWithTitle:@"Save" action:0 keyEquivalent:@"S"];
  [file_menu addItemWithTitle:@"Save as..." action:0 keyEquivalent:@"A"];
  [file_menu addSeparator];
  [file_menu addItemWithTitle:@"Quit" action:0 keyEquivalent:@"Q"];
  VKMenu *help_menu = [menu_bar addMenuWithTitle:@"Help" keyEquivalent:@"H"];
  [help_menu addItemWithTitle:@"About" action:0 keyEquivalent:@"A"];

  VKPushButton *btn =
      [[VKPushButton newWithName:@"button_1" parent:win label:@"Click Me!"]
          autorelease];

  /*VKMainWindow *secWin =
      [[VKMainWindow newWithTitle:@"Second Window"] autorelease];
  [secWin setFrame:NSMakeRect(741, 100, 320, 240)];*/

  [win show];
  //[secWin show];

  [app run];

  /*NXApplication *app =
      [[NXApplication newWithName:@"hello_world" argc:argc argv:argv]
          autorelease];
  [app setTitle:@"My first NXApp"];

  NXPushButton *btn =
      [[NXPushButton newWithName:@"button_1" parent:app label:@"Push Me!"]
          autorelease];
  [btn manageChild];

  [app realize];
  [app run];*/
  NSLog(@"app run finished");

  [pool release]; // In the future call drain
  return 0;
}
