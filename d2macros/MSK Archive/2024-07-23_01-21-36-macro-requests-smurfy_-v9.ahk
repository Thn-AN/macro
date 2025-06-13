#Persistent
#NoEnv
#SingleInstance Force
SendMode Input
SetWorkingDir %A_ScriptDir%
global activeScript := "lumina"
global isPaused := false
global CurrentConfig := 1
global Configs := ["Warlock", "Hunter"]

F4::
    ShowGui()
    return

; Create GUI
ShowGui() {
    Gui, Destroy
    Gui, Add, Text,, Select Configuration:
    if (isPaused) {
        Gui, Add, Button, gPauseMacro, Unpause Macro
    } else {
        Gui, Add, Button, gPauseMacro, Pause Macro
    }
    Gui, Add, Button, gActivateLumina, Lumina Grapple
    Gui, Add, Button, gActivateRocket, Rocket Grapple
    Gui, Add, Button, gConfigWarlock, Warlock
    Gui, Add, Button, gConfigHunter, Hunter
    Gui, Show, w240 h200, Grapple Macro Selector
}

ActivateLumina:
    Gui, Hide
    activeScript := "lumina"
    ActivateLuminaGrapple()
    return

ActivateRocket:
    Gui, Hide
    activeScript := "rocket"
    ActivateRocketGrapple()
    return

ConfigWarlock:
    Gui, Hide
    CurrentConfig := 1
    isPaused := false
    MsgBox % "Switched to Warlock config. Script resumed."
    return

ConfigHunter:
    Gui, Hide
    CurrentConfig := 2
    isPaused := false
    MsgBox % "Switched to Hunter config. Script resumed."
    return

PauseMacro:
    Gui, Hide
    TogglePauseMacro()
    return

ActivateLuminaGrapple() {
    global sens, Y, grenade, activate, isPaused

    if !FileExist("lumina_grapple.ini") {
        MsgBox, No lumina_grapple.ini found, please input your sensitivity now.

        InputBox, sens, Sensitivity, Input your ingame sensitivity (default: 6):,, 230, 150
        IniWrite, %sens%, lumina_grapple.ini, Variables, Sensitivity

        InputBox, grenade, Grenade, Input your grenade bind (default: G):,, 230, 150
        IniWrite, %grenade%, lumina_grapple.ini, Variables, Grenade

        InputBox, activate, Activate, Input your desired activation bind (default: /):,, 230, 150
        IniWrite, %activate%, lumina_grapple.ini, Variables, Activate

        Y := Round(150/sens)
    } else {
        IniRead, sens, lumina_grapple.ini, Variables, Sensitivity
        IniRead, grenade, lumina_grapple.ini, Variables, Grenade
        IniRead, activate, lumina_grapple.ini, Variables, Activate
        Y := Round(150/sens)
    }

    if (!isPaused) {
        MsgBox, Lumina Grapple activated. Press %activate% to grapple. Press F5 to change sensitivity. F6 to change activation bind.
        SetTimer, LuminaGrappleLoop, 10
    }
}

ActivateRocketGrapple() {
    global sens, Y, grenade, activate, isPaused

    if !FileExist("rocket_grapple.ini") {
        MsgBox, No rocket_grapple.ini found, please input your sensitivity now.

        InputBox, sens, Sensitivity, Input your ingame sensitivity (default: 6):,, 230, 150
        IniWrite, %sens%, rocket_grapple.ini, Variables, Sensitivity

        InputBox, grenade, Grenade, Input your grenade bind (default: G):,, 230, 150
        IniWrite, %grenade%, rocket_grapple.ini, Variables, Grenade

        InputBox, activate, Activate, Input your desired activation bind (default: /):,, 230, 150
        IniWrite, %activate%, rocket_grapple.ini, Variables, Activate

        Y := Round(15 * (15/sens))
    } else {
        IniRead, sens, rocket_grapple.ini, Variables, Sensitivity
        IniRead, grenade, rocket_grapple.ini, Variables, Grenade
        IniRead, activate, rocket_grapple.ini, Variables, Activate
        Y := Round(15 * (15/sens))
    }

    if (!isPaused) {
        MsgBox, Rocket Grapple activated. Press %activate% to grapple. Press F5 to change sensitivity. F6 to change activation bind.
        SetTimer, RocketGrappleLoop, 10
    }
}

TogglePauseMacro() {
    global isPaused
    isPaused := !isPaused
    if (isPaused) {
        DeactivateScript()
        MsgBox, Macros paused.
    } else {
        MsgBox, Macros resumed.
        if (activeScript = "lumina") {
            ActivateLuminaGrapple()
        } else {
            ActivateRocketGrapple()
        }
    }
    ShowGui()  ; Update the GUI to reflect the new state
}

DeactivateScript() {
    SetTimer, LuminaGrappleLoop, Off
    SetTimer, RocketGrappleLoop, Off
}

LuminaGrappleLoop:
if GetKeyState(activate) {
    KeyWait, %activate%
    SendInput {LButton}
    DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", Y)
    SendInput %grenade%
}
if GetKeyState("F5") {
    InputBox, sens, Sensitivity, Input your ingame sensitivity (current: %sens%):,, 230, 150
    IniWrite, %sens%, lumina_grapple.ini, Variables, Sensitivity
    Reload
    Return
}
if GetKeyState("F6") {
    InputBox, activate, Activate, Input your desired activation bind (current: %activate%):,, 230, 150
    IniWrite, %activate%, lumina_grapple.ini, Variables, Activate
    Reload
    Return
}
return

RocketGrappleLoop:
if GetKeyState(activate) {
    KeyWait, %activate%
    SendInput {LButton}
    DllCall("mouse_event", "UInt", 0x01, "UInt", 0, "UInt", Y)
    SendInput %grenade%
}
if GetKeyState("F5") {
    InputBox, sens, Sensitivity, Input your ingame sensitivity (current: %sens%):,, 230, 150
    IniWrite, %sens%, rocket_grapple.ini, Variables, Sensitivity
    Reload
    Return
}
if GetKeyState("F6") {
    InputBox, activate, Activate, Input your desired activation bind (current: %activate%):,, 230, 150
    IniWrite, %activate%, rocket_grapple.ini, Variables, Activate
    Reload
    Return
}
return

; Skate Configurations
SkateKeyBind = XButton1
FlatSkateKeyBind = MButton
SuperKeyBind = F
ShatterdiveKeyBind = X

Hotkey, *%SkateKeyBind%, Skate
Hotkey, *%FlatSkateKeyBind%, FlatSkate

Skate:
if (isPaused) {
    Return
}
Switch Configs[CurrentConfig] {
    Case "Warlock":
        Send {Click Right}
        Sleep 100
        Send {Space}
        Send {%SuperKeyBind%}
        Sleep 100
        Send {Space}
        Return
    Case "Hunter":
        Click, Right
        Sleep, 35
        Send {space}
        Sleep, 10
        Send {%ShatterdiveKeyBind%}
        Return
}
Return

FlatSkate:
if (isPaused) {
    Return
}
Switch Configs[CurrentConfig] {
    Case "Warlock":
        Send {space}
        Sleep 10
        Click, Left
        Sleep 10
        Send {space}
        Send {%SuperKeyBind%}
        Return
    Case "Hunter":
        Send {space}
        Sleep, 5
        Click, Left
        Sleep, 5
        Send {space}
        Sleep, 5
        Send {%ShatterdiveKeyBind%}
        Return
}
Return

SwapConfig:
if (isPaused) {
    Return
}
CurrentConfig := Mod(CurrentConfig, Configs.Length()) + 1
MsgBox % "Switching to " . Configs[CurrentConfig] . " config."
Return

GuiClose:
GuiVisible := false
Gui, Hide
Return

; Start with the Lumina Grapple activated
ActivateLuminaGrapple()



