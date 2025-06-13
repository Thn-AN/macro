    WinGet, vPID, PID, ahk_exe destiny2.exe


    MsgBox, % JEE_ProcessIsElevated(vPID)


Return
    
JEE_ProcessIsElevated(vPID)
{
	;PROCESS_QUERY_LIMITED_INFORMATION := 0x1000
	if !(hProc := DllCall("kernel32\OpenProcess", "UInt",0x1000, "Int",0, "UInt",vPID, "Ptr"))
		return -1
	;TOKEN_QUERY := 0x8
	hToken := 0
	if !(DllCall("advapi32\OpenProcessToken", "Ptr",hProc, "UInt",0x8, "Ptr*",hToken))
	{
		DllCall("kernel32\CloseHandle", "Ptr",hProc)
		return -1
	}
	;TokenElevation := 20
	vIsElevated := vSize := 0
	vRet := (DllCall("advapi32\GetTokenInformation", "Ptr",hToken, "Int",20, "UInt*",vIsElevated, "UInt",4, "UInt*",vSize))
	DllCall("kernel32\CloseHandle", "Ptr",hToken)
	DllCall("kernel32\CloseHandle", "Ptr",hProc)
	return vRet ? vIsElevated : -1
}