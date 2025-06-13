#SingleInstance, Force
SendMode Input
SetWorkingDir, %A_ScriptDir%

 MsgBox, `n ######## Option 2 is the best choice ######## `n `n INSERT = to Dismantle blues in possession: be on the "Character" screen `n HOME = to Buy & dismantle blues: be on the "Collections" screen`n [ = Reload script `n ] = Exit/quit script

Insert::
{
    delete_blues(36)
}
Return

Home::
{
    InputBox, num_blues , How Many Blues, How many blues do you want to buy and dismantle (1-36) `n `n - Be sure to start the script on the "Collections" menu `n - Reload the script if not ready (Press "[" to reload)
    WinActivate, Destiny 2
    Sleep, 200
    if (num_blues > 36)
        num_blues := 36
    Send, #
    Sleep, 800
    Click, % A_ScreenWidth*0.46836 " " A_ScreenHeight*0.34583 " " 0 
    Sleep, 500
    Click, % A_ScreenWidth*0.46836 " " A_ScreenHeight*0.34583

    Sleep, 500
    Click, % A_ScreenWidth*0.11680 " " A_ScreenHeight*0.77083 " " 0
    Sleep, 700
    Click, % A_ScreenWidth*0.11680 " " A_ScreenHeight*0.77083
    Sleep, 300
    Send, {Right}
    Sleep, 400
    buy_blues(num_blues)
    Sleep, 100
    Send, i
    Sleep, 2100
    delete_blues(num_blues)
}
Return 

buy_blues(num_blues)
{
    difference := 0.43-0.377
    x_value := 0.377
    y_value := 0.25
    Loop, % num_blues
    {
        Click, % A_ScreenWidth*(x_value+(difference*Floor((A_Index-1)/9))) " " A_ScreenHeight*y_value " " 0 
        Sleep, 100
        Send, {LButton Down}
        Sleep, 3100
        ; Sleep, 1000
        Send, {LButton Up}
        Sleep, 150
    }
    Return
}

delete_blues(num_blues)
{
    difference := 0.71-0.595
    x_value_1 := 0.725
    x_value_2 := 0.785
    y_value := 0.25
    current_armor_piece := -1
    Loop, % num_blues
    {
        if (Floor((A_Index-1)/9) > current_armor_piece)
        {
            current_armor_piece := Floor((A_Index-1)/9)
            Click, % A_ScreenWidth*x_value_1 " " A_ScreenHeight*(y_value+(difference*Floor((A_Index-1)/9))) " " 0
            Sleep, 200
        }
        Click, % A_ScreenWidth*x_value_2 " " A_ScreenHeight*(y_value+(difference*Floor((A_Index-1)/9))) " " 0
        Sleep, 700
        upgrade_blue()
        Sleep, 500
        Click, % A_ScreenWidth*x_value_1 " " A_ScreenHeight*(y_value+(difference*Floor((A_Index-1)/9))) " " 0
        Sleep, 200
        Click, % A_ScreenWidth*x_value_2 " " A_ScreenHeight*(y_value+(difference*Floor((A_Index-1)/9))) " " 0
        Sleep, 700
        Send, {f Down}
        Sleep, 1100
        Send, {f Up}
        Sleep, 400
    }
    Return
}

upgrade_blue() 
{
    Send, {RButton}
    Sleep, 1000
    Click, % A_ScreenWidth*0.20938 " " A_ScreenHeight*0.36389 " " 0 
    Sleep, 500
    Loop, 3
    {
        Send, {LButton Down}
        Sleep, 1500
        Send, {LButton Up}
        Sleep, 250
    }
    Send, {Esc}
    Return
}

[::Reload
]::ExitApp