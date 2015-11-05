import logging
import subprocess

from libqtile.config import Key, Screen, Group, Drag, Click, Match
from libqtile.command import lazy
from libqtile import layout, bar, widget

logger = logging.getLogger('qtile')

mod = "mod4"

def app_or_group(group, app):
    def f(qtile):
        try:
            qtile.groupMap[group].cmd_toscreen()
        except KeyError:
            qtile.cmd_spawn(app)
    return f

def dynamic_tag(key, name, cmd, **matches):
    return (key,
        Group(name, persist=False, init=False,
            matches=matches),
        cmd)

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
)

dynamic_tags = (
    dynamic_tag('a', 'qt',
        '/home/jpic/py3/bin/python3 /home/jpic/py3/bin/qutebrowser',
        wm_class=['qutebrowser']),
    dynamic_tag('o', 'ff', 'firefox', wm_class=['Firefox']),
    dynamic_tag('e', 'ch', 'chromium', wm_class=['chromium']),
    dynamic_tag('u', 'mz', 'lxmusic', title=['LXMusic']),
)

groups = [j for i, j in tag_keys] + [i[1] for i in dynamic_tags]

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
        lazy.layout.decrease_ratio()
    ),
    Key(
        [mod], "l",
        lazy.layout.increase_ratio()
    ),

    # Switch window focus to other pane(s) of stack
    Key(
        [mod], "space",
        lazy.layout.next()
    ),

    # Swap panes of split stack
    Key(
        [mod, "shift"], "space",
        lazy.layout.rotate()
    ),

    Key(
        [mod], "Return",
        lazy.layout.zoom()
    ),
    Key([mod], "t", lazy.spawn("termite")),

    # Toggle between different layouts as defined below
    Key([mod], "space", lazy.next_layout()),
    Key([mod], "Tab", lazy.screen.togglegroup()),
    Key([mod, "shift"], "c", lazy.window.kill()),

    Key([mod, "control"], "r", lazy.restart()),
    Key([mod, "control"], "q", lazy.shutdown()),
    Key([mod], "p", lazy.spawncmd()),
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

for key, group, cmd in dynamic_tags:
    keys.append(Key([mod], key, app_or_group(group.name, cmd)))
    keys.append(Key([mod, "shift"], key, lazy.window.togroup(group.name)))

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
    MyTile(),
    layout.Max(),
]

widget_defaults = dict(
    font='Deja Vu',
    fontsize=16,
    padding=3,
)

screens = [
    Screen(
        bottom=bar.Bar(
            [
                widget.GroupBox(),
                widget.Prompt(),
                widget.WindowName(),
                widget.Memory(),
                widget.Volume(),
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
