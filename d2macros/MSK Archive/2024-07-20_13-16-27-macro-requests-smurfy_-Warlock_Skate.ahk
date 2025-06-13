#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%


;         Skate Bind ↓↓↓ | Change it to whatever you want.
WarlockSkateKeyBind = XButton1

;        Flat Sakte Bind ↓↓↓ | Change it to whatever you want.
WarlockFlatSkateKeyBind = Numpad0

;  Super Bind ↓↓↓ | Change it to whatever you want.
SuperKeyBind = F

; Dont touch shit under here.
toggle := true
Hotkey,*%WarlockSkateKeyBind%,Skate
Hotkey,*%WarlockFlatSkateKeyBind%,FlatSkate
Return

=::toggle := !toggle
#If toggle

Skate:
Send {Click Right}
Sleep 100
Send {Space}
Send {%SuperKeyBind%}
Sleep 100
Send {Space}

Return

FlatSkate:
send {space}
Sleep 10
Click, Left
Sleep 10
send {space}
send {%SuperKeyBind%}

Return

F4::
ExitApp