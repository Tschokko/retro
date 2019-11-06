#include <stdlib.h>
#include <X11/Intrinsic.h>
#include <Xm/FileSB.h>
#include <Xm/MainW.h>
#include <Xm/Label.h>
#include <Xm/List.h>
#include <Xm/MessageB.h>

Widget toplevel;

void file_cb(Widget, XtPointer, XtPointer);
void help_cb(Widget, XtPointer, XtPointer);

int main(int argc, char *argv[])
{
    Widget main_w, menubar, list_w, widget;
    XtAppContext app;
    XmString file, help, open, quit;

    XtSetLanguageProc(NULL, NULL, NULL);

    toplevel = XtVaAppInitialize(&app, "Hello", NULL, 0, &argc, argv, NULL, NULL);

    main_w = XtVaCreateManagedWidget("main_window",
                                     xmMainWindowWidgetClass, toplevel,
                                     NULL);

    file = XmStringCreateLocalized("File");
    help = XmStringCreateLocalized("Help");

    menubar = XmVaCreateSimpleMenuBar(main_w, "menubar",
                                      XmVaCASCADEBUTTON, file, 'F',
                                      XmVaCASCADEBUTTON, help, 'H',
                                      NULL);
    XmStringFree(file);
    /*XmStringFree(help);*/

    if ((widget = XtNameToWidget(menubar, "button_1")) != NULL)
    {
        XtVaSetValues(menubar,
                      XmNmenuHelpWidget, widget,
                      NULL);
    }

    open = XmStringCreateLocalized("Open...");
    quit = XmStringCreateLocalized("Quit");
    XmVaCreateSimplePulldownMenu(menubar, "file_menu", 0, file_cb,
                                 XmVaPUSHBUTTON, open, 'N', NULL, NULL,
                                 XmVaSEPARATOR,
                                 XmVaPUSHBUTTON, quit, 'Q', NULL, NULL,
                                 NULL);
    XmStringFree(open);
    XmStringFree(quit);

    XmVaCreateSimplePulldownMenu(menubar, "help_menu", 1, help_cb,
                                 XmVaPUSHBUTTON, help, 'H', NULL, NULL,
                                 NULL);
    XmStringFree(help);

    XtManageChild(menubar);

    XFontStruct *font = NULL;
    XmFontList font_list = NULL;
    char *font_name = "-adobe-courier-medium-r-normal-17--17-*-*-*-*-*-*-*";

    list_w = XmCreateScrolledList(main_w, "main_list", NULL, 0);
    //font = XLoadQueryFont(XtDisplay(list_w), font_name);
    //font_list = XmFontListCreate(font, XmSTRING_DEFAULT_CHARSET);

    XtVaSetValues(list_w,
                  /*XmNfontList, font_list,*/
                  XtVaTypedArg, XmNitems, XmRString,
                  "1  Red, 2  Green, 3  Blue, 4  Orange, 5  Maroon, 6  Grey, 7  Black, 8  White", 76,
                  XmNitemCount, 8,
                  XmNvisibleItemCount, 5,
                  NULL);
    // XmFontListFree(font_list);

    XtManageChild(list_w);

    XtVaSetValues(main_w, XmNworkWindow, XtParent(list_w), NULL);

    XtRealizeWidget(toplevel);
    // XtAppMainLoop(app);
    do
    {
        XEvent event;
        XtAppNextEvent(app, &event);
        XtDispatchEvent(&event);
    } while (XtAppGetExitFlag(app) == FALSE);
    printf("Exit application\n");
}

void file_cb(Widget widget, XtPointer client_data, XtPointer call_data)
{
    static Widget dialog;
    int item_sel = (int)client_data;
    if (item_sel == 1)
    {
        exit(0);
    }

    if (!dialog)
    {
        dialog = XmCreateFileSelectionBox(toplevel, "file_dialog", NULL, 0);
        XtAddCallback(dialog,
                      XmNcancelCallback, (void (*)(Widget, XtPointer, XtPointer))XtUnmanageChild,
                      NULL);
    }

    XtManageChild(dialog);
    XtPopup(XtParent(dialog), XtGrabNone);
}

#define MSG "Hello World App"
void help_cb(Widget widget, XtPointer client_data, XtPointer call_data)
{
    static Widget dialog;

    if (!dialog)
    {
        Arg args[5];
        int n = 0;
        XmString msg = XmStringCreateLtoR(MSG, XmFONTLIST_DEFAULT_TAG);
        XtSetArg(args[n], XmNmessageString, msg);
        n++;
        dialog = XmCreateInformationDialog(toplevel, "help_dialog", args, n);
    }

    XtManageChild(dialog);
    XtPopup(XtParent(dialog), XtGrabNone);
}