#!/bin/bash -x

set -x

#xset dpms force off
#xrandr --output eDP-1 --off
#source .screenlayout/quad.sh &> .xinitrc.screenlayout.log
source ~/.keyboardrc
if [ -x /usr/bin/autocutsel ]; then
    #this will keep the clipboard in sync
    #   with the primary buffer
    autocutsel -selection CLIPBOARD -fork

    #this will keep the primary in sync
    #   with the clipboard buffer
    autocutsel -selection PRIMARY -fork
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi
function kde_session() {
  exec startkde
}

function screens() {
out=$(xrandr)
if echo $out | grep DP2-1.connected && echo $out | grep DP2-2.connected && echo $out | grep DP2-3.connected; then
    xrandr --output eDP1 --off --output DP1 --off --output DP2 --off --output DP2-1 --mode 1920x1080 --pos 0x0 --rotate normal --output DP2-2 --mode 1920x1080 --pos 1920x0 --rotate normal --output DP2-3 --mode 1920x1080 --pos 3840x0 --rotate normal --output HDMI1 --off --output HDMI2 --off --output VIRTUAL1 --off
fi
}

keyring() {
    eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    export SSH_AUTH_SOCK
}

applets() {
    nm-applet &
    redshift-gtk &
    blueman-applet &
    cbatticon 0 &
    cbatticon 1 &
}

base() {
    #screens
    # conky &
    applets
    keyring
    #pw-jack cadence &
    xsetroot -cursor_name left_ptr -solid '#1d1f21' &
}

function qtile_session() {
    base
    #feh --bg-scale ~/Pictures/background.jpg &
    #xrdb -merge ~/.Xresources &
    light -S 14.81 &
    #qjackctl &
    #wmname LG3D &
    exec qtile start &> qtile.log
}

gnome_session() {
    export XDG_SESSION_TYPE=x11
    export GDK_BACKEND=x11
    exec gnome-session
}

apps() {
    qutebrowser &
    gnome-calendar &
    whatsdesk &
    mattermost-desktop &
    slack &
}

dwm_session() {
    base
    apps
    clipcatd
    #xfce4-panel --disable-wm-check &
    #go-dwmstatus &
    slstatus 2>&1 >/dev/null &
    while true; do exec ~/.local/bin/dwm &> dwm.log; done
}

#cbatticon 0 &
#cbatticon 1 &

#cinnamon
#xfce4-session
#gnome_session

#wmname LG3D &
dwm_session
#exec openbox
#qtile_session
#kde_session
#exec startkde
#~/local/bin/dwm
#openbox
