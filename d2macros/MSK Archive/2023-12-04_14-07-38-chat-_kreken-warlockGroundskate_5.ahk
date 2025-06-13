#SingleInstance Force
#KeyHistory 0
#MaxThreadsPerHotkey 1
SetBatchLines -1
ListLines Off

~*^k::
ExitApp
Return
    

5::
Send, 3
Sleep, 420
Send, {Space}
Sleep, 20
Send, {LButton}
Sleep, 20
Send, {Space}
Sleep, 10
Send, {f}   
Return

