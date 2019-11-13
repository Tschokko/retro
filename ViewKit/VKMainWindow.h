#import <Foundation/Foundation.h>

#include <X11/Intrinsic.h>

#import "VKComponent.h"

@class VKMenuBar;
@class VKMenu;

@interface VKMainWindow : VKComponent {
  Widget _top_level_shell_widget;
  id _delegate;
  VKMenuBar *_menu_bar;
  VKComponent *_message_area;
  VKComponent *_work_area;
}
+ (id)newWithName:(NSString *)aName title:(NSString *)aTitle;
- (id)initWithName:(NSString *)aName title:(NSString *)aTitle;
- (void)setDelegate:(id)aDelegate;
- (void)show;
// Menu methods
- (VKMenuBar *)addMenuBarWithName:(NSString *)aName;
// Generic methods
- (void)setFrame:(NSRect)aFrameRect;
- (void)setFrameOrigin:(NSPoint)aOrigin;
- (void)setFrameSize:(NSSize)aSize;
- (void)setMessageArea:(VKComponent *)aMessageArea;
- (VKComponent *)messageArea;
- (void)setWorkArea:(VKComponent *)aWorkArea;
- (VKComponent *)workArea;
@end

@interface VKMenuBar : VKComponent {
  id _target;
}
+ (id)newWithName:(NSString *)aName parent:(VKComponent *)aParent;
- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent;
- (void)addItemWithTitle:(NSString *)aTitle
                  action:(SEL)anAction
           keyEquivalent:(NSString *)aKeyEquivalent;
- (VKMenu *)addMenuWithTitle:(NSString *)aTitle
               keyEquivalent:(NSString *)aKeyEquivalent;
- (void)setTarget:(id)aTarget;
@end

@interface VKMenu : VKComponent {
  NSMutableArray *_items;
  id _target;
}
+ (id)newWithName:(NSString *)aName parent:(VKComponent *)aParent;
- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent;
- (void)addItemWithTitle:(NSString *)aTitle
                  action:(SEL)anAction
           keyEquivalent:(NSString *)aKeyEquivalent;
- (void)addSeparator;
- (void)setTarget:(id)aTarget;
@end
