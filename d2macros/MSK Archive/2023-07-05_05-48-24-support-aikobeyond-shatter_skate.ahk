#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.
#If WinActive("ahk_exe destiny2.exe")

6:: ; hunter ledge skate
{
Send 3
Sleep 400
Send {RButton}
Sleep 25
Send {RButton up}
Send {Space}
Send C
Sleep 300
Sleep 100
Send {Shift Down}
Sleep 100
Send {Shift Up}
Send {1}
Return
}



5:: ; hunter skate, flat ground
{
Send 3
Sleep 400
Send {Space}
Sleep 10
Send {LButton}
Sleep 25
Send {Space}
Sleep 15
Send C
Sleep 25
Send {Space}
Send {Shift Down}
Sleep 100
Send {Shift Up}
Send {1}
Return
}