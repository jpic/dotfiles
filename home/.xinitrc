#!/bin/bash

if [ -d /etc/X11/xinit/xinitrc.d ]; then
  for f in /etc/X11/xinit/xinitrc.d/*; do
    [ -x "$f" ] && . "$f"
  done
  unset f
fi


source ~/.keyboardrc
termite &
xsetroot -cursor_name left_ptr &
feh --bg-scale ~/Pictures/background.jpg &
xrdb -merge ~/.Xresources &
light -S 14.81 &
redshift-gtk &

if [ -x /usr/bin/autocutsel ]; then
    #this will keep the clipboard in sync
    #   with the primary buffer
    autocutsel -selection CLIPBOARD -fork

    #this will keep the primary in sync
    #   with the clipboard buffer
    autocutsel -selection PRIMARY -fork
fi
wmname LG3D &
source ~/.xrandrrc &

dwmstatus &
cbatticon 0 &
cbatticon 1 &
nm-applet &
while true; do ~/bin/dwm; done
