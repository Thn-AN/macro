; 144 fps
; 2560 x 1440 resolution
; press [ to start macro
; press Esc to stop macro

speed:= 35
delay:= 200
Mouse_click(x_coord, y_coord, move_speed, bool, unit_number:=0, upgrade:=0)
{
    Sleep, delay
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
    Sleep, delay
    if (upgrade = 1)
	{
		Send, {t}
	}
	Sleep, delay
    Send, {q}
}
Esc::
Reload
return
 
[::
Mouse_click(28, 1043, speed, 0)
Mouse_click(1220, 340, speed, 0)
Mouse_click(1343, 180, speed, 0)
Mouse_click(878, 181, speed, 0)

Loop
{
	Mouse_click(691, 736, speed, 0, 1, 0)
	loop 3
	{
		Mouse_click(100, 0, speed, 1, 2, 1)
	}
	ImageSearch, FoundX, FoundY, 0, 0, 1910, 1090, D:\Excess\macro\def_black.png
	if (errorLevel = 0)
		{
		    Mouse_click(1227, 841, speed, 0)
		    Sleep, 1000
		    Mouse_click(878, 181, speed, 0)
		    Sleep, 1000
		}

}
return