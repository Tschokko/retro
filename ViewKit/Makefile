PROJECT = HelloWorld
SOURCES = $(wildcard *.m)
OBJS = $(SOURCES:.m=.o)
CC=gcc
CFLAGS=-g -Wall -I/usr/include/GNUstep -fconstant-string-class=NSConstantString -fgnu-runtime
LDFLAGS=-L/usr/lib/GNUstep/Libraries -lgnustep-base -lobjc -lGLw -lXm -lXt -lGLEW -lGLU -lGL -lX11

.PHONY: all
all: $(PROJECT)
 
# Compile the source files into object files
#simple.o : simple.m
#	$(CC) -c simple.m -o simple.o $(CFLAGS)
%.o: %.m
	$(CC) -c -o $@ $(CFLAGS) $<
#    $(CC) $(CFLAGS) -o $@ -c $<

# Link the object files into a binary
#simple : simple.o
#	$(CC) -o simple simple.o $(LDFLAGS)
$(PROJECT): $(OBJS)
	$(CC) -o $@ $^ $(LDFLAGS)
 
# Clean target
.PHONY: clean
clean:
	rm -f $(OBJS) $(PROJECT)
#	rm simple.o simple