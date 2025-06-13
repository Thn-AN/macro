#Persistent
Toggle := false


Numpad5::
Toggle := !Toggle
if (Toggle)
{
    SetTimer, Enchanting, 0
}
else
{
    SetTimer, Stop, Off
}
return

Enchanting:
if (Toggle)
{
    MouseMove 813, 704
    Send, {Shift down}
    MouseClick, left, 813, 704
    Send {Shift up}
    sleep 125
    MouseClick, left, 1012, 464
    Sleep 125
    Send {Shift down}
    MouseClick, left, 837, 445
    Send {Shift up}
    Sleep 100
}
return
Stop:
if (!Toggle)
{
    Send {Shift up}
}
return

Numpad6::
Toggle := !Toggle
if (Toggle)
{
    SetTimer, HoldLMB, 10
}
else
{
    SetTimer, ReleaseLMB, 10
}
return

HoldLMB:
if (Toggle)
{
    Click, Left
    Sleep, 1500
}
return

ReleaseLMB:
if (!Toggle)
{
    Click, Left, Up
    SetTimer, ReleaseLMB, Off
}
return

Numpad7::
Toggle := !Toggle
if (Toggle)
{
    SetTimer, HoldRMB, 10
}
else
{
    SetTimer, ReleaseRMB, 10
}
return

HoldRMB:
if (Toggle)
{
    Click, Right, Down
}
return

ReleaseRMB:
if (!Toggle)
{
    Click, Right, Up
    SetTimer, ReleaseRMB, Off
}
return

Numpad8::ExitApp