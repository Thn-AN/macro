#Persistent
#SingleInstance, Force
SetBatchLines, -1
Process, Priority,, H
SendMode Input
#IfWinActive ahk_exe destiny2.exe 

G::
    Loop {
        Send, {c down} 
        Sleep, 380
        Send, {LButton}
        Sleep, 550
        Send, {LButton}
        Sleep, 550
        Send, {RButton}
        Send, {c up}
        Sleep, 150
        Send, {LButton}
        Sleep, 550
        Send, {LButton}
        Sleep, 550
        Send, {LButton}
    }
Return

G Up::
Send, {c up}
Reload
Return

F2::Exitapp
F3::Reload