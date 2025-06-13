speed := 2
delay := 100

Esc::
Reload
return


[::
loop 5{
    Send {O}
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
Sleep, 2000
Loop     				; Infinite loop
{
    idx_char := 1
    coord_multi := 0

    init:
    loop 4
    {
        Send % idx_char
        MouseMove, 830 - (coord_multi * 0.005), 579 + coord_multi, speed
        Send {Lbutton Down}{Lbutton Up}
        Sleep, delay
        Send {t}
        Sleep, delay
        
        loop 4
        {
            Send % idx_char
            MouseMove, 60, 0, speed, R
            Send {Lbutton Down}{Lbutton Up}
            Sleep, delay
            Send {t}
            Sleep, delay
            Send {q}
        }

        idx_char := Mod(idx_char, 4) + 1
        coord_multi := Mod(coord_multi, 300) + 75
        ImageSearch, Px, Py, 345, 782, 985, 828, C:\Users\Pie\Documents\Macro Recorder\tools\retry.png
        If ErrorLevel = 0
            Sleep, delay
            MouseMove, 1178, 839, speed
            Sleep, delay
            Send {Lbutton Down}{Lbutton Up}
            Sleep, delay
            Mousemove, 878, 181, speed
            Sleep, 800
            Send {Lbutton Down}{Lbutton Up}
            Goto, init
    }
}
return