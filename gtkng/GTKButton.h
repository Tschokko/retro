#ifndef __GTKNG_GTKBUTTON_H
#define __GTKNG_GTKBUTTON_H

#import "GTKComponent.h"

#import <Foundation/Foundation.h>
#import <gtk/gtk.h>

@interface GTKButton : GTKComponent {
  SEL _action;
  id _target;
}
+ (id)newWithLabel:(NSString *)aLabel;
- (id)initWithLabel:(NSString *)aLabel;
- (SEL)action;
- (void)setAction:(SEL)aAction;
- (id)target;
- (void)setTarget:(id)aTarget;
@end

#endif // __GTKNG_GTKBUTTON_H
