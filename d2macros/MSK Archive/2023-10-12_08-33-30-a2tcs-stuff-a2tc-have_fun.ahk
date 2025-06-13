#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

Gui Font, Bold
Gui Font, s12, Segoe UI
Gui Add, Text, x8 y0 w220 h20 +0x200, Movement Speed

Gui Font, s9, Segoe UI
Gui Add, Radio, x8 y24 w54 h26 vMspeedLow Checked, Low
Gui Add, Radio, x64 y24 w66 h26 vMspeedMedium, Medium
Gui Add, Radio, x136 y24 w54 h26 vMspeedHigh, High
Gui Add, Radio, x192 y24 w66 h26 vMspeedRandom, Random

Gui Font, Bold
Gui Font, s12, Segoe UI
Gui Add, Text, x8 y112 w220 h20 +0x200, Movement Direction
Gui Font, s9, Segoe UI
Gui Add, Radio, x8 y80 w54 h26 vMdurationLow Checked, Low
Gui Add, Radio, x64 y80 w66 h26 vMdurationMedium, Medium
Gui Add, Radio, x136 y80 w54 h26 vMdurationHigh, High
Gui Add, Radio, x192 y80 w66 h26 vMdurationRandom, Random

Gui Font, Bold
Gui Font, s12, Segoe UI
Gui Add, Text, x8 y56 w220 h20 +0x200, Movement Duration
Gui Font, s9, Segoe UI
Gui Add, Radio, x8 y136 w63 h26 vMdirectionRandom Checked, Random
Gui Add, Radio, x72 y136 w55 h26 vMdirectionSquare, Square
Gui Add, Radio, x128 y136 w132 h26 vMdirectionUpDownLeftRight, Up-Down-Left-Right

Gui Add, Button, x72 y168 w121 h44 gstart_button, Start :)



Gui Show, w265 h217, Camera Movements
Return

start_button:
{
    Gui, Submit, NoHide
    OutputText := "Selected Options:"
    
    if MspeedLow
        Mspeed := 1
    else if MspeedMedium
        Mspeed := 2
    else if MspeedHigh
        Mspeed := 3
    else if MspeedRandom
        Mspeed := 4
    
    if MdurationLow
        Mduration := 1
    else if MdurationMedium
        Mduration := 2
    else if MdurationHigh
        Mduration := 3
    else if MdurationRandom
        Mduration := 4
    
    if MdirectionRandom
        Mdirection := 1
    else if MdirectionSquare
        Mdirection := 2
    else if MdirectionUpDownLeftRight
        Mdirection := 3
    
    OutputText .= "`n`nMovement Speed: " . Mspeed . "`nMovement Duration: " . Mduration . "`nMovement Direction: " . Mdirection
    ; MsgBox, % OutputText
    WinActivate, Destiny 2
    Sleep, 200
    WinWaitActive, Destiny 2
    moveCamera(Mspeed, Mduration, Mdirection)
}

moveCamera(speed, duration, direction)
{
    movement_speeds := [10, 100, 250]
    movement_durations := [3, 10, 100]
    ; 1 = left, 2 = down, 3 = right, 4 = up
    movement_directions := [[], [1, 2, 3, 4], [4, 2, 1, 3]]
    loop,
    {
        if (speed == 4)
            movement_speed := randomNum(25, 250)
        else
            movement_speed := movement_speeds[speed]

        if (duration == 4)
            movement_duration := randomNum(5, 65)
        else
            movement_duration := movement_durations[duration]

        if (direction == 1)
            movement_direction := randomNum(1, 4)
        else
            movement_direction := movement_directions[direction][((Mod(A_Index, 4))+1)]

        ; MsgBox, % movement_speed " | " movement_duration " | " movement_direction
        if (movement_direction == 1)
        {
            loop, %movement_duration%
            {
                DllCall("mouse_event",uint,1,int,-movement_speed,int,0,uint,0,int,0)
                Sleep, 10
                IfWinNotActive, Destiny 2
                    Break 2
            }
        }
        else if (movement_direction == 2)
        {
            loop, %movement_duration%
            {
                DllCall("mouse_event",uint,1,int,0,int,movement_speed,uint,0,int,0)
                Sleep, 10
                IfWinNotActive, Destiny 2
                    Break 2
            }
        }
        else if (movement_direction == 3)
        {
            loop, %movement_duration%
            {
                DllCall("mouse_event",uint,1,int,movement_speed,int,0,uint,0,int,0)
                Sleep, 10
                IfWinNotActive, Destiny 2
                    Break 2
            }
        }
        else if (movement_direction == 4)
        {
            loop, %movement_duration%
            {
                DllCall("mouse_event",uint,1,int,0,int,-movement_speed,uint,0,int,0)
                Sleep, 10
                IfWinNotActive, Destiny 2
                    Break 2
            }
        }
        else 
            MsgBox, huh
    }
}

randomNum(min, max)
{
    Random, returnVar, min, max
    return returnVar
}

; uint,movement happens,
; int,distance to move horizontal,
; int,Distance to move vertical,
; uint,XButtons,
; int,Extra stuff

F4::Reload