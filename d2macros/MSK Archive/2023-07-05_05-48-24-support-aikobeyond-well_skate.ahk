#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#If WinActive("ahk_exe destiny2.exe")

6:: ; Warlock ledge skate
{
Send 3
Sleep 400
Send {RButton}
Sleep 25
Send {RButton up}
Send {Space}
Send F
Sleep 25
Send {Space}
Return
}


5:: ; Warlock skate, flat ground
{
Send 3
Sleep 400
Send {Space}
Sleep 10
Send {LButton}
Sleep 25
Send {Space}
Sleep 15
Send F
Sleep 25
Send {Space}
Sleep 100
Send {Shift Down}
Sleep 100
Send {Shift Up}
Return
}