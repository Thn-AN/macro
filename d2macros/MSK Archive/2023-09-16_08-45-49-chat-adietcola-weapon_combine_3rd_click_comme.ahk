; <3 from antra! https://discord.gg/KGyjysA5WY
#noenv ; improves performance by maybe like 0.01% by not loading environment variables
#singleinstance force ; only allow one of this script to be open at once
#persistent ; run the script until an exitapp is encountered
#ifwinactive ahk_exe destiny2.exe ; only have hotkeys work if d2 is active
setbatchlines, -1 ; never automatically sleep, not really necessary here but who cares
setworkingdir %a_scriptdir% ; read files from the scripts directory

sysx := 65535//a_screenwidth
sysy := 65535//a_screenheight

;---------------------------------------------------------------------------
SendMouse_LeftClick() { ; send fast left mouse clicks
    ;---------------------------------------------------------------------------
        DllCall("mouse_event", "UInt", 0x02) ; left button down
        DllCall("mouse_event", "UInt", 0x04) ; left button up
    }

W::
sleep 50
Click
sleep 50
dllcall("mouse_event", "uint", 0x8001, "uint", 500*sysx, "uint", 315*sysy) 
sleep 50
Click
sleep 50
dllcall("mouse_event", "uint", 0x8001, "uint", 300*sysx, "uint", 500*sysy)
sleep 45
Click
sleep 45
dllcall("mouse_event", "uint", 0x8001, "uint", 1100*sysx, "uint", 420*sysy)
sleep 45
Click
sleep 45
sleep 45
Click
sleep 45

Return


F5::Reload