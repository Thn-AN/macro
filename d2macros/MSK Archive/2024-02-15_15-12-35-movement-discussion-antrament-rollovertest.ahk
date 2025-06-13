F10::
Loop, 26
{
    key := Chr(A_Index + 96) ; Convert index to ASCII character code
    SendInput, %key%
    Sleep, 50 ; Adjust the delay if necessary
}
return