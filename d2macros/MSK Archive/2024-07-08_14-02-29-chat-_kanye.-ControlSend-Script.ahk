F3::
if WinExist("*New Text Document.txt - Notepad")
{
    ControlSend, Edit1, f, *New Text Document.txt - Notepad
}
else
{
    MsgBox, no window found bruvva.
}
return
