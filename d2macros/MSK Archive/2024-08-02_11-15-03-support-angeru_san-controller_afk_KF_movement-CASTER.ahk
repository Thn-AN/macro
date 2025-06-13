#SingleInstance, Force
#Persistent
#include <AHK-ViGEm-Bus>

; Create a new Xbox 360 controller
controller := new ViGEmXb360()
return

f8::
Loop, 
{
    controller.Axes.RT.SetState(true)
    Sleep, 100
    controller.Axes.RT.SetState(false) 
    Sleep, 500
    controller.Axes.LY.SetState(0)
    Sleep, 1000
    controller.Axes.LY.SetState(50)
    Sleep, 2000
}
Return

f10::ExitApp