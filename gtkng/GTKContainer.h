#ifndef __GTKNG_GTKCONTAINER_H
#define __GTKNG_GTKCONTAINER_H

#import "GTKComponent.h"

@protocol GTKContainer
- (void)addChild:(GTKComponent *)aChild;
- (void)setBorderWidth:(uint)aWidth;
@end

#endif // __GTKNG_GTKCONTAINER_H
