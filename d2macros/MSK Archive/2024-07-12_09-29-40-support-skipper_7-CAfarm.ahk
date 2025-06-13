#SingleInstance force					; Don't allow multiple versions to run

; Creator: SevenOilRigs :3
; Edited by: twitch.tv/Leopard / youtube.com/leopardstealth

; Change the values below to YOUR keybinds
OpenMap = m
Interact = e
Sprint = Shift
Ghost = Tab
Orbit = g

; Also, the macro requires you to have the following settings:
; 2560 x 1440 resolution or 1920 x 1080 res
; 800 dpi, no mouse acceleration
; 7 sensitivity in game
; FPS can be anything but 30 FPS is the most consistent

; Instructions:
; Press [ when you are in the landing to start the macro
; Press Esc to stop the macro


[::										; Keybind to start macro, which you can change
Loop {    								; Infinite loop to go to orbit
	Loop 40 {							; Reloading the Landing 40 times			
		Character_Turn(-700)			; Turn character slightly left
		Send {%Sprint% Down}			; Activate sprint
		Send {w Down}				; Hold w
		Sleep 7400				; Run towards plant for 7.4 seconds
		Send {%Sprint% Up}			; Let go of sprint
		Send {w Up}				; Let go of w
		Character_Turn(2900)			; Turn character right
		Sleep 30000				; Wait 30 seconds to allow chests to spawn
		Send {%Sprint% Down}			; Active sprint
		Send {w Down}				; Hold w
		Sleep 6400				; Run towards chest for 6.4 seconds
		Character_Turn(-680)			; Turn slightly left towards chest
		Sleep 3000				; Continue to run for 3.0 seconds
		Send {%Sprint% Up}			; Let go of sprint
		Send {w Up}				; Let go of w
		Character_Turn(-1800)			; Face the chest
		Sleep 100				; Small pause
		Send {%Interact% Down}			; Hold interact keybind down
		Sleep 1200				; Wait for 1.2 seconds
		Send {%Interact% Up}			; Let go of interact keybind
		Sleep 100				; Small pause
                Send, %OpenMap%				; Keybind for opening map
		Sleep, 1500				; Waiting for Map to load 
		Cursor_Move(0,500)			; Moving your mouse to the left so it moves the map
		Sleep 1500 * (A_ScreenHeight / 1080) ; Waiting for map to move, scaled by your res
		Cursor_Move(684,516)			; Center mouse so map stops moving
		Sleep, 10				; Small pause
		Send, {Lbutton Down}			; Left click mouse on Landing Fast Travel
		Sleep, 1200				; Hold left click for 1.2 seconds
		Send, {Lbutton Up}			; Let go of left click
		Sleep, 10000                             ; Wait 10 seconds for Landing to load
	}						; End of loop for running to the chest

	; This sections sends you to Orbit and relaunches the Pale Heart to reset your Overthrow
	Send {%Ghost%}					; Keybind for Ghost
	Sleep 1000					; Wait 1 second
	Send {%Orbit% Down}				; Keybind for Orbit
	Sleep 4000					; Wait 4 seconds
	Send {%Orbit% Up}				; Let go of Orbit
	Sleep 10000					; Wait 10 seconds
	Send {%OpenMap%}				; Keybind for Map
	Sleep 2000					; Wait 2 seconds
	Cursor_Move(963, 480)				; Move cursor to Pale Heart
	Sleep 100					; Small pause
	Send {Lbutton}					; Press left click
	Sleep 2000					; Wait 2 seconds
	Cursor_Move(0,500)				; Move mouse to the left so it moves the map
	Sleep 1500 * (A_ScreenHeight / 1080) ; Waiting for map to move, scaled by resolution
	Cursor_Move(684,516)				; Center mouse so map stops moving
	Sleep, 500					; Small pause
	Send, {Lbutton Down}				; Left click mouse on Landing Fast Travel
	Sleep, 1200					; Hold left click for 1.2 seconds
	Send, {Lbutton Up}				; Let go of left click
	Sleep, 1500					; Wait 1.5 seconds
	Cursor_Move(1620, 900)				; Move mouse to Launch button
	Send, {Lbutton Down}				; Left click
	Sleep, 1200					; Wait 1.2 seconds
	Send, {Lbutton Up}				; Let go of left click
	Sleep, 30000				        ; Wait 30 seconds for game to load the Landing
}

Cursor_Move(cord_x, cord_y)
{
    MouseMove, cord_x * (A_ScreenWidth / 1920), cord_y * (A_ScreenHeight / 1080), 1
}

Character_Turn(cord_x)
{
    DllCall("mouse_event", "UInt", 0x01, "Int", cord_x, "Int", 0, "UInt", 0, "UInt", 0)
}

Esc::							; Pressing escape to exit macro
	Reload
return