#noenv ; improves performance by maybe like 0.01% by not loading environment variables
#singleinstance force ; only allow one of this script to be open at once
#persistent ; run the script until an exitapp is encountered

setbatchlines, -1 ; never automatically sleep, not really necessary here but who cares
setworkingdir %a_scriptdir% ; read files from the scripts directory

; Initializing all variables so even when script is not running it gives the user feedback.

start := 0
CursorTracking := 1
xx := 00
yy := 00
x1 := 00
y1 := 00
customcolor := "000000"
loopcounter := 0
loopcounter2 := 0
input1 := 0
Line3 := " "
Line4 := " "
Line5 := " "
coord1 := " "


; Basic Menu GUI Stuff
gui, +lastfound +alwaysontop -caption +toolwindow +owner 
gui, color, %customcolor%
gui, font, s20, verdana
gui, add, text, vbasicmenu x0 y0 cwhite, XXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
gui, add, text, vhelpmenu x825 y0 cwhite, XXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
winset, Transparent, 255
;winset, transcolor, %customcolor% 255


;guicontrol, hide, helpmenu ; hides advanced menu by default

settimer, updategui, 200
gosub, updategui
updategui:
if winactive("Destiny 2") {
    if (start = 0) {
        gui, show, x0 y0 noactivate        
        guicontrol,, basicmenu, Press F2 to quit script, F3 to reload it, or F4 to convert Legendary Shards to Phantasmal Fragments. `nPres F9 to load Help Menu. 
        guicontrol,, helpmenu, Pres F10 to close Help menu `nCurosor Location: %xx% , %yy% `nPhantasmal Fragments Location: %x1% , %y1%  
         if (CursorTracking =1) {
                       MouseGetPos, xx, yy
                              }                
         }
                               
    else if (start = 1){
        gui, show, x0 y0 noactivate
        guicontrol,, basicmenu, Script Running. Press F2 to quit script, F3 to reload it. `nPres F9 to load Help Menu.. `n%Line3% `n%Line4% `n%Line5%
        guicontrol,, helpmenu, Pres F10 to close Help menu `nCurosor Location: %xx% , %yy% `nPhantasmal Fragments Location: %x1% , %y1% `nUser input: %input1% `nLegendary Shards to Spend: %loopcounter%0 `nLegendary Shards Spent: %loopcounter2%0
        if (CursorTracking =1) {
                       MouseGetPos, xx, yy
                              }        
        } 
}
else {
    gui, hide
    
}

F2:: ; press F2 to close the script
{
    exitapp 
}

F3:: ; press F3 to reload the script
{	
    start := 0
    CursorTracking := 1
    xx := 00
    yy := 00
    x1 := 00
    y1 := 00
    customcolor := "000000"
    loopcounter := 0
    loopcounter2 := 0
    input1 := 0
    Line3 := " "
    Line4 := " "
    Line5 := " "
    coord1 := " "    
    reload
}

F4:: ; Sets up Coordinates and delays
{
     start := 1
     CoordMode, Mouse, Screen
     sysx := 65535//a_screenwidth
     sysy := 65535//a_screenheight
     Line3 := "Go to Lectern of Enchantment and press Spacebar. "
     Input, SingleKey, L1, {Space}
     Sleep 1500
     send, {e down}
     sleep 2000
     send, {e up}
     Line4 := "Move Cursor to Phantasmal Fragments and press Spacebar"
     Input, SingleKey, L1, {Space}
     MouseGetPos, x1, y1
     coord1 := Format("{:02},{:02}",x1,y1)
     Line3 := "Phantasmal Fragments Coordinates: " coord1
     Line4 := "Input a 5 digint number of shards to spend:"
     Input, input1, L5, {Space}
     Line4 := "Running......"
     loopcounter = %input1%
     loopcounter /= 10
     loop %loopcounter%
        {
            sleep 1000
            dllcall("mouse_event", "uint", 0x8001, "uint", x1*sysx, "uint", y1*sysy) 
            sleep 1000
            click
            loopcounter2++
         }
         
     send, {Esc}
     Line5 := "Script Complete. Press Spacebar..."
     Input, SingleKey, L1, {Space}
     
 reload
     
     
     
     
}





F9:: ; Toggle Help Menu On
{
    guicontrol, show, helpmenu
return
}

F10:: ; Toggle Advanced Mode Menu Off
{
   guicontrol, hide, helpmenu
return
}






