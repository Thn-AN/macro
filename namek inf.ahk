speed := 5
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


Loop
{
    idx_char := 1
    coord_multi := 0

    init:
    loop 4
    {
        Send % idx_char
        MouseMove, 830 - (coord_multi * 0.1), 579 + coord_multi*0.8, speed
        Send {Lbutton Down}{Lbutton Up}
        Sleep, delay
        Send {t}
        Sleep, delay
        
        loop 4
        {
            Send % idx_char
            MouseMove, 60+(coord_multi*0.005), 0, speed, R
            Send {Lbutton Down}{Lbutton Up}
            Sleep, delay
            Send {t}
            Sleep, delay
            Send {q}
        }

        idx_char := Mod(idx_char, 4) + 1
        coord_multi := Mod(coord_multi, 300) + 75
        MouseMove, 1178, 839, speed
        Send {Lbutton Down}{Lbutton Up}
        Mousemove, 878, 181, speed
        Send {Lbutton Down}{Lbutton Up}
    }
}
return