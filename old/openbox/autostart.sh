#!/bin/bash
if which dbus-launch >/dev/null && test -z "$DBUS_SESSION_BUS_ADDRESS"; then
    eval `dbus-launch --sh-syntax --exit-with-session`
fi
[[ -f $HOME/.fehbg ]] && $(< $HOME/.fehbg)
urxvtd -q -o -f
orage &
tint2 &
#conky &
#pytyle &
#gnome-screensaver
[[ -f $HOME/.laptopmode ]] && gpomme &
[[ -f $HOME/.laptopmode ]] && syndaemon -d -i 0.45
[[ -f $HOME/.laptopmode ]] || synergys
[[ -f $HOME/.noxmodmap ]] || xmodmap $HOME/.xmodmaprc
glipper-old &
#sonata --hidden --profile=1 &
#$HOME/.dropbox-dist/dropboxd &
xcompmgr -c -r6 -Cf -l -9 -t -7 -D 2 &