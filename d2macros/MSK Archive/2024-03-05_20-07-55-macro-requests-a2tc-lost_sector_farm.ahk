#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

F3::
{
    Send, {e Down}
    Sleep, 2000
    Send, {e Up}
    Sleep, 1000
    Click, % A_ScreenWidth*0.84805 " " A_ScreenHeight*0.77014 " " 0
    Sleep, 100
    Click, % A_ScreenWidth*0.84805 " " A_ScreenHeight*0.77014
    Sleep, 1500
    Click, % A_ScreenWidth*0.17031 " " A_ScreenHeight*0.32153 " " 0
    Sleep, 100
    Click, % A_ScreenWidth*0.17031 " " A_ScreenHeight*0.32153
    Sleep, 1500
    Click, % A_ScreenWidth*0.84336 " " A_ScreenHeight*0.83333 " " 0
    Sleep, 100
    Click, % A_ScreenWidth*0.84336 " " A_ScreenHeight*0.83333
    Sleep, 3000
    Send, {e Down}
    Sleep, 12000
    Send, {e Up}
    Send, {tab}
    Sleep, 1000
    Send, {y Down}
    Sleep, 3200
    Send, {y Up}
    Sleep, 1000
    return
}

F4::reload