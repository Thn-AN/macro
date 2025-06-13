; 144 fps
; 2560 x 1440 resolution
; press [ to start macro
; press Esc to stop macro

speed:= 10
delay:= 100

Mouse_click(x_coord, y_coord)
{
	MouseMove, x_coord, y_coord, speed
	Sleep, delay
	Send, {Lbutton Down}{Lbutton Up}
	Sleep, delay

}

Esc::
Reload
return
 
[::

Loop
{	
	Mouse_click(1331, 693)
	Mouse_click(784,716)
	Mouse_click(975,970)
	Sleep, 10000
	Mouse_click(975,970)
	Sleep, 4000
	Mouse_click(975,970)
}
return