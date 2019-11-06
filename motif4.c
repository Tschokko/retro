#include <stdlib.h>
#include <stdio.h>
#include <X11/Intrinsic.h>
#include <Xm/AtomMgr.h>
#include <Xm/FileSB.h>
#include <Xm/MainW.h>
#include <Xm/Label.h>
#include <Xm/List.h>
#include <Xm/Protocols.h>
#include <Xm/MessageB.h>

XtAppContext app_context;
Widget session_shell_widget;
Widget top_level_shell_widget, main_window_widget;
Widget sec_top_level_shell_widget, sec_main_window_widget;
Display *session_shell_display;

void session_shell_destroy_cb(Widget w, XtPointer clientData, XtPointer callData)
{
    printf("session_shell_destroy_cb has been called\n");
    XtAppSetExitFlag(app_context);
}

void top_level_shell_destroy_cb(Widget w, XtPointer clientData, XtPointer callData)
{
    printf("top_level_shell_destroy_cb has been called\n");
}

void main_window_destroy_cb(Widget w, XtPointer clientData, XtPointer callData)
{
    printf("main_window_destroy_cb has been called\n");
    XtAppSetExitFlag(app_context);
}

void sec_top_level_shell_destroy_cb(Widget w, XtPointer clientData, XtPointer callData)
{
    printf("sec_top_level_shell_destroy_cb has been called\n");
}

void sec_main_window_destroy_cb(Widget w, XtPointer clientData, XtPointer callData)
{
    printf("sec_main_window_destroy_cb has been called\n");
    XtAppSetExitFlag(app_context);
}

// NO NEEDED NOW

void wm_delete_window(Widget w, XtPointer clientData, XtPointer callData)
{
    printf("wm_delete_window has been called\n");
}

void wm_quit_app(Widget w, XtPointer clientData, XtPointer callData)
{
    printf("wm_quit_app has been called\n");
}

int main(int argc, char *argv[])
{
    Cardinal ac = 0;
    Arg al[10];

    //
    // Create application and session shell widget
    //
    session_shell_widget =
        XtOpenApplication(&app_context, "motif4", NULL, 0, &argc,
                          argv, NULL, sessionShellWidgetClass, NULL, 0);
    // XtRealizeWidget(session_shell_widget);
    XtAddCallback(session_shell_widget, XmNdestroyCallback,
                  session_shell_destroy_cb, NULL);
    session_shell_display = XtDisplay(session_shell_widget);

    //
    // Create top level shell widget
    //
    ac = 0;
    XtSetArg(al[ac], XmNx, 0);
    ac++;
    XtSetArg(al[ac], XmNy, 0);
    ac++;
    XtSetArg(al[ac], XmNwidth, 640);
    ac++;
    XtSetArg(al[ac], XmNheight, 480);
    ac++;
    XtSetArg(al[ac], XmNtitle, "Main Window");
    ac++;
    // XtSetArg(al[ac], XmNdeleteResponse, XmDO_NOTHING);
    // ac++;

    top_level_shell_widget = XtCreatePopupShell("top_level_shell",
                                                topLevelShellWidgetClass,
                                                session_shell_widget, al, ac);
    XtAddCallback(top_level_shell_widget, XmNdestroyCallback,
                  top_level_shell_destroy_cb, NULL);

    //
    // Create main window widget
    //

    /*Atom WM_DELETE_WINDOW;
    Atom WM_QUIT_APP;
    WM_DELETE_WINDOW = XmInternAtom(session_shell_display,
                                    (char *)"WM_DELETE_WINDOW", False);
    WM_QUIT_APP = XmInternAtom(session_shell_display,
                               (char *)"WM_QUIT_APP", True);*/

    main_window_widget = XmCreateMainWindow(top_level_shell_widget,
                                            "main_window", al, ac);

    // XtVaSetValues(main_window_widget, XmNdeleteResponse, XmUNMAP, NULL);
    XtAddCallback(main_window_widget, XmNdestroyCallback,
                  main_window_destroy_cb, NULL);
    /*XmAddWMProtocolCallback(
        main_window_widget, WM_DELETE_WINDOW, wm_delete_window, NULL);
    if (WM_QUIT_APP != None)
    {
        XmAddWMProtocolCallback(main_window_widget, WM_QUIT_APP, wm_quit_app, NULL);
    }*/

    XtManageChild(main_window_widget);

    //
    // TEST
    //
    // XtMakeResizeRequest(session_shell_widget, 640, 480, NULL, NULL);

    XtPopup(top_level_shell_widget, XtGrabNonexclusive);

    // ----------
    /// SECOND WINDOW
    // -----------

    ac = 0;
    XtSetArg(al[ac], XmNx, 641);
    ac++;
    XtSetArg(al[ac], XmNy, 0);
    ac++;
    XtSetArg(al[ac], XmNwidth, 320);
    ac++;
    XtSetArg(al[ac], XmNheight, 240);
    ac++;
    XtSetArg(al[ac], XmNtitle, "Second Window");
    ac++;

    sec_top_level_shell_widget = XtCreatePopupShell("sec_top_level_shell",
                                                    topLevelShellWidgetClass,
                                                    session_shell_widget, al, ac);
    XtAddCallback(sec_top_level_shell_widget, XmNdestroyCallback,
                  sec_top_level_shell_destroy_cb, NULL);

    sec_main_window_widget = XmCreateMainWindow(sec_top_level_shell_widget,
                                                "sec_main_window", NULL, 0);
    XtAddCallback(sec_main_window_widget, XmNdestroyCallback,
                  sec_main_window_destroy_cb, NULL);

    XtManageChild(sec_main_window_widget);

    XtPopup(sec_top_level_shell_widget, XtGrabNonexclusive);

    // ----------
    // OUR MAIN LOOP
    // ----------

    XtAppMainLoop(app_context);

    return 0;
}
