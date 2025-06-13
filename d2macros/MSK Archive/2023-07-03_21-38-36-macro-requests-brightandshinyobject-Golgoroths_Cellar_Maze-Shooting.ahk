;	░█████╗░░█████╗░████████╗███╗░░██╗██╗██████╗░
;	██╔══██╗██╔══██╗╚══██╔══╝████╗░██║██║██╔══██╗
;	██║░░╚═╝███████║░░░██║░░░██╔██╗██║██║██████╔╝
;	██║░░██╗██╔══██║░░░██║░░░██║╚████║██║██╔═══╝░
;	╚█████╔╝██║░░██║░░░██║░░░██║░╚███║██║██║░░░░░
;	░╚════╝░╚═╝░░╚═╝░░░╚═╝░░░╚═╝░░╚══╝╚═╝╚═╝░░░░░
;	░█████╗░███╗░░██╗██████╗░
;	██╔══██╗████╗░██║██╔══██╗
;	███████║██╔██╗██║██║░░██║
;	██╔══██║██║╚████║██║░░██║
;	██║░░██║██║░╚███║██████╔╝
;	╚═╝░░╚═╝╚═╝░░╚══╝╚═════╝░
;	███╗░░░███╗██╗██╗░░░░░██╗░░██╗░░░░█████╗░░█████╗░███╗░░░███╗
;	████╗░████║██║██║░░░░░██║░██╔╝░░░██╔══██╗██╔══██╗████╗░████║
;	██╔████╔██║██║██║░░░░░█████═╝░░░░██║░░╚═╝██║░░██║██╔████╔██║
;	██║╚██╔╝██║██║██║░░░░░██╔═██╗░░░░██║░░██╗██║░░██║██║╚██╔╝██║
;	██║░╚═╝░██║██║███████╗██║░╚██╗██╗╚█████╔╝╚█████╔╝██║░╚═╝░██║
;	╚═╝░░░░░╚═╝╚═╝╚══════╝╚═╝░░╚═╝╚═╝░╚════╝░░╚════╝░╚═╝░░░░░╚═╝
;
;@Ahk2Exe-SetName GolgorothsCellarAFK.exe
;@Ahk2Exe-SetDescription Farms XP in Golgoroth's Cellar.
;@Ahk2Exe-SetCopyright CatnipandMilk © 2022
;@Ahk2Exe-SetCompanyName Catnip and Milk

; Youtube Video: https://youtu.be/xGR2RWYFvQU
; Discord: https://discord.gg/r9DXzAr5sW

ToolTip, Press F1 to start, F2 to pause, and F3 to exit!
SetTimer, RemoveToolTip, -5000
return

F2:: pause, toggle

F1::
loop,
{
	Send {lbutton down}
    Sleep, 800
	Send {lbutton up}
; This is where we set the mouse to move slightly to the right: (3) pixels  
    MouseMove, 3, 45, 5, R
; If that is too much, lower the first number (3)
    Sleep, 400
    MouseMove, 0, -50, 5, R
    Sleep, 2600
    Continue
return
}

RemoveToolTip:
ToolTip
return

F3::
ExitApp
