;README - Sparrowfly in Destiny 2 for AutoHotkey v1.3.33.10 - https://www.autohotkey.com/
;AHK seems to be very unreliable with delay.
;DllCall("Sleep", "UInt", 50) fixes this somewhat but these sleep-delays also vary a little bit. Also for some reason the script can sometimes trigger with up to 1sec delay.
;Ive spent hours, trying different things but only the Logitech-Macro is 100% reliable. If you find a solution, please let me know.
;Also you may need to adjust some of the delays below, depending on input lag and computer performance.

;Trigger-Key (see AutoHotkey Documentation for more)
;+1:: ; shift-1
;^+R:: ; strg-shift-r
Mbutton:: ; middlemouse-button

;Call Sparrow with script(unreliable)
;Send {Tab}
;Send {E}
;Send {E}
;Send {E}
;DllCall("Sleep", "UInt", 50) ;
;Send {E}


;Turn Sparrow 90°
Send {Shift down}
Send {D down}
DllCall("Sleep", "UInt", 350) ;
Send {D up}
Send {Shift up}

;Dodge up 1
Send {A down}
Send {A up}
DllCall("Sleep", "UInt", 5) ;
Send {A down}
Send {A up}

;Turn Sparrow 180°
Send {D down}
DllCall("Sleep", "UInt", 500) ;
Send {D up}

;Dodge up 2
Send {D down}
Send {D up}
DllCall("Sleep", "UInt", 5) ;
Send {D down}
Send {D up}

;Turn Sparrow 180°
Send {D down}
DllCall("Sleep", "UInt", 750) ;
Send {D up}

;Dodge up 3
Send {A down}
Send {A up}
DllCall("Sleep", "UInt", 5) ;
Send {A down}
Send {A up}

;Turn Sparrow 180°
Send {D down}
DllCall("Sleep", "UInt", 750) ;
Send {D up}

;Dodge up 4
Send {D down}
Send {D up}
DllCall("Sleep", "UInt", 5) ;
Send {D down}
Send {D up}

;Turn Sparrow 180°
Send {D down}
DllCall("Sleep", "UInt", 800) ;
Send {D up}

;Dodge up 5
Send {A down}
Send {A up}
DllCall("Sleep", "UInt", 5) ;
Send {A down}
Send {A up}

;Turn Sparrow 180°
Send {D down}
DllCall("Sleep", "UInt", 1000) ;
Send {D up}

;Dodge D 6
Send {D down}
Send {D up}
DllCall("Sleep", "UInt", 5) ;
Send {D down}
Send {D up}
Return
