#SingleInstance, Force
CoordMode, Mouse
CoordMode, Pixel

global CoordsActivate := 1

Gui, Color, 0x010101
Gui, +E0x20 -caption +AlwaysOnTop +ToolWindow
Gui, Font, q3 s30 cWhite Bold, Segue
Gui, Add, Text, x8 y8 w300 h50 +0x200 vposition +Center

Gui, Show , x20 y20 NoActivate,Position
WinSet, Transparent, 255, Position
WinSet, TransColor, 010101, Position

SetTimer, doStuff, 25

return

doStuff:
    MouseGetPos, VarX, VarY
    GuiControl,, position, X%VarX% Y%VarY%
Return

^+1::
    MouseGetPos, VarX, VarY
    ClipBoard := % "x: " VarX " y: " VarY
Return

^+2::
    MouseGetPos, VarX, VarY
    temp1 := Round((VarX/A_ScreenWidth), 5)
    temp2 := Round((VarY/A_ScreenHeight), 5)
    xVar = A_ScreenWidth*%temp1%
    yVar = A_ScreenHeight*%temp2%
    ClipBoard := % "x: " xVar " y: " yVar
Return

^+3::
    if (CoordsActivate == 1)
    {
        Gui, Hide
        CoordsActivate := 0
        SetTimer, doStuff, Off
    }
    Else
    {
        Gui, Show
       CoordsActivate := 1
        SetTimer, doStuff, 25
    }
Return
