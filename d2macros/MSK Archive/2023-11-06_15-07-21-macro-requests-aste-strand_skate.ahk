#NoEnv
SendMode Input
SetWorkingDir %A_ScriptDir%

z::
Send, v
Send, {LButton}
Send, v
Send, {LButton}
Sleep, 100
Send, q
Sleep, 10
Send, q
Sleep, 10
Send, {Space}
Sleep, 10
Send, {Space}
return