;####################
; My discord is antrament - this is a server with more macro/script shit + support: https://discord.gg/KGyjysA5WY
;####################

#SingleInstance, Force
start = 0

if FileExist("ViGEmWrapper.dll") {
	FileAppend, ViGEmWrapper.dll found!`n, fishinglog.txt
}
else  {
	UrlDownloadToFile, https://github.com/Antraless/tabbed-out-fishing/raw/main/ViGEmWrapper.dll, ViGEmWrapper.dll
	UrlDownloadToFile, https://github.com/Antraless/tabbed-out-fishing/raw/main/ViGEmBus_1.21.442_x64_x86_arm64.exe, ViGEmBus_1.21.442_x64_x86_arm64.exe
	msgbox,0x40,Antra's Fishing Script, Attempting to download required files. If they do not appear join https://discord.gg/KGyjysA5WY for support.
	if (errorlevel = 1) {
		FileAppend, ViGEmWrapper.dll not found so attempted to download it and ViGEmBus_1.21.442_x64_x86_arm64.exe but something went wrong! Join https://discord.gg/KGyjysA5WY for support.`n, fishinglog.txt
		msgbox,0x30,Antra's Fishing Script, Something went wrong while trying to install required files. Please join https://discord.gg/KGyjysA5WY for support.`n`nThe script will now close itself.
	}
	else {
		FileAppend, ViGEmWrapper.dll not found so downloadeded it and ViGEmBus_1.21.442_x64_x86_arm64.exe`n, fishinglog.txt
		msgbox,0x40,Antra's Fishing Script, Required files downloaded!`n`nPlease run ViGEmBus_1.21.442_x64_x86_arm64.exe to install ViGEmBus, then open this script (tabbed-out-fishing.exe) again.
	}
	exitapp
}

; ==========================================================
;                  .NET Framework Interop
;      https://autohotkey.com/boards/viewtopic.php?t=4633
; ==========================================================
;
;   Author:     Lexikos
;   Version:    1.2
;   Requires:	AutoHotkey_L v1.0.96+
;   EDITED by Antra, this is not the original - do not reuse expecting that to be the case.
;
CLR_LoadLibrary(AssemblyName, AppDomain=0)
{
	if !AppDomain
		AppDomain := CLR_GetDefaultDomain()
	e := ComObjError(0)
	Loop 1 {
		if assembly := AppDomain.Load_2(AssemblyName)
			break
		static null := ComObject(13,0)
		args := ComObjArray(0xC, 1),  args[0] := AssemblyName
		typeofAssembly := AppDomain.GetType().Assembly.GetType()
		if assembly := typeofAssembly.InvokeMember_3("LoadWithPartialName", 0x158, null, null, args)
			break
		if assembly := typeofAssembly.InvokeMember_3("LoadFrom", 0x158, null, null, args)
			break
	}
	ComObjError(e)
	return assembly
}

CLR_CreateObject(Assembly, TypeName, Args*)
{
	if !(argCount := Args.MaxIndex())
		return Assembly.CreateInstance_2(TypeName, true)
	
	vargs := ComObjArray(0xC, argCount)
	Loop % argCount
		vargs[A_Index-1] := Args[A_Index]
	
	static Array_Empty := ComObjArray(0xC,0), null := ComObject(13,0)
	
	return Assembly.CreateInstance_3(TypeName, true, 0, null, vargs, null, Array_Empty)
}

CLR_CompileC#(Code, References="", AppDomain=0, FileName="", CompilerOptions="")
{
	return CLR_CompileAssembly(Code, References, "System", "Microsoft.CSharp.CSharpCodeProvider", AppDomain, FileName, CompilerOptions)
}

CLR_CompileVB(Code, References="", AppDomain=0, FileName="", CompilerOptions="")
{
	return CLR_CompileAssembly(Code, References, "System", "Microsoft.VisualBasic.VBCodeProvider", AppDomain, FileName, CompilerOptions)
}

CLR_StartDomain(ByRef AppDomain, BaseDirectory="")
{
	static null := ComObject(13,0)
	args := ComObjArray(0xC, 5), args[0] := "", args[2] := BaseDirectory, args[4] := ComObject(0xB,false)
	AppDomain := CLR_GetDefaultDomain().GetType().InvokeMember_3("CreateDomain", 0x158, null, null, args)
	return A_LastError >= 0
}

CLR_StopDomain(ByRef AppDomain)
{	
	DllCall("SetLastError", "uint", hr := DllCall(NumGet(NumGet(0+RtHst:=CLR_Start())+20*A_PtrSize), "ptr", RtHst, "ptr", ComObjValue(AppDomain))), AppDomain := ""
	return hr >= 0
}

CLR_Start(Version="") 
{
	static RtHst := 0
	if RtHst
		return RtHst
	EnvGet SystemRoot, SystemRoot
	if Version =
		Loop % SystemRoot "\Microsoft.NET\Framework" (A_PtrSize=8?"64":"") "\*", 2
			if (FileExist(A_LoopFileFullPath "\mscorlib.dll") && A_LoopFileName > Version)
				Version := A_LoopFileName
	if DllCall("mscoree\CorBindToRuntimeEx", "wstr", Version, "ptr", 0, "uint", 0
	, "ptr", CLR_GUID(CLSID_CorRuntimeHost, "{CB2F6723-AB3A-11D2-9C40-00C04FA30A3E}")
	, "ptr", CLR_GUID(IID_ICorRuntimeHost,  "{CB2F6722-AB3A-11D2-9C40-00C04FA30A3E}")
	, "ptr*", RtHst) >= 0
		DllCall(NumGet(NumGet(RtHst+0)+10*A_PtrSize), "ptr", RtHst) ; Start
	return RtHst
}

CLR_GetDefaultDomain()
{
	static defaultDomain := 0
	if !defaultDomain
	{
		if DllCall(NumGet(NumGet(0+RtHst:=CLR_Start())+13*A_PtrSize), "ptr", RtHst, "ptr*", p:=0) >= 0
			defaultDomain := ComObject(p), ObjRelease(p)
	}
	return defaultDomain
}

CLR_CompileAssembly(Code, References, ProviderAssembly, ProviderType, AppDomain=0, FileName="", CompilerOptions="")
{
	if !AppDomain
		AppDomain := CLR_GetDefaultDomain()
	
	if !(asmProvider := CLR_LoadLibrary(ProviderAssembly, AppDomain))
	|| !(codeProvider := asmProvider.CreateInstance(ProviderType))
	|| !(codeCompiler := codeProvider.CreateCompiler())
		return 0

	if !(asmSystem := (ProviderAssembly="System") ? asmProvider : CLR_LoadLibrary("System", AppDomain))
		return 0
	
	StringSplit, Refs, References, |, %A_Space%%A_Tab%
	aRefs := ComObjArray(8, Refs0)
	Loop % Refs0
		aRefs[A_Index-1] := Refs%A_Index%
	
	prms := CLR_CreateObject(asmSystem, "System.CodeDom.Compiler.CompilerParameters", aRefs)
	, prms.OutputAssembly          := FileName
	, prms.GenerateInMemory        := FileName=""
	, prms.GenerateExecutable      := SubStr(FileName,-3)=".exe"
	, prms.CompilerOptions         := CompilerOptions
	, prms.IncludeDebugInformation := true
	
	compilerRes := codeCompiler.CompileAssemblyFromSource(prms, Code)
	
	if error_count := (errors := compilerRes.Errors).Count
	{
		error_text := ""
		Loop % error_count
			error_text .= ((e := errors.Item[A_Index-1]).IsWarning ? "Warning " : "Error ") . e.ErrorNumber " on line " e.Line ": " e.ErrorText "`n`n"
		MsgBox, 16, Compilation Failed, %error_text%
		return 0
	}
	return compilerRes[FileName="" ? "CompiledAssembly" : "PathToAssembly"]
}

CLR_GUID(ByRef GUID, sGUID)
{
	VarSetCapacity(GUID, 16, 0)
	return DllCall("ole32\CLSIDFromString", "wstr", sGUID, "ptr", &GUID) >= 0 ? &GUID : ""
}
; ==========================================================
;                     AHK-ViGEm-Bus
;          https://github.com/evilC/AHK-ViGEm-Bus
; ==========================================================
;
;   Author:     evilC
;   EDITED by Antra, this is not the original script - do not reuse expecting that to be the case.
;
class ViGEmWrapper {
	static asm := 0
	static client := 0
	
	Init(){
		if (this.client == 0){
			this.asm := CLR_LoadLibrary("ViGEmWrapper.dll")
		}
	}
	
	CreateInstance(cls){
		return this.asm.CreateInstance(cls)
	}

}

; Base class for ViGEm "Targets" (Controller types - eg xb360 / ds4) to inherit from
class ViGEmTarget {
	target := 0
	helperClass := ""
	controllerClass := ""

	__New(){
		ViGEmWrapper.Init()
		this.Instance := ViGEmWrapper.CreateInstance(this.helperClass)
		
		if (this.Instance.OkCheck() != "OK"){
			msgbox,0x30,Antra's Fishing Script, ViGEmWrapper.dll failed to load!`n`nIf you unzipped ViGEmWrapper.dll, that corrupted it. Delete ViGEmWrapper.dll and then run tabbed-out-fishing. The script will automatically download a new ViGEmWrapper.dll for you.`n`nOtherwise, something is horribly wrong. Ask for help here: https://discord.gg/KGyjysA5WY
			ExitApp
		}
	}
	
	SendReport(){
		this.Instance.SendReport()
	}
	
	SubscribeFeedback(callback){
		this.Instance.SubscribeFeedback(callback)
	}
}

; Xb360
class ViGEmXb360 extends ViGEmTarget {
	helperClass := "ViGEmWrapper.Xb360"
	__New(){
		static buttons := {A: 4096, B: 8192, X: 16384, Y: 32768, LB: 256, RB: 512, LS: 64, RS: 128, Back: 32, Start: 16, Xbox: 1024}
		static axes := {LX: 2, LY: 3, RX: 4, RY: 5, LT: 0, RT: 1}
		
		this.Buttons := {}
		for name, id in buttons {
			this.Buttons[name] := new this._ButtonHelper(this, id)
		}
		
		this.Axes := {}
		for name, id in axes {
			this.Axes[name] := new this._AxisHelper(this, id)
		}
		
		this.Dpad := new this._DpadHelper(this)
		
		base.__New()
	}
	
	class _ButtonHelper {
		__New(parent, id){
			this._Parent := parent
			this._Id := id
		}
		
		SetState(state){
			this._Parent.Instance.SetButtonState(this._Id, state)
			this._Parent.Instance.SendReport()
			return this._Parent
		}
	}
	
	class _AxisHelper {
		__New(parent, id){
			this._Parent := parent
			this._id := id
		}
		
		SetState(state){
			this._Parent.Instance.SetAxisState(this._Id, this.ConvertAxis(state))
			this._Parent.Instance.SendReport()
		}
		
		ConvertAxis(state){
			value := round((state * 655.36) - 32768)
			if (value == 32768)
				return 32767
			return value
		}
	}
	
	class _DpadHelper {
		_DpadStates := {1:0, 8:0, 2:0, 4:0} ; Up, Right, Down, Left
		__New(parent){
			this._Parent := parent
		}
		
		SetState(state){
			static dpadDirections := { None: {1:0, 8:0, 2:0, 4:0}
				, Up: {1:1, 8:0, 2:0, 4:0}
				, UpRight: {1:1, 8:1, 2:0, 4:0}
				, Right: {1:0, 8:1, 2:0, 4:0}
				, DownRight: {1:0, 8:1, 2:1, 4:0}
				, Down: {1:0, 8:0, 2:1, 4:0}
				, DownLeft: {1:0, 8:0, 2:1, 4:1}
				, Left: {1:0, 8:0, 2:0, 4:1}
				, UpLeft: {1:1, 8:0, 2:0, 4:1}}
			newStates := dpadDirections[state]
			for id, newState in newStates {
				oldState := this._DpadStates[id]
				if (oldState != newState){
					this._DpadStates[id] := newState
					this._Parent.Instance.SetButtonState(id, newState)
				}
				this._Parent.SendReport()
			}
		}
	}
}

; ==========================================================
;                  ShinsImageScanClass
;      https://github.com/Spawnova/ShinsImageScanClass
; ==========================================================
;
;   Author: Spawnova
;   EDITED by Antra, this is not the original script - do not reuse expecting that to be the case. I really cut the shit out of this one, lol.
;
class ShinsImageScanClass {
	__New(title:=0, UseClientArea:=1) {
		this.AutoUpdate 		:= 1 
		this.UseControlClick 	:= 0  
		this.WindowScale 		:= 1	
		this.LoadLib("gdiplus")
		VarSetCapacity(gsi, 24, 0)
		NumPut(1,gsi,0,"uint")
		DllCall("gdiplus\GdiplusStartup", "Ptr*", token, "Ptr", &gsi, "Ptr", 0)
		this.gdiplusToken := token
		this.bits := (a_ptrsize == 8) ;0=32,1=64
		this.desktop := (title = 0 or title = "")
		this.UseClientArea := UseClientArea
		this.imageCache := []
		this.offsetX := 0
		this.offsetY := 0
		if (this.desktop)
			coordmode,mouse,screen
		else if (UseClientArea)
			coordmode,mouse,client
		else
			coordmode,mouse,window
		this.tBufferPtr := tBufferPtr := this.SetVarCapacity("ttBuffer",1048576,0)
		this.dataPtr := dataPtr := this.SetVarCapacity("_data",1024,0)
		this._scanPixelCountRegion := this.mcode("VVdWU4PsKItEJEyLdCREi1wkVItUJEABxotMJFCIHCSJdCQUhcB5DItEJESJdCREiUQkFIt0JEgBzol0JBCFyXkMi0QkSIl0JEiJRCQQi0wkRIXJD4jGAQAAi0QkSIXAD4i6AQAAi0QkPItMJBSLbCQQi3AIOc6NRv+JdCQYD0fBiUQkFInHi0QkPItADI1I/znoD0fNiUwkEITbD4TuAAAAOUwkSA+NagEAAInQD690JEjB6BAPtsCJRCQED7bGiUQkCItEJESJdCQcMfbB4AKJRCQkjQS9AAAAAIlEJCAPtsKJRCQMifaNvCcAAAAAi0QkFDlEJER9bItEJDyLXCQkiyiLRCQcweACAcMB6wNsJCABxY12AIsTD7bOK0wkCInQD7bSic/B+BDB/x8PtsArRCQEMfkp+YnHwf8fMfgp+DjID0fIK1QkDInXwf8fMfop+jjRD0PROBQkg97/g8MEOd11sotcJBiDRCRIAQFcJByLRCQQO0QkSA+Fb////4nwg8QoW15fXcOQjXQmADlMJEgPjXwAAACLRCREi3wkSItsJEjB4AIPr/6JRCQEi0QkFMHgAokEJDHAjXQmAIt0JBQ5dCREfTeLdCQ8i0wkBIsejTS9AAAAAAHxAdkDHCQB3o10JgCLGYHj////ADnaD5TDg8EED7bbAdg58XXng8UBA3wkGDlsJBB1soPEKFteX13Dg8QoMcBbXl9dw7j9////6Vn///+QkJCQkJA=|QVdBVkFVQVRVV1ZTSIPsGIuEJJAAAABBicREiUQkcESLhCSAAAAARIt0JHBIiUwkYIuMJIgAAABFAcZFhcB5DUSLRCRwRIl0JHBFicZGjTwJhcl5CUSJyUWJ+UGJz4tMJHCFyQ+IggEAAEWFyQ+IeQEAAEiLdCRgi14QjUv/RDnziVwkCEQPRvGLThREjUH/RDn5RQ9G+ITAD4TZAAAARTn5D409AQAAi3wkcIneidUPtsZBD6/xwe0QQYnFD7baRCn3QA+27THAiXwkDEQB9kQ5dCRwfXlIi3wkYItMJAxIiz9EjRQxZg8fhAAAAAAARInSiwyXD7bVRCnqQYnQQcH4H0QxwkQpwkGJ0InKD7bJwfoQD7bSKepBidNBwfsfRDHaRCnaRDjCQQ9G0CnZQYnIQcH4H0QxwUQpwTjKD0LRQTjUg9j/QYPCAUQ51nWgQYPBAQN0JAhFOc8PhW////9Ig8QYW15fXUFcQV1BXkFfw2YPH0QAAEU5+X1oQYnaid6LXCRwSItsJGBFD6/Ri3wkcDHARCnzRQHyDx9EAABEOfd9L0yLXQBCjQwTDx8AQYnIR4sEg0GB4P///wBEOcJBD5TAg8EBRQ+2wEQBwEE5ynXcQYPBAUEB8kU5z3XA6Xz///8xwOl1////uP3////pa////5CQkJCQkJCQkJA=")
		
		if (!this.desktop and !this.hwnd := winexist(title)) { ; this script made by antra :)
			msgbox % "Could not find window: " title "!`n`nScanner will not function!"
			return
		}
		if (!this.GetRect(gw,gh))
			return
		
		this.width := gw
		this.height := gh
		this.srcDC := DllCall("GetDCEx", "Ptr", (this.desktop ? 0 : this.hwnd),"Uint",0,"Uint",(this.UseClientArea ? 0 : 1))
		this.dstDC := DllCall("CreateCompatibleDC", "Ptr", 0)
		NumPut(tBufferPtr,dataPtr+0,(this.bits ? 8 : 4),"Ptr")
		this.CreateDIB()
		
	}
	
	PixelCountRegion(color,x1,y1,w,h,variance=0) {
		if (this.AutoUpdate)
			this.Update(x1,y1,w,h)
		c := DllCall(this._ScanPixelCountRegion,"Ptr",this.dataPtr,"Uint",color&0xFFFFFF,"int",(this.autoUpdate?0:x1),"int",(this.autoUpdate?0:y1),"int",w,"int",h,"uchar",variance,"int") ; this script made by antra <3
		return (c > 0 ? c : 0)
	}
	
	CheckWindow() {
		if (this.desktop)
			return 1

		if (this.UseClientArea and !this.GetClientRect(w,h))
			return 0
		else if (!this.UseClientArea and !this.GetWindowRect(w,h))
			return 0
			
		if (w != this.width or h != this.height) {
			this.width := w
			this.height := h
			DllCall("DeleteObject","Ptr",this.hbm)
			this.CreateDIB()
		}
		return 1
	}
	CreateDIB() {
		VarSetCapacity(_scan,8)
		VarSetCapacity(bi,40,0)
		NumPut(this.width,bi,4,"int")
		NumPut(-this.height,bi,8,"int")
		NumPut(40,bi,0,"uint")
		NumPut(1,bi,12,"ushort")
		NumPut(32,bi,14,"ushort")
		this.hbm := DllCall("CreateDIBSection", "Ptr", this.dstDC, "Ptr", &bi, "uint", 0, "Ptr*", _scan, "Ptr", 0, "uint", 0, "Ptr")
		this.temp0 := _scan
		NumPut(_scan,this.dataPtr,0,"Ptr")
		NumPut(this.width,this.dataPtr,(this.bits ? 16 : 8),"uint")
		NumPut(this.height,this.dataPtr,(this.bits ? 20 : 12),"uint")
		DllCall("SelectObject", "Ptr", this.dstDC, "Ptr", this.hbm)
	}
	SetVarCapacity(key,size,fill=0) {
		this.SetCapacity(key,size)
		DllCall("RtlFillMemory","Ptr",this.GetAddress(key),"Ptr",size,"uchar",fill)
		return this.GetAddress(key)
	} ; this script made by antra :3
	Update(x:=0,y:=0,w:=0,h:=0,applyOffset:=1) {
		if (this.CheckWindow()) {
			if (applyOffset) {
				this.offsetX := x
				this.offsetY := y
			} else {
				this.offsetX := 0
				this.offsetY := 0
			}
			DllCall("gdi32\BitBlt", "Ptr", this.dstDC, "int", 0, "int", 0, "int", (w?w:this.width), "int", (h?h:this.height), "Ptr", this.srcDC, "int", x, "int", y, "uint", 0xCC0020) ;40
		}
	}
	GetRect(ByRef w, ByRef h) {
		if (this.desktop) {
			w := dllcall("GetSystemMetrics","int",78)
			h := dllcall("GetSystemMetrics","int",79)
			return 1
		}
		if (this.UseClientArea) {
			if (!this.GetClientRect(w,h)) {
				msgbox % "Problem with Client rectangle dimensions, is window minimized?`n`nScanner will not function!"
				return 0
			}
		} else {
			if (!this.GetWindowRect(w,h)) {
				msgbox % "Problem with Window rectangle dimensions, is window minimized?`n`nScanner will not function!"
				return 0
			}
		}
		return 1
	}
	Mcode(str) {
		local
		s := strsplit(str,"|")
		if (s.length() != 2)
			return
		if (!DllCall("crypt32\CryptStringToBinary", "str", s[this.bits+1], "uint", 0, "uint", 1, "ptr", 0, "uint*", pp, "ptr", 0, "ptr", 0))
			return
		p := DllCall("GlobalAlloc", "uint", 0, "ptr", pp, "ptr")
		if (this.bits)
			DllCall("VirtualProtect", "ptr", p, "ptr", pp, "uint", 0x40, "uint*", op)
		if (DllCall("crypt32\CryptStringToBinary", "str", s[this.bits+1], "uint", 0, "uint", 1, "ptr", p, "uint*", pp, "ptr", 0, "ptr", 0))
			return p
		DllCall("GlobalFree", "ptr", p)
	}
	LoadLib(lib*) {
		for k,v in lib
			if (!DllCall("GetModuleHandle", "str", v, "Ptr"))
				DllCall("LoadLibrary", "Str", v) 
	}
}

; ==========================================================
;                  The script (oh no)
;      https://discord.gg/KGyjysA5WY https://github.com/Antraless/tabbed-out-fishing
; ==========================================================
scan := New ShinsImageScanClass() ; make da scanny scanner from the class above

return 

;determine_brightness:
;start = 2
;	loop {
;		controller.buttons.y.setstate(true)
;		sleep 50
;		controller.buttons.y.setstate(false)
;		; all hex values of the grey surrounding the x from 7 to 1 brightness
;		loop, 10 {
;		hexvalues := ["0x5B5B5B", "0x555555", "0x4D4D4D", "0x444444", "0x393939", "0x2C2C2C", "0x212121"]
;			for index, hex in hexvalues {
;				if (scan.pixelcountregion(hex, startwidth, startheight, regionwidth, regionheight) > threshold) {
;					start = 5
;					gosub, search_for_x
;				}
;			}
;		}
;		start = 3
;	}
;return

search_for_x:
    loop {
        ; TODO: replace with percentage values based off screen dimensions
        if (scan.pixelcountregion(0xFFFFFF, 1390, 150, 485, 100, variance=10) < 10) {
            tooltip, waiting for join
        } else {
            tooltip, join found!
        }
    }
return


f2::exitapp
f3::reload
f4::
{	
	FileAppend, starting script - for support join: https://discord.gg/KGyjysA5WY`n, fishinglog.txt
	wingetpos, x, y, w, h, ahk_exe destiny2.exe
	; why do this here? i dont know, i dont care
	threshold := 20
	startwidth := 10
	startheight := 10
	regionwidth := w*0.35
	regionheight := h*0.25
	start = 5
	hex := 0x73B9A0
	gosub, search_for_x
}
f8::
{
    WinGetPos,,, Width, Height, ahk_exe destiny2.exe
    WinMove, ahk_exe destiny2.exe,, (A_ScreenWidth/2)-(Width/2), (A_ScreenHeight/2)-(Height/2)
	FileAppend, Centred window`n, fishinglog.txt
}