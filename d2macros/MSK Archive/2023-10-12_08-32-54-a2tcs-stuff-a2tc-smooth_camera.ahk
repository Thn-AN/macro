#SingleInstance Force
#NoEnv
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

global spinning := 0
global stropSpinning := 0
global speed := 0
global direction := 1

Gui Font, Bold
Gui Font, s12, Segoe UI
Gui Add, Text, x8 y0 w220 h20 +0x200, Spin Direction

Gui Font, s9, Segoe UI
Gui Add, Radio, x8 y24 w54 h26 vMdirectionLeft Checked, Left
Gui Add, Radio, x64 y24 w66 h26 vMdirectionRight, Right

Gui Font, Bold
Gui Font, s12, Segoe UI
Gui Add, Text, x8 y50 w220 h20 +0x200, Spin Speed

Gui Font, s9, Segoe UI
Gui Add, Edit, x8 y74 w80 h26 vMspeed Number, 20

Gui Add, Button, x130 y40 w121 h44 gstart_button, Start :)

Gui Show, w270 h110, Camera Movements

loop,
{
    if spinning
    {
        if (direction == 1)
        {
            while (spinning)
            {
                DllCall("mouse_event",uint,1,int,-speed,int,0,uint,0,int,0)
                Sleep, 10
                DllCall("mouse_event",uint,1,int,-speed,int,0,uint,0,int,0)
                Sleep, 10
                IfWinNotActive, Destiny 2
                {
                    spinning := 0
                    break 
                }
                if (stopSpinning)
                {
                    spinning := 0
                    stopSpinning := 0
                    break 
                }
            }
        }
        else if (direction == 2)
        {
            while (spinning)
            {
                DllCall("mouse_event",uint,1,int,speed,int,0,uint,0,int,0)
                Sleep, 10
                DllCall("mouse_event",uint,1,int,speed,int,0,uint,0,int,0)
                Sleep, 10
                IfWinNotActive, Destiny 2
                {
                    spinning := 0
                    break 
                }
                if (stopSpinning)
                {
                    spinning := 0
                    stopSpinning := 0
                    break 
                }
            }
        }
        else
        {
            spinning := 0
        }
    }
    else 
        sleep 50
}

Return

MButton::
{
    if spinning
    {  
        stopSpinning := 1
        spinning := 0
    }
    else 
    {
        spinning := 1
        stopSpinning := 0
        Gui, Submit, NoHide
        OutputText := "Selected Options:"
        if MdirectionLeft
            Mdirection := 1
        else if MdirectionRight
            Mdirection := 2
        OutputText .= "`n`nMovement Speed: " . Mspeed . "`nMovement Direction: " . Mdirection
        speed := Mspeed
        direction := Mdirection
    }
}
Return

start_button:
{
    spinning := 1
    stopSpinning := 0
    Gui, Submit, NoHide
    OutputText := "Selected Options:"
    if MdirectionLeft
        Mdirection := 1
    else if MdirectionRight
        Mdirection := 2
    OutputText .= "`n`nMovement Speed: " . Mspeed . "`nMovement Direction: " . Mdirection
    ; MsgBox, % OutputText
    speed := Mspeed
    direction := Mdirection
    WinActivate, Destiny 2
    Sleep, 200
    WinWaitActive, Destiny 2
}
Return

startSpin:
    moveCamera()
Return

moveCamera()
{
    if (direction == 1)
    {
        while (spinning)
        {
            DllCall("mouse_event",uint,1,int,-speed,int,0,uint,0,int,0)
            Sleep, 10
            IfWinNotActive, Destiny 2
            {
                spinning := 0
                break 
            }
            if (stopSpinning)
            {
                spinning := 0
                stopSpinning := 0
                break 
            }
        }
    }
    else if (direction == 2)
    {
        while (spinning)
        {
            DllCall("mouse_event",uint,1,int,speed,int,0,uint,0,int,0)
            Sleep, 10
            IfWinNotActive, Destiny 2
            {
                spinning := 0
                break 
            }
            if (stopSpinning)
            {
                spinning := 0
                stopSpinning := 0
                break 
            }
        }
    }
    else
    {
        spinning := 0
    }
}

; uint,movement happens,
; int,distance to move horizontal,
; int,Distance to move vertical,
; uint,XButtons,
; int,Extra stuff

F4::Reload
