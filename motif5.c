#include <X11/Intrinsic.h>
#include <X11/Shell.h>
#include <Xm/MainW.h>
#include <errno.h>
#include <stdlib.h>
#include <stdio.h>

struct ui_main_window
{
    Widget top_level_shell_widget;
    Widget widget;
};
typedef struct ui_main_window *ui_main_window_t;

void ui_main_window_free(ui_main_window_t main_window);

/*******************************************************************************
 * ui_application
 ******************************************************************************/
struct ui_application
{
    XtAppContext xt_app_context;
    Widget session_shell_widget;
    ui_main_window_t main_window;
};
typedef struct ui_application *ui_application_t;

int ui_application_alloc(ui_application_t *application_p, const char *name, int argc, char *argv[])
{
    if (application_p == NULL || name == NULL)
    {
        return EINVAL;
    }

    if ((*application_p = calloc(1, sizeof(struct ui_application))) == NULL)
    {
        return ENOMEM;
    }

    (*application_p)->session_shell_widget = XtOpenApplication(&((*application_p)->xt_app_context),
                                                               name, NULL, 0, &argc,
                                                               argv, NULL, sessionShellWidgetClass,
                                                               NULL, 0);

    printf("ui_application_alloc\n");
    return 0;
}

void ui_application_free(ui_application_t application)
{
    if (application == NULL)
    {
        return;
    }

    free(application);
    printf("ui_application_free\n");
}

void ui_application_exit(ui_application_t application)
{
    if (application == NULL)
    {
        return;
    }

    XtAppSetExitFlag(application->xt_app_context);

    if (application->main_window != NULL)
    {
        ui_main_window_free(application->main_window);
    }

    ui_application_free(application);
}

void ui_application_run(ui_application_t application)
{
    XtAppMainLoop(application->xt_app_context);
}

void __ui_application_destroy_cb(Widget w, XtPointer clientData,
                                 XtPointer callData)
{
    ui_application_exit(g_ui_application_run);
}

int ui_application_register_main_window(ui_application_t application, ui_main_window_t main_window)
{
    if (application == NULL || application->main_window != NULL)
    {
        return EINVAL;
    }

    application->main_window = main_window;

    XtAddCallback(application->main_window->widget, XmNdestroyCallback, __ui_application_destroy_cb, NULL);
}

/*******************************************************************************
 * ui_shared_application
 ******************************************************************************/

static ui_application_t s_ui_shared_application;

int ui_shared_application_init(const char *name, int argc, char *argv[])
{
    if (s_ui_shared_application != NULL)
    {
        return 0;
    }

    return ui_application_alloc(&s_ui_shared_application,
                                name, argc, argv);
}

void ui_shared_application_run()
{
    ui_application_run(s_ui_shared_application);
}

Widget ui_shared_application_widget()
{
    if (s_ui_shared_application == NULL)
    {
        return NULL;
    }

    return s_ui_shared_application->session_shell_widget;
}

/*******************************************************************************
 * ui_main_window
 ******************************************************************************/

int ui_main_window_alloc(ui_main_window_t *main_window_p, const char *name, const char *title)
{
    if (main_window_p == NULL || name == NULL || title == NULL || g_ui_application_run == NULL)
    {
        return EINVAL;
    }

    if ((*main_window_p = calloc(1, sizeof(struct ui_main_window))) == NULL)
    {
        return ENOMEM;
    }

    printf("ui_main_window_alloc\n");
    return 0;
}

int ui_main_window_init(ui_main_window_t *main_window_p, const char *name, const char *title)
{
    int err = 0;

    if ((err = ui_main_window_alloc(main_window_p, name, title)) != 0)
    {
        return err;
    }

    /* Create a top level shell for the window */
    (*main_window_p)->top_level_shell_widget = XtVaCreatePopupShell(
        "main_window_shell", topLevelShellWidgetClass, g_ui_application_run->session_shell_widget,
        XmNtitle, title, NULL);

    /* Create a new main window widget */
    (*main_window_p)->widget = XmCreateMainWindow((*main_window_p)->top_level_shell_widget, (char *)name, NULL, 0);
    XtManageChild((*main_window_p)->widget);

    /* Add the new window to the application window list */
    return ui_application_register_main_window(g_ui_application_run, *main_window_p);
}

void ui_main_window_free(ui_main_window_t main_window)
{
    if (main_window == NULL)
    {
        return;
    }

    free(main_window);
    printf("ui_main_window_free\n");
}

void ui_main_window_show(ui_main_window_t main_window)
{
    XtPopup(main_window->top_level_shell_widget, XtGrabNonexclusive);
}

int main(int argc, char *argv[])
{
    int err = 0;
    ui_application_t app;
    ui_main_window_t win;

    if ((err = ui_application_init_shared(&app, "my_app", argc, argv)) != 0)
    {
        return err;
    }

    if ((err = ui_main_window_init(&win, "main_win", "Hello World!")) != 0)
    {
        return err;
    }

    ui_main_window_show(win);

    ui_application_run(app);

    return 0;
}
