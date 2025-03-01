#!/usr/bin/env bash

setxkbmap -option ctrl:nocaps
setxkbmap -layout us -variant altgr-intl
xset r rate 350 70
xsetroot -cursor_name left_ptr
pactl set-sink-volume 0 50%
udiskie &
(sleep 2 && feh --no-fehbg --bg-max ~/wp.png) &

exec i3
