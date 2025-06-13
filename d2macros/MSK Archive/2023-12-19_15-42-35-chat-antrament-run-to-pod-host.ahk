#noenv
#singleinstance force
sendmode input
return

get_in_host_pod:
Send {W down}
Send {LShift down}
Sleep 50
Send {LShift up}
Sleep 3200
Send {Space down}
Sleep 1000
Send {Space up}
Sleep 5000
Send {W up}
Send {A down}
Sleep 3000
Send {A up}
Send {E down}
Sleep 1500
Send {E up}
DllCall("mouse_event", "UInt", 0x01, "UInt", -200, "UInt", 0)
Send {W down}
Send {LShift down}
Sleep 50
Send {LShift up}
Sleep 6000
Send {W up}
Send {E down}
Sleep 1500
Send {E up}
return

f3::reload
f4:: 
{

    gosub, get_in_host_pod

}


