#noenv
#persistent
CoordMode, Mouse, Screen

; Set the multipliers for different aspect ratios
multipliers_16_9 := {X: 0.84583, Y: 0.83704}  ; these should be universal for all 16:9 screens
multipliers_21_9 := {X: 00000, Y: 00000}    ; placeholder values, needs adjustments 

; function to get teh aspect ratio
GetAspectRatio() {
    ScreenWidth := A_ScreenWidth
    ScreenHeight := A_ScreenHeight
    ratio := Round(ScreenWidth / ScreenHeight, 2)
    return ratio
}

; click Launch button based on auto-finding the region
ClickLaunch() {
    global multipliers_16_9, multipliers_21_9

    ratio := GetAspectRatio()
    if (ratio = 1.78) {  ; 16:9 aspect ratio
        ClickX := A_ScreenWidth * multipliers_16_9.X
        ClickY := A_ScreenHeight * multipliers_16_9.Y
    } else if (ratio = 2.33) {  ; 21:9 aspect ratio
        ClickX := A_ScreenWidth * multipliers_21_9.X
        ClickY := A_ScreenHeight * multipliers_21_9.Y
    } else {
        MsgBox, Aspect ratio not supported
        return
    }
    Click, %ClickX%, %ClickY%
}

; press and hold the orbit key, "O" in this case
HoldOrbit() {
    Send, {O down}
    Sleep, 6000
    Send, {O up}
}

; Main loop 
MainLoop() {
    global running
    while (running) {
        ClickLaunch()
        Sleep, 2000 ; 
        HoldOrbit()
        Sleep, 100 ; 
    }
}

; Hotkey to start the macro
+4::
running := true
SetTimer, MainLoop, 0
return

; Hotkey to stop the macro
+5::
running := false
SetTimer, MainLoop, Off
Reload
return

; Start the script
running := false
return