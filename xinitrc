#!/usr/bin/env bash

setxkbmap -option ctrl:nocaps
setxkbmap -layout us -variant altgr-intl
xset r rate 225 65 # 225ms, ~15ms, macos equiv: 15, 1
xsetroot -cursor_name left_ptr
pactl set-sink-volume 0 50%
udiskie &
volumeicon &
blueman-applet &
cbatticon &
nm-applet &
lxpanel &
sxhkd -c ~/.sxhkdrc &
(sleep 2 && feh --no-fehbg --bg-max ~/wp.png) &

exec metacity
