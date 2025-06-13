; <3 from antra! https://discord.gg/KGyjysA5WY
#noenv ; improves performance by maybe like 0.01% by not loading environment variables
#singleinstance force ; only allow one of this script to be open at once
#persistent ; run the script until an exitapp is encountered
#ifwinactive ahk_exe destiny2.exe ; only have hotkeys work if d2 is active
setbatchlines, -1 ; never automatically sleep, not really necessary here but who cares
setworkingdir %a_scriptdir% ; read files from the scripts directory
; <3 from antra! https://discord.gg/KGyjysA5WY

;set status as 0 e.g. not started for the overlay
status = 0

;used for absolute mouse coords
sysx := 65535//a_screenwidth
sysy := 65535//a_screenheight


F4::
    Click
    dllcall("mouse_event", "uint", 0x8001, "uint", 750*sysx, "uint", 320*sysy)
    Click
    Sleep 25
    Click
    Send {d}
    Sleep 125
    Click
Return

F5::Reload