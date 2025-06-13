#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#SingleInstance Force
#KeyHistory 0
#MaxThreadsPerHotkey 1
SetBatchLines -1
ListLines Off
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

customcolor := "000000"
gui +lastfound +alwaysontop -caption +toolwindow
gui, color, %customcolor%
gui, font, s32, verdana
gui, add, text, vmytext cwhite, XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ; make text not cut out
guicontrol,, mytext, ready
winset, transcolor, %customcolor% 255


settimer, updategui, 200
gosub, updategui
updategui:
    gui, show, x0 y0 noactivate 

$*^k::
ExitApp

F5::
loop {
    GoToPod()
    guicontrol,, mytext, waiting for activity completion
    sleep, 45000
    guicontrol,, mytext, joining cp holder
    joinPlayer()
    guicontrol,, mytext, waiting for load into activity
    waitForJoinActivity()
    sleep, 8000 ; wait for leader to leave
    guicontrol,, mytext, waiting for rejoin
    waitForJoinActivity()
    guicontrol,, mytext, going to pod
}
return

F6::
GoToPod()
return

F7::
Reload
MsgBox, Failed to reload
return

waitForJoinOrbit(){
    loop {
        PixelSearch,,, 2650, 210, 2815, 245, 0xFFFFFF, 10, Fast RGB
        if (ErrorLevel = 0){
            guicontrol,, mytext, Player Detected
            break
        } else if (ErrorLevel = 1){
            guicontrol,, mytext, No Detection
        } else if (ErrorLevel = 2){
            MsgBox, An error was encountered when trying to perform a pixelsearch
        }
        sleep, 100
    }
}

waitForJoinActivity(){
    loop {
        PixelGetColor, radarColor, 350, 160 , RGB ; change coords for you radar 
        if (radarColor = "0x73B9A0"){
            guicontrol,, mytext, Player Detected
            break
        } else {
            guicontrol,, mytext, No Detection
        }
        Sleep, 100
    }
}

GoToPod(){ ; goes to second pod from second spawn position, assumes door is unlocked
    Send, {w Down}
    Sleep, 32
    Send, {d Down}
    Sleep, 315
    Send, {LShift Down}
    Sleep, 2232
    Send, {LShift Up}
    Sleep, 218
    Send, {w Up}
    Sleep, 1141
    Send, {w Down}
    Sleep, 62
    Send, {d Up}
    Sleep, 16
    Send, {LShift Down}
    Sleep, 297
    Send, {LShift Up}
    Sleep, 344
    Send, {Space Down}
    Sleep, 375
    Send, {Space Up}
    Send, {d Down}
    sleep, 2900
    Send, {d Up}
    Send, {w Up}
    Send, {LAlt Down}
    Sleep, 1313
    Send, {LAlt Up}
    Sleep, 1281
    Send, {w Down}
    Send, {Shift Down}
    Sleep, 20
    Send, {Shift Up}
    Sleep 590
    Send, {d Down}
    Sleep, 3875
    Send, {d Up}
    Sleep, 1500
    Send, {w Up}
    sleep, 12000
    Send, {LAlt Down}
    Sleep, 562
    Send, {LAlt Up}
}

joinPlayer(){
    Send, {enter}
    Sleep, 10
    ;Send, /join Liloz01{#}5353
    Send, /join Green Tea{#}8259
    Sleep, 10
    Send, {enter}
    Sleep, 250
    Send, {enter}
}