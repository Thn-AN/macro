; F3 to change settings, F4 to stop macro
; F5 on mission complete

#SingleInstance Force
SendMode Input

F3::
global Activity, Host, Farm, Length, LengthStr
global Speed := 1.0

InputBox, Activity, Activity selection, 
(
DUNGEONS:
The Shattered Throne
Pit of Heresy
Prophecy
Grasp of Avarice (Normal)
Grasp of Avarice (Master)
Duality (Normal)
Duality (Master)
Spire of the Watcher (Normal)
Spire of the Watcher (Master)
Ghosts of the Deep (Normal)
Ghosts of the Deep (Master)
Warlord's Ruin (Normal)
Warlord's Ruin (Master)

RAIDS:
Last Wish
Garden of Salvation
Deep Stone Crypt
Vault of Glass (Normal)
Vault of Glass (Master)
Vow of the Disciple
Vow of the Disciple (Master)
King's Fall (Normal)
King's Fall (Master)
Root of Nightmares (Normal)
Root of Nightmares (Master)
Crota's End (Normal)
Crota's End (Master)

OTHER:
Vanguard Ops
Grandmaster Nightfall
Dares of Eternity (Legend)
Exotic Mission Rotator (Normal)
Exotic Mission Rotator (Legend)
Trials of Osiris / Iron Banner
Competitive
)
,,250,755

InputBox, LengthStr, Farm type, Checkpoints or fulls?,,200,130
if (LengthStr == "Fulls" || LengthStr == "fulls") {
	MsgBox, Press F5 on mission complete.
	Length := 1
} else if (LengthStr == "Checkpoints" || LengthStr == "checkpoints" || LengthStr == "CPs" || LengthStr == "cps") {
	InputBox, Host, Host selection, Which character do you want to launch from (1-3)?,,200,150
	InputBox, Farm, Farm selection, Which character do you want to farm on (1-3)?,,200,150
	MsgBox, Press F5 on mission complete, then press F6 when the launch button has an outline after people join. Have a farming team member's join command copied!
	Length := 0
} else {
	MsgBox, Invalid input.
	Reload
}
Return

F5::

if (Length == 0) {
	swap_to_host()
}

; Open destinations tab
Send, {Tab down}
if (Length == 1) {
	PreciseSleep(1500)
	Send, {Tab up}
	fastclick(2125, 91, 1000, 1)
}
Send, {Tab up}
PreciseSleep(1500)

; Select chosen activity
switch Activity {
	case "The Shattered Throne", "throne", "shattered", "tst", "st":
	fastclick(2121, 584, 20, 1)
	fastclick(1300, 0, 20, 1)
	PreciseSleep(1200)
	fastclick(1305, 438, 500, 1)
	Launch(Length)

	case "Pit of Heresy", "pit", "poh":
	fastclick(2073, 1167, 20, 1)
	fastclick(2560, 0, 20, 1)
	PreciseSleep(1100)
	fastclick(1357, 365, 500, 1)
	Launch(Length)
	
	case "Prophecy", "prophecy", "proph":
	fastclick(1592, 204, 20, 1)
	PreciseSleep(1200)
	fastclick(980, 1039, 500, 1)
	Launch(Length)
	
	case "Grasp of Avarice (Normal)", "grasp", "goa":
	fastclick(1614, 1281, 20, 1)
	fastclick(900, 0, 20, 1)
	PreciseSleep(1550)
	fastclick(784, 260, 500, 1)
	Launch(Length)
	
	case "Grasp of Avarice (Master)", "master grasp", "mgoa":
	fastclick(1614, 1281, 20, 1)
	fastclick(900, 0, 20, 1)
	PreciseSleep(1550)
	fastclick(784, 260, 500, 1)
	PreciseSleep(700)
	fastclick(2178, 1114, 20, 1)
	PreciseSleep(1100)
	fastclick(442, 460, 20, 1)
	Launch(Length)
	
	case "Duality (Normal)", "duality":
	fastclick(2073, 1167, 20, 1)
	fastclick(0, 1440, 20, 1)
	PreciseSleep(1100)
	fastclick(512, 1056, 500, 1)
	Launch(Length)
	
	case "Duality (Master)", "master duality", "mduality":
	fastclick(2073, 1167, 20, 1)
	fastclick(0, 1440, 20, 1)
	PreciseSleep(1100)
	fastclick(512, 1056, 500, 1)
	PreciseSleep(700)
	fastclick(2178, 1114, 20, 1)
	PreciseSleep(1100)
	fastclick(442, 460, 20, 1)
	Launch(Length)

	case "Spire of the Watcher (Normal)", "spire", "sotw":
	fastclick(579, 1056, 20, 1)
	fastclick(0, 485, 20, 1)
	PreciseSleep(1100)
	fastclick(573, 512, 500, 1)
	Launch(Length)

	case "Spire of the Watcher (Master)", "master spire", "msotw":
	fastclick(579, 1056, 20, 1)
	fastclick(0, 485, 20, 1)
	PreciseSleep(1100)
	fastclick(573, 512, 500, 1)
	PreciseSleep(700)
	fastclick(2178, 1114, 20, 1)
	PreciseSleep(1100)
	fastclick(442, 460, 20, 1)
	Launch(Length)
	
	case "Ghosts of the Deep (Normal)", "ghosts", "gotd":
	fastclick(878, 761, 20, 1)
	fastclick(518, 275, 2000, 1)
	Launch(Length)

	case "Ghosts of the Deep (Master)", "master ghosts", "mgotd":
	fastclick(878, 761, 20, 1)
	fastclick(518, 275, 2000, 1)
	PreciseSleep(700)
	fastclick(2178, 1114, 20, 1)
	PreciseSleep(1100)
	fastclick(442, 460, 20, 1)
	Launch(Length)

	case "Warlord's Ruin (Normal)", "warlord's", "warlord", "wr":
	fastclick(945, 1272, 20, 1)
	fastclick(2559, 729, 20, 1)
	PreciseSleep(1500)
	fastclick(1876, 741, 500, 1)
	Launch(Length)

	case "Warlord's Ruin (Master)", "master warlord's", "master warlord", "mwr":
	fastclick(945, 1272, 20, 1)
	fastclick(2559, 729, 20, 1)
	PreciseSleep(1500)
	fastclick(1876, 741, 500, 1)
	PreciseSleep(700)
	fastclick(2178, 1114, 20, 1)
	PreciseSleep(1100)
	fastclick(442, 460, 20, 1)
	Launch(Length)

	case "Last Wish", "wish", "lw":
	fastclick(2121, 584, 20, 1)
	fastclick(350, 0, 20, 1)
	PreciseSleep(1000)
	fastclick(913, 325, 750, 1)
	Launch(Length) 
	
	case "Garden of Salvation", "garden", "gos":
	fastclick(2073, 1167, 20, 1)
	fastclick(0, 0, 20, 1)
	PreciseSleep(1100)
	fastclick(969, 391, 500, 1)
	Launch(Length) 
	
	case "Deep Stone Crypt", "deep stone", "dsc":
	fastclick(290, 744, 20, 1)
	fastclick(1950, 0, 20, 1)
	PreciseSleep(2000)
	fastclick(1537, 413, 500, 1)
	Launch(Length) 
	
	case "Vault of Glass (Normal)", "vog":
	fastclick(1592, 204, 20, 1)
	PreciseSleep(1200)
	fastclick(615, 650, 500, 1)
	Launch(Length)
	
	case "Vault of Glass (Master)", "master vog", "mvog":
	fastclick(1592, 204, 20, 1)
	PreciseSleep(1200)
	fastclick(615, 650, 500, 1)
	PreciseSleep(700)
	fastclick(2178, 1114, 20, 1)
	PreciseSleep(1100)
	fastclick(442, 460, 20, 1)
	Launch(Length)
	
	case "Vow of the Disciple", "vow", "votd":
	fastclick(579, 1056, 20, 1)
	fastclick(0, 0, 20, 1)
	PreciseSleep(2000)
	fastclick(1210, 335, 500, 1)
	Launch(Length) 
	
	case "Vow of the Disciple (Master)", "master vow", "mvow", "mvotd":
	fastclick(579, 1056, 20, 1)
	fastclick(0, 0, 20, 1)
	PreciseSleep(2000)
	fastclick(1210, 335, 500, 1)
	PreciseSleep(700)
	fastclick(2178, 1114, 20, 1)
	PreciseSleep(1100)
	fastclick(442, 460, 20, 1)
	Launch(Length)	
	
	case "King's Fall (Normal)", "kf":
	fastclick(1592, 204, 20, 1)
	PreciseSleep(1200)
	fastclick(1950, 650, 500, 1)
	Launch(Length) 
	
	case "King's Fall (Master)", "master kf", "mkf":
	fastclick(1592, 204, 20, 1)
	PreciseSleep(1200)
	fastclick(1950, 650, 500, 1)
	PreciseSleep(700)
	fastclick(2178, 1114, 20, 1)
	PreciseSleep(1100)
	fastclick(442, 460, 20, 1)
	Launch(Length)

	case "Root of Nightmares (Normal)", "root", "ron":
	fastclick(582, 427, 20, 1)
	fastclick(0, 0, 20, 1)
	PreciseSleep(1400)
	fastclick(832, 430, 500, 1)
	Launch(Length) 
	
	case "Root of Nightmares (Master)", "master root", "master ron", "mron":
	fastclick(582, 427, 20, 1)
	fastclick(0, 0, 20, 1)
	PreciseSleep(1400)
	fastclick(832, 430, 500, 1)
	PreciseSleep(700)
	fastclick(2178, 1114, 20, 1)
	PreciseSleep(1100)
	fastclick(442, 460, 20, 1)
	Launch(Length)

	case "Crota's End (Normal)", "crota", "ce":
	fastclick(1592, 204, 20, 1)
	PreciseSleep(1200)
	fastclick(1273, 413, 500, 1)
	Launch(Length) 
	
	case "Crota's End (Master)", "master crota", "mce":
	fastclick(1592, 204, 20, 1)
	PreciseSleep(1200)
	fastclick(1273, 413, 500, 1)
	PreciseSleep(700)
	fastclick(2178, 1114, 20, 1)
	PreciseSleep(1100)
	fastclick(442, 460, 20, 1)
	Launch(Length)
	
	case "Vanguard Ops", "strikes":
	fastclick(965, 201, 20, 1)
	PreciseSleep(1100)
	fastclick(1275, 565, 500, 1)
	Launch(Length) 
	
	case "Grandmaster Nightfall", "gms":
	fastclick(965, 201, 20, 1)
	PreciseSleep(1100)
	fastclick(1638, 1068, 500, 1)
	Launch(Length)
	
	case "Dares of Eternity (Legend)", "doe", "dares":
	fastclick(1970, 381, 20, 1)
	PreciseSleep(1200)
	fastclick(1275, 839, 500, 1)
	PreciseSleep(700)
	fastclick(2178, 1114, 20, 1)
	PreciseSleep(1100)
	fastclick(442, 460, 20, 1)
	Launch(Length)

	case "Exotic Mission Rotator (Normal)", "exotic mission", "exotic", "rotator":
	fastclick(1592, 204, 20, 1)
	PreciseSleep(1200)
	fastclick(1577, 1040, 500, 1)
	Launch(Length)

	case "Exotic Mission Rotator (Legend)", "legend exotic mission", "legend rotator":
	fastclick(1592, 204, 20, 1)
	PreciseSleep(1200)
	fastclick(1577, 1040, 500, 1)
	PreciseSleep(700)
	fastclick(2178, 1114, 20, 1)
	PreciseSleep(1100)
	fastclick(442, 460, 20, 1)
	Launch(Length)

	case "Trials of Osiris", "trials", "Iron Banner", "ib", "banner":
	fastclick(1383, 204, 20, 1)
	PreciseSleep(1200)
	fastclick(1532, 541, 500, 1)
	PreciseSleep(300)
	Launch(Length)

	case "Competitive", "comp":
	fastclick(1383, 204, 20, 1)
	PreciseSleep(1200)
	fastclick(1023, 531, 500, 1)
	PreciseSleep(300)
	Launch(Length)

	default:
	MsgBox, Invalid activity name.
	Return
}

if (Length == 0) {
	Pause
	Click
	PreciseSleep(15000)
	swap_to_farm()
}

Return

swap_to_farm() {
	Send, {F1}
	PreciseSleep(600)
	Send, D
	PreciseSleep(800)
	Send, D
	PreciseSleep(800)
	fastclick(385, 920, 20, 1)
	PreciseSleep(500)
	fastclick(2150, 335, 20, 1)
	PreciseSleep(500)
	Send, {Enter}
	PreciseSleep(9000)
		
	switch Farm
	{
		case 1:
		fastclick(1800, 600, 20, 1)
		
		case 2:
		fastclick(1800, 760, 20, 1)
		
		case 3:
		fastclick(1800, 900, 20, 1)
	}
	PreciseSleep(10000)
	Send, {Enter}
	PreciseSleep(400)
	Send, ^v
	PreciseSleep(400)
	Send, {Enter}
}

swap_to_host() {
	Send, {F1}
	PreciseSleep(600)
	Send, D
	PreciseSleep(600)
	Send, D
	PreciseSleep(800)
	fastclick(385, 920, 20, 1)
	PreciseSleep(500)
	fastclick(2150, 335, 20, 1)
	PreciseSleep(500)
	Send, {Enter}
	PreciseSleep(4500)

	switch Host
	{
		case 1:
		fastclick(1800, 600, 20, 1)
		
		case 2:
		fastclick(1800, 760, 20, 1)
		
		case 3:
		fastclick(1800, 900, 20, 1)
	}
	PreciseSleep(2500)
}

F4::
ExitApp

F6::
Pause

fastclick(x, y, delay, press) {
    DllCall("mouse_event", "UInt", 0x8001, "UInt", x * 65535 / 2560, "UInt", y * 65535 / 1440)
	PreciseSleep(delay)
	if (press == 1) {
		Click
	}	
}

PreciseSleep(s) {
    DllCall("QueryPerformanceFrequency", "Int64*", QPF)
    DllCall("QueryPerformanceCounter", "Int64*", QPCB)
    While (((QPCA - QPCB) / QPF * 1000) < (1 / Speed * s))
        DllCall("QueryPerformanceCounter", "Int64*", QPCA)
    return ((QPCA - QPCB) / QPF * 1000) 
}

Launch(Length) {
	PreciseSleep(700)
	fastclick(2178, 1205, 20, Length)
}