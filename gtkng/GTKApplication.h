#ifndef __GTKNG_GTKAPPLICATION_H
#define __GTKNG_GTKAPPLICATION_H

#import "GTKWindow.h"

#import <Foundation/Foundation.h>
#import <gtk/gtk.h>

@interface GTKApplication : NSObject {
  id _delegate;
}
+ (id)newWithArgc:(int)argc argv:(char **)argv;
- (id)initWithArgc:(int)argc argv:(char **)argv;
- (void)setDelegate:(id)aDelegate;
- (void)run /*:(GTKWindow *)window*/;
- (void)quit;
@end

extern GTKApplication *GTKApp;

#endif // __GTKNG_GTKAPPLICATION_H
