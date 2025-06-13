speed := 1
delay := 100

Esc::
Reload
return


[::
loop 10
{
    Send {o}
    Sleep, delay
}
MouseMove, 28, 1043 , speed
Sleep, delay
Send, {Lbutton Down}{Lbutton Up}
Sleep, delay
MouseMove, 1220, 420, speed
Sleep, delay
Send {WheelDown 2000}
Sleep, delay
Send, {Lbutton Down}{Lbutton Up}
Sleep, delay
MouseMove, 1343, 180, speed
Sleep, delay
Send, {Lbutton Down}{Lbutton Up}
Sleep, delay
MouseMove, 878, 181, speed
Sleep, delay
Send, {Lbutton Down}{Lbutton Up}
