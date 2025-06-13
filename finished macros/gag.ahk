; 144 fps
; 2560 x 1440 resolution
; press [ to start macro
; press Esc to stop macro

speed:= 10
delay:= 50

]::
Reload
return
 
[::

loop
{
	MouseMove, 1052, 615, speed
	Click
	Sleep delay
	MouseMove, 672, 144, speed
	Click
	Sleep, delay
	Send, e
	Sleep, 2000
		loop 10
		{
			MouseMove, 941, 678, speed
			Send, {WheelDown 200}
			sleep 1000
			Click
			sleep delay
			MouseMove, 764, 816, speed
			sleep delay
			Click
			sleep delay

			MouseMove, 942, 458, speed
			Click
			sleep delay
			MouseMove, 802, 856, speed
			Click 2
			sleep delay
			
			MouseMove, 929, 350, speed
			sleep delay
			Click
			MouseMove, 774, 840, speed
			Click 2
			sleep delay

			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 830, speed
			Click 2 
			sleep delay

			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 820, speed
			Click 2 
			sleep delay

			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 810, speed
			Click 2 
			sleep delay

			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 800, speed
			Click 2 
			sleep delay

			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 790, speed
			Click 2 
			sleep delay

			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 780, speed
			Click 2 
			sleep delay
			
			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 770, speed
			Click 2 
			sleep delay
			
			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 760, speed
			Click 2 
			sleep delay

			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 750, speed
			Click 2 
			sleep delay

			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 750, speed
			Click 2 
			sleep delay

			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 740, speed
			Click 2 
			sleep delay

			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 730, speed
			Click 2 
			sleep delay

			MouseMove, 929, 350, speed
			sleep delay
			Click
			mouseMove, 774, 720, speed
			Click 2 
			sleep delay

		}
}
return