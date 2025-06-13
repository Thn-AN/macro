#SingleInstance Force
SetWorkingDir %A_ScriptDir%

F3::
global sens := 6.0
global recoil := 2.0
global cycle_time := 60.0


global res_scalar := 1
switch %A_ScreenHeight%
{
	case 720:
	res_scalar := 1.5
	
	case 1080:
	res_scalar := 1.3
	
	case 1440:
	res_scalar := 1
	
	case 2160:
	res_scalar := 0.75
}

global current_x := 0
global current_y := 0

global WishNumber
InputBox, WishNumber, Wall of Wishes menu by Aegis#8622,
(
1. Ethereal Key (once per account) [124]
2. Glittering Key chest spawn [68]
3. Numbers of Power emblem [66]
4. Shuro Chi encounter [214]
5. Morgeth encounter [165]
6. Vault encounter [141]
7. Riven encounter [152]
8. Hope for the Future song [150]
9. Failsafe dialogue [24]
10. Drifter dialogue [64]
11. Party effect on precision kills [147]
12. Random effect around players' heads [108]
13. Petra's Run [166]
14. Corrupted Eggs spawn [102]
15. Change sensitivity (default: 8)
16. Change recoil (default: 2.95)
17. Change speed/shot delay (default: 53)
)
,, 300, 400
if ErrorLevel {
	Return
}


Sleep, 150
Global CounterBefore := 
DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
switch WishNumber
{
	case 1:
	key()	
	
	case 2:
	chest()
	
	case 3:
	emblem()
	
	case 4:
	shuro()
	
	case 5:
	morgeth()
	
	case 6:
	vault()
	
	case 7:
	riven()
	
	case 8:
	song()
	
	case 9:
	failsafe()
	
	case 10:
	drifter()
	
	case 11:
	party()
	
	case 12:
	halo()
	
	case 13:
	petra()
	
	case 14:
	eggs()
	
	case 15:
	sens()

	case 16:
	recoil()

	case 17:
	speed()

	case 18:
	print()
	
	default:
	MsgBox, Invalid menu option
	Return
}

PreciseSleep(ms)
{
    DllCall("QueryPerformanceFrequency", "Int64*", freq)
    DllCall("QueryPerformanceCounter", "Int64*", CounterBeforee)
    While (((counterAfterr - CounterBeforee) / freq * 1000) < ms)
        DllCall("QueryPerformanceCounter", "Int64*", CounterAfterr)
    return ((counterAfterr - CounterBeforee) / freq * 1000) 
}



key()
{
	Array := [3, 4, 5, 9, 10, 18, 11, 12, 16, 1]
	shoot(Array, 1)
	Array := [3, 4, 5, 9, 10, 18, 12, 16, 17, 2]
	shoot(Array, 1)
	Array := [3, 4, 5, 9, 10, 18, 11, 16, 17, 6]
	shoot(Array, 1)
	Array := [3, 4, 5, 9, 10, 18, 11, 12, 17, 7]
	shoot(Array, 1)
	Array := [3, 4, 5, 9, 10, 18, 14, 15, 19, 20]
	shoot(Array, 4)
	Array := [3, 4, 5, 9, 10, 18, 11, 12, 16, 17]
	shoot(Array, 2)
	Array := [3, 4, 5, 9, 10, 11, 0, 0, 0, 0]
	shoot(Array, 1)
	Array := [3, 4, 5, 9, 10, 12, 0, 0, 0, 0]
	shoot(Array, 1)
	Array := [3, 4, 5, 9, 10, 16, 0, 0, 0, 0]
	shoot(Array, 1)
	Array := [3, 4, 5, 9, 10, 17]
	shoot(Array, 1)
	done()
}

chest()
{
	Array := [3, 8, 13, 18, 20, 1, 6, 5, 10, 15]
	shoot(Array, 3)
	Array := [3, 8, 13, 18, 20, 1, 6, 11, 16, 0]
	shoot(Array, 1)
	Array := [3, 8, 13, 18, 20, 0, 0, 11, 16, 0]
	shoot(Array, 1)
	Array := [3, 8, 13, 18, 0, 0, 0, 0, 0, 0]
	shoot(Array, 5)
	Array := [3, 8]
	shoot(Array, 1)
	comp(0, -10)	
	done()
}

emblem()
{
	Array := [17, 19, 11, 13, 15, 7, 9, 1, 3, 5]
	shoot(Array, 1)
	Array := [17, 19, 11, 13, 15, 0, 0, 0, 0, 0]
	shoot(Array, 8)
	comp(0, -20)
	Array := [17, 19, 7, 9, 0, 0, 0, 0, 0, 0]
	shoot(Array, 4)
	comp(0, -10)
	done()
}

shuro()
{
	Array := [2, 3, 4, 1, 7, 14, 20, 5, 9, 12]
	shoot(Array, 2)
	Array := [2, 3, 4, 1, 7, 14, 20, 9, 12, 16]
	shoot(Array, 2)
	Array := [2, 3, 4, 1, 7, 14, 20, 5, 12, 16]
	shoot(Array, 2)
	Array := [2, 3, 4, 1, 7, 14, 20, 5, 9, 16]
	shoot(Array, 2)
	Array := [2, 3, 4, 1, 7, 14, 20, 5, 9, 8]
	shoot(Array, 3)
	Send, R
	Sleep, 2100
	Array := [2, 3, 4, 12, 16, 8, 6, 10, 11, 15]
	shoot(Array, 3)
	Array := [2, 3, 1, 7, 14, 20, 5, 17, 18, 19]
	shoot(Array, 2)
	Array := [9, 12, 16, 6, 10, 11, 15, 17, 18, 19]
	shoot(Array, 2)
	Array := [4, 1, 7, 14, 20, 5, 9, 12, 16, 8]
	shoot(Array, 2)
	Array := [6, 10, 11, 15, 17, 18, 19, 0, 0, 0]
	shoot(Array, 2)
	done()
}

morgeth()
{
	Array := [8, 3, 13, 18, 2, 4, 17, 19, 7, 9]
	shoot(Array, 4)
	Array := [8, 3, 13, 18, 2, 4, 17, 19, 12, 14]
	shoot(Array, 4)
	Array := [8, 3, 13, 18, 2, 4, 7, 9, 12, 14]
	shoot(Array, 3)
	Array := [8, 3, 13, 18, 17, 19, 1, 5, 16, 20]
	shoot(Array, 3)
	Array := [8, 2, 7, 9, 12, 14, 1, 5, 16, 20]
	shoot(Array, 1)
	Array := [8, 3, 13, 18, 4, 17, 19, 7, 9, 12]
	shoot(Array, 1)
	Array := [14, 1, 5, 16, 20]
	shoot(Array, 1)
	comp(3, -5)
	done()
}

vault()
{
	Array := [3, 2, 4, 16, 17, 18, 19, 20, 1, 5]
	shoot(Array, 5)
	Array := [3, 2, 4, 16, 17, 18, 19, 20, 7, 9]
	shoot(Array, 5)
	Array := [3, 2, 4, 16, 17, 18, 1, 5, 7, 9]
	shoot(Array, 1)
	comp(0, 5)
	Array := [3, 2, 4, 19, 20, 1, 5, 7, 9, 6]
	shoot(Array, 1)
	Array := [3, 2, 4, 1, 5, 7, 9, 10, 11, 15]
	shoot(Array, 1)
	Array := [3, 1, 5, 7, 9, 0, 0, 0, 0, 0]
	shoot(Array, 2)
	Array := [3]
	shoot(Array, 1)
	done()
}

riven()
{
	Array := [1, 16, 10, 15, 13, 3, 18, 6, 11, 9]
	shoot(Array, 2)
	Array := [1, 16, 10, 15, 13, 3, 18, 6, 11, 14]
	shoot(Array, 2)
	Array := [1, 16, 10, 15, 13, 3, 18, 6, 11, 5]
	shoot(Array, 2)
	Array := [1, 16, 10, 15, 13, 3, 18, 9, 14, 20]
	shoot(Array, 2)
	comp(0, -30)
	Array := [1, 16, 10, 15, 13, 3, 18, 5, 2, 17]
	shoot(Array, 2)
	Array := [1, 16, 10, 15, 13, 3, 18, 6, 11, 20]
	shoot(Array, 2)
	Array := [1, 16, 10, 15, 13, 9, 14, 5, 2, 17]
	shoot(Array, 1)
	Array := [1, 16, 10, 15, 13, 9, 14, 20, 2, 17]
	shoot(Array, 1)
	Array := [1, 16, 10, 15, 6, 11, 5, 9, 14, 20]
	shoot(Array, 1)
	Array := [1, 16]
	shoot(Array, 1)
	comp(5, -7)
	done()
}

song()
{
	Array := [13, 3, 8, 18, 2, 7, 12, 17, 4, 9]
	shoot(Array, 4)
	Array := [13, 3, 8, 18, 2, 7, 12, 17, 14, 19]
	shoot(Array, 4)
	Array := [13, 3, 8, 18, 2, 7, 4, 9, 14, 19]
	shoot(Array, 2)
	Array := [13, 3, 8, 18, 12, 17, 4, 9, 14, 19]
	shoot(Array, 2)
	Array := [13, 3, 2, 7, 12, 17, 4, 9, 14, 19]
	shoot(Array, 2)
	Array := [13, 8, 18, 0, 0, 0, 4, 9, 14, 19]
	shoot(Array, 1)
	Array := [13, 8, 18]
	shoot(Array, 1)
	comp(5, -5)
}

failsafe()
{
	Array := [14, 7, 8, 9, 12, 13, 0, 0, 0, 0]
	shoot(Array, 2)
	Array := [14, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	shoot(Array, 12)
	comp(0, -25)
	done()
}

drifter()
{
	Array := [7, 8, 13, 14, 10, 15, 19, 20, 1, 2]
	shoot(Array, 2)
	Array := [7, 8, 13, 14, 10, 15, 19, 5, 6, 11]
	shoot(Array, 2)
	Array := [7, 8, 13, 14, 20, 0, 0, 0, 0, 0]
	shoot(Array, 2)
	Array := [7, 8, 13, 14, 0, 0, 0, 0, 0, 0]
	shoot(Array, 1)
	Array := [7, 8, 0, 0, 0, 0, 0, 0, 0, 0]
	shoot(Array, 5)
	comp(0, -20)
	done()
}

party()
{
	Array := [4, 5, 10, 11, 16, 17, 15, 19, 20, 9]
	shoot(Array, 1)
	Array := [4, 5, 10, 1, 2, 6, 11, 16, 17, 15]
	shoot(Array, 5)
	Array := [4, 5, 10, 1, 2, 6, 11, 16, 17, 9]
	shoot(Array, 3)
	Array := [4, 5, 10, 1, 2, 6, 19, 20, 9, 0]
	shoot(Array, 1)
	Array := [4, 5, 10, 1, 2, 6, 19, 20, 13, 0]
	shoot(Array, 2)
	Array := [4, 5, 10, 1, 2, 6, 19, 0, 0, 0]
	shoot(Array, 2)
	Array := [4, 5, 10, 1, 2, 6, 20, 8, 0, 0]
	shoot(Array, 2)
	comp(0, -26)
	done()
}

halo()
{
	Array := [14, 15, 20, 13, 5, 8, 9, 10, 1, 6]
	shoot(Array, 1)
	Array := [14, 15, 20, 13, 5, 8, 9, 10, 11, 7]
	shoot(Array, 1)
	Array := [14, 15, 20, 13, 5, 8, 9, 10, 12, 16]
	shoot(Array, 2)
	Array := [14, 15, 20, 13, 5, 8, 9, 10, 11, 12]
	shoot(Array, 2)
	Array := [14, 15, 20, 13, 5, 8, 9, 10, 11, 16]
	shoot(Array, 1)
	Array := [14, 15, 20, 13, 5, 8, 9, 10, 16, 0]
	shoot(Array, 1)
	Array := [14, 15, 20, 13, 5, 8, 9, 10, 0, 0]
	shoot(Array, 1)
	Array := [14, 15, 20, 13, 0, 0, 0, 0, 0, 0]
	shoot(Array, 3)
	Array := [14, 15, 20, 0, 0, 0, 0, 0, 0, 0]
	shoot(Array, 3)
	comp(0, -20)
	done()
}

petra()
{
	Array := [4, 9, 12, 17, 3, 1, 6, 15, 20, 5]
	shoot(Array, 2)
	Array := [4, 9, 12, 17, 3, 1, 6, 15, 20, 10]
	shoot(Array, 2)
	Array := [4, 9, 12, 17, 3, 1, 6, 15, 20, 11]
	shoot(Array, 2)
	Array := [4, 9, 12, 17, 3, 1, 6, 15, 20, 16]
	shoot(Array, 2)
	Array := [4, 9, 12, 17, 3, 5, 10, 11, 16, 2]
	shoot(Array, 2)
	Array := [4, 9, 12, 17, 1, 6, 15, 20, 7, 14]
	shoot(Array, 2)
	Array := [4, 9, 12, 17, 3, 5, 10, 11, 16, 19]
	shoot(Array, 2)
	Array := [1, 6, 15, 20, 3, 5, 10, 11, 16, 0]
	shoot(Array, 2)
	Array := [4, 9, 12, 17, 1, 6, 15, 20, 0, 0]
	shoot(Array, 1)
	comp(0, 10)
	done()
}

eggs()
{
	Array := [8, 3, 17, 20, 2, 4, 14, 13, 1, 11]
	shoot(Array, 1)
	Array := [8, 3, 17, 20, 2, 4, 14, 13, 5, 16]
	shoot(Array, 5)
	Array := [8, 3, 17, 20, 2, 4, 14, 1, 0, 0]
	shoot(Array, 2)
	Array := [8, 3, 17, 20, 2, 4, 1, 0, 0, 0]
	shoot(Array, 1)
	Array := [8, 3, 17, 20, 2, 1, 0, 0, 0, 0]
	shoot(Array, 1)
	Array := [8, 3, 17, 20, 0, 0, 0, 0, 0, 0]
	shoot(Array, 1)
	Array := [8, 3, 17, 0, 0, 0, 0, 0, 0, 0]
	shoot(Array, 1)
	Array := [8, 3, 0, 0, 0, 0, 0, 0, 0, 0]
	shoot(Array, 2)
	Array := [8, 0, 0, 0, 0, 0, 0, 0, 0, 0]
	shoot(Array, 2)
	comp(0, -30)
	done()
}

sens()
{
	InputBox, sens, Sensitivity, Input your ingame sensitivity (default: 8):,, 230, 150
	IniWrite, %sens%, wall_settings.ini, Variables, Sensitivity
	Reload
}

recoil()
{
	InputBox, recoil, Recoil, Input your recoil (default: 2.95`,` higher = down):,, 230, 150
	IniWrite, %recoil%, wall_settings.ini, Variables, Recoil
	Reload
}

speed()
{
	InputBox, cycle_time, Speed / shot delay, Input shot delay in ms (default: 53`,` higher = slower):,, 230, 150
	IniWrite, %cycle_time%, wall_settings.ini, Variables, Cycle_Time
	Reload
}

print()
{
	MsgBox, sens: %sens%`nrecoil: %recoil%`nspeed: %cycle_time%
}

shoot(Array, LoopCount)
{
	Loop %LoopCount%
	{
		ArrayIndex := 1
		ArrayLength := Array.MaxIndex()
		Loop %ArrayLength%
		{
			switch Array[ArrayIndex]
			{
				case 0:
				column := column
				row := row
			
				case 1:
				column := -375
				row := -245
			
				case 2:
				column := -195
				row := -260
			
				case 3:
				column := 0
				row := -265
			
				case 4:
				column := 190
				row := -255
			
				case 5:
				column := 370
				row := -235
			
				case 6:
				column := -375
				row := -80
			
				case 7:
				column := -195
				row := -95
			
				case 8:
				column := 0
				row := -95
			
				case 9:
				column := 190
				row := -90
			
				case 10:
				column := 370
				row := -75
			
				case 11:
				column := -375
				row := 95
			
				case 12:
				column := -195
				row := 90
			
				case 13:
				column := 0
				row := 90
			
				case 14:
				column := 190
				row := 95
			
				case 15:
				column := 370
				row := 100
			
				case 16:
				column := -375
				row := 280
			
				case 17:
				column := -195
				row := 280
			
				case 18:
				column := 0
				row := 280
			
				case 19:
				column := 190
				row := 280
			
				case 20:
				column := 370
				row := 280
			}
			
			new_x := column * res_scalar / sens * 8.0
			new_y := row * res_scalar / sens * 8.0
			
			if (Array[ArrayIndex] == 0) {
				PreciseSleep(85)
			} else if (Array[ArrayIndex] != "") {
				DllCall("mouse_event", "UInt", 0x01, "UInt", new_x - current_x, "UInt", new_y - current_y + recoil / sens * 8.0)
				PreciseSleep(15)
				DllCall("mouse_event", "UInt", 0x02, "UInt", 0, "UInt", 0)
				PreciseSleep(15)
				DllCall("mouse_event", "UInt", 0x04, "UInt", 0, "UInt", 0)
				PreciseSleep(cycle_time)
			}
	
			current_x := new_x
			current_y := new_y
			ArrayIndex++
		}
	}
}

comp(x, y)
{
	DllCall("mouse_event", "UInt", 0x01, "UInt", x, "UInt", y)
}

done()
{
	Send, r
	DllCall("mouse_event", "UInt", 0x01, "UInt", 0 - current_x, "UInt", 0 - current_y)
	Send, {w down}
	Sleep, 400
	Send, {w up}
	Sleep, 600
	Send, {s down}
	Sleep, 500
	Send, {s up}
	DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
	MsgBox % "Time taken: "  CounterAfter - CounterBefore
	Reload
}

F4::
Click, Left up
ExitApp

F5::
Click, Left up
Reload