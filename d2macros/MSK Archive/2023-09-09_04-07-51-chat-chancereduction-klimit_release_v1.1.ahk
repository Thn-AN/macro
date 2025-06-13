; TODO make exe??
; TODO custom enableLimitMode() kb gui??
; TODO fix UL/DL TCP/UDP
; the point of this macro is so you dont have to use sketchy netlimiter bypasses, specific versions get banned if many people use them and most dont know how to make their own
#NoEnv
#SingleInstance Force
#KeyHistory 0
#MaxThreadsPerHotkey 1
SetBatchLines -1
ListLines Off

; request admin if not running as one
If (!A_IsAdmin){ 
    Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"
}

checkForIni()
return

; ==================================
;             GUI Part
; ==================================

; isnt a function because that makes timer shenanigans easier
overlay:
; funky overlay stuff
global mytext
customcolor := "222222"
gui, +lastfound +alwaysontop -caption +toolwindow
gui, color, %customcolor%
gui, font, s10, Whitney
gui, add, text, x5 y5 cwhite, made by _kreken
gui, font, s24, verdana
gui, add, text, x5 y25 vmytext cwhite, XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;  make text not cut out
winset, transcolor, %customcolor% 255
line_1 = %27kBind% 27k 
line_2 = %30kBind% 30k 
line_3 = %3074Bind% 3074 
line_4 = %lagswitchBind% lagswitch 
line_5 = %killMacroBind% to exit
; update overlay every 200 ms
settimer, updateOverlay, 200
gosub, updateOverlay
updateOverlay:
    guicontrol,, mytext, %line_1%`n%line_2%`n%line_3%`n%line_4%`n%line_5%`n%line_6%
    gui, show, x0 y0 noactivate 
return

checkForIni(){
    if fileExist("klim_settings.ini"){
        settingsRead()
        gosub, overlay
    } else {
        settingsGUI()
    }
}

settingsGUI(){
    global 27kBind
    global 30kBind 
    global 3074Bind
    global 7500Bind
    global killMacroBind
    global settingsGuiBind
    global lagswitchBind

    ; load defaults if exist
    if fileExist("klim_settings.ini"){
       settingsRead() 
    }

    Gui, Font, s11 q5 cc2c5c9, Whitney
    Gui, Color, c1e2124
    Gui, Add, Button, x100 y230 w200 h25 +Default, Save

    Gui Add, Text, x10 y10 w150 h25 +0x200, 27000 bind:
    Gui Add, Hotkey, x220 y10 w75 h25 v27Kbind, %27Kbind%
    Gui Add, Text, x10 y40 w150 h25 +0x200, 30000 bind:
    Gui Add, Hotkey, x220 y40 w75 h25 v30Kbind, %30Kbind%
    Gui Add, Text, x10 y70 w150 h25 +0x200, 3074 bind:
    Gui Add, Hotkey, x220 y70 w75 h25 v3074bind, %3074bind%
    Gui Add, Text, x10 y100 w150 h25 +0x200, kill macro bind:
    Gui Add, Hotkey, x220 y100 w75 h25 vkillMacroBind, %killMacroBind%
    Gui Add, Text, x10 y130 w150 h25 +0x200, settings GUI bind:
    Gui Add, Hotkey, x220 y130 w75 h25 vsettingsGuiBind, %settingsGuiBind%
    Gui Add, Text, x10 y160 w150 h25 +0x200, lagswitch bind:
    Gui Add, Hotkey, x220 y160 w75 h25 vlagswitchBind, %lagswitchBind%
    Gui Add, Text, x10 y185 w400 h25 +0x200, (doesn't work on windows home edition)

    Gui, Show, w400, Settings
}

settingsWrite(){
    global 27kBind
    global 30kBind 
    global 3074Bind
    global killMacroBind
    global settingsGuiBind
    global lagswitchBind

    IniWrite, %27kBind%, klim_settings.ini, Script settings, 27kBind
    IniWrite, %30kBind%, klim_settings.ini, Script settings, 30kBind
    IniWrite, %3074Bind%, klim_settings.ini, Script settings, 3074Bind
    IniWrite, %killMacroBind%, klim_settings.ini, Script settings, killMacroBind
    IniWrite, %settingsGuiBind%, klim_settings.ini, Script settings, settingsGuiBind
    IniWrite, %lagswitchBind%, klim_settings.ini, Script settings, lagswitchBind
}

settingsRead(){
    global 27kBind
    global 30kBind 
    global 3074Bind
    global killMacroBind
    global settingsGuiBind
    global lagswitchBind

    IniRead, 27kBind, klim_settings.ini, Script settings, 27kBind
    IniRead, 30kBind, klim_settings.ini, Script settings, 30kBind
    IniRead, 3074Bind, klim_settings.ini, Script settings, 3074Bind
    IniRead, killMacroBind, klim_settings.ini, Script settings, killMacroBind
    IniRead, settingsGuiBind, klim_settings.ini, Script settings, settingsGuiBind
    IniRead, lagswitchBind, klim_settings.ini, Script settings, lagswitchBind 

    if (27kBind) {
	    Hotkey, %27kBind%, 27kBind
    }
    if (30kBind) {
	    Hotkey, %30kBind%, 30kBind
    }
    if (3074Bind) {
	    Hotkey, %3074Bind%, 3074Bind
    }
    if (killMacroBind) {
	    Hotkey, %killMacroBind%, killMacroBind
    }
    if (settingsGuiBind) {
	    Hotkey, %settingsGuiBind%, settingsGuiBind
    }
    if (lagswitchBind) {
	    Hotkey, %lagswitchBind%, lagswitchBind
    }
}
; gui labels
ButtonSave: 
Gui, Submit
settingsWrite()
Gui, Destroy
disable27k()
disable3074()
disable30k()
disableLimitMode()
reload
return

GuiClose:
Gui, Destroy
disable27k()
disable3074()
disable30k()
disableLimitMode()
reload
Return

GuiEscape:
Gui, Cancel
Gui, Destroy
disable27k()
disable3074()
disable30k()
disableLimitMode()
reload
Return

; ==================================
;               BINDS
; ==================================

; non customizable binds
$*^+k::
Reload
MsgBox, failed to reload script
return

$*^k::
ExitApp

; bring back settingsGui without deleting klim_settings.ini 
$*F9:: 
settimer, updateOverlay, Delete
gui, destroy
settingsGUI()
return

; customizable binds
; they be toggles!!!
27kBind:
if (WinActive("Destiny 2") || WinActive("ahk_exe Code.exe")){ ; only trigger if d2 or vscode is active
    if (line_1 != "27k On"){ ; != cuz it might be blank
        enable27k()
        line_1 = 27k On
    } else if (line_1 != "27k Off"){
        disable27k()
        line_1 = 27k Off
    }
}
return

30kBind:
if (WinActive("Destiny 2") || WinActive("ahk_exe Code.exe")){ ; only trigger if d2 or vscode is active
    if (line_2 != "30k On"){ ; != cuz it might be blank
        enable30k()
        line_2 = 30k On
    } else if (line_2 != "30k Off"){
        disable30k()
        line_2 = 30k Off
    }
}
return

3074Bind:
if (WinActive("Destiny 2") || WinActive("ahk_exe Code.exe")){ ; only trigger if d2 or vscode is active
    if (line_3 != "3074 On"){ ; != cuz it might be blank
        enable3074()
        line_3 = 3074 On
    } else if (line_3 != "3074 Off"){
        disable3074()
        line_3 = 3074 Off
    }
}
return

killMacroBind:
line_1 = Exiting...
line_2 =
line_3 =
line_4 =
line_5 =
disable27k()
disable3074()
disable30k()
disableLimitMode()
ExitApp

settingsGuiBind:
settimer, updateOverlay, Delete
gui, destroy
settingsGUI()
return

lagswitchBind:
if (WinActive("Destiny 2") || WinActive("ahk_exe Code.exe")){ ; only trigger if d2 or vscode is active
    if (line_4 != "Lagswitch On"){ ; != cuz it might be blank
        enableLimitMode("40")
        line_4 = Lagswitch On
    } else if (line_4 != "Lagswitch Off"){
        disableLimitMode()
        line_4 = Lagswitch Off
    }
}
return

; ==================================
;           limiter part
; ==================================

enable27k(){
    run netsh advfirewall firewall add rule dir=out action=block name="d2limit-27k-tcp-out" profile=any remoteport=27015-27200 protocol=tcp interfacetype=any,,hide
    run netsh advfirewall firewall add rule dir=out action=block name="d2limit-27k-udp-out" profile=any remoteport=27015-27200 protocol=udp interfacetype=any,,hide
    run netsh advfirewall firewall add rule dir=in action=block name="d2limit-27k-tcp-in" profile=any remoteport=27015-27200 protocol=tcp interfacetype=any,,hide
    run netsh advfirewall firewall add rule dir=in action=block name="d2limit-27k-udp-in" profile=any remoteport=27015-27200 protocol=udp interfacetype=any,,hide
}

disable27k(){
    run netsh advfirewall firewall delete rule name="d2limit-27k-tcp-out",,hide
    run netsh advfirewall firewall delete rule name="d2limit-27k-udp-out",,hide
    run netsh advfirewall firewall delete rule name="d2limit-27k-tcp-in",,hide
    run netsh advfirewall firewall delete rule name="d2limit-27k-udp-in",,hide
}

enable30k(){
    ;run netsh advfirewall firewall add rule dir=out action=block name="d2limit-30k-tcp-out" profile=any remoteport=30000-30009 protocol=tcp interfacetype=any,,hide
    ;run netsh advfirewall firewall add rule dir=out action=block name="d2limit-30k-udp-out" profile=any remoteport=30000-30009 protocol=udp interfacetype=any,,hide
    run netsh advfirewall firewall add rule dir=in action=block name="d2limit-30k-tcp-in" profile=any remoteport=30000-30009 protocol=tcp interfacetype=any,,hide
    run netsh advfirewall firewall add rule dir=in action=block name="d2limit-30k-udp-in" profile=any remoteport=30000-30009 protocol=udp interfacetype=any,,hide

}

disable30k(){
    ;run netsh advfirewall firewall delete rule name="d2limit-3074-tcp-out",,hide
    ;run netsh advfirewall firewall delete rule name="d2limit-3074-udp-out",,hide
    run netsh advfirewall firewall delete rule name="d2limit-30k-tcp-in",,hide
    run netsh advfirewall firewall delete rule name="d2limit-30k-udp-in",,hide
}

enable3074(){
    run netsh advfirewall firewall add rule dir=out action=block name="d2limit-3074-tcp-out" profile=any remoteport=3074 protocol=tcp interfacetype=any,,hide
    run netsh advfirewall firewall add rule dir=out action=block name="d2limit-3074-udp-out" profile=any remoteport=3074 protocol=udp interfacetype=any,,hide
    run netsh advfirewall firewall add rule dir=in action=block name="d2limit-3074-tcp-in" profile=any remoteport=3074 protocol=tcp interfacetype=any,,hide
    run netsh advfirewall firewall add rule dir=in action=block name="d2limit-3074-udp-in" profile=any remoteport=3074 protocol=udp interfacetype=any,,hide
}

disable3074(){
    run netsh advfirewall firewall delete rule name="d2limit-3074-tcp-out",,hide
    run netsh advfirewall firewall delete rule name="d2limit-3074-udp-out",,hide
    run netsh advfirewall firewall delete rule name="d2limit-3074-tcp-in",,hide
    run netsh advfirewall firewall delete rule name="d2limit-3074-udp-in",,hide
}
; random TODO: add checkboxes for udp tcp upload and download?? maybe as it might not even be useful

enableLimitMode(kb){
    RunWait powershell.exe -ExecutionPolicy bypass -c New-NetQosPolicy -Name "Destiny2-Limit" -AppPathNameMatchCondition "destiny2.exe" -ThrottleRateActionBitsPerSecond %kb%KB,,hide
}

disableLimitMode(){
    RunWait powershell.exe -ExecutionPolicy bypass -c Remove-NetQosPolicy -Name "Destiny2-Limit" -Confirm:$false,,hide 
}