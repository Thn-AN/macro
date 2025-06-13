#SingleInstance, Force
SendMode Input
SetKeyDelay, 0, 0
SetWorkingDir, %A_ScriptDir%

keybinds := get_d2_keybinds(["ui_open_start_menu_settings_tab"])

if !keybinds
{
    MsgBox, Could not find the cvars.xml file
    ExitApp
}

for key, value in keybinds 
{
    if (value == "" || value == "unused") {
        MsgBox, % "The keybind for '" key "' is not set or is an unknown key."
        ExitApp
    }
}

global SETTINGS := keybinds["ui_open_start_menu_settings_tab"]

^1::
    IfWinActive, Destiny 2
    {
        Send, {%SETTINGS%} 
        Sleep, 100
        Click, % A_ScreenWidth*0.18633 " " A_ScreenHeight*0.44861 " 0"
        Sleep, 800
        Click
        Sleep, 100
        Click, % A_ScreenWidth*0.77500 " " A_ScreenHeight*0.37778 " 0"
        Sleep, 600
        Click
        Sleep, 300
        Send, {enter}
        Sleep, 100
        Send, {Esc}
    }
Return

^F4::Reload

get_d2_keybinds(k) 
{
    FileRead, f, % A_AppData "\Bungie\DestinyPC\prefs\cvars.xml"
    if ErrorLevel 
        return False
    b := {}, t := {"shift": "LShift", "control": "LCtrl", "alt": "LAlt", "menu": "AppsKey", "insert": "Ins", "delete": "Del", "pageup": "PgUp", "pagedown": "PgDn", "keypad`/": "NumpadDiv", "keypad`*": "NumpadMult", "keypad`-": "NumpadSub", "keypad`+": "NumpadAdd", "keypadenter": "NumpadEnter", "leftmousebutton": "LButton", "middlemousebutton": "MButton", "rightmousebutton": "RButton", "extramousebutton1": "XButton1", "extramousebutton2": "XButton2", "mousewheelup": "WheelUp", "mousewheeldown": "WheelDown", "escape": "Esc"}
    for _, n in k 
        RegExMatch(f, "<cvar\s+name=""`" n `"""\s+value=""([^""]+)""", m) ? b[n] := t.HasKey(k2 := StrReplace((k1 := StrSplit(m1, "!")[1]) != "unused" ? k1 : k1[2], " ", "")) ? t[k2] : k2 : b[n] := "unused"
    return b
}