; 144 fps
; 2560 x 1440 resolution
; press [ to start macro
; press Esc to stop macro
; kin -> veg -> speed
speed:= 30
delay:= 150

Mouse_click(x_coord, y_coord, move_speed, bool, unit_number:=0, upgrade:=0)
{
    Send, {%unit_number%}
	if (bool = 1)
	{
    	MouseMove, x_coord, y_coord, move_speed, R
	}
	else
	{
		MouseMove, x_coord, y_coord, move_speed
	} 
    Sleep, delay
    Send, {Lbutton Down}{Lbutton Up}
    if (upgrade = 1)
	{
		Send, {t}
	}
    Send, {q}
}

Esc::
Reload
return
 
[::

Loop 10
{
	Send, {o}
}
Mouse_click(28, 1043, speed, 0)
Mouse_click(1220, 340, speed, 0)
Mouse_click(1343, 180, speed, 0)
Mouse_click(878, 181, speed, 0)
Loop
{
	Mouse_click(793, 477, speed, 0, 1, 0)
	Mouse_click(1489, 490, speed, 0, 3, 1)
	Mouse_click(1547, 500, speed, 0, 3, 1)
	Mouse_click(1604, 509, speed, 0, 3, 1)
	Mouse_click(816, 524, speed, 0, 2, 1)
	loop 4
	{
		Mouse_click(50, 0, speed, 1, 2, 1)
	}
	ImageSearch, FoundX, FoundY, 0, 0, 1910, 1090, C:\Users\Pie\Documents\Macro Recorder\def_black.png
	if (errorLevel = 0)
		{
		    Mouse_click(1227, 841, speed, 0)
		    Sleep, 1000
		    Mouse_click(878, 181, speed, 0)
		    Sleep, 1000
		}
}
return