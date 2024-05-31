/* See LICENSE file for copyright and license details. */
#include <X11/XF86keysym.h>

/* appearance */
static const unsigned int borderpx  = 1;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;     /* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const char panel[][20]       = { "xfce4-panel", "Xfce4-panel" }; /* name & cls of panel win */
static const int topbar             = 1;        /* 0 means bottom bar */
static const char *fonts[]          = { "hack:size=12" };
static const char dmenufont[]       = "monospace:size=12";
/*
static const char col_gray1[]       = "#4c09cd";
static const char col_gray2[]       = "#444444";
static const char col_gray3[]       = "#ffffff";
static const char col_gray4[]       = "#eeeeee";
static const char col_cyan[]        = "#ff0883";
static const char selbg[]        = "#4c09cd";
*/
static const char normbg[]       = "#1d1f21";
static const char normborder[]   = "#444444";
static const char normfg[]       = "#c5c8c6";
static const char selfg[]        = "#eeeeee";
static const char selbg[]        = "#632a71";
static const char selborder[]    = "#ff0883";
static const char *colors[][3]   = {
	/*               fg         bg         border   */
    /*
	[SchemeNorm] = { col_gray3, col_gray1, col_gray2 },
	[SchemeSel]  = { col_gray4, col_cyan,  col_cyan  },
    */
	[SchemeNorm] = { normfg, normbg, normborder },
	[SchemeSel]  = { selfg, selbg, selborder },
};

/* tagging */
static const char *tags[] = { "c", "q", "a", "o", "e", "u", "g", "w", "s", "m", "1", "2", "3", "4", "5", "6", "7", "8", "9", "0"};

static const Rule rules[] = {
	/* class      instance    title       tags mask     isfloating   monitor */
    { "Chromium",       NULL,       NULL,     1 << 0, 0, 0 },
    { "qutebrowser",    NULL,       NULL,     1 << 1, 0, 0 },
    { "gnome-calendar",    NULL,       NULL,     1 << 6, 0, 0 },
    { "whatsdesk",    NULL,       NULL,     1 << 7, 0, 0 },
    { "Slack",    NULL,       NULL,     1 << 8, 0, 0 },
    { "Mattermost",    NULL,       NULL,     1 << 9, 0, 0 },
};

/* layout(s) */
static const float mfact      = 0.55; /* factor of master area size [0.05..0.95] */
static const int nmaster      = 1;    /* number of clients in master area */
static const Bool resizehints = True; /* True means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[] = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", normbg, "-nf", normfg, "-sb", selbg, "-sf", selfg, NULL };

static const char *rofi_run[] = { "rofi", "-show", "run" };

static const char *termcmd[]  = { "urxvt", NULL };
static const char *ttermcmd[]  = { "terminology", NULL };
/*
static const char *termitecmd[]  = { "termite", NULL };
 */
static const char *termitecmd[]  = { "sh", "-c", "vblank_mode=1 alacritty", NULL };
static const char *lockcmd[]  = { "lock", NULL };
static const char *volmutemiccmd[]  = { "pactl", "set-source-mute", "1", "toggle", NULL };
static const char *volmutecmd[] = { "pactl", "set-sink-mute", "0", "toggle", NULL };
static const char *volupcmd[] = { "pactl", "set-sink-volume", "0", "+5%", NULL };
static const char *voldowncmd[] = { "pactl", "set-sink-volume", "0", "-5%", NULL };
static const char *lightupcmd[]  = { "brightness", "up", NULL };
static const char *lightdowncmd[]  = { "brightness", "down", NULL };
static const char *screenA[] = {"xdotool", "mousemove", "960", "540", NULL };
static const char *screenB[] = {"xdotool", "mousemove", "2800", "540", NULL };
static const char *screenC[] = {"xdotool", "mousemove", "4800", "540", NULL };
static const char *screenD[] = {"xdotool", "mousemove", "6720", "540", NULL };
static const char *scrot[] = {"scrot", "-select", "screenshot-%Y%m%d-%H%M%S.jpg" };
static const char *slock[] = {"slock" };

static Key keys[] = {
	{ MODKEY,                       XK_colon,      spawn,          {.v = rofi_run } },
	{ MODKEY,                       XK_t,      spawn,          {.v = termitecmd } },
	{ MODKEY|ShiftMask,             XK_t,      spawn,          {.v = ttermcmd } },
	//{ MODKEY|ControlMask,                       XK_t,      spawn,          {.v = termcmd } },
	{ MODKEY|ShiftMask,             XK_l,      spawn,          {.v = lockcmd } },
	{ 0,                            XF86XK_AudioMute,          spawn,          {.v = volmutecmd } },
	{ 0,                            XF86XK_AudioMicMute,       spawn,          {.v = volmutemiccmd } },
	{ 0,                            XF86XK_AudioLowerVolume,        spawn,          {.v = voldowncmd } },
	{ 0,                            XF86XK_AudioRaiseVolume,        spawn,          {.v = volupcmd } },
	{ 0,                            XF86XK_MonBrightnessDown,     spawn,          {.v = lightdowncmd } },
	{ 0,                            XF86XK_MonBrightnessUp,     spawn,          {.v = lightupcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstack,     {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstack,     {.i = -1 } },
	// { MODKEY|ShiftMask,             XK_d,      incnmaster,     {.i = +1 } },
	// { MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ControlMask,           XK_c,      killclient,     {0} },
	{ MODKEY|ControlMask,           XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY|ControlMask,             XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY|ControlMask,             XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY|ControlMask,             XK_r,  setlayout,      {0} },
	{ MODKEY,             XK_f,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	// { MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	// { MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_v,  spawn,       {.v = scrot } },
	{ MODKEY|ShiftMask,                       XK_l,  spawn,       {.v = slock } },
	{ MODKEY,                       XK_apostrophe,  spawn,       {.v = screenB } },
	{ MODKEY,                       XK_comma,  spawn,       {.v = screenC } },
	{ MODKEY,                       XK_period,       spawn,       {.v = screenD } },
	{ MODKEY,                       XK_p,      spawn,       {.v = screenA } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = +1 } },
	TAGKEYS(                        XK_c,                      0)
	TAGKEYS(                        XK_q,                      1)
	TAGKEYS(                        XK_a,                      2)
	TAGKEYS(                        XK_o,                      3)
	TAGKEYS(                        XK_e,                      4)
	TAGKEYS(                        XK_u,                      5)
	TAGKEYS(                        XK_g,                      6)
	TAGKEYS(                        XK_w,                      7)
	TAGKEYS(                        XK_s,                      8)
	TAGKEYS(                        XK_m,                      9)
	TAGKEYS(                        XK_exclam,                 10)
	TAGKEYS(                        XK_at,                     11)
	TAGKEYS(                        XK_numbersign,             12)
	TAGKEYS(                        XK_dollar,                 13)
	TAGKEYS(                        XK_ampersand,              14)
	TAGKEYS(                        XK_braceleft,              15)
	TAGKEYS(                        XK_braceright,             16)
	TAGKEYS(                        XK_asterisk,               17)
	TAGKEYS(                        XK_parenleft,              18)
	TAGKEYS(                        XK_parenright,             19)
	{ MODKEY|ControlMask,             XK_q,      quit,           {0} },
};


/* button definitions */
/* click can be ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkLtSymbol,          0,              Button1,        setlayout,      {0} },
	{ ClkLtSymbol,          0,              Button3,        setlayout,      {.v = &layouts[2]} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
};

