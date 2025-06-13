    WinGet, Destiny2PID, PID, ahk_exe destiny2.exe

    IsProcessElevated(Destiny2PID)
    if(IsElevated) {
        msgbox balls
    } else {
        msgbox cum
    }
Return
    
IsProcessElevated(ProcessID) ; check if destiny is admin
{
if !(hProcess := DllCall("OpenProcess", "uint", 0x1000, "int", 0, "uint", ProcessID, "ptr"))
    throw Exception("OpenProcess failed", -1)
if !(DllCall("advapi32\OpenProcessToken", "ptr", hProcess, "uint", 0x0008, "ptr*", hToken))
    throw Exception("OpenProcessToken failed", -1), DllCall("CloseHandle", "ptr", hProcess)
if !(DllCall("advapi32\GetTokenInformation", "ptr", hToken, "int", 20, "uint*", IsElevated, "uint", 4, "uint*", size))
    throw Exception("GetTokenInformation failed", -1), DllCall("CloseHandle", "ptr", hToken) && DllCall("CloseHandle", "ptr", hProcess)
return IsElevated, DllCall("CloseHandle", "ptr", hToken) && DllCall("CloseHandle", "ptr", hProcess)
}