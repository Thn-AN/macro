#SingleInstance Force

IfWinExist, ahk_exe destiny2.exe
{
    WinClose, ahk_exe destiny2.exe
    Sleep, 5000
}

MsgBox, 3, D2 Launcher, ****Welcome to Destiny 2 Launcher****`n`nDo you want to enable farming mode?`n`n**Yes** will delete your existing cvar files and replace them with farm.xml.`n**No** will delete your existing cvar files and replace them with game.xml.`n**Cancel** will launch the game without modifying any cvar files.
IfMsgBox, Yes
{
    FileDelete, % A_AppData "\Bungie\DestinyPC\prefs\cvars.xml"
    FileDelete, % A_AppData "\Bungie\DestinyPC\prefs\cvars.old"
    FileCopy, % A_AppData "\Bungie\DestinyPC\prefs\farm.xml", % A_AppData "\Bungie\DestinyPC\prefs\cvars.xml"
    FileCopy, % A_AppData "\Bungie\DestinyPC\prefs\farm.xml", % A_AppData "\Bungie\DestinyPC\prefs\cvars.old"
}
IfMsgBox, No
{
    FileDelete, % A_AppData "\Bungie\DestinyPC\prefs\cvars.xml"
    FileDelete, % A_AppData "\Bungie\DestinyPC\prefs\cvars.old"
    FileCopy, % A_AppData "\Bungie\DestinyPC\prefs\game.xml", % A_AppData "\Bungie\DestinyPC\prefs\cvars.xml"
    FileCopy, % A_AppData "\Bungie\DestinyPC\prefs\game.xml", % A_AppData "\Bungie\DestinyPC\prefs\cvars.old"
}

IfWinNotExist, Destiny 2
    Run steam://rungameid/1085660

exitapp
Return