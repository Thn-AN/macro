; 144 fps
; 2560 x 1440 resolution
; press [ when you tp to spawn to start macro
; press Esc to stop macro
speed:= 2
delay:= 50
Mouse_Move(cord_x, cord_y)
{
    MouseMove, cord_x * (A_ScreenWidth / 1920), cord_y * (A_ScreenHeight / 1080), 1
}
Esc::
Reload
return

[::
Loop     				; Infinite loop
{
	Mouse_Move(902,193)
	Sleep, delay
	Send, {Lbutton Down}
	Sleep, delay
	Send, {Lbutton Up}

	Send {1}
	MouseMove, -252, 607, speed, R
	Send {Lbutton Down}
	Sleep, delay
	Send, {Lbutton Up}
	Send {t}
	loop 3
	{
		Send {2}	
		MouseMove, 200, 0, speed, R
		Send {Lbutton Down}
		Sleep, delay
		Send, {Lbutton Up}
		Sleep, delay
		Send {t}
		Sleep, delay
		Send {q}
	}
}
return