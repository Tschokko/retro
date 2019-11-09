#import "NXWidget.h"
#import "VKApplication.h"
#import "VKMainWindow.h"
#import "VKOpenGLDrawingArea.h"

// #include <GL/gl.h>
#define GLEW_STATIC
#include <GL/glew.h>
// #include <GL/glut.h>

@interface OpenGLView : VKOpenGLDrawingArea {
}
+ (id)newWithMainWindow:(VKMainWindow *)aParent;
- (id)initWithMainWindow:(VKMainWindow *)aParent;
- (void)drawRect:(NSRect)aRect;
- (void)resize:(NSRect)aRect;
@end // OpenGLView

@implementation OpenGLView
+ (id)newWithMainWindow:(VKMainWindow *)aParent {
  return [[self alloc] initWithMainWindow:aParent];
}

- (id)initWithMainWindow:(VKMainWindow *)aParent {
  self = [super initWithName:@"opengl" parent:aParent];
  return self;
}

- (void)drawRect:(NSRect)aRect {
  NSLog(@"OpenGLView drawRect called");

  glClearColor(0.0, 0.0, 0.0, 0.0);
  glClear(GL_COLOR_BUFFER_BIT);

  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();

  gluPerspective(20.0, (GLdouble)aRect.size.width / (GLdouble)aRect.size.height,
                 0.5, 20.0);
  glMatrixMode(GL_MODELVIEW);
  glViewport(0, 0, aRect.size.width, aRect.size.height);

  glBegin(GL_POLYGON);
  glColor3f(0.0, 0.0, 0.0);
  glVertex3f(-0.5, -0.5, -3.0);
  glColor3f(1.0, 0.0, 0.0);
  glVertex3f(0.5, -0.5, -3.0);
  glColor3f(0.0, 0.0, 1.0);
  glVertex3f(0.5, 0.5, -3.0);
  glEnd();
  glFlush();
}

- (void)resize:(NSRect)aRect {
  NSLog(@"OpenGLView resize called");
  /*glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  // Angle of view:40 degrees
  // Near clipping plane distance: 0.5
  // Far clipping plane distance: 20.0
  gluPerspective(20.0, (GLdouble)aRect.size.width / (GLdouble)aRect.size.height,
                 0.5, 20.0);
  glMatrixMode(GL_MODELVIEW);
  glViewport(0, 0, aRect.size.width,
             aRect.size.height); // Use the whole window for rendering*/
}
@end // OpenGLView

@interface HelloWorldController : NSObject {
  VKMainWindow *_main_window;
}
- (id)init;
- (void)applicationDidFinishLaunching;
- (void)quit;
@end

@implementation HelloWorldController
- (id)init {
  self = [super init];
  assert(self);

  _main_window = [[VKMainWindow newWithName:@"main_window" title:@"Hello World"]
      autorelease];
  [_main_window setFrame:NSMakeRect(100, 100, 640, 480)];

  VKMenuBar *menu_bar = [_main_window addMenuBarWithName:@"main_menu"];

  VKMenu *file_menu = [menu_bar addMenuWithTitle:@"File" keyEquivalent:@"F"];
  [file_menu setTarget:self];
  [file_menu addItemWithTitle:@"Open..." action:0 keyEquivalent:@"O"];
  [file_menu addItemWithTitle:@"Save" action:0 keyEquivalent:@"S"];
  [file_menu addItemWithTitle:@"Save as..." action:0 keyEquivalent:@"A"];
  [file_menu addSeparator];
  [file_menu addItemWithTitle:@"Quit"
                       action:@selector(quit)
                keyEquivalent:@"Q"];

  VKMenu *help_menu = [menu_bar addMenuWithTitle:@"Help" keyEquivalent:@"H"];
  [help_menu setTarget:self];
  [help_menu addItemWithTitle:@"About" action:0 keyEquivalent:@"A"];

  /*VKPushButton *btn = [[VKPushButton newWithName:@"button_1"
                                          parent:_main_window
                                           label:@"Click Me!"] autorelease];*/
  /*VKOpenGLDrawingArea *glw =
      [[VKOpenGLDrawingArea newWithName:@"opengl" parent:_main_window]
          autorelease];
  [glw setDelegate:self];*/

  OpenGLView *view = [[OpenGLView newWithMainWindow:_main_window] autorelease];

  return self;
}

- (void)dealloc {
  [super dealloc];
}

- (void)applicationDidFinishLaunching {
  [_main_window show];
}

- (void)quit {
  [VKApp quit];
}

- (void)resize:(NSSize)aSize {
  if (aSize.width == 0 || aSize.height == 0)
    return; // Nothing is visible then, so return
  // Set a new projection matrix
  glMatrixMode(GL_PROJECTION);
  glLoadIdentity();
  // Angle of view:40 degrees
  // Near clipping plane distance: 0.5
  // Far clipping plane distance: 20.0
  gluPerspective(40.0, (GLdouble)aSize.width / (GLdouble)aSize.height, 0.5,
                 20.0);
  glMatrixMode(GL_MODELVIEW);
  glViewport(0, 0, aSize.width,
             aSize.height); // Use the whole window for rendering
}

- (void)expose {
  // glClearColor(0.5, 0.5, 0.5, 1.0);
  /*glClearColor(0.0, 0.0, 0.0, 0.0);
  glClear(GL_COLOR_BUFFER_BIT);
  glColor3f(1.0, 0.0, 0.0);
  glRectf(-.5, -.5, .5, .5);
  glColor3f(0.0, 1.0, 0.0);
  glRectf(-.4, -.4, .4, .4);
  glColor3f(0.0, 0.0, 1.0);
  glRectf(-.3, -.3, .3, .3);
  glFlush();*/
  glClear(GL_COLOR_BUFFER_BIT);
  glLoadIdentity();
  glBegin(GL_POLYGON);
  glColor3f(0.0, 0.0, 0.0);
  glVertex3f(-0.5, -0.5, -3.0);
  glColor3f(1.0, 0.0, 0.0);
  glVertex3f(0.5, -0.5, -3.0);
  glColor3f(0.0, 0.0, 1.0);
  glVertex3f(0.5, 0.5, -3.0);
  glEnd();
  glFlush();

  /*static const GLfloat g_vertex_buffer_data[] = {
      -1.0f, -1.0f, 0.0f, 1.0f, -1.0f, 0.0f, 0.0f, 1.0f, 0.0f,
  };

  GLuint VertexArrayID;
  glGenVertexArrays(1, &VertexArrayID);
  glBindVertexArray(VertexArrayID);

  // This will identify our vertex buffer
  GLuint vertexbuffer;
  // Generate 1 buffer, put the resulting identifier in vertexbuffer
  glGenBuffers(1, &vertexbuffer);
  // The following commands will talk about our 'vertexbuffer' buffer
  glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
  // Give our vertices to OpenGL.
  glBufferData(GL_ARRAY_BUFFER, sizeof(g_vertex_buffer_data),
               g_vertex_buffer_data, GL_STATIC_DRAW);

  // 1st attribute buffer : vertices
  glEnableVertexAttribArray(0);
  glBindBuffer(GL_ARRAY_BUFFER, vertexbuffer);
  glVertexAttribPointer(0, // attribute 0. No particular reason for 0, but must
                           // match the layout in the shader.
                        3, // size
                        GL_FLOAT, // type
                        GL_FALSE, // normalized?
                        0,        // stride
                        (void *)0 // array buffer offset
  );
  // Draw the triangle !
  glDrawArrays(GL_TRIANGLES, 0,
               3); // Starting from vertex 0; 3 vertices total -> 1 triangle
  glDisableVertexAttribArray(0);*/
}
@end

int main(int argc, char *argv[]) {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  VKApplication *app =
      [[VKApplication openWithName:@"hello_world" argc:argc argv:argv]
          autorelease];

  HelloWorldController *ctrl =
      [[[HelloWorldController alloc] init] autorelease];

  [app setDelegate:ctrl];
  [app run];

  NSLog(@"app run finished");

  [pool drain]; // Call release when older GNUSTEP
  return 0;
}
