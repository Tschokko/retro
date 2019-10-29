#include <X11/IntrinsicP.h>
#include <X11/ShellP.h>
#include <Xm/MainW.h>
#include <stdio.h>

Widget toplevel_widget;
XtAppContext app;

void main(int argc, char *argv[]) {
  // void button_pushed();
  // XmString label;
  Widget main_window_widget;
  short unsigned int xx, yy;

  XtSetLanguageProc(NULL, NULL, NULL);

  toplevel_widget = XtOpenApplication(&app, "Hello", NULL, 0, &argc, argv, NULL,
                                      applicationShellWidgetClass, NULL, 0);
  XtMakeResizeRequest(toplevel_widget, 640, 480, &xx, &yy);

  main_window_widget = XtVaCreateManagedWidget(
      "main_window", xmMainWindowWidgetClass, toplevel_widget, NULL);

  label = XmStringCreateLocalized("Push here to say hello");
  button = XtVaCreateManagedWidget("pushme", xmPushButtonWidgetClass, toplevel,
                                   XmNlabelString, label, NULL);
  XmStringFree(label);
  // XtAddCallback(button, XmNactivateCallback, button_pushed, NULL);

  XtManageChild(button);

  // XtVaSetValues(main_w, XmNworkWindow, XtParent(button), NULL);

  XtRealizeWidget(toplevel_widget);
  XtAppMainLoop(app);
}

/*void button_pushed(Widget widget, XtPointer client_data, XtPointer call_data)
{ printf("Hello Yourself");
}*/
