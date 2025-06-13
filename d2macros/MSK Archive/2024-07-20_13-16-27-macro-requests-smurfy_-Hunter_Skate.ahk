#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance Force
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


;        Skate Bind ↓↓↓ | Change it to would whatever you want.
HunterSkateKeyBind = XButton1

;            Flat Sakte ↓↓↓ | Change it to would whatever you want.
HunterFlatSkateKeyBind = N

;  Shatterdive Bind ↓↓↓ | Change it to would whatever you want.
ShatterdiveKeyBind = X

; Dont touch shit under here.
toggle := true
Hotkey,*%HunterSkateKeyBind%,Skate
Hotkey,*%HunterFlatSkateKeyBind%,FlatSkate
Return

=::toggle := !toggle
#If toggle

Skate:
Click, Right
Sleep, 35
send {space}
Sleep, 10
send {%ShatterdiveKeyBind%}

Return

FlatSkate:
send {space}
Sleep, 5
Click, Left
Sleep, 5
send {space}
Sleep, 5
send {%ShatterdiveKeyBind%}

Return

F4::
ExitApp