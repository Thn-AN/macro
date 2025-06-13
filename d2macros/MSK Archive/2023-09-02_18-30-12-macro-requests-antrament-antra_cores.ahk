IfWinExist, Destiny 2
{
	WinGet, WinId, ID ; get the ahk id of D2 if it exists
} else {
	msgbox, Destiny 2 is not open, script closing ; lol d2 isnt open
	exitapp
}

VarSetCapacity(RECT, 16, 0)
DllCall("user32\GetClientRect", Ptr,WinId, Ptr,&RECT)
DllCall("user32\ClientToScreen", Ptr,WinId, Ptr,&RECT)
Win_Client_X := NumGet(&RECT, 0, "Int")
Win_Client_Y := NumGet(&RECT, 4, "Int")

6::
	Loop {
		MouseMove, Win_Client_X+1095, Win_Client_Y+55, 0
		Click
		Sleep 2000
		MouseMove, Win_Client_X+590, Win_Client_Y+380, 0
		Click
		Sleep 2000
		Send {Right}
		Sleep 2000
		MouseMove, Win_Client_X+865, Win_Client_Y+775, 0
		Sleep 500

		Loop 9 {
			Click, down
			Sleep 3000
			Click, up
			Sleep 1500
		}

		Send {N}
		Sleep 1000
		MouseMove, Win_Client_X+520, Win_Client_Y+385, 0
		Sleep 1000
		MouseMove, Win_Client_X+410, Win_Client_Y+380, 3
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