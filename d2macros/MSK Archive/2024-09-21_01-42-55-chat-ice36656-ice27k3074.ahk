#NoEnv 
#MaxThreadsperHotkey 4
#SingleInstance Force



; Global Variables

if (!A_IsAdmin){ 
    Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"
}
mainGUI:

    Gui, +AlwaysOnTop
    Gui, Font, s11 q5 cc2c5c9, Whitney
    Gui, Color, c1e2124

    Gui Add, Text, x10 y25 w150 h25 +0x200, 27k:
    Gui Add, Hotkey, x220 y25 w75 h25 v27Kbind, %27Kbind%
    Gui Add, Text, x10 y50 w150 h25 +0x200, 3074:
    Gui Add, Hotkey, x220 y50 w75 h25 v3074bind, %3074bind%
	Gui Add, Text, x10 y100 w75 +0x200, Sound-Cues:
	Gui Add, CheckBox, x220 y100 w75 h25 vsoundCues gCheckSound
    Gui Add, Text, x100 y25 w30 h25 +0x200 v27kStatus, OFF
	Gui Add, Text, x140 y25 w30 h25 +0x200 v27UTime, 0
	Gui Add, Text, x180 y25 w30 h25 +0x200 v27DTime, 0
	
    Gui Add, Text, x100 y50 w30 h25 +0x200 v3074Status, OFF
	Gui Add, Text, x140 y50 w30 h25 +0x200 v3074UTime, 0
	Gui Add, Text, x180 y50 w30 h25 +0x200 v3074DTime, 0
	Gui Add, Text, x170 y0 w150 h25 +0x200, Exit App: F8
    Gui, Show, w300 h200, buh
return

27kHotkey:
{

		if (toggle := !toggle) {

			guicontrol,, 27kStatus, ON
			enable27k()
			if (sound_cue){
				SoundBeep, 523
				SoundBeep, 750
			}
		}
		else {
			guicontrol,, 27kStatus, OFF
			disable27k()
			if (sound_cue){
				SoundBeep, 750
				SoundBeep, 523
			}
		}
	}
return


3074Hotkey:
{

		if (toggle := !toggle) {

			guicontrol,, 3074Status, ON
			enable3074()
			if (sound_cue){
				SoundBeep, 523
				SoundBeep, 750
			}
		}
		else {
			guicontrol,, 3074Status, OFF
			disable3074()
			if (sound_cue){
				SoundBeep, 750
				SoundBeep, 523
			}
		}
	}
return

$*F8::
	disable27k()
    disable3074()
	ExitApp
	
~LButton::
    {
				} ;; REMOVING THIS FUCKING LINE OF CODE BREAKS THE ENTIRE THING


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
return

CheckSound:
	GuiControlGet, soundCues
	if (soundCues) {
		sound_cue := 1
	} else {
		sound_cue := 0
	}
return



;
;       LIMITER
;

enable27k(){
    
    run netsh advfirewall firewall add rule dir=out action=block name="d2limit-27k-tcp-out" profile=any remoteport=27000-27200 protocol=tcp interfacetype=any,,hide
    run netsh advfirewall firewall add rule dir=out action=block name="d2limit-27k-udp-out" profile=any remoteport=27000-27200 protocol=udp interfacetype=any,,hide
    run netsh advfirewall firewall add rule dir=in action=block name="d2limit-27k-tcp-in" profile=any remoteport=27000-27200 protocol=tcp interfacetype=any,,hide
    run netsh advfirewall firewall add rule dir=in action=block name="d2limit-27k-udp-in" profile=any remoteport=27000-27200 protocol=udp interfacetype=any,,hide
}

disable27k(){
    run netsh advfirewall firewall delete rule name="d2limit-27k-tcp-out",,hide
    run netsh advfirewall firewall delete rule name="d2limit-27k-udp-out",,hide
    run netsh advfirewall firewall delete rule name="d2limit-27k-tcp-in",,hide
    run netsh advfirewall firewall delete rule name="d2limit-27k-udp-in",,hide
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
return
	
;Shuts off all limits when you close ahk

return
