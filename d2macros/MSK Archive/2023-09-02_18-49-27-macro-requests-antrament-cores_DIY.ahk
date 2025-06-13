
6::
	Loop {
		MouseMove, NUM_1, NUM_2, 0 ; replace with the two numbers you get when you hover over "collections"
		Click
		Sleep 2000
		MouseMove, NUM_1, NUM_2, 0 ; replace with the two numbers you get when you hover over "weapons"
		Click
		Sleep 2000
		Send {Right}
		Sleep 2000
		MouseMove, NUM_1, NUM_2, 0 ; replace with the two numbers you get when you hover over whatever the fuck the gun is called
		Sleep 500

		Loop 9 {
			Click, down
			Sleep 3000
			Click, up
			Sleep 1500
		}

		Send {F1}
		Sleep 1000
		Send {F1}
		Sleep 1000
		MouseMove, NUM_1, NUM_2, 0 ; replace with the two numbers you get when you hover over the weapon slot you want to dismantle
		Sleep 1000
		MouseMove, NUM_1, NUM_2, 3 ; replace with whatever two numbers you get when you hover over the first item to be dismantled 
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