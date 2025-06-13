#SingleInstance Force
#KeyHistory 0
#MaxThreadsPerHotkey 1
#HotkeyModifierTimeout -1
SetBatchLines -1
ListLines Off

;IMPORTANT - there are comments at the very very bottom of the script


;macros

F13::

send {LControl}
sleep(8)
send {LButton down}
sleep(8)
send {LButton up}
send {t down}
sleep(8)
send {t up}
sleep(96)
send {q down}
sleep(8)
send {q up}
send {space down}
sleep(8)
send {space up}

return

!`::Reload









;functions



;time and sleep are just here to mitigate autohotkey's terrible timing quality
time() 
{
	static freq
	if (!freq)
		dllcall("QueryPerformanceFrequency", "Int64*", freq)
	dllcall("QueryPerformanceCounter", "Int64*", tick)
	return tick / freq * 1000
}

sleep(ms) 
{
	start := time()
	since := 0
	delta := ms > 4 ? 0.742 : 0.2
	
	if (ms == 0) 
	{    
		sleep 0
		return 0
	}
	
	loop 
	{
		if (ms - since < delta)
			return since - ms
		DllCall("Sleep", "UInt", 1)
		since := time() - start
	}
}













/*

COMMENTS:


The original code and timings, courtesy of mangopanda45 from thrallway.com

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

==========================================================================================

earlyworm's rebuild

mvmtSkatePunch() ;use bow, aim at enemy in desired direction CREDIT: mangopanda45 for timings
{
do(togglecrouch)
sleep(8)
do(fire down)
sleep(8)
do(fire up)
do(meleeuncharged down)
sleep(8)
do(meleeuncharged up)
sleep(96)
do(grenade down)
sleep(8)
do(grenade up)
do(jump down)
sleep(8)
do(jump up)
}

==========================================================================================