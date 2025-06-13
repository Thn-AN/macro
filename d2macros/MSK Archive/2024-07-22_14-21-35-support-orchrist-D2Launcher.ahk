#SingleInstance Force
command = %1%

IfWinExist, ahk_exe destiny2.exe
{
    WinClose, ahk_exe destiny2.exe
    Sleep, 5000
}

if(command == "game" || command == "ghunter" || command == "gwarlock" || command == "gtitan"){
    FileDelete, % A_AppData "\Bungie\DestinyPC\prefs\cvars.xml"
    FileDelete, % A_AppData "\Bungie\DestinyPC\prefs\cvars.old"
    FileCopy, % A_AppData "\Bungie\DestinyPC\prefs\game.xml", % A_AppData "\Bungie\DestinyPC\prefs\cvars.xml"
    FileCopy, % A_AppData "\Bungie\DestinyPC\prefs\game.xml", % A_AppData "\Bungie\DestinyPC\prefs\cvars.old"
}
else {
    FileDelete, % A_AppData "\Bungie\DestinyPC\prefs\cvars.xml"
    FileDelete, % A_AppData "\Bungie\DestinyPC\prefs\cvars.old"
    FileCopy, % A_AppData "\Bungie\DestinyPC\prefs\farm.xml", % A_AppData "\Bungie\DestinyPC\prefs\cvars.xml"
    FileCopy, % A_AppData "\Bungie\DestinyPC\prefs\farm.xml", % A_AppData "\Bungie\DestinyPC\prefs\cvars.old"
}

IfWinNotExist, Destiny 2
    Run steam://rungameid/1085660

Winwait, Destiny 2
WinGet, hWnd, ID, ahk_exe destiny2.exe
if !hWnd {
    MsgBox, Error: Could not find the Destiny 2 window.
    return
}

run, "C:\Scripts\Personal\Auto Hotkey\Destiny\Destiny_Shortcuts.ahk"

WinGetPos, d2x, d2y, d2width, d2height, ahk_id %hWnd%
xref := d2x + (d2width / 2)
yref := d2y + (d2height / 2)

WinActivate, Destiny 2
CoordMode, Client
CoordMode, pixel, screen

loop,
{
    DllCall("SetCursorPos", "int", xref, "int", yref)
    PixelGetColor, color, xref, yref, Alt
    if(color == 0xFFFFFF){
        Click
        break
    }
}
yref := d2y + (d2height * .8)
loop,
{
    DllCall("SetCursorPos", "int", xref, "int", yref)
    PixelGetColor, color, xref, yref, Alt
    if(color == 0xC6C5C4 || color == 0xC5C5C4 || color == 0x5D5551 || color == 0xD1D0D0 || color == 0xB9B6B5){
        xref := d2x + (d2width * .7)
        if(command == "hunter" || command == "ghunter"){
            yref := d2y + (d2height * .45)
        }
        if(command == "warlock" || command == "gwarlock"){
            yref := d2y + (d2height * .55)
        }
        if(command == "titan" || command == "gtitan"){
            yref := d2y + (d2height * .65)
        }
        else {
            yref := d2y + (d2height * .55)
        }
        DllCall("SetCursorPos", "int", xref, "int", yref)
        sleep, 200
        Click
        exitapp
    }
}
exitapp
Return

F7::exitapp