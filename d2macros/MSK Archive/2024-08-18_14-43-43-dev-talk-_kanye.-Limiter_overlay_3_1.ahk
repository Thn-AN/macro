;opelzafiri the goat
;open nl first then run this in admin :))
;set hotkeys
;join nalgini limiter discord @ https://www.nalgini.shop/invite :)
hotkey3074 := "^1"
hotkey7500 := "^2"
hotkey30k := "^3"
hotkey27k := "^4"

hotkey, %hotkey3074%, toggle3074
hotkey, %hotkey7500%, toggle7500
hotkey, %hotkey30k%, toggle30k
hotkey, %hotkey27k%, toggle27k



;variables
;join nalgini limiter discord @ https://www.nalgini.shop/invite :)
overlaytext3074 := "                    "
overlaytext7500 := "                    "
overlaytext30k := "                    "
overlaytext27k := "                    "
timerRunning := false
Global startTime3074 := 0
Global startTime7500 := 0
Global startTime30k := 0
Global startTime27k := 0
Global running3074 := False
Global running7500 := False
Global running30k := False
Global runningHotKeys:= []



; GUI setup
;join nalgini limiter discord @ https://www.nalgini.shop/invite :)
Gui, 1:+LastFound +AlwaysOnTop -Caption +E0x80000 +ToolWindow
Gui, 1:Color, Black
Gui, 1:Font, s12  
Gui, 1:Add, Text, vOverlayText cWhite, %overlaytext3074%
Gui, 1:Show, x0 y0 w500 h25
WinSet, TransColor, 000000

Gui, 2:+LastFound +AlwaysOnTop -Caption +E0x80000 +ToolWindow
Gui, 2:Color, Black
Gui, 2:Font, s12  
Gui, 2:Add, Text, vOverlayText cWhite, %overlaytext7500%
Gui, 2:Show, x0 y25 w100 h25
WinSet, TransColor, 000000

Gui, 3:+LastFound +AlwaysOnTop -Caption +E0x80000 +ToolWindow
Gui, 3:Color, Black
Gui, 3:Font, s12  
Gui, 3:Add, Text, vOverlayText cWhite, %overlaytext30k%
Gui, 3:Show, x0 y50 w100 h25
WinSet, TransColor, 000000

Gui, 4:+LastFound +AlwaysOnTop -Caption +E0x80000 +ToolWindow
Gui, 4:Color, Black
Gui, 4:Font, s12  
Gui, 4:Add, Text, vOverlayText cWhite, %overlaytext27k%
Gui, 4:Show, x0 y75 w100 h25
WinSet, TransColor, 000000

moveOverlays:
; move each overlay's y position to (25*runningHotkeys.Count()-1)
;join nalgini limiter discord @ https://www.nalgini.shop/invite :)
nextYPos := 0  ; Initialize nextYPos at the start
if(running3074){
    ypos:= runningHotKeys.Find("3074")*25
    Gui, 1:Show, y%nextYPos%
    nextYPos += 25
}
if(running7500){
    ypos:= runningHotKeys.Find("7500")*25
    Gui, 2:Show, y%nextYPos%
    nextYPos += 25
}
if(running30k){
    ypos:= runningHotKeys.Find("30k")*25
    Gui, 3:Show, y%nextYPos%
    nextYPos += 25
}
if(running27k){
    ypos:= runningHotKeys.Find("27k")*25
    Gui, 4:Show, y%nextYPos%
    nextYPos += 25
}
return
;timers
;join nalgini limiter discord @ https://www.nalgini.shop/invite :)
timer3074:
if (running3074) {
    currentTime := A_TickCount - startTime3074
    hours := Floor(currentTime / 3600000)
    currentTime -= hours * 3600000
    minutes := Floor(currentTime / 60000)
    currentTime -= minutes * 60000
    seconds := Floor(currentTime / 1000)
    FormattedMinutes := Format("{:02}", minutes) 
    FormattedSeconds := Format("{:02}", seconds) 
    GuiControl,, OverlayText, 3074 %FormattedMinutes%:%FormattedSeconds%
}
timer7500:
if (running7500) {
    currentTime := A_TickCount - startTime7500
    hours := Floor(currentTime / 3600000)
    currentTime -= hours * 3600000
    minutes := Floor(currentTime / 60000)
    currentTime -= minutes * 60000
    seconds := Floor(currentTime / 1000)
    FormattedMinutes := Format("{:02}", minutes) 
    FormattedSeconds := Format("{:02}", seconds) 
    GuiControl,2:, OverlayText, 7500 %FormattedMinutes%:%FormattedSeconds%
}
timer30k:
if (running30k) {
    currentTime := A_TickCount - startTime30k
    hours := Floor(currentTime / 3600000)
    currentTime -= hours * 3600000
    minutes := Floor(currentTime / 60000)
    currentTime -= minutes * 60000
    seconds := Floor(currentTime / 1000)
    FormattedMinutes := Format("{:02}", minutes) 
    FormattedSeconds := Format("{:02}", seconds) 
    GuiControl,3:, OverlayText, 30k %FormattedMinutes%:%FormattedSeconds%
}
timer27k:
if (running27k) {
    currentTime := A_TickCount - startTime27k
    hours := Floor(currentTime / 3600000)
    currentTime -= hours * 3600000
    minutes := Floor(currentTime / 60000)
    currentTime -= minutes * 60000
    seconds := Floor(currentTime / 1000)
    FormattedMinutes := Format("{:02}", minutes) 
    FormattedSeconds := Format("{:02}", seconds) 
    GuiControl,4:, OverlayText, 27k %FormattedMinutes%:%FormattedSeconds%
}
return
;toggles
;join nalgini limiter discord @ https://www.nalgini.shop/invite :)
toggle3074: 
send,%hotkey3074%
If (running3074){
    running3074 := False
    index := runningHotKeys.Find("3074")  ; Find the index of "3074"
    if (index != "")  ; If "3074" is found
        runningHotKeys.RemoveAt(index)  ; Remove "3074" from the array
    GuiControl,, OverlayText, %overlaytext3074%
    SetTimer, timer3074, Off
}
Else{
    running3074 := True
    runningHotKeys.Push("3074")  ; Add "3074" to the end of the array
    startTime3074 := A_TickCount
    GuiControl,, OverlayText, 3074 00:00
    SetTimer, timer3074, 1000
}
Gosub, moveOverlays

return

toggle7500: 
send,%hotkey7500%
If (running7500){
    running7500:= false
    index := runningHotKeys.Find("7500") 
    if (index != "") 
        runningHotKeys.RemoveAt(index)
    SetTimer, timer7500, OFF
    GuiControl,2:, OverlayText, %overlaytext7500%
    
}
Else{
    running7500 := True
    runningHotKeys.Push("7500")
    startTime7500 := A_TickCount
    GuiControl,2:, OverlayText, 7500 00:00
    SetTimer, timer7500, 1000
}
Gosub, moveOverlays
return

toggle30k: 
send,%hotkey30k%

If (running30k){
    running30k:= false
    index := runningHotKeys.Find("30k") 
    if (index != "") 
        runningHotKeys.RemoveAt(index)
    SetTimer, timer30k, OFF
    GuiControl,3:, OverlayText, %overlaytext30k%
    
}
Else{
    running30k := True
    runningHotKeys.Push("30k")
    startTime30k := A_TickCount
    GuiControl,3:, OverlayText, 30k 00:00
    SetTimer, timer30k, 1000
}
Gosub, moveOverlays
return



toggle27k: 
send,%hotkey27k%
If (running27k){
    running27k:= false
    index := runningHotKeys.Find("27k") 
    if (index != "") 
        runningHotKeys.RemoveAt(index)
    SetTimer,timer27k,Off
    GuiControl,4:, OverlayText, %overlaytext27k%
}
Else{
    running27k := True
    runningHotKeys.Push("27k")
    startTime27k := A_TickCount
    GuiControl,4:, OverlayText, 27k 00:00
    SetTimer, timer27k, 1000
}

Gosub, moveOverlays
return

;join nalgini limiter discord @ https://www.nalgini.shop/invite :)