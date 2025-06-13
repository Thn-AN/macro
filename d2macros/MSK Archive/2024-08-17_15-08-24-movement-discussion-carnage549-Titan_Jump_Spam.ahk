Setbatchlines, -1
#SingleInstance Force
SendMode Input
SetStoreCapsLockMode, Off
F3:
MsgBox, Active
loop {
		if GetKeyState("F5") {
		loop {
			Send, {WheelDown}
			Sleep, 5
			if !GetKeyState("F5") 
				break
			}
		}
}
