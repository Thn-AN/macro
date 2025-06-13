#MaxThreadsPerHotkey 2
SetMouseDelay, 0
;SetFormat, float, 0

F4::

Click
Send {1 down}
Send {2 down}
Send {3 down}
Send {1 up}
Send {2 up}
Send {3 up}
sleep 1000
Send {e down}
sleep 1500
Send {e up}
return
F5:: Reload