#singleinstance force
start = 0

customcolor := "000000"
gui +lastfound +alwaysontop -caption +toolwindow
gui, color, %customcolor%
gui, font, s32, verdana
gui, add, text, vmytext cwhite, XXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
winset, transcolor, %customcolor% 255


settimer, updategui, 200
gosub, updategui
updategui:
if winactive("Destiny 2") {
    gui, show, x0 y0 noactivate 
    if (start = 0) {
        guicontrol,, mytext, F2 to close, F3 to Pause, F4 to start farming XP
    } 
    else {
        guicontrol,, mytext, F2 to close, F3 to pause farming XP `nTime Spent: %UserFriendlyTime%
    }
}
else {
    gui, hide
}

F2:: ; press F2 to close the script
{
	exitapp 
}

F3:: ; press F3 to pause the script
{
	reload
}

F4:: ; press F4 to start the script
{
    start = 1
    StartTime := A_TickCount
    loop {
        loop {
            if !winactive("Destiny 2") {
				sleep 500 ; if this isn't here, multiple scripts open ??????? wtf????
				FileAppend, Destiny 2 is not active - pausing script`n, afklog.txt
                reload
            }
            else {
            	Send, g
		Sleep, 800
		MouseMove, 0, 40, 5, R
		Sleep, 400
		MouseMove, 0, -40, 5, R
		Sleep, 400
		Send, {Down}
		Sleep 1090
		ElapsedTime := A_TickCount - StartTime
		UserFriendlyTime:= MillisecToTime(ElapsedTime) 
            }
        }
        num++
    }
}

MillisecToTime(msec) {
	secs := floor(mod((msec / 1000),60))
	mins := floor(mod((msec / (1000 * 60)), 60) )
	hour := floor(mod((msec / (1000 * 60 * 60)) , 24))
	return Format("{:02}:{:02}:{:02}",hour,mins,secs)
}