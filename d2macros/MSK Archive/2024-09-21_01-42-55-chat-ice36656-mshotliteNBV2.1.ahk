#NoEnv
#SingleInstance Force
#KeyHistory 0
#MaxThreadsPerHotkey 1
global pause_shot_hotkey 
SetBatchLines -1
ListLines Off
checkForIni()
return
checkForIni(){
if fileExist("Multishot_Settings.ini"){
settingsRead()
} else {
settingsGUI()
}
}
settingsGUI(){
global multiplayer_Multishot_Hotkey
global singleplayer_Multishot_Hotkey
global pause_shot_hotkey
if fileExist("Multishot_Settings.ini"){
settingsRead()
}
Gui, Font, s11 q5 cc2c5c9, Whitney
Gui, Color, 2f2133
Gui, Add, Button, x100 y260 w200 h25 +Default, Save
Gui Add, Text, x10 y30 w200 h25 +0x200, multiplayer Multishot Hotkey(27k):
Gui Add, Hotkey, x250 y30 w200 h25 vmultiplayer_Multishot_Hotkey, %multiplayer_Multishot_Hotkey%
Gui Add, Text, x10 y55 w250 h25 +0x200, singleplayer Multishot Hotkey(3074):
Gui Add, Hotkey, x250 y55 w200 h25 vsingleplayer_Multishot_Hotkey, %singleplayer_Multishot_Hotkey%
Gui Add, Text, x10 y80 w350 h25 +0x200, make your hotkey for 27k(in/download) ctrl+shift+end
Gui Add, Text, x10 y105 w350 h25 +0x200, make your hotkey for 3074k(in/download) ctrl+shift+home
Gui Add, Text, x10 y150 w250 h25 +0x200, pause shot hotkey(no limiter needed):
Gui Add, Text, x10 y175 w400 h25 +0x200, PAUSE SHOT WILL STUTTER YOUR GAME 
Gui Add, Text, x10 y195 w400 h25 +0x200, DO NOT PRESS ANYTHING DURING PAUSE SHOT
Gui Add, Hotkey, x250 y150 w200 h25 vpause_shot_hotkey, %pause_shot_hotkey%
Gui Add, Text, x10 y220 w350 h35 +0x200,  USE NETBALANCER FOR 1-2S MULTISHOT INTERVALS! 
Gui Add, Text, x10 y0 w200 h25 +0x200, Rechange Hotkeys: F9   |
Gui Add, Text, x170 y0 w150 h25 +0x200, Exit App: F8
Gui, Show, w400, Settings
}
settingsWrite(){
global multiplayer_Multishot_Hotkey
global singleplayer_Multishot_Hotkey
global pause_shot_hotkey 
IniWrite, %multiplayer_Multishot_Hotkey%, Multishot_Settings.ini, Script settings, multiplayer_Multishot_Hotkey
IniWrite, %singleplayer_Multishot_Hotkey%, Multishot_Settings.ini, Script settings, singleplayer_Multishot_Hotkey
IniWrite, %pause_shot_hotkey%, Multishot_Settings.ini, Script settings, pause_shot_hotkey
}
settingsRead(){
global multiplayer_Multishot_Hotkey
global singleplayer_Multishot_Hotkey
global pause_shot_hotkey
IniRead, multiplayer_Multishot_Hotkey, Multishot_Settings.ini, Script settings, multiplayer_Multishot_Hotkey
IniRead, singleplayer_Multishot_Hotkey, Multishot_Settings.ini, Script settings, singleplayer_Multishot_Hotkey
IniRead, pause_shot_hotkey, Multishot_Settings.ini, Script settings, pause_shot_hotkey
if (multiplayer_Multishot_Hotkey) {
Hotkey, %multiplayer_Multishot_Hotkey%, multiplayer_Multishot_Hotkey
}
if (singleplayer_Multishot_Hotkey) {
Hotkey, %singleplayer_Multishot_Hotkey%, singleplayer_Multishot_Hotkey
}
if (pause_shot_hotkey) {
Hotkey, %pause_shot_hotkey%, pause_shot_hotkey
}
}
ButtonSave:
Gui, Submit
settingsWrite()
Gui, Destroy
reload
return
GuiClose:
Gui, Destroy
reload
Return
GuiEscape:
Gui, Cancel
Gui, Destroy
reload
Return
$*F8::
ExitApp
$*F9::
gui, destroy
settingsGUI()
return
multiplayer_Multishot_Hotkey:
enable27k()
return
singleplayer_Multishot_Hotkey:
enable3074()
return
pause_shot_hotkey:
enablebuffer()
return
killMacroBind:
ExitApp
settingsGuiBind:
gui, destroy
settingsGUI()
return
enable27k(){
Send, {Ctrl Down}
Send, {Shift Down}
Send, {End}
Send, {Ctrl Up}
Send, {Shift Up}
SoundBeep, 750
Sleep, 100
Click, Down
Sleep, 100
Click, Up
Sleep, 1400
Send, {Ctrl Down}
Send, {Shift Down}
Send, {End}
Send, {Ctrl Up}
Send, {Shift Up}
SoundBeep, 523
return
}
enable3074(){
Send, {Ctrl Down}
Send, {Shift Down}
Send, {Home}
Send, {Ctrl Up}
Send, {Shift Up}
SoundBeep, 750
Sleep, 100
Click, Down
Sleep, 100
Click, Up
Sleep, 1400
Send, {Ctrl Down}
Send, {Shift Down}
Send, {Home}
Send, {Ctrl Up}
Send, {Shift Up}
SoundBeep, 523
}
enablebuffer() {
SoundBeep, 750
Click, Down              ; totally not stolen code
                Sleep, 10
                Process_Suspend("Destiny2.exe")
                Sleep, 325
                Process_Resume("Destiny2.exe")
                Sleep, 35
                Process_Suspend("Destiny2.exe")
                Sleep, 325
                Process_Resume("Destiny2.exe")
                Sleep, 35           
                Process_Suspend("Destiny2.exe")
                Sleep, 325
                Process_Resume("Destiny2.exe")
                Sleep, 35
                Process_Suspend("Destiny2.exe")
                Sleep, 335
                Process_Resume("Destiny2.exe")
                Sleep, 35
                Process_Suspend("Destiny2.exe")
                Sleep, 325
                Process_Resume("Destiny2.exe")
				Click, Up
SoundBeep, 523
return
}
Process_Suspend(PID_or_Name){
    PID := (InStr(PID_or_Name,".")) ? ProcExist(PID_or_Name) : PID_or_Name
    h:=DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)
    If !h   
        Return -1
    DllCall("ntdll.dll\NtSuspendProcess", "Int", h)
    DllCall("CloseHandle", "Int", h)
	Return
	}
                                       ; this code isnt malicious its for the process suspend and process resume
Process_Resume(PID_or_Name){
    PID := (InStr(PID_or_Name,".")) ? ProcExist(PID_or_Name) : PID_or_Name
    h:=DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)
    If !h   
        Return -1
    DllCall("ntdll.dll\NtResumeProcess", "Int", h)
    DllCall("CloseHandle", "Int", h)
	}

ProcExist(PID_or_Name=""){
    Process, Exist, % (PID_or_Name="") ? DllCall("GetCurrentProcessID") : PID_or_Name
    Return Errorlevel
}
return