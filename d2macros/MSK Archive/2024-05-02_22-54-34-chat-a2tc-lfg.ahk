F5::
    {
        Click 
        Click 
        Click
        Send, ^c
        text := Clipboard

        pos := InStr(text, "/join ")

        text := Substr(text, pos)
        
        RegExMatch(text, "i)/join .+#\d{4}", match)
        text := Substr(text, 1, StrLen(match))

        Clipboard := text

        WinActivate, Destiny 2
        Send, {enter}
        Send, ^v
        Send, {enter}
    }
Return

F4::Reload