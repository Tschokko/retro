#import "GTKBin.h"

@implementation GTKBin
- (id)init {
  NSLog(@"GTKBin init entered");
  self = [super init];
  NSLog(@"GTKBin init finished");
  return self;
}

- (void)dealloc {
  NSLog(@"GTKBin dealloc entered");
  if (_child) {
    [_child autorelease];
    NSLog(@"GTKBin autorelease child: %@", _child);
  }
  [super dealloc];
  NSLog(@"GTKBin dealloc finished");
}

- (void)addChild:(GTKComponent *)aChild {
  [_child autorelease];
  _child = [aChild retain];
  NSLog(@"GTKBin retain child: %@", _child);
  gtk_container_add(GTK_CONTAINER([self widget]), [aChild widget]);
}

- (void)removeChild {
  if (_child) {
    gtk_container_remove(GTK_CONTAINER([self widget]), [_child widget]);
    [_child autorelease];
    NSLog(@"GTKBin autorelease child: %@", _child);
  }
}

- (void)setBorderWidth:(uint)aWidth {
  gtk_container_set_border_width(GTK_CONTAINER([self widget]), aWidth);
}
@end
