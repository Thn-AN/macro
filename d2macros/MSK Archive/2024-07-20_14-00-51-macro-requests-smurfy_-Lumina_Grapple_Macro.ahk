Setbatchlines, -1
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
F3::
KeyWait, F3
global sens := 6
global Y
global grenade := g
global showPopup := true

if !FileExist("lumina_grapple.ini") {
	MsgBox, No lumina_grapple.ini found, please input your sensitivity now.

	InputBox, sens, Sensitivity, Input your ingame sensitivity (default: 6):,, 230, 150

	IniWrite, %sens%, lumina_grapple.ini, Variables, Sensitivity

	InputBox, grenade, Grenade, Input your grenade bind (default: G):,, 230, 150

	IniWrite, %grenade%, lumina_grapple.ini, Variables, Grenade

	InputBox, activate, Activate, Input your desired activation bind (default: /):,, 230, 150

	IniWrite, %activate%, lumina_grapple.ini, Variables, Activate
	
	Y := Round(150/sens)
	Grapple := grenade
} else {
	IniRead, sens, lumina_grapple.ini, Variables, Sensitivity
	IniRead, grenade, lumina_grapple.ini, Variables, Grenade
	IniRead, activate, lumina_grapple.ini, Variables, Activate
	Y := Round(150/sens)
	Grapple := grenade
	}
MsgBox, Activated, press %activate% to lumina grapple. Press F3 to deactivate. Press F4 to change sensitivity. F5 to change activation bind.
loop {
	if GetKeyState("/") {
		KeyWait, /
		SendInput {LButton}
		DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", Y)
		SendInput %grenade%
		}
	if GetKeyState("F3") {
		KeyWait, F3
		break
		}
	if GetKeyState("F4") {
		InputBox, sens, Sensitivity, Input your ingame sensitivity (current: %sens%):,, 230, 150
		IniWrite, %sens%, lumina_grapple.ini, Variables, Sensitivity
		Reload
		Return
		}
	if GetkeyState("F5") {
		InputBox, activate, Activate, Input your desired activation bind (current: %activate%):,, 230, 150
		IniWrite, %activate%, lumina_grapple.ini, Variables, Sensitivity
		Reload
		Return
		}

     }