#ifndef __GTKNG_GTKBIN_H
#define __GTKNG_GTKBIN_H

#import "GTKComponent.h"
#import "GTKContainer.h"

#import <Foundation/Foundation.h>
#import <gtk/gtk.h>

@interface GTKBin : GTKComponent <GTKContainer> {
  GTKComponent *_child;
}
- (id)init;
- (void)addChild:(GTKComponent *)aChild;
- (void)removeChild;
- (void)setBorderWidth:(uint)aWidth;
@end

#endif // __GTKNG_GTKBIN_H
