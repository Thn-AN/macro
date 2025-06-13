#SingleInstance Force
#KeyHistory 0
#MaxThreadsPerHotkey 1
#HotkeyModifierTimeout -1
SetBatchLines -1
ListLines Off

~*^k::
ExitApp
Return

SleepSleep(s)
{
	CounterBefore := 
    DllCall("QueryPerformanceFrequency", "Int64*", freq)
    DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
    While (((counterAfter - CounterBefore) / freq * 1000) < s)
        DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
		global Counter := CounterBefore/10000
    return ((counterAfter - CounterBefore) / freq * 1000) 
}
    

5::
Send, {LButton down}
SleepSleep(15)
Send, {lbutton up}
Send, {t down}
SleepSleep(10)
Send, {t up}
SleepSleep(100)
Send, {q down}
SleepSleep(10)
Send, {q up}
Send, {Space down}
SleepSleep(10)
Send, {Space up}     
Return

F5::reload
