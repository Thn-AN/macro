#NoEnv 

#SingleInstance Force



; Global Variables

if (!A_IsAdmin){ 
    Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"
}

; Defualt Binds (uncomment the bind you want permenantly bound)
 ;global 27kBind := "F9"
 ;global 3074Bind := "F7"
;global pauseBind := "F8"
 ;global PBoxBind := "F10"
 ;global filthyBind := "\"

 ;Hotkey, %27Kbind%, 27kHotkey
 ;Hotkey, %3074bind%, 3074Hotkey
; Hotkey, %pauseBind%, PauseHotkey
; Hotkey, %PBoxBind%, PBoxHotkey
; Hotkey, %filthyBind%, FilthyHotkey


;random shit
delayPBox := (244 + floor(((fps * 50) / 220)))
fps = 60
fire_mode := 0
fire_mode_delay := 0
filthy_delay := 40

mainGUI:

    Gui, +AlwaysOnTop
    Gui, Font, s11 q5 cc2c5c9, Whitney
    Gui, Color, c1e2124

    Gui, Add, Text, x225 y130 vfpsvalue, AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
	guicontrol,, fpsvalue, FPS: %fps%
	Gui, Add, Slider, x10 y130 w200 h30 Range30-250 vSliderValue gSlide, %fps%

    ;Gui, Add, Text, x10 y195, Charge Time (in ms)
    ;Gui, Add, DropDownList, x175 y190 w100 h100 Choose1 vChargeTime, None|500|774|1000



    Gui Add, Text, x10 y10 w150 h25 +0x200, 27k:
    Gui Add, Hotkey, x220 y10 w75 h25 v27Kbind, %27Kbind%
    Gui Add, Text, x10 y40 w150 h25 +0x200, 3074:
    Gui Add, Hotkey, x220 y40 w75 h25 v3074bind, %3074bind%
    Gui Add, Text, x10 y70 w150 h25 +0x200, Pause:
    Gui Add, Hotkey, x220 y70 w75 h25 vpauseBind, %pauseBind%
    Gui Add, Text, x10 y100 w150 h25 +0x200, PBox:
    Gui Add, Hotkey, x220 y100 w75 h25 vpboxBind, %pboxBind%
    Gui Add, Text, x10 y160 w150 h25 +0x200, Filthy:
    Gui Add, Hotkey, x220 y160 w75 h25 vfilthyBind, %filthyBind%

    Gui Add, Text, x100 y10 w30 h25 +0x200 v27kStatus, OFF
    Gui Add, Text, x100 y40 w30 h25 +0x200 v3074Status, OFF
    Gui Add, Text, x100 y70 w30 h25 +0x200 vpauseStatus, OFF
    Gui Add, Text, x100 y160 w30 h25 +0x200 vfilthyStatus, OFF
	Gui Add, Text, x10 y200 w150 h25 +0x200, Click here before closing:
    Gui Add, Button, x185 y203 w100 h20 gUpdateHotkeys, Save
    Gui, Show, w300 h245, Goobing Technology 2.0

return

27kHotkey:
    if (toggle := !toggle) {
        guicontrol,, 27kStatus, ON
	    enable27k()
		SoundBeep, 523
		SoundBeep, 750
	}
    else {
        guicontrol,, 27kStatus, OFF
	    disable27k()
		SoundBeep, 750
		SoundBeep, 523
	}
return

3074Hotkey:
    if (toggle := !toggle) {
        guicontrol,, 3074Status, ON
	    enable3074()
		SoundBeep, 523
		SoundBeep, 750
	}
    else {
        guicontrol,, 3074Status, OFF
	    disable3074()
		SoundBeep, 750
		SoundBeep, 523
	}
return

PauseHotkey:
    if (toggle := !toggle) {
        guicontrol,, pauseStatus, ON
	    Process_Suspend("destiny2.exe")
		SoundBeep, 523
		SoundBeep, 750
	}
    else {
        guicontrol,, pauseStatus, OFF
	    Process_Resume("destiny2.exe")
		SoundBeep, 750
		SoundBeep, 523
	}
return


PBoxHotkey:
    Send {Enter down} ;
	sleep 10 ;
	Send {Enter up} ;
	sleep 10 ;
	Send {P down} ;
	sleep 10 ;
	Send {P up} ;
	sleep 10 ;
	Send {Enter down} ;
	sleep 10 ; 
	Send {Enter up} ;
	sleep 10 ;
	Send {N down} ;
	sleep %delayPBox% ;
	Process_Suspend("destiny2.exe")
	sleep 1300 ;
	Process_Resume("destiny2.exe")
	Send {N down} ;
	sleep  325 ;
	Send {N up} ;   
return

;
; Filthy
;

#if (fire_mode)
    {
        ~RButton:: ; right click
            {
                enable3074()
                
                ; wait
                While GetKeyState("RButton", "P") ; While right mouse button is pressed
                {
                    Sleep, 1
                }

                disable3074()
                
            }
        Return
    }
#if

FilthyHotkey:
    guicontrol,, filthyStatus, ON
    guiControlGet, filthyLimit,, fLimit
	SoundBeep, 523
	SoundBeep, 750
    if (fire_mode) {
        fire_mode := 0
        enable3074() 
    } else {
        fire_mode := 1
        
    }
return


~LButton::
    {
        pause_time := 325
        unpause_time := 35
        ; pause_time := 275 ; makes 5 pretty well
        ; unpause_time := 40
        IfWinActive, Destiny 2
        {
            if (fire_mode)
            {
                Sleep, 40
                Process_Suspend("Destiny2.exe")
                Sleep, % pause_time
                Process_Resume("Destiny2.exe")
                Sleep, % unpause_time
                Process_Suspend("Destiny2.exe")
                Sleep, % pause_time
                Process_Resume("Destiny2.exe")
                Sleep, % unpause_time
                Process_Suspend("Destiny2.exe")
                Sleep, % pause_time
                Process_Resume("Destiny2.exe")
                Sleep, % unpause_time
                Process_Suspend("Destiny2.exe")
                Sleep, % pause_time
                Process_Resume("Destiny2.exe")
                Sleep, % unpause_time
                Process_Suspend("Destiny2.exe")
                Sleep, % pause_time
                Process_Resume("Destiny2.exe")
                fire_mode := 0
				SoundBeep, 750
				SoundBeep, 523
            }
        }
    }


;
;   HOTKEY SAVING AND UPDATING
;


UpdateHotkeys:
    GuiControlGet, bind1,, 27kBind

    if (bind1){
        if(bind1 != 27kBind) {
            if (27kBind){
                Hotkey, %27kBind%, 27kHotkey, off
            }
            27kBind := bind1  
            Hotkey, %27kBind%, 27kHotkey, on
        }
    }

    GuiControlGet, bind3,, 3074Bind

    if (bind3){
        if(bind3 != 3074Bind) {
            if(3074bind){
                Hotkey, %3074Bind%, 3074Hotkey, off
            }
            3074Bind := bind3  
            Hotkey, %3074Bind%, 3074Hotkey, on
        }
    }

    GuiControlGet, bind4,, pauseBind

    if (bind4){
        if(bind4 != pauseBind) {
            if(pauseBind){
                Hotkey, %pauseBind%, pauseHotkey, off
            }
            pauseBind := bind4  
            Hotkey, %pauseBind%, pauseHotkey, on
        }
    }

    GuiControlGet, bind5,, PBoxBind

    if (bind5){
        if(bind5 != PBoxBind) {
           if(PBoxBind){
                Hotkey, %PBoxBind%, pboxHotkey, off
            }
            PBoxBind := bind5  
            Hotkey, %PBoxBind%, pboxHotkey, on
        }
    }

    GuiControlGet, bind7,, filthyBind

    if (bind7){
        if(bind7 != filthyBind) {
            if(filthyBind){
                Hotkey, %filthyBind%, filthyHotkey, off
            }
            filthyBind := bind7  
            Hotkey, %filthyBind%, filthyHotkey, on
        }
    }

    GuiControlGet, delay,, ChargeTime
    filthyDelay := delay
return

Slide:
	GuiControlGet, SliderValue
	
	if (sliderValue = 250) {
		guicontrol,, fpsvalue, FPS: ∞
	} else {
		guicontrol,, fpsvalue, FPS: %sliderValue%
	}

	delayPBox := (244 + floor(((%SliderValue% * 50) / 220)))

return


;
;       LIMITER
;

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



;
;   GAMEPAUSE
;

Process_Suspend(PID_or_Name){
    PID := (InStr(PID_or_Name,".")) ? ProcExist(PID_or_Name) : PID_or_Name
    h:=DllCall("OpenProcess", "uInt", 0x1F0FFF, "Int", 0, "Int", pid)
    If !h   
        Return -1
    DllCall("ntdll.dll\NtSuspendProcess", "Int", h)
    DllCall("CloseHandle", "Int", h)
	Return
	}
 
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
	

F5::reload

;Shuts off all limits when you close ahk

ExitApp:
	disable27k()
    disable30k()
    disable3074()
return
