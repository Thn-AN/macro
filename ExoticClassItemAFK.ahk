; SevenOilRigs :3
; 800 dpi
; 15 sensitivity
; 30 fps
; 1920 x 1080 resolution
; press [ when you are in the landing to start macro
; press Esc to stop macro

Esc::
Reload
return

[::
Loop
{
Loop 40
{
Send {m}
Sleep 1000
MouseMove, 960, 520, 0
Sleep 1500
DllCall("mouse_event", "UInt", 0x01, "Int", -600, "Int", 0, "UInt", 0, "UInt", 0)
Sleep 1225
DllCall("mouse_event", "UInt", 0x01, "Int", 175, "Int", 0, "UInt", 0, "UInt", 0)
Sleep 500
Send {Lbutton Down}
Sleep 1200
Send {Lbutton Up}
Sleep 10000
DllCall("mouse_event", "UInt", 0x01, "Int", -330, "Int", 0, "UInt", 0, "UInt", 0)
Send {Shift Down}
Send {w Down}
Sleep 7400
Send {Shift Up}
Send {w Up}
DllCall("mouse_event", "UInt", 0x01, "Int", 1360, "Int", 0, "UInt", 0, "UInt", 0)
Sleep 30000
Send {Shift Down}
Send {w Down}
Sleep 6400
DllCall("mouse_event", "UInt", 0x01, "Int", -330, "Int", 0, "UInt", 0, "UInt", 0)
Sleep 3200
Send {Shift Up}
Send {w Up}
DllCall("mouse_event", "UInt", 0x01, "Int", -900, "Int", 0, "UInt", 0, "UInt", 0)
Sleep 500
Send {e Down}
Sleep 1200
Send {e Up}
Sleep 500
}
Send {Tab}
Sleep 1000
Send {o Down}
Sleep 4000
Send {o Up}
Sleep 10000
Send {m}
Sleep 1000
MouseMove, 960, 520, 0
Sleep 1500
Send {Lbutton}
Sleep 2000
DllCall("mouse_event", "UInt", 0x01, "Int", -600, "Int", 0, "UInt", 0, "UInt", 0)
Sleep 1225
DllCall("mouse_event", "UInt", 0x01, "Int", 175, "Int", 0, "UInt", 0, "UInt", 0)
Sleep 500
Send {Lbutton Down}
Sleep 1200
Send {Lbutton Up}
MouseMove, 1600, 900, 0
Sleep 500
Send {Lbutton}
Sleep 30000
}
return