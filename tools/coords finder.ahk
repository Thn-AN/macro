CoordMode, Mouse, Screen
SetTimer, Check, 10
return

Check:
MouseGetPos, xx, yy
Tooltip %xx%`, %yy%
return

Esc::ExitApp
