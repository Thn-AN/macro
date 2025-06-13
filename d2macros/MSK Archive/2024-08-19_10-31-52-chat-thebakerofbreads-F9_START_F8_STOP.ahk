; This script was created using Pulover's Macro Creator
; www.macrocreator.com

#NoEnv
SetWorkingDir %A_ScriptDir%
CoordMode, Mouse, Window
SendMode Input
#SingleInstance Force
SetTitleMatchMode 2
#WinActivateForce
SetControlDelay 1
SetWinDelay 0
SetKeyDelay -1
SetMouseDelay -1
SetBatchLines -1


F9::
Macro1:
Loop, 50
{
    Click, Left, 1
    Sleep, 10
    Send, {t}
    Sleep, 7000
    Send, {s}
    Sleep, 7000
}
Return


F8::ExitApp

/*
PMC File Version 5.4.1
---[Do not edit anything in this section]---

[PMC Globals]|None||
[PMC Code v5.4.1]|F9||1|Window,2,Fast,0,1,Input,-1,-1,1|1|Macro1
Context=None|
Groups=Start:1
1|[LoopStart]|LoopStart|50|0|Loop|||||1|
2|Left Click|Left, 1, |1|0|Click|||||3|
3|[Pause]||1|10|Sleep|||||4|
4|t|{t}|1|0|Send|||||5|
5|[Pause]||1|7000|Sleep|||||6|
6|s|{s}|1|0|Send|||||7|
7|[Pause]||1|7000|Sleep|||||8|
8|[LoopEnd]|LoopEnd|1|0|Loop|||||9|

*/
