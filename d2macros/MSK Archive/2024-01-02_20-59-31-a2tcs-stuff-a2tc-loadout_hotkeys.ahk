SetMouseDelay, 0
SetKeyDelay, 0
#Include <Gdip_all>

keybinds := get_d2_keybinds(["ui_open_start_menu_alternative"])

if !keybinds
{
    MsgBox, Could not find the cvars.xml file
    ExitApp
}

for key, value in keybinds 
{
    if (value == "" || value == "unused") {
        MsgBox, % "The keybind for 'Character' is not set or is an unknown key."
        ExitApp
    }
}

global INVENTORY := keybinds["ui_open_start_menu_alternative"]

pToken := Gdip_Startup()

#IfWinActive, Destiny 2
~1::select_loadout(1)
~2::select_loadout(2)
~3::select_loadout(3)
~4::select_loadout(4)
~5::select_loadout(5)
~6::select_loadout(6)
~7::select_loadout(7)
~8::select_loadout(8)
~9::select_loadout(9)
~0::select_loadout(10) 
 
select_loadout(loadout_num)
{
    Send, {%INVENTORY%}
    sleep, 50
    SetTimer, time_out, 3000

    ; Define the region of interest
    difference := (0.09514-0.08264)/10
    x := A_ScreenWidth * 0.03945
    y1 := A_ScreenHeight * 0.08264
    region := x "|" y1 "|" x+1 "|" y1+10

    loop,
    {
        Send, {Left}
        loadouts_loaded := 0
        ; Take a screenshot of the region
        pScreen := Gdip_BitmapFromScreen(region)

        loop, 10
        {
            y := (difference * (A_Index - 1))
            color := (Gdip_GetPixel(pScreen, 0, y) & 0x00F0F0F0)
            if (((color & 0xf0f0f0) == 0xf0f0f0) || ((color & 0xf0f0f0) == 0xe0e0e0))
                loadouts_loaded += 1
        }
        if (loadouts_loaded >= 9)
        {
            SetTimer, time_out, Off
            break
        }
        Gdip_DisposeImage(pScreen)
    }

    if (Mod(loadout_num, 2) == 0)
        x := Round((A_ScreenWidth*0.125), 0)
    Else
        x := Round((A_ScreenWidth*0.075), 0)

    y := Round(A_ScreenHeight*(Ceil((loadout_num)/2)*0.09+0.355-0.09), 0)

    click, % x " " y " " 0
    Sleep, 60
    click, % x " " y
    click, % A_ScreenWidth/2 " " A_ScreenHeight/2 " " 0
    Sleep, 10
    Send, {%INVENTORY%}
    return
}

time_out:
F4::
Gdip_Shutdown(pToken)
Reload

^Esc::
Gdip_Shutdown(pToken)
ExitApp

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