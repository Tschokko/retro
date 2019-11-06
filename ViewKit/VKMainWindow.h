#import <Foundation/Foundation.h>

#include <X11/Intrinsic.h>

#import "VKComponent.h"

@class VKMenuBar;
@class VKMenu;

@interface VKMainWindow : VKComponent {
  Widget _top_level_shell_widget;
  id _delegate;
  VKMenuBar *_menu_bar;
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
@end

@interface VKMenuBar : VKComponent {
}
+ (id)newWithName:(NSString *)aName parent:(VKComponent *)aParent;
- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent;
- (void)addItemWithTitle:(NSString *)aTitle
                  action:(SEL)anAction
           keyEquivalent:(NSString *)aKeyEquivalent;
- (VKMenu *)addMenuWithTitle:(NSString *)aTitle
               keyEquivalent:(NSString *)aKeyEquivalent;
@end

@interface VKMenu : VKComponent {
}
+ (id)newWithName:(NSString *)aName parent:(VKComponent *)aParent;
- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent;
- (void)addItemWithTitle:(NSString *)aTitle
                  action:(SEL)anAction
           keyEquivalent:(NSString *)aKeyEquivalent;
- (void)addSeparator;
@end
