#import <Foundation/Foundation.h>
#import <stdio.h>

@interface Person : NSObject {
    char *name;
}

- (void)sayHello;
@end

@implementation Person

- (void)sayHello {
    printf("Hello World!\n");
}
@end

int main(void) {
    Person *brad = [Person new];
    [brad sayHello];
    [brad release];

    return 0;
}
