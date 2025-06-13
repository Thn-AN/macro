WinGetPos, Win_X, Win_y, Win_w, Win_h, ahk_exe destiny2.exe

6::
	Loop {
		MouseMove, Win_X+1105, Win_y+65, 0
		Click
		Sleep 2000
		MouseMove, Win_X+00, Win_y+390, 0
		Click
		Sleep 2000
		Send {Right}
		Sleep 2000
		MouseMove, Win_X+865, Win_y+785, 0
		Sleep 500

		Loop 9 {
			Click, down
			Sleep 3000
			Click, up
			Sleep 1500
		}

		Send {N}
		Sleep 1000
		MouseMove, Win_X+530, Win_y+395, 0
		Sleep 1000
		MouseMove, Win_X+420, Win_y+390, 3
		Sleep 500

		Loop 9 {
			Send {F down}
			Sleep 2000
			Send {F up}
			Sleep 1000
		}
	}
Return


7::reload
8::exitapp