#import "VKOpenGLDrawingArea.h"
#import "VKApplication.h"

#include <GL/GLwMDrawA.h>
#include <assert.h>

static GLXContext glx_context; // assume only one context
static XVisualInfo *visual_info;
static int attribs[] = {GLX_RGBA, None};

static void __objc_VKOpenGLDrawingArea_expose_cb(Widget widget,
                                                 XtPointer client_data,
                                                 XtPointer call_data);
static void __objc_VKOpenGLDrawingArea_resize_cb(Widget widget,
                                                 XtPointer client_data,
                                                 XtPointer call_data);
static void __objc_VKOpenGLDrawingArea_ginit_cb(Widget widget,
                                                XtPointer client_data,
                                                XtPointer call_data);
@implementation VKOpenGLDrawingArea
+ (id)newWithName:(NSString *)aName parent:(VKComponent *)aParent {
  return [[self alloc] initWithName:aName parent:aParent];
}

- (id)initWithName:(NSString *)aName parent:(VKComponent *)aParent {
  NSLog(@"VKOpenGLDrawingArea init entered");

  self = [super init];
  assert(self);

  if (!(visual_info = glXChooseVisual(
            [VKApp display], DefaultScreen([VKApp display]), attribs))) {
    assert(NULL && "OpenGL error: no suitable RGB visual");
  }
  // XtAppError(app, "no suitable RGB visual");

  _widget = XtVaCreateManagedWidget([aName cString], glwMDrawingAreaWidgetClass,
                                    [aParent widget], GLwNvisualInfo,
                                    visual_info, NULL);
  XtAddCallback(_widget, GLwNexposeCallback,
                __objc_VKOpenGLDrawingArea_expose_cb, self);
  XtAddCallback(_widget, GLwNresizeCallback,
                __objc_VKOpenGLDrawingArea_resize_cb, self);
  XtAddCallback(_widget, GLwNginitCallback, __objc_VKOpenGLDrawingArea_ginit_cb,
                self);

  // XtManageChild(_widget);

  // [self draw];

  NSLog(@"VKOpenGLDrawingArea init finished");
  return self;
}

- (void)dealloc {
  NSLog(@"VKOpenGLDrawingArea dealloc entered");
  [super dealloc];
  NSLog(@"VKOpenGLDrawingArea dealloc finished");
}

- (void)drawRect:(NSRect)aRect {
}

- (void)resize:(NSRect)aRect {
}
@end

void __objc_VKOpenGLDrawingArea_expose_cb(Widget widget, XtPointer client_data,
                                          XtPointer call_data) {
  // NSLog(@"__objc_VKOpenGLDrawingArea_expose_cb called");
  // GLwDrawingAreaMakeCurrent(widget, glx_context);

  if (client_data != NULL) {
    GLwDrawingAreaCallbackStruct *glw_call_data =
        (GLwDrawingAreaCallbackStruct *)call_data;
    NSLog(@"VKOpenGLDrawingArea expose callback called: width=%d height=%d",
          glw_call_data->width, glw_call_data->height);
    VKOpenGLDrawingArea *glw = (VKOpenGLDrawingArea *)client_data;
    [glw
        drawRect:NSMakeRect(0, 0, glw_call_data->width, glw_call_data->height)];
  }
}

void __objc_VKOpenGLDrawingArea_resize_cb(Widget widget, XtPointer client_data,
                                          XtPointer call_data) {
  // NSLog(@"__objc_VKOpenGLDrawingArea_resize_cb called");
  // GLwDrawingAreaMakeCurrent(widget, glx_context);

  // TODO Decide if we change the viewport before or after perform action
  GLwDrawingAreaCallbackStruct *glw_call_data =
      (GLwDrawingAreaCallbackStruct *)call_data;
  glXWaitX();
  glViewport(0, 0, glw_call_data->width, glw_call_data->height);

  if (client_data != NULL) {
    VKOpenGLDrawingArea *glw = (VKOpenGLDrawingArea *)client_data;
    NSLog(@"VKOpenGLDrawingArea resize callback called: width=%d height=%d",
          glw_call_data->width, glw_call_data->height);
    [glw resize:NSMakeRect(0, 0, glw_call_data->width, glw_call_data->height)];
  }
}

void __objc_VKOpenGLDrawingArea_ginit_cb(Widget widget, XtPointer client_data,
                                         XtPointer call_data) {
  NSLog(@"__objc_VKOpenGLDrawingArea_ginit_cb called");

  /*Arg args[1];
  XVisualInfo *vi;

  XtSetArg(args[0], GLwNvisualInfo, &vi);
  XtGetValues(widget, args, 1);*/

  // create a visual context
  glx_context = glXCreateContext([VKApp display], visual_info, NULL, GL_TRUE);
  GLwDrawingAreaMakeCurrent(widget, glx_context);

  if (client_data != NULL) {
    // VKOpenGLDrawingArea *glw = (VKOpenGLDrawingArea *)client_data;
    // Perform any necessary graphics initialization
  }
}
