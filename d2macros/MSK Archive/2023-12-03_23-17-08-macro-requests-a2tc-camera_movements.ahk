#Persistent
#SingleInstance, force
SetTimer, CheckKeys, 10 ; Check every 10ms

; Initialize counters for each key
Numpad4Count := 0
Numpad6Count := 0
Numpad8Count := 0
Numpad2Count := 0
return

CheckKeys:
    ; Check Numpad4 state
    if GetKeyState("Numpad4", "P") {
        Numpad4Count += 0.2
        DllCall("mouse_event", uint, 1, int, -5 - Floor(Numpad4Count), int, 0, uint, 0, int, 0)
    } else {
        Numpad4Count := 0
    }

    ; Check Numpad6 state
    if GetKeyState("Numpad6", "P") {
        Numpad6Count += 0.2
        DllCall("mouse_event", uint, 1, int, 5 + Floor(Numpad6Count), int, 0, uint, 0, int, 0)
    } else {
        Numpad6Count := 0
    }

    ; Check Numpad8 state
    if GetKeyState("Numpad8", "P") {
        Numpad8Count += 0.2
        DllCall("mouse_event", uint, 1, int, 0, int, -5 - Floor(Numpad8Count), uint, 0, int, 0)
    } else {
        Numpad8Count := 0
    }

    ; Check Numpad2 state
    if GetKeyState("Numpad2", "P") {
        Numpad2Count += 0.2
        DllCall("mouse_event", uint, 1, int, 0, int, 5 + Floor(Numpad2Count), uint, 0, int, 0)
    } else {
        Numpad2Count := 0
    }
return

F4::reload
