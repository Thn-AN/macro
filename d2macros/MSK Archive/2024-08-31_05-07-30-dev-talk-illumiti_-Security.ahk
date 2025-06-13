#SingleInstance, Force ; doesn't allow opening multiple instances
#Persistent ; keeps script running 
#include <AHK-ViGEm-Bus> ; includes ViGEm library which allows the controller to work

controller := new ViGEmXb360() ; controller setup
return

4::
{
    sleep 1000
    controller.Buttons.LB.SetState(true) ; left bumper on 
    sleep 100
    controller.Buttons.RB.SetState(true) ; right bumper on
    sleep 100
    controller.Buttons.LB.SetState(false) ; left off
    sleep 100
    controller.Buttons.RB.SetState(false) ; right off
    return
}

^7::reload ; reload/refresh macro
^8::exitapp ; close