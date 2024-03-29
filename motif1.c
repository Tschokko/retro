/* dynapix.c -- Display a bitmap in a MainWindow, but allow the user 
** to change the bitmap and its color dynamically. The design of the 
** program is structured on the pulldown menus of the menubar and the 
** callback routines associated with them. To allow the user to choose 
** a new bitmap, the "Open" button pops up a FileSelectionDialog where 
** a new bitmap file can be chosen. 
*/
#include <stdio.h>
#include <stdlib.h>
#include <Xm/MainW.h>
#include <Xm/Label.h>
#include <Xm/MessageB.h>
#include <Xm/FileSB.h>

/* Globals: the toplevel window/widget and the label for the bitmap. 
** "colors" defines the colors we use, "cur_color" is the current 
** color being used, and "cur_bitmap" references the current bitmap 
** file. 
*/
Widget toplevel, label;
String colors[] = {"Black", "Red", "Green", "Blue"};
Pixel cur_color;
/* make large enough for full pathnames */
char cur_bitmap[1024] = "xlogo64";

void main(int argc, char *argv[])
{
    Widget main_w, menubar, menu, widget;
    XtAppContext app;
    Pixmap pixmap;
    XmString file, edit, help, open, quit, red, green, blue, black;
    void file_cb(Widget, XtPointer, XtPointer);
    void change_color(Widget, XtPointer, XtPointer);
    void help_cb(Widget, XtPointer, XtPointer);
    Arg al[10];
    Cardinal ac = 0;

    XtSetLanguageProc(NULL, NULL, NULL);
    /* Initialize toolkit and parse command line options. */
    toplevel = XtVaOpenApplication(&app, "Demos", NULL, 0, &argc, argv,
                                   NULL, sessionShellWidgetClass, NULL);
    /* main window contains a MenuBar and a Label displaying a pixmap */
    ac = 0;
    XtSetArg(al[ac], XmNscrollBarDisplayPolicy, XmAS_NEEDED);
    ac++;
    XtSetArg(al[ac], XmNscrollingPolicy, XmAUTOMATIC);
    ac++;
    main_w = XmCreateMainWindow(toplevel, "main_window", al, ac);
    /* Create a simple MenuBar that contains three menus */
    file = XmStringCreateLocalized("File");
    edit = XmStringCreateLocalized("Edit");
    help = XmStringCreateLocalized("Help");
    menubar = XmVaCreateSimpleMenuBar(main_w, "menubar",
                                      XmVaCASCADEBUTTON, file, 'F',
                                      XmVaCASCADEBUTTON, edit, 'E',
                                      XmVaCASCADEBUTTON, help, 'H',
                                      NULL);
    XmStringFree(file);
    XmStringFree(edit);
    /* don't free "help" compound string yet -- reuse it later */
    /* Tell the menubar which button is the help menu */
    if ((widget = XtNameToWidget(menubar, "button_2")) != (Widget)0)
        XtVaSetValues(menubar, XmNmenuHelpWidget, widget, NULL);
    /* First menu is the File menu -- callback is file_cb() */
    open = XmStringCreateLocalized("Open...");
    quit = XmStringCreateLocalized("Quit");
    XmVaCreateSimplePulldownMenu(menubar, "file_menu", 0, file_cb,
                                 XmVaPUSHBUTTON, open, 'N', NULL, NULL,
                                 XmVaSEPARATOR,
                                 XmVaPUSHBUTTON, quit, 'Q', NULL, NULL,
                                 NULL);
    XmStringFree(open);
    XmStringFree(quit);
    /* Second menu is the Edit menu -- callback is change_color() */
    black = XmStringCreateLocalized(colors[0]);
    red = XmStringCreateLocalized(colors[1]);
    green = XmStringCreateLocalized(colors[2]);
    blue = XmStringCreateLocalized(colors[3]);
    menu = XmVaCreateSimplePulldownMenu(menubar, "edit_menu", 1, change_color,
                                        XmVaRADIOBUTTON, black, 'k', NULL, NULL,
                                        XmVaRADIOBUTTON, red, 'R', NULL, NULL,
                                        XmVaRADIOBUTTON, green, 'G', NULL, NULL,
                                        XmVaRADIOBUTTON, blue, 'B', NULL, NULL,
                                        /* RowColumn resources to enforce */
                                        XmNradioBehavior, True,
                                        /* radio behavior in Menu */
                                        XmNradioAlwaysOne, True,
                                        NULL);
    XmStringFree(black);
    XmStringFree(red);
    XmStringFree(green);
    XmStringFree(blue);
    /* Initialize menu so that "black" is selected. */
    if ((widget = XtNameToWidget(menu, "button_0")) != (Widget)0)
        XtVaSetValues(widget, XmNset, XmSET, NULL);
    /* Third menu is the help menu -- callback is help_cb() */
    XmVaCreateSimplePulldownMenu(menubar, "help_menu", 2, help_cb,
                                 XmVaPUSHBUTTON, help, 'H', NULL, NULL, NULL);
    XmStringFree(help); /* we're done with it; now we can free it */
    XtManageChild(menubar);
    /* user can still specify the initial bitmap */
    if (argv[1])
        (void)strcpy(cur_bitmap, argv[1]);
    /* initialize color */
    cur_color = BlackPixelOfScreen(XtScreen(toplevel)),
    /* create initial bitmap */
        pixmap = XmGetPixmap(XtScreen(toplevel), cur_bitmap, cur_color,
                             WhitePixelOfScreen(XtScreen(toplevel)));
    if (pixmap == XmUNSPECIFIED_PIXMAP)
    {
        puts("can't create initial pixmap");
        exit(1);
    }
    /* Now create label using pixmap */
    ac = 0;
    XtSetArg(al[ac], XmNlabelType, XmPIXMAP);
    ac++;
    XtSetArg(al[ac], XmNlabelPixmap, pixmap);
    ac++;
    label = XmCreateLabel(main_w, "label", al, ac);
    XtManageChild(label);
    /* set the label as the "work area" of the main window */
    XtVaSetValues(main_w, XmNmenuBar, menubar, XmNworkWindow, label, NULL);
    XtManageChild(main_w);
    XtRealizeWidget(toplevel);
    XtAppMainLoop(app);
}

/*
** Popdown routine for the File Selection Box
*/
void hide_fsb(Widget w, XtPointer client_data, XtPointer call_data)
{
    /* This also pops down the XmDialogShell parent of the
** File Selection Box
*/
    XtUnmanageChild(w);
}

/* Any item the user selects from the File menu calls this function. 
** It will either be "Open" (item_no == 0) or "Quit" (item_no == 1). 
*/
void file_cb(Widget widget,         /* menu item that was selected */
             XtPointer client_data, /* the index into the menu */
             XtPointer call_data)   /* unused */
{
    static Widget dialog; /* make it static for reuse */
    void load_pixmap(Widget, XtPointer, XtPointer);
    long item_no = (long)client_data;

    if (item_no == 1) /* the "quit" item */
        exit(0);
    /* "Open" was selected. Create a Motif FileSelectionDialog w/callback */
    if (!dialog)
    {
        dialog = XmCreateFileSelectionDialog(toplevel, "file_sel", NULL, 0);
        XtAddCallback(dialog, XmNokCallback, load_pixmap, NULL);
        XtAddCallback(dialog, XmNcancelCallback, hide_fsb, NULL);
    }
    /* This also pops up the XmDialogShell parent of the File selection box */
    XtManageChild(dialog);
}

/* The OK button was selected from the FileSelectionDialog (or, the user 
** double-clicked on a file selection). Try to read the file as a bitmap.
** If the user changed colors, we call this function directly from
** change_color()to reload the pixmap. In this case, we pass NULL as the
** callback struct so we can identify this special case. 
*/
void load_pixmap(Widget dialog, XtPointer client_data, XtPointer call_data)
{
    Pixmap pixmap;
    char *file = NULL;
    XmFileSelectionBoxCallbackStruct *cbs;

    cbs = (XmFileSelectionBoxCallbackStruct *)call_data;
    if (cbs)
    {
        file = (char *)XmStringUnparse(cbs->value, NULL,
                                       XmCHARSET_TEXT, XmCHARSET_TEXT,
                                       NULL, 0, XmOUTPUT_ALL);
        if (file == (char *)0)
            return; /* internal error */
        (void)strcpy(cur_bitmap, file);
        XtFree(file); /* free allocated data from XmStringUnparse() */
    }
    pixmap = XmGetPixmap(XtScreen(toplevel), cur_bitmap, cur_color,
                         WhitePixelOfScreen(XtScreen(toplevel)));
    if (pixmap == XmUNSPECIFIED_PIXMAP)
        printf("Can't create pixmap from %s\n", cur_bitmap);
    else
    {
        Pixmap old;
        XtVaGetValues(label, XmNlabelPixmap, &old, NULL);
        XmDestroyPixmap(XtScreen(toplevel), old);
        XtVaSetValues(label, XmNlabelType, XmPIXMAP, XmNlabelPixmap, pixmap,
                      NULL);
    }
}
/* called from any of the "Edit" menu items. Change the color of the 
** current bitmap being displayed. Do this by calling load_pixmap(). 
*/
void change_color(Widget widget,         /* selected menu item  */
                  XtPointer client_data, /* the index into the menu */
                  XtPointer call_data)   /* unused */
{
    XColor xcolor, unused;
    Display *dpy = XtDisplay(label);
    Colormap cmap = DefaultColormapOfScreen(XtScreen(label));
    long item_no = (long)client_data;

    if (XAllocNamedColor(dpy, cmap, colors[item_no], &xcolor, &unused) == 0 ||
        cur_color == xcolor.pixel)
        return;

    cur_color = xcolor.pixel;
    load_pixmap(widget, NULL, NULL);
}

#define MSG \
    "Use the FileSelection dialog to find bitmap files to\n\
display in the scrolling area in the main window. Use\n\
the edit menu to display the bitmap in different colors."

/* The help button in the help menu from the menubar was selected. 
** Display help information defined above for how to use the program. 
** This is done by creating a Motif information dialog box. Again, 
** make the dialog static so we can reuse it. 
*/
void help_cb(Widget widget, XtPointer client_data, XtPointer call_data)
{
    static Widget dialog;
    if (!dialog)
    {
        Arg args[5];
        int n = 0;
        XmString msg = XmStringCreateLocalized(MSG);
        XtSetArg(args[n], XmNmessageString, msg);
        n++;
        dialog = XmCreateInformationDialog(toplevel, "help_dialog", args, n);
    }
    /* This also pops up the XmDialogShell parent of the XmMessageBox */
    XtManageChild(dialog);
}
