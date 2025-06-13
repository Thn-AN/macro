F3::
while true
{
    MouseMove, 1550 * (A_ScreenWidth / 2560), 850 * (A_ScreenHeight / 1440), 1
    Click
    Send, w
    if GetKeyState(5)
        Break
}
return

F4::reload

