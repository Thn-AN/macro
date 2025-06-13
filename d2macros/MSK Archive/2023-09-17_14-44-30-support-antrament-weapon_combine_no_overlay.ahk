; <3 from antra! https://discord.gg/KGyjysA5WY
#noenv ; improves performance by maybe like 0.01% by not loading environment variables
#singleinstance force ; only allow one of this script to be open at once
#persistent ; run the script until an exitapp is encountered
setbatchlines, -1 ; never automatically sleep, not really necessary here but who cares
setworkingdir %a_scriptdir% ; read files from the scripts directory
; <3 from antra! https://discord.gg/KGyjysA5WY


;set status as 0 e.g. not started for the overlay
status = 0

;used for absolute mouse coords
sysx := 65535//a_screenwidth
sysy := 65535//a_screenheight


;---------------------------------------------------------------------------
SendMouse_LeftClick() { ; send fast left mouse clicks
    ;---------------------------------------------------------------------------
        DllCall("mouse_event", "UInt", 0x02) ; left button down
        DllCall("mouse_event", "UInt", 0x04) ; left button up
        DllCall("mouse_event", "UInt", 0x04) ; left button up
    }

F3::
Loop 4 {
    status := A_Index
    KeyWait %A_Index%, D
    MouseGetPos xpos%A_Index%, ypos%A_Index%
}
status = 5
Loop {
    KeyWait, F4, D
    Loop 4 {
        xposVar := xpos%A_Index% * sysx
        yposVar := ypos%A_Index% * sysy
        dllcall("mouse_event", "uint", 0x8001, "uint", xposVar, "uint", yposVar)
        sleep 50
		SendMouse_LeftClick()
		sleep 50
    }
    sleep 50
    Click
    sleep 50
    Click
}
Return

F5::Reload

F8::Exitapp
