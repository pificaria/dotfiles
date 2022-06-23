#xrandr --setprovideroffloadsink nouveau Intel
xset -b
# xset +fp /usr/share/fonts/terminus/
xbacklight -set 15
xrdb -merge ~/.Xresources
xinput --set-prop "AlpsPS/2 ALPS DualPoint Stick" 279 1
xinput --set-prop "AlpsPS/2 ALPS DualPoint TouchPad" 131 0

qiv -z "$HOME/waste/img/ae.nts.wp.jpg"

# xsetroot -cursor_name left_ptr
conky -d
exec fvwm
