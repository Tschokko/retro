CC=gcc 
CFLAGS=-Wall -I/usr/include/GNUstep -fconstant-string-class=NSConstantString
LDFLAGS=-L/usr/lib/GNUstep/Libraries -lgnustep-base -lobjc -lXm -lXt -lX11

.PHONY : all
all : simple
 
# Link the object files into a binary
simple : simple.o
	$(CC) -o simple simple.o $(LDFLAGS)
 
# Compile the source files into object files
simple.o : simple.m
	$(CC) -c simple.m -o simple.o $(CFLAGS)
 
# Clean target
.PHONY : clean
clean :
	rm simple.o simple