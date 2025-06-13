#Persistent
#MaxThreadsPerHotkey 2

MouseMoveAmount := 200

KeyPressInterval := 200
F3::exitapp
F4::
Toggle := !Toggle
If (Toggle) {
    SetTimer, MouseAndKeyActions, % KeyPressInterval
} Else {
    SetTimer, MouseAndKeyActions, Off
}
return

MouseAndKeyActions:
    MouseMove, 0, %MouseMoveAmount%, 20, R
    Sleep, 150
    SendInput, {a down}
	Sleep, 150
	SendInput, {a up}
    Sleep, %KeyPressInterval%
    MouseMove, 0, -%MouseMoveAmount%, 20, R
    Sleep, 150
    SendInput, {d down}
	Sleep, 150
	SendInput, {d up}
    Sleep, %KeyPressInterval%
return
