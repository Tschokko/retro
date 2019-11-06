#ifndef __GTKNG_GTKTOGGLEBUTTON_H
#define __GTKNG_GTKTOGGLEBUTTON_H

#import "GTKButton.h"

#import <Foundation/Foundation.h>
#import <gtk/gtk.h>

@interface GTKToggleButton : GTKButton {
  /*SEL _action;
  id _target;*/
}
+ (id)newWithLabel:(NSString *)aLabel;
- (id)initWithLabel:(NSString *)aLabel;
- (BOOL)isActive;
/*- (SEL)action;
- (void)setAction:(SEL)aAction;
- (id)target;
- (void)setTarget:(id)aTarget;*/
@end

#endif // __GTKNG_GTKTOGGLEBUTTON_H
