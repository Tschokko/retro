#import <Foundation/Foundation.h>

#include <X11/Intrinsic.h>

@interface NXWidget : NSObject {
  Widget _w;
  NSString *_name;
  NXWidget *_parent;
}
+ (id)newWithName:(NSString *)aName widgetClass:(WidgetClass)aWidgetClass;
+ (id)newWithName:(NSString *)aName
      widgetClass:(WidgetClass)aWidgetClass
           parent:(NXWidget *)aParent;
- (id)initWithName:(NSString *)aName;
- (id)initWithName:(NSString *)aName widgetClass:(WidgetClass)aWidgetClass;
- (id)initWithName:(NSString *)aName
       widgetClass:(WidgetClass)aWidgetClass
            parent:(NXWidget *)aParent;
- (void)manageChild;
- (void)realize;
- (NSString *)name;
- (Widget)baseWidget;
@end

@interface NXApplication : NXWidget {
  XtAppContext _app_context;
  Display *_display;
  NSString *_title;
}
+ (id)newWithName:(NSString *)aName argc:(int)argc argv:(char **)argv;
- (id)initWithName:(NSString *)aName argc:(int)argc argv:(char **)argv;
- (void)run;
- (NSString *)title;
- (void)setTitle:(NSString *)aTitle;
@end

@interface NXPushButton : NXWidget {
  NSString *_label;
}
+ (id)newWithName:(NSString *)aTitle
           parent:(NXWidget *)aParent
            label:(NSString *)aString;
- (id)initWithName:(NSString *)aTitle
            parent:(NXWidget *)aParent
             label:(NSString *)aString;
- (NSString *)label;
- (void)setLabel:(NSString *)aLabel;
@end
