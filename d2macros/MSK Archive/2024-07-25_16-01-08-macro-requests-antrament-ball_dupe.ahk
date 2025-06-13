#MaxThreadsPerHotkey 2
SetMouseDelay, 0
;SetFormat, float, 0

F4::
Send {e up}
Send {e down}
Sleep, 50
Loop, 30 {
	Send {WheelDown}
}
sleep 100
Send {e up}
Send {e up}
Send {e up}
Send {e up}
Send {e up}
return
F5:: Reload