#MaxThreadsPerHotkey 2
SetMouseDelay, 0
;SetFormat, float, 0

F4::

Click
Loop, 30 {
	Send {WheelDown}
}
sleep 1500
Send {e down}
sleep 1500
Send {e up}
return
F5:: Reload