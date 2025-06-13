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
return
F5:: Reload