#Persistent
Toggle := false

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