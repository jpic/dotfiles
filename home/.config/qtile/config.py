import logging
import os
import subprocess

from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, hook, widget

logger = logging.getLogger('qtile')

mod = "mod4"

tag_keys = (
    ('exclam', Group('1')),
    ('at', Group('2')),
    ('numbersign', Group('3')),
    ('dollar', Group('4')),
    ('ampersand', Group('5')),
    ('braceleft', Group('6')),
    ('braceright', Group('7')),
    ('asterisk', Group('8')),
    ('parenleft', Group('9')),
    ('parenright', Group('0')),
    ('a', Group('a')),
    ('o', Group('o')),
    ('e', Group('e')),
    ('u', Group('u')),
)

groups = [i[1] for i in tag_keys]

keys = [
    # Switch between windows in current stack pane
    Key(
        [mod], "k",
        lazy.layout.previous()
    ),
    Key(
        [mod], "j",
        lazy.layout.next()
    ),
    # Move windows up or down in current stack
    Key(
        [mod], "h",
        lazy.layout.shrink()
    ),
    Key(
        [mod], "l",
        lazy.layout.grow()
    ),

    # Switch window focus to other pane(s) of stack
    Key(
        [mod], "space",
        lazy.layout.next()
    ),

    Key(
        [mod], "Return",
        lazy.layout.shuffle_up()
    ),

    Key(
        [mod], "apostrophe",
        lazy.to_screen(0),
        lazy.spawn('xdotool mousemove 960 540'),
    ),
    Key(
        [mod], "comma",
        lazy.to_screen(1),
        lazy.spawn('xdotool mousemove 2800 540'),
    ),
    Key(
        [mod], "period",
        lazy.to_screen(2),
        lazy.spawn('xdotool mousemove 4800 540'),
    ),

    Key([mod], "t", lazy.spawn("termite")),
    Key([mod, "control"], "t", lazy.spawn("cool-retro-term -p newjames")),
    Key([mod], "q", lazy.spawn('slock')),
    Key([mod], "v", lazy.spawn('scrot -select')),

    # click with the keyboard ... perfect with a trackpoint
    Key([mod], "g", lazy.spawn("xdotool click 1")),
    #Key([mod], "c", lazy.spawn("xdotool click 2")),
    Key([mod], "r", lazy.spawn("xdotool click 3")),

    # scroll in any window with the same shortcut !
    Key([mod], "b", lazy.spawn("xdotool click 4")),
    Key([mod], "m", lazy.spawn("xdotool click 5")),

    # Toggle between different layouts as defined below
    Key([mod], "space", lazy.next_layout()),
    Key([mod], "Tab", lazy.screen.togglegroup()),
    Key([mod, "control"], "c", lazy.window.kill()),
    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    #Key([mod], "p", lazy.spawncmd()),
    Key([mod], "p", lazy.spawn("rofi -show run")),
    Key([mod], "w", lazy.spawn("rofi -show window")),
    Key([mod], "s", lazy.spawn("rofi -show ssh")),

    Key([], "XF86AudioMute", lazy.spawn("amixer -q set Master toggle")),
    Key([], "XF86AudioLowerVolume", lazy.spawn("amixer -c 0 sset Master 1- unmute")),
    Key([], "XF86AudioRaiseVolume", lazy.spawn("amixer -c 0 sset Master 1+ unmute")),

]

for key, i in tag_keys:
    # mod1 + letter of group = switch to group
    keys.append(
        Key([mod], key, lazy.group[i.name].toscreen())
    )

    # mod1 + shift + letter of group = switch to & move focused window to group
    keys.append(
        Key([mod, "shift"], key, lazy.window.togroup(i.name))
    )

class MyTile(layout.Tile):
    def cmd_zoom(self):
        if self.focused not in self.master_windows:
            masters = [self.focused]
        else:
            i = self.clients.index(self.focused)

            if len(self.clients) > i:
                i += 1
            elif len(self.client) < i:
                i -= 1
            else:
                return

            masters = [self.clients[i]]

        self.clients = masters + [
            c for c in self.clients if c not in masters
        ]
        self.focus(masters[0])
        self.group.layoutAll(True)

layouts = [
    layout.MonadTall(),
    layout.Max(),
    layout.Floating(),
]

widget_defaults = dict(
    font='Hack',
    fontsize=12,
    padding=2,
    border_width=1,
)

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Net(),
                widget.Memory(),
                widget.MemoryGraph(border_width=1),
                widget.CPUGraph(border_width=1, graph_color='ff00e9', border_color='ff00e9', fill_color='792a72'),
                widget.HDDBusyGraph(border_width=1, graph_color='6aff00', border_color='6aff00', fill_color='619d37'),
                widget.Volume(),
                widget.Notify(),
                widget.BatteryIcon(battery_name='BAT0'),
                widget.BatteryIcon(battery_name='BAT1'),
                widget.Systray(),
                widget.Clock(format='%Y-%m-%d %a %I:%M %p'),
            ],
            30,
        ),
    )
    for i in range(0, 3)
]

# Drag floating layouts.
mouse = [
    Drag([mod], "Button1", lazy.window.set_position_floating(),
        start=lazy.window.get_position()),
    Drag([mod], "Button3", lazy.window.set_size_floating(),
        start=lazy.window.get_size()),
    Click([mod], "Button2", lazy.window.bring_to_front())
]

dgroups_key_binder = None
dgroups_app_rules = []
main = None
follow_mouse_focus = True
bring_front_click = False
cursor_warp = False
floating_layout = layout.Floating()
auto_fullscreen = True

# XXX: Gasp! We're lying here. In fact, nobody really uses or cares about this
# string besides java UI toolkits; you can see several discussions on the
# mailing lists, github issues, and other WM documentation that suggest setting
# this string if your java app doesn't work correctly. We may as well just lie
# and say that we're a working one by default.
#
# We choose LG3D to maximize irony: it is a 3D non-reparenting WM written in
# java that happens to be on java's whitelist.
wmname = "LG3D"



# Gnome hack
# import qtile_gnome
