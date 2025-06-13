#Persistent

; Define the coordinates
Coordinate1 := {x: 1820, y: 615}
Coordinate2 := {x: 1140, y: 465}
Coordinate3 := {x: 515, y: 385}
Coordinate4 := {x: 415, y: 385}
Coordinate6 := {x: 1205, y: 170}
Coordinate7 := {x: 240, y: 430}

; Initialize toggle variable and loop counter
toggle := false
loopCounter := 8

; Hotkey to start or stop the loop
X::
    toggle := !toggle ; Toggle the state
    if (toggle) {
        SetTimer, LoopRoutine, 10
    } else {
        SetTimer, LoopRoutine, Off
    }
return

LoopRoutine:
    ; Increment the loop counter
    loopCounter++
    
    Sleep, 3000

    ; Go to Coordinate1, wait 1 second, then click
    MouseMove, % Coordinate1.x, % Coordinate1.y
    Sleep, 1000
    Click

    ; Go to Coordinate2, wait 1 second, then click 9 times
    MouseMove, % Coordinate2.x, % Coordinate2.y
    Sleep, 1000
    Loop, 9 {
        Click
        Sleep, 1000 ; Small delay between clicks
    }

    ; Press I
    Send, i

    ; Go to Coordinate3, wait 1 second
    MouseMove, % Coordinate3.x, % Coordinate3.y
    Sleep, 1000

    ; Go to Coordinate4
    MouseMove, % Coordinate4.x, % Coordinate4.y

    ; Hold F for 1.1 second, 9 times
    Loop, 9 {
        Send, {f down}
        Sleep, 1100
        Send, {f up}
        Sleep, 1000 ; Small delay between key presses
    }

    ; Press escape
    Send, {Esc}

    ; Check if 8 loops have been completed
    if (loopCounter >= 8) {
        ; Reset the loop counter
        loopCounter := 0

        Sleep, 1000

        ; Press escape
        Send, {Esc}

        ; Hold W for 3.75 seconds
        Send, {s down}
        Sleep, 5500
        Send, {s up}

        ; Hold W for 3.75 seconds
        Send, {d down}
        Sleep, 1800
        Send, {d up}

        ; Wait 1 second
        Sleep, 1000

        ; Hold E for 1.1 second
        Send, {e down}
        Sleep, 1100
        Send, {e up}

        ; Wait 1 second then press escape
        Sleep, 1000
        Send, {Esc}

        ; Wait another second
        Sleep, 1000

        ; Move to Coordinate6 and wait 1 second
        MouseMove, % Coordinate6.x, % Coordinate6.y
        Sleep, 1000

        ; Right click
        Click, right

        ; Wait 1 second
        Sleep, 1000

        ; Move to Coordinate7 and click it 50 times with 0.5 second sleep between clicks
        MouseMove, % Coordinate7.x, % Coordinate7.y
        Loop, 50 {
            Click
            Sleep, 750
        }

        ; Wait 1 second and press escape, wait another second, then press escape again
        Sleep, 1000
        Send, {Esc}
        Sleep, 1000
        Send, {Esc}

        Sleep, 1000

        ; Hold W for 3.75 seconds
        Send, {a down}
        Sleep, 1800
        Send, {a up}

        ; Hold W for 3.75 seconds
        Send, {w down}
        Sleep, 5500
        Send, {w up}

        ; Wait 1 second
        Sleep, 1000

        ; Hold E for 1.1 second
        Send, {e down}
        Sleep, 1100
        Send, {e up}
    }
return
