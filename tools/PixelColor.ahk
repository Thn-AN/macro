CoordMode, Mouse, Screen
SetTimer, Check, 10

Check:
MouseGetPos, X_Coord, Y_Coord
PixelGetColor, output, %X_Coord%, %Y_Coord%
Tooltip %output%
Return

Esc::ExitApp