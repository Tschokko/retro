#ifndef __GTKNG_GTKWINDOW_H
#define __GTKNG_GTKWINDOW_H

#import "GTKBin.h"

#import <Foundation/Foundation.h>
#import <gtk/gtk.h>

@interface GTKWindow : GTKBin {
  id _delegate;
}
+ (id) new;
- (id)init;
- (void)setDelegate:(id)aDelegate;
- (void)showAll;
@end

#endif // __GTKNG_GTKWINDOW_H
