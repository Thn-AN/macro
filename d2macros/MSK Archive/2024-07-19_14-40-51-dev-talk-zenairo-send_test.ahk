#Requires AutoHotkey >=1.1.36 <1.2
#Persistent
#SingleInstance, Force
OnExit("on_script_exit")

OnMessage(0x1003, "on_chest_open")
OnMessage(0x1004, "on_exotic_drop")

DetectHiddenWindows, On
WinGet, MainPID, PID, %A_ScriptFullPath% - AutoHotkey v
; Start the child scripts
; MsgBox, %A_AhkPath%
Run, %A_AhkPath% "monitor_loot.ahk" %MainPID% "chest", , , CHEST_PID
Run, %A_AhkPath% "monitor_loot.ahk" %MainPID% "exotic", , , EXOTIC_PID

sleep 1000


Return

F3::
{
    loop,
    {
        ToolTip, Monitoring, -50, -50

        StartMonitoring(CHEST_PID)
        StartMonitoring(EXOTIC_PID)

        Sleep, 4000

        ToolTip, Stop Monitoring, -50, -50

        StopMonitoring(EXOTIC_PID)
        if (EXOTIC_DROP)
            PLAYER_DATA[CURRENT_GUARDIAN]["ClassStats"]["current_exotics"]++
        EXOTIC_DROP := false

        Sleep, 2000
    }
    Return
}

F5::
{
    ExitApp
    Return
}


on_script_exit()
{
    if (CHEST_PID)
        Process, Close, %CHEST_PID%
    if (EXOTIC_PID)
        Process, Close, %EXOTIC_PID%
}

StartMonitoring(target_pid) {
    PostMessage, 0x1001, 0, 0, , % "ahk_pid " target_pid
}

StopMonitoring(target_pid) {
    PostMessage, 0x1002, 0, 0, , % "ahk_pid " target_pid
}

on_chest_open(wParam, lParam, msg, hwnd) {
    CHEST_OPENED := true
}

on_exotic_drop(wParam, lParam, msg, hwnd) {
    EXOTIC_DROP := true
}

