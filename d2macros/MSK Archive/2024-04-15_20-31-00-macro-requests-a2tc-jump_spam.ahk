#SingleInstance, Force
SendMode Input
SetKeyDelay, 0, 0

keyName = F3

Hotkey, %keyName%, doJump

doJump:
{
    While getkeystate(keyName, "P") 
    {
        Send, {space Down}
        Sleep, 10
        Send, {space Up}
        Sleep, 20
    }
}
