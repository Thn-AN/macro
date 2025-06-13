/*
script by earlyworm [earlyworm on discord]
u can contact me through the thrallway.com discord server
more documentation is in this channel

;https://discord.gg/DtVmMHgmJ3


IMPORTANT - there are comments at the very very bottom of the script for devs

=================================================================================================================================================================================

HOW IT WORKS

you can punchskate with a Fel Taradiddle with the following

Agile Bow String
Compact Arrow Shaft
Perpetual Motion
Cornered
Sprint Grip Mod

this is to max out handling

Synthoceps with three kinetic handling mods

Strand Titan with grapple, thread of ascent

=================================================================================================================================================================================

HOW TO DO IT

you need to empty your melee charges before doing this but this is a known issue, probably related to my weird keybinds

aim at a nearby red bar and hold control and click on them with the bow, this will execute the skate, sometimes

this takes practice to get the distance and timings right, however. thirty minutes and it should feel like just an extra technique in normal gameplay.

=================================================================================================================================================================================

HOW TO GET IT TO WORK FOR YOU

make sure you change either your binds or my code to map your controls better
change the name of the keys in the curly bracket next to send lines
THERE WILL BE NO SUPPORT FOR THIS SCRIPT, IT IS A PROOF OF CONCEPT. YOU MUST MAKE THIS WORK FOR YOURSELF.
IF YOU ASK FOR HELP FOR THIS SCRIPT SPECIFICALLY I WILL BULLY YOU UNTIL YOU BLOCK ME.

for the retards in the back of the room, here's documentation

https://www.autohotkey.com/docs/v1/KeyList.htm



=================================================================================================================================================================================
*/


#SingleInstance Force
#KeyHistory 0
#MaxThreadsPerHotkey 1
#HotkeyModifierTimeout -1
SetBatchLines -1
ListLines Off




;THE MACRO IN QUESTION

^LButton::

	;send {LControl} ;crouch
	send {LButton} ;fire
	sleep(12)
	send {XButton1} ;melee
	sleep(104)
	send {XButton2} ;nade
	sleep(8)
	send {Space down} ;jump
	sleep(24)
	send {Space up}
	send {LControl up}

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

earlyworm's rebuild 1

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

earlyworm's rebuild 2

;send {LControl} ;crouch
;sleep(8)
send {LButton} ;fire
sleep(8)
;send {LButton up}
sleep(4)
send {XButton1} ;melee
sleep(8)
;send {XButton1 up}
sleep(96)
send {XButton2} ;nade
sleep(8)
;send {XButton2 up}
send {Space down} ;jump
sleep(24)
send {Space up}
send {LControl up}