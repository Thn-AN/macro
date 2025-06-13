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
x2 := 00
y2 := 00
x3 := 00
y3 := 00
delay1 := 00
delay2 := 00
delay3 := 00
delay4 := 00
DelayLocked := "No"
CoordsLocked := "No"
customcolor := "000000"
Line3 := " "
Line4 := " "
Line5 := " "
coord1 := " "
coord2 := " "
coord3 := " "

; Basic Menu GUI Stuff
gui, +lastfound +alwaysontop -caption +toolwindow +owner 
gui, color, %customcolor%
gui, font, s20, verdana
gui, add, text, vbasicmenu x0 y0 cwhite, XXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
gui, add, text, vhelpmenu x825 y0 cwhite, XXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX`nXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
winset, Transparent, 255
;winset, transcolor, %customcolor% 255


guicontrol, hide, helpmenu ; hides advanced menu by default

settimer, updategui, 200
gosub, updategui
updategui:
if winactive("Destiny 2") {
    if (start = 0) {
        gui, show, x0 y0 noactivate        
        guicontrol,, basicmenu, Press F2 to quit script, F4 to prep Coords or F5 to Craft Weapons. `nPres F9 to load Help Menu. 
        guicontrol,, helpmenu, Pres F10 to close Help menu `nCurosor Location: %xx% , %yy% `nCoord1: %x1% , %y1%  Delay1: %delay1%  Delay4: %delay4% `nCoord2: %x2% , %y2%  Delay2: %delay2%  CoordsLocked: %CoordsLocked%  `nCoord3: %x3% , %y3%  Delay3: %delay3%  DelaysLocked: %DelayLocked% 
         if (CursorTracking =1) {
                       MouseGetPos, xx, yy
                              }                
         }
                               
    else if (start = 1){
        gui, show, x0 y0 noactivate
        guicontrol,, basicmenu, Press F3 to start over, or F2 to quit script. `nPres F9 to load Help Menu. `n%Line3% `n%Line4% `n%Line5%
        guicontrol,, helpmenu, Pres F10 to close Help menu `nCurosor Location: %xx% , %yy% `nCoord1: %x1% , %y1%  Delay1: %delay1%  Delay4: %delay4% `nCoord2: %x2% , %y2%  Delay2: %delay2%  CoordsLocked: %CoordsLocked%  `nCoord3: %x3% , %y3%  Delay3: %delay3%  DelaysLocked: %DelayLocked%
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
     x2 := 00
     y2 := 00
     x3 := 00
     y3 := 00
     delay1 := 00
     delay2 := 00
     delay3 := 00
     delay4 := 00
     DelayLocked := "No"
     CoordsLocked := "No"
     customcolor := "000000"
     Line3 := " "
     Line4 := " "
     Line5 := " "
     coord1 := " "
     coord2 := " "
     coord3 := " "	
     reload
}

F4:: ; Sets up Coordinates and delays
{
     start := 1
     Line3 := "To start, hover cursor over the giving gun. Then, "
     Line4 := "Move Cursor to Ammo Type and press Spacebar"
     Input, SingleKey, L1, {Space}
     MouseGetPos, x1, y1
     coord1 := Format("{:02},{:02}",x1,y1)
     Line3 := "Captured coord 1:      " coord1  
     Line4 := "Move Cursor to Gun Type and press Spacebar"
     Input, SingleKey, L1, {Space}
     MouseGetPos, x2, y2
     coord2 := Format("{:02},{:02}",x2,y2)
     Line3 := "Captured coord 1:      " coord1 "     " coord2
     Line4 := "Hover over the receiving gun and press Spacebar"
     Input, SingleKey, L1, {Space}
     MouseGetPos, x3, y3
     coord3 := Format("{:02},{:02}",x3,y3)
     Line3 := "Captured coords:     " coord1 "     " coord2 "     " coord3
     Line4 := "If this looks correct, Press Y/N"
     Input, SingleKey, L1, {Space}, y,n
     if (SingleKey = "n")
         reload
     CoordsLocked := "Yes"
     Line3 := "Coordinates locked and valid."
     Line4 := "Do You Want to Accept default timings? Press Y/N"
     Input, SingleKey, L1, {Space}, y,n
     if (SingleKey = "n"){
             Line5 := "Input the 1st delay in xxx milliseconds"
             Input, delay1, L3
             Line5 := "Input the 2nd delay in xxx milliseconds"
             Input, delay2, L3
             Line5 := "Input the 3rd delay in xxx milliseconds"
             Input, delay3, L3
             Line5 := "Input the 4th delay in xxx milliseconds"
             Input, delay4, L3
         
         }
     else if (SingleKey != "n"){
          ; this is temp while i work out rest of script
          delay1 := 50
          delay2 := 45
          delay3 := 45
          delay4 := 45
          DelayLocked := "Yes"
           }
      Line5 := "Delay Timings are locked. Go to 1st weapon, then Press Y to craft funny gun."
 Return
     
     
     
     
}

F5:: ; press F5 to start the script
{
    start := 1
    Line3 := "THIS WILL HIDE THE MENU AND CRAFT GUN "
    Line4 := "Menu will be hidden for 15 sec."
    Line5 := " "
    start := 2
    gui, hide
    CoordMode, Mouse, Screen
    sysx := 65535//a_screenwidth
    sysy := 65535//a_screenheight
    sleep delay1
    Click
    sleep delay1
    dllcall("mouse_event", "uint", 0x8001, "uint", x1*sysx, "uint", y1*sysy) 
    sleep delay2
    Click
    sleep delay2
    dllcall("mouse_event", "uint", 0x8001, "uint", x2*sysx, "uint", y2*sysy)
    sleep delay3
    Click
    sleep delay3
    dllcall("mouse_event", "uint", 0x8001, "uint", x3*sysx, "uint", y3*sysy)
    sleep delay4
    Click
    sleep delay4
    sleep delay4
    Click
    sleep delay4
    sleep 5000
    dtsrt := 1
    gui, show, x0 y0 noactivate
}

F7:: ; shows the gui overlay
{
reload
}

F8:: ; hides the gui overlay
{
start := 2
gui, hide
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






