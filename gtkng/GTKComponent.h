#ifndef __GTKNG_GTKCOMPONENT_H
#define __GTKNG_GTKCOMPONENT_H

#import <Foundation/Foundation.h>
#import <gtk/gtk.h>

@interface GTKComponent : NSObject {
  GtkWidget *_widget;
}
- (GtkWidget *)widget;
@end

#endif // __GTKNG_GTKCOMPONENT_H
