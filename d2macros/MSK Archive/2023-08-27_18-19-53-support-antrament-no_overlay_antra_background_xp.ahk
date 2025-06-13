; <3 from antra! https://discord.gg/KGyjysA5WY
#noenv ; improves performance by maybe like 0.01% by not loading environment variables
#singleinstance force ; only allow one of this script to be open at once
#persistent ; run the script until an exitapp is encountered
#ifwinactive ahk_exe destiny2.exe ; only have hotkeys work if d2 is active
setbatchlines, -1 ; never automatically sleep, not really necessary here but who cares
setworkingdir %a_scriptdir% ; read files from the scripts directory


if FileExist("ViGEmWrapper.dll") {
}
else  {
	UrlDownloadToFile, https://github.com/Antraless/tabbed-out-fishing/raw/main/ViGEmWrapper.dll, ViGEmWrapper.dll
	UrlDownloadToFile, https://github.com/Antraless/tabbed-out-fishing/raw/main/ViGEmBus_1.21.442_x64_x86_arm64.exe, ViGEmBus_1.21.442_x64_x86_arm64.exe
	msgbox,0x40,Antra's Background XP Script, Attempting to download required files.`n`nIf they do not appear join https://discord.gg/KGyjysA5WY for support.
	if (errorlevel = 1) {
		msgbox,0x30,Antra's Background XP Script, Something went wrong while trying to install required files.`n`nPlease join https://discord.gg/KGyjysA5WY for support.`n`nThe script will now close itself.
	}
	else {
		msgbox,0x40,Antra's Background XP Script, Required files downloaded!`n`nPlease run ViGEmBus_1.21.442_x64_x86_arm64.exe to install ViGEmBus, then open this script (antra_background_xp) again.
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
			msgbox,0x30,Antra's Background XP Script, ViGEmWrapper.dll failed to load!`n`nAsk for help here: https://discord.gg/KGyjysA5WY
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
;                  shinsoverlayclass
;      https://github.com/Spawnova/ShinsOverlayClass
; ==========================================================
;
;   Author: Spawnova
;   
;
; Direct2d overlay class by Spawnova (5/27/2022)
; https://github.com/Spawnova/ShinsOverlayClass
;
;
; Special thanks to teadrinker for helping me understand some 64bit param structures! -> https://www.autohotkey.com/boards/viewtopic.php?f=76&t=105420


class ShinsOverlayClass {

	;x_orTitle					:		x pos of overlay OR title of window to attach to
	;y_orClient					:		y pos of overlay OR attach to client instead of window (default window)
	;width_orForeground			:		width of overlay OR overlay is only drawn when the attached window is in the foreground (default 1)
	;height						:		height of overlay
	;alwaysOnTop				:		If enabled, the window will always appear over other windows
	;vsync						:		If enabled vsync will cause the overlay to update no more than the monitors refresh rate, useful when looping without sleeps
	;clickThrough				:		If enabled, mouse clicks will pass through the window onto the window beneath
	;taskBarIcon				:		If enabled, the window will have a taskbar icon
	;guiID						:		name of the ahk gui id for the overlay window, if 0 defaults to "ShinsOverlayClass_TICKCOUNT"
	;
	;notes						:		if planning to attach to window these parameters can all be left blank
	
	__New(x_orTitle:=0,y_orClient:=1,width_orForeground:=1,height:=0,alwaysOnTop:=1,vsync:=0,clickThrough:=1,taskBarIcon:=0,guiID:=0) {
	
	
		;[input variables] you can change these to affect the way the script behaves
		
		this.interpolationMode := 0 ;0 = nearestNeighbor, 1 = linear ;affects DrawImage() scaling 
		this.data := []				;reserved name for general data storage
	
	
		;[output variables] you can read these to get extra info, DO NOT MODIFY THESE
		
		this.x := x_orTitle					;overlay x position OR title of window to attach to
		this.y := y_orClient				;overlay y position OR attach to client area
		this.width := width_orForeground	;overlay width OR attached overlay only drawn when window is in foreground
		this.height := height				;overlay height
		this.x2 := x_orTitle+width_orForeground
		this.y2 := y_orClient+height
		this.attachHWND := 0				;HWND of the attached window, 0 if not attached
		this.attachClient := 0				;1 if using client space, 0 otherwise
		this.attachForeground := 0			;1 if overlay is only drawn when the attached window is the active window; 0 otherwise
		
		;Generally with windows there are invisible borders that allow
		;the window to be resized, but it makes the window larger
		;these values should contain the window x, y offset and width, height for actual postion and size
		this.realX := 0
		this.realY := 0
		this.realWidth := 0
		this.realHeight := 0
		this.realX2 := 0
		this.realY2 := 0
	
	
	
	
	
	
		;#############################
		;	Setup internal stuff
		;#############################
		this.bits := (a_ptrsize == 8)
		this.imageCache := []
		this.fonts := []
		this.lastPos := 0
		this.offX := -x_orTitle
		this.offY := -y_orClient
		this.lastCol := 0
		this.drawing := 0
		this.guiID := guiID := (guiID = 0 ? "ShinsOverlayClass_" a_tickcount : guiID)
		this.owned := 0
		this.alwaysontop := alwaysontop
		
		this._cacheImage := this.mcode("VVdWMfZTg+wMi0QkLA+vRCQoi1QkMMHgAoXAfmSLTCQki1wkIA+26gHIiUQkCGaQD7Z5A4PDBIPBBIn4D7bwD7ZB/g+vxpn3/YkEJA+2Qf0Pr8aZ9/2JRCQED7ZB/A+vxpn3/Q+2FCSIU/wPtlQkBIhT/YhD/on4iEP/OUwkCHWvg8QMifBbXl9dw5CQkJCQ|V1ZTRTHbRItUJEBFD6/BRo0MhQAAAABFhcl+YUGD6QFFD7bSSYnQQcHpAkqNdIoERQ+2WANBD7ZAAkmDwARIg8EEQQ+vw5lB9/qJx0EPtkD9QQ+vw5lB9/pBicFBD7ZA/ECIefxEiEn9QQ+vw0SIWf+ZQff6iEH+TDnGdbNEidhbXl/DkJCQkJCQkJCQkJCQ")
		
		this.LoadLib("d2d1","dwrite","dwmapi","gdiplus")
		VarSetCapacity(gsi, 24, 0)
		NumPut(1,gsi,0,"uint")
		DllCall("gdiplus\GdiplusStartup", "Ptr*", token, "Ptr", &gsi, "Ptr", 0)
		this.gdiplusToken := token
		this._guid("{06152247-6f50-465a-9245-118bfd3b6007}",clsidFactory)
		this._guid("{b859ee5a-d838-4b5b-a2e8-1adc7d93db48}",clsidwFactory)
		
		if (clickThrough)
			gui %guiID%: +hwndhwnd -Caption +E0x80000 +E0x20
		else
			gui %guiID%: +hwndhwnd -Caption +E0x80000
		if (alwaysOnTop)
			gui %guiID%: +AlwaysOnTop
		if (!taskBarIcon)
			gui %guiID%: +ToolWindow
		
		this.hwnd := hwnd
		DllCall("ShowWindow","Uptr",this.hwnd,"uint",(clickThrough ? 8 : 1))

		this.tBufferPtr := this.SetVarCapacity("ttBuffer",4096)
		this.rect1Ptr := this.SetVarCapacity("_rect1",64)
		this.rect2Ptr := this.SetVarCapacity("_rect2",64)
		this.rtPtr := this.SetVarCapacity("_rtPtr",64)
		this.hrtPtr := this.SetVarCapacity("_hrtPtr",64)
		this.matrixPtr := this.SetVarCapacity("_matrix",64)
		this.colPtr := this.SetVarCapacity("_colPtr",64)
		this.clrPtr := this.SetVarCapacity("_clrPtr",64)
		VarSetCapacity(margins,16)
		NumPut(-1,margins,0,"int"), NumPut(-1,margins,4,"int"), NumPut(-1,margins,8,"int"), NumPut(-1,margins,12,"int")
		ext := DllCall("dwmapi\DwmExtendFrameIntoClientArea","Uptr",hwnd,"ptr",&margins,"uint")
		if (ext != 0) {
			this.Err("Problem with DwmExtendFrameIntoClientArea","overlay will not function`n`nReloading the script usually fixes this`n`nError: " DllCall("GetLastError","uint") " / " ext)
			return
		}
		DllCall("SetLayeredWindowAttributes","Uptr",hwnd,"Uint",0,"char",255,"uint",2)
		if (DllCall("d2d1\D2D1CreateFactory","uint",1,"Ptr",&clsidFactory,"uint*",0,"Ptr*",factory) != 0) {
			this.Err("Problem creating factory","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
			return
		}
		this.factory := factory
		NumPut(255,this.tBufferPtr,16,"float")
		if (DllCall(this.vTable(this.factory,11),"ptr",this.factory,"ptr",this.tBufferPtr,"ptr",0,"uint",0,"ptr*",stroke) != 0) {
			this.Err("Problem creating stroke","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
			return
		}
		this.stroke := stroke
		NumPut(2,this.tBufferPtr,0,"uint")
		NumPut(2,this.tBufferPtr,4,"uint")
		NumPut(2,this.tBufferPtr,12,"uint")
		NumPut(255,this.tBufferPtr,16,"float")
		if (DllCall(this.vTable(this.factory,11),"ptr",this.factory,"ptr",this.tBufferPtr,"ptr",0,"uint",0,"ptr*",stroke) != 0) {
			this.Err("Problem creating rounded stroke","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
			return
		}
		this.strokeRounded := stroke
		NumPut(1,this.rtPtr,8,"uint")
		NumPut(96,this.rtPtr,12,"float")
		NumPut(96,this.rtPtr,16,"float")
		NumPut(hwnd,this.hrtPtr,0,"Uptr")
		NumPut(width_orForeground,this.hrtPtr,a_ptrsize,"uint")
		NumPut(height,this.hrtPtr,a_ptrsize+4,"uint")
		NumPut((vsync?0:2),this.hrtPtr,a_ptrsize+8,"uint")
		if (DllCall(this.vTable(this.factory,14),"Ptr",this.factory,"Ptr",this.rtPtr,"ptr",this.hrtPtr,"Ptr*",renderTarget) != 0) {
			this.Err("Problem creating renderTarget","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
			return
		}
		this.renderTarget := renderTarget
		NumPut(1,this.matrixPtr,0,"float")
		this.SetIdentity(4)
		if (DllCall(this.vTable(this.renderTarget,8),"Ptr",this.renderTarget,"Ptr",this.colPtr,"Ptr",this.matrixPtr,"Ptr*",brush) != 0) {
			this.Err("Problem creating brush","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
			return
		}
		this.brush := brush
		DllCall(this.vTable(this.renderTarget,32),"Ptr",this.renderTarget,"Uint",1)
		if (DllCall("dwrite\DWriteCreateFactory","uint",0,"Ptr",&clsidwFactory,"Ptr*",wFactory) != 0) {
			this.Err("Problem creating writeFactory","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
			return
		}
		this.wFactory := wFactory
		
		if (x_orTitle != 0 and winexist(x_orTitle))
			this.AttachToWindow(x_orTitle,y_orClient,width_orForeground)
		 else
			this.SetPosition(x_orTitle,y_orClient)
		
		DllCall(this.vTable(this.renderTarget,48),"Ptr",this.renderTarget)
		DllCall(this.vTable(this.renderTarget,47),"Ptr",this.renderTarget,"Ptr",this.clrPtr)
		DllCall(this.vTable(this.renderTarget,49),"Ptr",this.renderTarget,"int64*",tag1,"int64*",tag2)
	}
	
	
	;####################################################################################################################################################################################################################################
	;AttachToWindow
	;
	;title				:				Title of the window (or other type of identifier such as 'ahk_exe notepad.exe' etc..
	;attachToClientArea	:				Whether or not to attach the overlay to the client area, window area is used otherwise
	;foreground			:				Whether or not to only draw the overlay if attached window is active in the foreground, otherwise always draws
	;setOwner			:				Sets the ownership of the overlay window to the target window
	;
	;return				;				Returns 1 if either attached window is active in the foreground or no window is attached; 0 otherwise
	;
	;Notes				;				Does not actually 'attach', but rather every BeginDraw() fuction will check to ensure it's 
	;									updated to the attached windows position/size
	;									Could use SetParent but it introduces other issues, I'll explore further later
	
	AttachToWindow(title,AttachToClientArea:=0,foreground:=1,setOwner:=0) {
		if (title = "") {
			this.Err("AttachToWindow: Error","Expected title string, but empty variable was supplied!")
			return 0
		}
		if (!this.attachHWND := winexist(title)) {
			this.Err("AttachToWindow: Error","Could not find window - " title)
			return 0
		}
		numput(this.attachHwnd,this.tbufferptr,0,"UPtr")
		this.attachHWND := numget(this.tbufferptr,0,"Uptr")
		if (!DllCall("GetWindowRect","Uptr",this.attachHWND,"ptr",this.tBufferPtr)) {
			this.Err("AttachToWindow: Error","Problem getting window rect, is window minimized?`n`nError: " DllCall("GetLastError","uint"))
			return 0
		}
		
		this.attachClient := AttachToClientArea
		this.attachForeground := foreground
		this.AdjustWindow(x,y,w,h)
		
		VarSetCapacity(newSize,16)
		NumPut(this.width,newSize,0,"uint")
		NumPut(this.height,newSize,4,"uint")
		DllCall(this.vTable(this.renderTarget,58),"Ptr",this.renderTarget,"ptr",&newsize)
		this.SetPosition(x,y,this.width,this.height)
		if (setOwner) {
			this.alwaysontop := 0
			WinSet, AlwaysOnTop, off, % "ahk_id " this.hwnd
			this.owned := 1
			dllcall("SetWindowLongPtr","Uptr",this.hwnd,"int",-8,"Uptr",this.attachHWND)
			this.SetPosition(this.x,this.y)
		} else {
			this.owned := 0
		}
	}
	
	
	;####################################################################################################################################################################################################################################
	;BeginDraw
	;
	;return				;				Returns 1 if either attached window is active in the foreground or no window is attached; 0 otherwise
	;
	;Notes				;				Must always call EndDraw to finish drawing and update the overlay
	
	BeginDraw() {
		if (this.attachHWND) {
			if (!DllCall("GetWindowRect","Uptr",this.attachHWND,"ptr",this.tBufferPtr) or (this.attachForeground and DllCall("GetForegroundWindow","cdecl Ptr") != this.attachHWND)) {
				if (this.drawing) {
					DllCall(this.vTable(this.renderTarget,48),"Ptr",this.renderTarget)
					DllCall(this.vTable(this.renderTarget,47),"Ptr",this.renderTarget,"Ptr",this.clrPtr)
					this.EndDraw()
					this.drawing := 0
				}
				return 0
			}
			x := NumGet(this.tBufferPtr,0,"int")
			y := NumGet(this.tBufferPtr,4,"int")
			w := NumGet(this.tBufferPtr,8,"int")-x
			h := NumGet(this.tBufferPtr,12,"int")-y
			if ((w<<16)+h != this.lastSize) {
				this.AdjustWindow(x,y,w,h)
				VarSetCapacity(newSize,16)
				NumPut(this.width,newSize,0,"uint")
				NumPut(this.height,newSize,4,"uint")
				DllCall(this.vTable(this.renderTarget,58),"Ptr",this.renderTarget,"ptr",&newsize)
				this.SetPosition(x,y)
			} else if ((x<<16)+y != this.lastPos) {
				this.AdjustWindow(x,y,w,h)
				this.SetPosition(x,y)
			}
			if (!this.drawing and this.alwaysontop) {
				winset,alwaysontop,on,% "ahk_id " this.hwnd
			}
			
		} else {
			if (!DllCall("GetWindowRect","Uptr",this.hwnd,"ptr",this.tBufferPtr)) {
				if (this.drawing) {
					DllCall(this.vTable(this.renderTarget,48),"Ptr",this.renderTarget)
					DllCall(this.vTable(this.renderTarget,47),"Ptr",this.renderTarget,"Ptr",this.clrPtr)
					this.EndDraw()
					this.drawing := 0
				}
				return 0
			}
			x := NumGet(this.tBufferPtr,0,"int")
			y := NumGet(this.tBufferPtr,4,"int")
			w := NumGet(this.tBufferPtr,8,"int")-x
			h := NumGet(this.tBufferPtr,12,"int")-y
			if ((w<<16)+h != this.lastSize) {
				this.AdjustWindow(x,y,w,h)
				VarSetCapacity(newSize,16)
				NumPut(this.width,newSize,0,"uint")
				NumPut(this.height,newSize,4,"uint")
				DllCall(this.vTable(this.renderTarget,58),"Ptr",this.renderTarget,"ptr",&newsize)
				this.SetPosition(x,y)
			} else if ((x<<16)+y != this.lastPos) {
				this.AdjustWindow(x,y,w,h)
				this.SetPosition(x,y)
			}
		}
		this.drawing := 1
		DllCall(this.vTable(this.renderTarget,48),"Ptr",this.renderTarget)
		DllCall(this.vTable(this.renderTarget,47),"Ptr",this.renderTarget,"Ptr",this.clrPtr)
		return 1
	}
	
	
	;####################################################################################################################################################################################################################################
	;EndDraw
	;
	;return				;				Void
	;
	;Notes				;				Must always call EndDraw to finish drawing and update the overlay
	
	EndDraw() {
		if (this.drawing)
			DllCall(this.vTable(this.renderTarget,49),"Ptr",this.renderTarget,"int64*",tag1,"int64*",tag2)
	}
	
	
	;####################################################################################################################################################################################################################################
	;DrawImage
	;
	;dstX				:				X position to draw to
	;dstY				:				Y position to draw to
	;dstW				:				Width of image to draw to
	;dstH				:				Height of image to draw to
	;srcX				:				X position to draw from
	;srcY				:				Y position to draw from
	;srcW				:				Width of image to draw from
	;srcH				:				Height of image to draw from
	;alpha				:				Image transparency, float between 0 and 1
	;drawCentered		:				Draw the image centered on dstX/dstY, otherwise dstX/dstY will be the top left of the image
	;rotation			:				Image rotation in degrees (0-360)
	;rotationOffsetX	:				X offset to base rotations on (defaults to center x)
	;rotationOffsetY	:				Y offset to base rotations on (defaults to center y)
	;
	;return				;				Void
	
	DrawImage(image,dstX,dstY,dstW:=0,dstH:=0,srcX:=0,srcY:=0,srcW:=0,srcH:=0,alpha:=1,drawCentered:=0,rotation:=0,rotOffX:=0,rotOffY:=0) {
		if (!i := this.imageCache[image]) {
			i := this.cacheImage(image)
		}
		if (dstW <= 0)
			dstW := i.w
		if (dstH <= 0)
			dstH := i.h
		x := dstX-(drawCentered?dstW/2:0)
		y := dstY-(drawCentered?dstH/2:0)
		NumPut(x,this.rect1Ptr,0,"float")
		NumPut(y,this.rect1Ptr,4,"float")
		NumPut(x + dstW,this.rect1Ptr,8,"float")
		NumPut(y + dstH,this.rect1Ptr,12,"float")
		NumPut(srcX,this.rect2Ptr,0,"float")
		NumPut(srcY,this.rect2Ptr,4,"float")
		NumPut(srcX + (srcW=0?i.w:srcW),this.rect2Ptr,8,"float")
		NumPut(srcY + (srcH=0?i.h:srcH),this.rect2Ptr,12,"float")
		
		if (rotation != 0) {
			if (this.bits) {
				if (rotOffX or rotOffY) {
					NumPut(dstX+rotOffX,this.tBufferPtr,0,"float")
					NumPut(dstY+rotOffY,this.tBufferPtr,4,"float")
					tooltip k
				} else {
					NumPut(dstX+(drawCentered?0:dstW/2),this.tBufferPtr,0,"float")
					NumPut(dstY+(drawCentered?0:dstH/2),this.tBufferPtr,4,"float")
				}
				DllCall("d2d1\D2D1MakeRotateMatrix","float",rotation,"double",NumGet(this.tBufferPtr,"double"),"ptr",this.matrixPtr)
			} else {
				DllCall("d2d1\D2D1MakeRotateMatrix","float",rotation,"float",dstX+(drawCentered?0:dstW/2),"float",dstY+(drawCentered?0:dstH/2),"ptr",this.matrixPtr)
			}
			DllCall(this.vTable(this.renderTarget,30),"ptr",this.renderTarget,"ptr",this.matrixPtr)
			DllCall(this.vTable(this.renderTarget,26),"ptr",this.renderTarget,"ptr",i.p,"ptr",this.rect1Ptr,"float",alpha,"uint",this.interpolationMode,"ptr",this.rect2Ptr)
			this.SetIdentity()
			DllCall(this.vTable(this.renderTarget,30),"ptr",this.renderTarget,"ptr",this.matrixPtr)
		} else {
			DllCall(this.vTable(this.renderTarget,26),"ptr",this.renderTarget,"ptr",i.p,"ptr",this.rect1Ptr,"float",alpha,"uint",this.interpolationMode,"ptr",this.rect2Ptr)
		}
	}
	
	
	;####################################################################################################################################################################################################################################
	;GetTextMetrics
	;
	;text				:				The text to get the metrics of
	;size				:				Font size to measure with
	;fontName			:				Name of the font to use
	;maxWidth			:				Max width (smaller width may cause wrapping)
	;maxHeight			:				Max Height
	;
	;return				;				An array containing width, height and line count of the string
	;
	;Notes				;				Used to measure a string before drawing it
	
	GetTextMetrics(text,size,fontName,maxWidth:=5000,maxHeight:=5000) {
		local
		if (!p := this.fonts[fontName size]) {
			p := this.CacheFont(fontName,size)
		}
		varsetcapacity(bf,64)
		DllCall(this.vTable(this.wFactory,18),"ptr",this.wFactory,"WStr",text,"uint",strlen(text),"Ptr",p,"float",maxWidth,"float",maxHeight,"Ptr*",layout)
		DllCall(this.vTable(layout,60),"ptr",layout,"ptr",&bf,"uint")
		
		w := numget(bf,8,"float")
		wTrailing := numget(bf,12,"float")
		h := numget(bf,16,"float")
		
		DllCall(this.vTable(layout,2),"ptr",layout)
		
		return {w:w,width:w,h:h,height:h,wt:wTrailing,widthTrailing:w,lines:numget(bf,32,"uint")}
		
	}
	
	
	;####################################################################################################################################################################################################################################
	;SetTextRenderParams
	;
	;gamma				:				Gamma value ................. (1 > 256)
	;contrast			:				Contrast value .............. (0.0 > 1.0)
	;clearType			:				Clear type level ............ (0.0 > 1.0)
	;pixelGeom			:				
	;									0 - DWRITE_PIXEL_GEOMETRY_FLAT
    ;									1 - DWRITE_PIXEL_GEOMETRY_RGB
    ;									2 - DWRITE_PIXEL_GEOMETRY_BGR
	;
	;renderMode			:				
    ; 									0 - DWRITE_RENDERING_MODE_DEFAULT
    ; 									1 - DWRITE_RENDERING_MODE_ALIASED
    ; 									2 - DWRITE_RENDERING_MODE_GDI_CLASSIC
    ; 									3 - DWRITE_RENDERING_MODE_GDI_NATURAL
    ; 									4 - DWRITE_RENDERING_MODE_NATURAL
    ; 									5 - DWRITE_RENDERING_MODE_NATURAL_SYMMETRIC
    ; 									6 - DWRITE_RENDERING_MODE_OUTLINE
	;									7 - DWRITE_RENDERING_MODE_CLEARTYPE_GDI_CLASSIC
	;									8 - DWRITE_RENDERING_MODE_CLEARTYPE_GDI_NATURAL
	;									9 - DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL
	;									10 - DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL_SYMMETRIC
	;
	;return				;				Void
	;
	;Notes				;				Used to affect how text is rendered
	
	SetTextRenderParams(gamma:=1,contrast:=0,cleartype:=1,pixelGeom:=0,renderMode:=0) {
		local
		DllCall(this.vTable(this.wFactory,12),"ptr",this.wFactory,"Float",gamma,"Float",contrast,"Float",cleartype,"Uint",pixelGeom,"Uint",renderMode,"Ptr*",params) "`n" params
		DllCall(this.vTable(this.renderTarget,36),"Ptr",this.renderTarget,"Ptr",params)
	}
	
	
	
	
	;####################################################################################################################################################################################################################################
	;DrawText
	;
	;text				:				The text to be drawn
	;x					:				X position
	;y					:				Y position
	;size				:				Size of font
	;color				:				Color of font
	;fontName			:				Font name (must be installed)
	;extraOptions		:				Additonal options which may contain any of the following seperated by spaces:
	;									Width .............	w[number]				: Example > w200			(Default: this.width)
	;									Height ............	h[number]				: Example > h200			(Default: this.height)
	;									Alignment ......... a[Left/Right/Center]	: Example > aCenter			(Default: Left)
	;									DropShadow ........	ds[hex color]			: Example > dsFF000000		(Default: DISABLED)
	;									DropShadowXOffset . dsx[number]				: Example > dsx2			(Default: 1)
	;									DropShadowYOffset . dsy[number]				: Example > dsy2			(Default: 1)
	;									Outline ........... ol[hex color]			: Example > olFF000000		(Default: DISABLED)
	;
	;return				;				Void
	
	DrawText(text,x,y,size:=18,color:=0xFFFFFFFF,fontName:="Arial",extraOptions:="") {
		local
		if (!RegExMatch(extraOptions,"w([\d\.]+)",w))
			w1 := this.width
		if (!RegExMatch(extraOptions,"h([\d\.]+)",h))
			h1 := this.height
		
		if (!p := this.fonts[fontName size]) {
			p := this.CacheFont(fontName,size)
		}
		
		DllCall(this.vTable(p,3),"ptr",p,"uint",(InStr(extraOptions,"aRight") ? 1 : InStr(extraOptions,"aCenter") ? 2 : 0))
		
		if (RegExMatch(extraOptions,"ds([a-fA-F\d]+)",ds)) {
			if (!RegExMatch(extraOptions,"dsx([\d\.]+)",dsx))
				dsx1 := 1
			if (!RegExMatch(extraOptions,"dsy([\d\.]+)",dsy))
				dsy1 := 1
			this.DrawTextShadow(p,text,x+dsx1,y+dsy1,w1,h1,"0x" ds1)
		} else if (RegExMatch(extraOptions,"ol([a-fA-F\d]+)",ol)) {
			this.DrawTextOutline(p,text,x,y,w1,h1,"0x" ol1)
		}
		
		this.SetBrushColor(color)
		NumPut(x,this.tBufferPtr,0,"float")
		NumPut(y,this.tBufferPtr,4,"float")
		NumPut(x+w1,this.tBufferPtr,8,"float")
		NumPut(y+h1,this.tBufferPtr,12,"float")
		
		DllCall(this.vTable(this.renderTarget,27),"ptr",this.renderTarget,"wstr",text,"uint",strlen(text),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
	}
	
	
	;####################################################################################################################################################################################################################################
	;DrawEllipse
	;
	;x					:				X position
	;y					:				Y position
	;w					:				Width of ellipse
	;h					:				Height of ellipse
	;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
	;thickness			:				Thickness of the line
	;
	;return				;				Void
	
	DrawEllipse(x, y, w, h, color, thickness:=1) {
		this.SetBrushColor(color)
		NumPut(x,this.tBufferPtr,0,"float")
		NumPut(y,this.tBufferPtr,4,"float")
		NumPut(w,this.tBufferPtr,8,"float")
		NumPut(h,this.tBufferPtr,12,"float")
		DllCall(this.vTable(this.renderTarget,20),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush,"float",thickness,"ptr",this.stroke)
	}
	
	
	;####################################################################################################################################################################################################################################
	;FillEllipse
	;
	;x					:				X position
	;y					:				Y position
	;w					:				Width of ellipse
	;h					:				Height of ellipse
	;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
	;
	;return				;				Void
	
	FillEllipse(x, y, w, h, color) {
		this.SetBrushColor(color)
		NumPut(x,this.tBufferPtr,0,"float")
		NumPut(y,this.tBufferPtr,4,"float")
		NumPut(w,this.tBufferPtr,8,"float")
		NumPut(h,this.tBufferPtr,12,"float")
		DllCall(this.vTable(this.renderTarget,21),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush)
	}
	
	
	;####################################################################################################################################################################################################################################
	;DrawCircle
	;
	;x					:				X position
	;y					:				Y position
	;radius				:				Radius of circle
	;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
	;thickness			:				Thickness of the line
	;
	;return				;				Void
	
	DrawCircle(x, y, radius, color, thickness:=1) {
		this.SetBrushColor(color)
		NumPut(x,this.tBufferPtr,0,"float")
		NumPut(y,this.tBufferPtr,4,"float")
		NumPut(radius,this.tBufferPtr,8,"float")
		NumPut(radius,this.tBufferPtr,12,"float")
		DllCall(this.vTable(this.renderTarget,20),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush,"float",thickness,"ptr",this.stroke)
	}
	
	
	;####################################################################################################################################################################################################################################
	;FillCircle
	;
	;x					:				X position
	;y					:				Y position
	;radius				:				Radius of circle
	;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
	;
	;return				;				Void
	
	FillCircle(x, y, radius, color) {
		this.SetBrushColor(color)
		NumPut(x,this.tBufferPtr,0,"float")
		NumPut(y,this.tBufferPtr,4,"float")
		NumPut(radius,this.tBufferPtr,8,"float")
		NumPut(radius,this.tBufferPtr,12,"float")
		DllCall(this.vTable(this.renderTarget,21),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush)
	}
	
	
	;####################################################################################################################################################################################################################################
	;DrawRectangle
	;
	;x					:				X position
	;y					:				Y position
	;w					:				Width of rectangle
	;h					:				Height of rectangle
	;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
	;thickness			:				Thickness of the line
	;
	;return				;				Void
	
	DrawRectangle(x, y, w, h, color, thickness:=1) {
		this.SetBrushColor(color)
		NumPut(x,this.tBufferPtr,0,"float")
		NumPut(y,this.tBufferPtr,4,"float")
		NumPut(x+w,this.tBufferPtr,8,"float")
		NumPut(y+h,this.tBufferPtr,12,"float")
		DllCall(this.vTable(this.renderTarget,16),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush,"float",thickness,"ptr",this.stroke)
	}
	
	
	;####################################################################################################################################################################################################################################
	;FillRectangle
	;
	;x					:				X position
	;y					:				Y position
	;w					:				Width of rectangle
	;h					:				Height of rectangle
	;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
	;
	;return				;				Void
	
	FillRectangle(x, y, w, h, color) {
		this.SetBrushColor(color)
		NumPut(x,this.tBufferPtr,0,"float")
		NumPut(y,this.tBufferPtr,4,"float")
		NumPut(x+w,this.tBufferPtr,8,"float")
		NumPut(y+h,this.tBufferPtr,12,"float")
		DllCall(this.vTable(this.renderTarget,17),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush)
	}
	
	
	;####################################################################################################################################################################################################################################
	;DrawRoundedRectangle
	;
	;x					:				X position
	;y					:				Y position
	;w					:				Width of rectangle
	;h					:				Height of rectangle
	;radiusX			:				The x-radius for the quarter ellipse that is drawn to replace every corner of the rectangle.
	;radiusY			:				The y-radius for the quarter ellipse that is drawn to replace every corner of the rectangle.
	;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
	;thickness			:				Thickness of the line
	;
	;return				;				Void
	
	DrawRoundedRectangle(x, y, w, h, radiusX, radiusY, color, thickness:=1) {
		this.SetBrushColor(color)
		NumPut(x,this.tBufferPtr,0,"float")
		NumPut(y,this.tBufferPtr,4,"float")
		NumPut(x+w,this.tBufferPtr,8,"float")
		NumPut(y+h,this.tBufferPtr,12,"float")
		NumPut(radiusX,this.tBufferPtr,16,"float")
		NumPut(radiusY,this.tBufferPtr,20,"float")
		DllCall(this.vTable(this.renderTarget,18),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush,"float",thickness,"ptr",this.stroke)
	}
	
	
	;####################################################################################################################################################################################################################################
	;FillRectangle
	;
	;x					:				X position
	;y					:				Y position
	;w					:				Width of rectangle
	;h					:				Height of rectangle
	;radiusX			:				The x-radius for the quarter ellipse that is drawn to replace every corner of the rectangle.
	;radiusY			:				The y-radius for the quarter ellipse that is drawn to replace every corner of the rectangle.
	;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
	;
	;return				;				Void
	
	FillRoundedRectangle(x, y, w, h, radiusX, radiusY, color) {
		this.SetBrushColor(color)
		NumPut(x,this.tBufferPtr,0,"float")
		NumPut(y,this.tBufferPtr,4,"float")
		NumPut(x+w,this.tBufferPtr,8,"float")
		NumPut(y+h,this.tBufferPtr,12,"float")
		NumPut(radiusX,this.tBufferPtr,16,"float")
		NumPut(radiusY,this.tBufferPtr,20,"float")
		DllCall(this.vTable(this.renderTarget,19),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush)
	}
	
	
	;####################################################################################################################################################################################################################################
	;DrawLine
	;
	;x1					:				X position for line start
	;y1					:				Y position for line start
	;x2					:				X position for line end
	;y2					:				Y position for line end
	;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
	;thickness			:				Thickness of the line
	;
	;return				;				Void

	DrawLine(x1,y1,x2,y2,color:=0xFFFFFFFF,thickness:=1,rounded:=0) {
		this.SetBrushColor(color)
		if (this.bits) {
			NumPut(x1,this.tBufferPtr,0,"float")  ;Special thanks to teadrinker for helping me
			NumPut(y1,this.tBufferPtr,4,"float")  ;with these params!
			NumPut(x2,this.tBufferPtr,8,"float")
			NumPut(y2,this.tBufferPtr,12,"float")
			DllCall(this.vTable(this.renderTarget,15),"Ptr",this.renderTarget,"Double",NumGet(this.tBufferPtr,0,"double"),"Double",NumGet(this.tBufferPtr,8,"double"),"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
		} else {
			DllCall(this.vTable(this.renderTarget,15),"Ptr",this.renderTarget,"float",x1,"float",y1,"float",x2,"float",y2,"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
		}
		
	}
	
	
	;####################################################################################################################################################################################################################################
	;DrawLines
	;
	;lines				:				An array of 2d points, example: [[0,0],[5,0],[0,5]]
	;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
	;connect			:				If 1 then connect the start and end together
	;thickness			:				Thickness of the line
	;
	;return				;				1 on success; 0 otherwise

	DrawLines(points,color,connect:=0,thickness:=1,rounded:=0) {
		if (points.length() < 2)
			return 0
		lx := sx := points[1][1]
		ly := sy := points[1][2]
		this.SetBrushColor(color)
		if (this.bits) {
			loop % points.length()-1 {
				NumPut(lx,this.tBufferPtr,0,"float"), NumPut(ly,this.tBufferPtr,4,"float"), NumPut(lx:=points[a_index+1][1],this.tBufferPtr,8,"float"), NumPut(ly:=points[a_index+1][2],this.tBufferPtr,12,"float")
				DllCall(this.vTable(this.renderTarget,15),"Ptr",this.renderTarget,"Double",NumGet(this.tBufferPtr,0,"double"),"Double",NumGet(this.tBufferPtr,8,"double"),"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
			}
			if (connect) {
				NumPut(sx,this.tBufferPtr,0,"float"), NumPut(sy,this.tBufferPtr,4,"float"), NumPut(lx,this.tBufferPtr,8,"float"), NumPut(ly,this.tBufferPtr,12,"float")
				DllCall(this.vTable(this.renderTarget,15),"Ptr",this.renderTarget,"Double",NumGet(this.tBufferPtr,0,"double"),"Double",NumGet(this.tBufferPtr,8,"double"),"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
			}
		} else {
			loop % points.length()-1 {
				x1 := lx
				y1 := ly
				x2 := lx := points[a_index+1][1]
				y2 := ly := points[a_index+1][2]
				DllCall(this.vTable(this.renderTarget,15),"Ptr",this.renderTarget,"float",x1,"float",y1,"float",x2,"float",y2,"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
			}
			if (connect)
				DllCall(this.vTable(this.renderTarget,15),"Ptr",this.renderTarget,"float",sx,"float",sy,"float",lx,"float",ly,"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
		}
		return 1
	}
	
	
	;####################################################################################################################################################################################################################################
	;DrawPolygon
	;
	;points				:				An array of 2d points, example: [[0,0],[5,0],[0,5]]
	;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
	;thickness			:				Thickness of the line
	;xOffset			:				X offset to draw the polygon array
	;yOffset			:				Y offset to draw the polygon array
	;
	;return				;				1 on success; 0 otherwise

	DrawPolygon(points,color,thickness:=1,rounded:=0,xOffset:=0,yOffset:=0) {
		if (points.length() < 3)
			return 0
		
		if (DllCall(this.vTable(this.factory,10),"Ptr",this.factory,"Ptr*",pGeom) = 0) {
			if (DllCall(this.vTable(pGeom,17),"Ptr",pGeom,"ptr*",sink) = 0) {
				this.SetBrushColor(color)
				if (this.bits) {
					numput(points[1][1]+xOffset,this.tBufferPtr,0,"float")
					numput(points[1][2]+yOffset,this.tBufferPtr,4,"float")
					DllCall(this.vTable(sink,5),"ptr",sink,"double",numget(this.tBufferPtr,0,"double"),"uint",1)
					loop % points.length()-1
					{
						numput(points[a_index+1][1]+xOffset,this.tBufferPtr,0,"float")
						numput(points[a_index+1][2]+yOffset,this.tBufferPtr,4,"float")
						DllCall(this.vTable(sink,10),"ptr",sink,"double",numget(this.tBufferPtr,0,"double"))
					}
					DllCall(this.vTable(sink,8),"ptr",sink,"uint",1)
					DllCall(this.vTable(sink,9),"ptr",sink)
				} else {
					DllCall(this.vTable(sink,5),"ptr",sink,"float",points[1][1]+xOffset,"float",points[1][2]+yOffset,"uint",1)
					loop % points.length()-1
						DllCall(this.vTable(sink,10),"ptr",sink,"float",points[a_index+1][1]+xOffset,"float",points[a_index+1][2]+yOffset)
					DllCall(this.vTable(sink,8),"ptr",sink,"uint",1)
					DllCall(this.vTable(sink,9),"ptr",sink)
				}
				
				if (DllCall(this.vTable(this.renderTarget,22),"Ptr",this.renderTarget,"Ptr",pGeom,"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke)) = 0) {
					DllCall(this.vTable(sink,2),"ptr",sink)
					DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
					return 1
				}
				DllCall(this.vTable(sink,2),"ptr",sink)
				DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
			}
		}
		
		
		return 0
	}
	
	
	;####################################################################################################################################################################################################################################
	;FillPolygon
	;
	;points				:				An array of 2d points, example: [[0,0],[5,0],[0,5]]
	;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
	;xOffset			:				X offset to draw the filled polygon array
	;yOffset			:				Y offset to draw the filled polygon array
	;
	;return				;				1 on success; 0 otherwise

	FillPolygon(points,color,xoffset:=0,yoffset:=0) {
		if (points.length() < 3)
			return 0
		
		if (DllCall(this.vTable(this.factory,10),"Ptr",this.factory,"Ptr*",pGeom) = 0) {
			if (DllCall(this.vTable(pGeom,17),"Ptr",pGeom,"ptr*",sink) = 0) {
				this.SetBrushColor(color)
				if (this.bits) {
					numput(points[1][1]+xoffset,this.tBufferPtr,0,"float")
					numput(points[1][2]+yoffset,this.tBufferPtr,4,"float")
					DllCall(this.vTable(sink,5),"ptr",sink,"double",numget(this.tBufferPtr,0,"double"),"uint",0)
					loop % points.length()-1
					{
						numput(points[a_index+1][1]+xoffset,this.tBufferPtr,0,"float")
						numput(points[a_index+1][2]+yoffset,this.tBufferPtr,4,"float")
						DllCall(this.vTable(sink,10),"ptr",sink,"double",numget(this.tBufferPtr,0,"double"))
					}
					DllCall(this.vTable(sink,8),"ptr",sink,"uint",1)
					DllCall(this.vTable(sink,9),"ptr",sink)
				} else {
					DllCall(this.vTable(sink,5),"ptr",sink,"float",points[1][1]+xoffset,"float",points[1][2]+yoffset,"uint",0)
					loop % points.length()-1
						DllCall(this.vTable(sink,10),"ptr",sink,"float",points[a_index+1][1]+xoffset,"float",points[a_index+1][2]+yoffset)
					DllCall(this.vTable(sink,8),"ptr",sink,"uint",1)
					DllCall(this.vTable(sink,9),"ptr",sink)
				}
				
				if (DllCall(this.vTable(this.renderTarget,23),"Ptr",this.renderTarget,"Ptr",pGeom,"ptr",this.brush,"ptr",0) = 0) {
					DllCall(this.vTable(sink,2),"ptr",sink)
					DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
					return 1
				}
				DllCall(this.vTable(sink,2),"ptr",sink)
				DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
				
			}
		}
		
		
		return 0
	}
	
	
	;####################################################################################################################################################################################################################################
	;SetPosition
	;
	;x					:				X position to move the window to (screen space)
	;y					:				Y position to move the window to (screen space)
	;w					:				New Width (only applies when not attached)
	;h					:				New Height (only applies when not attached)
	;
	;return				;				Void
	;
	;notes				:				Only used when not attached to a window
	
	SetPosition(x,y,w:=0,h:=0) {
		this.x := x
		this.y := y
		if (!this.attachHWND and w != 0 and h != 0) {
			VarSetCapacity(newSize,16)
			NumPut(this.width := w,newSize,0,"uint")
			NumPut(this.height := h,newSize,4,"uint")
			DllCall(this.vTable(this.renderTarget,58),"Ptr",this.renderTarget,"ptr",&newsize)
		}
		DllCall("MoveWindow","Uptr",this.hwnd,"int",x,"int",y,"int",this.width,"int",this.height,"char",1)
	}
	
	
	;####################################################################################################################################################################################################################################
	;GetImageDimensions
	;
	;image				:				Image file name
	;&w					:				Width of image
	;&h					:				Height of image
	;
	;return				;				Void
	
	GetImageDimensions(image,byref w, byref h) {
		if (!i := this.imageCache[image]) {
			i := this.cacheImage(image)
		}
		w := i.w
		h := i.h
	}
	
	
	;####################################################################################################################################################################################################################################
	;GetMousePos
	;
	;&x					:				X position of mouse to return
	;&y					:				Y position of mouse to return
	;realRegionOnly		:				Return 1 only if in the real region, which does not include the invisible borders, (client area does not have borders)
	;
	;return				;				Returns 1 if mouse within window/client region; 0 otherwise
	
	GetMousePos(byref x, byref y, realRegionOnly:=0) {
		DllCall("GetCursorPos","ptr",this.tBufferPtr)
		x := NumGet(this.tBufferPtr,0,"int")
		y := NumGet(this.tBufferPtr,4,"int")
		if (!realRegionOnly) {
			inside := (x >= this.x and y >= this.y and x <= this.x2 and y <= this.y2)
			x += this.offX
			y += this.offY
			return inside
		}
		x += this.offX
		y += this.offY
		return (x >= this.realX and y >= this.realY and x <= this.realX2 and y <= this.realY2)
		
	}
	
	
	;####################################################################################################################################################################################################################################
	;Clear
	;
	;notes						:			Clears the overlay, essentially the same as running BegindDraw followed by EndDraw
	
	Clear() {
		DllCall(this.vTable(this.renderTarget,48),"Ptr",this.renderTarget)
		DllCall(this.vTable(this.renderTarget,47),"Ptr",this.renderTarget,"Ptr",this.clrPtr)
		DllCall(this.vTable(this.renderTarget,49),"Ptr",this.renderTarget,"int64*",tag1,"int64*",tag2)
	}
		
	;########################################## 
	;  internal functions used by the class
	;########################################## 
	AdjustWindow(byref x,byref y,byref w,byref h) {
		local
		DllCall("GetWindowInfo","Uptr",(this.attachHWND ? this.attachHWND : this.hwnd),"ptr",this.tBufferPtr)
		pp := (this.attachClient ? 20 : 4)
		x1 := NumGet(this.tBufferPtr,pp,"int")
		y1 := NumGet(this.tBufferPtr,pp+4,"int")
		x2 := NumGet(this.tBufferPtr,pp+8,"int")
		y2 := NumGet(this.tBufferPtr,pp+12,"int")
		this.width := w := x2-x1
		this.height := h := y2-y1
		this.x := x := x1
		this.y := y := y1
		this.x2 := x + w
		this.y2 := y + h
		this.lastPos := (x1<<16)+y1
		this.lastSize := (w<<16)+h
		hBorders := (this.attachClient ? 0 : NumGet(this.tBufferPtr,48,"int"))
		vBorders := (this.attachClient ? 0 : NumGet(this.tBufferPtr,52,"int"))
		this.realX := hBorders
		this.realY := 0
		this.realWidth := w - (hBorders*2)
		this.realHeight := h - vBorders
		this.realX2 := this.realX + this.realWidth
		this.realY2 := this.realY + this.realHeight
		this.offX := -x1 ;- hBorders
		this.offY := -y1
	}
	SetIdentity(o:=0) {
		NumPut(1,this.matrixPtr,o+0,"float")
		NumPut(0,this.matrixPtr,o+4,"float")
		NumPut(0,this.matrixPtr,o+8,"float")
		NumPut(1,this.matrixPtr,o+12,"float")
		NumPut(0,this.matrixPtr,o+16,"float")
		NumPut(0,this.matrixPtr,o+20,"float")
	}
	DrawTextShadow(p,text,x,y,w,h,color) {
		this.SetBrushColor(color)
		NumPut(x,this.tBufferPtr,0,"float")
		NumPut(y,this.tBufferPtr,4,"float")
		NumPut(x+w,this.tBufferPtr,8,"float")
		NumPut(y+h,this.tBufferPtr,12,"float")
		DllCall(this.vTable(this.renderTarget,27),"ptr",this.renderTarget,"wstr",text,"uint",strlen(text),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
	}
	DrawTextOutline(p,text,x,y,w,h,color) {
		static o := [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1]]
		this.SetBrushColor(color)
		for k,v in o
		{
			NumPut(x+v[1],this.tBufferPtr,0,"float")
			NumPut(y+v[2],this.tBufferPtr,4,"float")
			NumPut(x+w+v[1],this.tBufferPtr,8,"float")
			NumPut(y+h+v[2],this.tBufferPtr,12,"float")
			DllCall(this.vTable(this.renderTarget,27),"ptr",this.renderTarget,"wstr",text,"uint",strlen(text),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
		}
	}
	Err(str*) {
		local
		s := ""
		for k,v in str
			s .= (s = "" ? "" : "`n`n") v
		msgbox,% 0x30 | 0x1000,% "Problem!",% s
	}
	LoadLib(lib*) {
		for k,v in lib
			if (!DllCall("GetModuleHandle", "str", v, "Ptr"))
				DllCall("LoadLibrary", "Str", v) 
	}
	SetBrushColor(col) {
		if (col <= 0xFFFFFF)
			col += 0xFF000000
		if (col != this.lastCol) {
			NumPut(((col & 0xFF0000)>>16)/255,this.colPtr,0,"float")
			NumPut(((col & 0xFF00)>>8)/255,this.colPtr,4,"float")
			NumPut(((col & 0xFF))/255,this.colPtr,8,"float")
			NumPut((col > 0xFFFFFF ? ((col & 0xFF000000)>>24)/255 : 1),this.colPtr,12,"float")
			DllCall(this.vTable(this.brush,8),"Ptr",this.brush,"Ptr",this.colPtr)
			this.lastCol := col
			return 1
		}
		return 0
	}
	vTable(a,p) {
		return NumGet(NumGet(a+0,0,"ptr"),p*a_ptrsize,"Ptr")
	}
	_guid(guidStr,byref clsid) {
		VarSetCapacity(clsid,16)
		DllCall("ole32\CLSIDFromString", "WStr", guidStr, "Ptr", &clsid)
	}
	SetVarCapacity(key,size,fill=0) {
		this.SetCapacity(key,size)
		DllCall("RtlFillMemory","Ptr",this.GetAddress(key),"Ptr",size,"uchar",fill)
		return this.GetAddress(key)
	}
	CacheImage(image) {
		local
		if (this.imageCache.haskey(image))
			return 1
		if (image = "") {
			this.Err("Error, expected resource image path but empty variable was supplied!")
			return 0
		}
		if (!FileExist(image)) {
			this.Err("Error finding resource image","'" image "' does not exist!")
			return 0
		}
		DllCall("gdiplus\GdipCreateBitmapFromFile", "Ptr", &image, "Ptr*", bm)
		DllCall("gdiplus\GdipGetImageWidth", "Ptr", bm, "Uint*", w)
		DllCall("gdiplus\GdipGetImageHeight", "Ptr", bm, "Uint*", h)
		VarSetCapacity(r,16,0)
		NumPut(w,r,8,"uint")
		NumPut(h,r,12,"uint")
		VarSetCapacity(bmdata, 32, 0)
		DllCall("Gdiplus\GdipBitmapLockBits", "Ptr", bm, "Ptr", &r, "uint", 3, "int", 0x26200A, "Ptr", &bmdata)
		scan := NumGet(bmdata, 16, "Ptr")
		p := DllCall("GlobalAlloc", "uint", 0x40, "ptr", 16+((w*h)*4), "ptr")
		DllCall(this._cacheImage,"Ptr",p,"Ptr",scan,"int",w,"int",h,"uchar",255)
		DllCall("Gdiplus\GdipBitmapUnlockBits", "Ptr", bm, "Ptr", &bmdata)
		DllCall("gdiplus\GdipDisposeImage", "ptr", bm)
		VarSetCapacity(props,64,0)
		NumPut(28,props,0,"uint")
		NumPut(1,props,4,"uint")
		if (this.bits) {
			NumPut(w,this.tBufferPtr,0,"uint")
			NumPut(h,this.tBufferPtr,4,"uint")
			if (v := DllCall(this.vTable(this.renderTarget,4),"ptr",this.renderTarget,"int64",NumGet(this.tBufferPtr,"int64"),"ptr",p,"uint",4 * w,"ptr",&props,"ptr*",bitmap) != 0) {
				this.Err("Problem creating D2D bitmap for image '" image "'")
				return 0
			}
		} else {
			if (v := DllCall(this.vTable(this.renderTarget,4),"ptr",this.renderTarget,"uint",w,"uint",h,"ptr",p,"uint",4 * w,"ptr",&props,"ptr*",bitmap) != 0) {
				this.Err("Problem creating D2D bitmap for image '" image "'")
				return 0
			}
		}
		return this.imageCache[image] := {p:bitmap,w:w,h:h}
	}
	CacheFont(name,size) {
		if (DllCall(this.vTable(this.wFactory,15),"ptr",this.wFactory,"wstr",name,"ptr",0,"uint",400,"uint",0,"uint",5,"float",size,"wstr","en-us","ptr*",textFormat) != 0) {
			this.Err("Unable to create font: " name " (size: " size ")","Try a different font or check to see if " name " is a valid font!")
			return 0
		}
		return this.fonts[name size] := textFormat
	}
	__Delete() {
		DllCall("gdiplus\GdiplusShutdown", "Ptr*", this.gdiplusToken)
		DllCall(this.vTable(this.factory,2),"ptr",this.factory)
		DllCall(this.vTable(this.stroke,2),"ptr",this.stroke)
		DllCall(this.vTable(this.strokeRounded,2),"ptr",this.strokeRounded)
		DllCall(this.vTable(this.renderTarget,2),"ptr",this.renderTarget)
		DllCall(this.vTable(this.brush,2),"ptr",this.brush)
		DllCall(this.vTable(this.wfactory,2),"ptr",this.wfactory)
		guiID := this.guiID
		gui %guiID%:destroy
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
}


; Neutron.ahk v1.0.0
; Copyright (c) 2020 Philip Taylor (known also as GeekDude, G33kDude)
; https://github.com/G33kDude/Neutron.ahk
;
; slightly edited by Antra, you should not use this expecting it to be as default
;
; MIT License
;
; Permission is hereby granted, free of charge, to any person obtaining a copy
; of this software and associated documentation files (the "Software"), to deal
; in the Software without restriction, including without limitation the rights
; to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
; copies of the Software, and to permit persons to whom the Software is
; furnished to do so, subject to the following conditions:
;
; The above copyright notice and this permission notice shall be included in all
; copies or substantial portions of the Software.
;


class NeutronWindow
{
	static TEMPLATE := "
( ; html
<!DOCTYPE html><html>
<head>

<meta http-equiv='X-UA-Compatible' content='IE=edge'>
<style>
	html, body {
		width: 100`%; 
		height: 100`%;
		margin: 0; 
		padding: 0;
		font-family: sans-serif;
	}

	body {
		display: flex;
		flex-direction: column;
	}

	header {
		width: 100`%;
		display: flex;
		background: silver;
		font-family: Segoe UI;
		font-size: 9pt;
	}

	.title-bar {
		padding: 0.35em 0.5em;
		flex-grow: 1;
	}

	.title-btn {
		padding: 0.35em 1.0em;
		cursor: pointer;
		vertical-align: bottom;
		font-family: Webdings;
		font-size: 11pt;
	}

	body .title-btn-restore {
		display: none
	}
	
	body.neutron-maximized .title-btn-restore {
		display: block
	}
	
	body.neutron-maximized .title-btn-maximize {
		display: none
	}

	.title-btn:hover {
		background: rgba(0, 0, 0, .2);
	}

	.title-btn-close:hover {
		background: #dc3545;
	}

	.main {
		flex-grow: 1;
		padding: 0.5em;
		overflow: auto;
	}
</style>
<style>{}</style>

</head>
<body>

<header>
	<span class='title-bar' onmousedown='neutron.DragTitleBar()'>{}</span>
	<span class='title-btn' style='display:none' onclick='neutron.Minimize()'>0</span>
	<span class='title-btn title-btn-maximize' style='display:none' onclick='neutron.Maximize()'>1</span>
	<span class='title-btn title-btn-restore' style='display:none'  onclick='neutron.Maximize()'>2</span>
	<span class='title-btn title-btn-close' style='display:none' onclick='neutron.Close()'>r</span>
</header>

<div class='main'>{}</div>

<script>{}</script>

</body>
</html>
)"
	
	; --- Constants ---
	
	static VERSION := "1.0.0"
	
	; Windows Messages
	, WM_DESTROY := 0x02
	, WM_SIZE := 0x05
	, WM_NCCALCSIZE := 0x83
	, WM_NCHITTEST := 0x84
	, WM_NCLBUTTONDOWN := 0xA1
	, WM_KEYDOWN := 0x100
	, WM_KEYUP := 0x101
	, WM_SYSKEYDOWN := 0x104
	, WM_SYSKEYUP := 0x105
	, WM_MOUSEMOVE := 0x200
	, WM_LBUTTONDOWN := 0x201
	
	; Virtual-Key Codes
	, VK_TAB := 0x09
	, VK_SHIFT := 0x10
	, VK_CONTROL := 0x11
	, VK_MENU := 0x12
	, VK_F5 := 0x74
	
	; Non-client hit test values (WM_NCHITTEST)
	, HT_VALUES := [[13, 12, 14], [10, 1, 11], [16, 15, 17]]
	
	; Registry keys
	, KEY_FBE := "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\MAIN"
	. "\FeatureControl\FEATURE_BROWSER_EMULATION"
	
	; Undoucmented Accent API constants
	; https://withinrafael.com/2018/02/02/adding-acrylic-blur-to-your-windows-10-apps-redstone-4-desktop-apps/
	, ACCENT_ENABLE_GRADIENT := 1
	, ACCENT_ENABLE_BLURBEHIND := 3
	, WCA_ACCENT_POLICY := 19
	
	; Other constants
	, EXE_NAME := A_IsCompiled ? A_ScriptName : StrSplit(A_AhkPath, "\").Pop()
	
	; OS minor version
	, OS_MINOR_VER := StrSplit(A_OSVersion, ".")[3]
	
	; --- Instance Variables ---
	
	LISTENERS := [this.WM_DESTROY, this.WM_SIZE, this.WM_NCCALCSIZE
	, this.WM_KEYDOWN, this.WM_KEYUP, this.WM_SYSKEYDOWN, this.WM_SYSKEYUP
	, this.WM_LBUTTONDOWN]
	
	; Maximum pixel inset for sizing handles to appear
	border_size := 6
	
	; The window size
	w := 800
	h := 600
	
	; Modifier keys as seen by neutron
	MODIFIER_BITMAP := {this.VK_SHIFT: 1<<0, this.VK_CONTROL: 1<<1
	, this.VK_MENU: 1<<2}
	modifiers := 0
	
	; Shortcuts to not pass on to the web control
	disabled_shortcuts :=
	( Join ; ahk
	{
		0: {
			this.VK_F5: false
		},
		this.MODIFIER_BITMAP[this.VK_CONTROL]: {
			GetKeyVK("F"): true,
			GetKeyVK("L"): true,
			GetKeyVK("N"): true,
			GetKeyVK("O"): true,
			GetKeyVK("P"): true
		}
	}
	)
	
	
	; --- Properties ---
	
	; Get the JS DOM object
	doc[]
	{
		get
		{
			return this.wb.Document
		}
	}
	
	; Get the JS Window object
	wnd[]
	{
		get
		{
			return this.wb.Document.parentWindow
		}
	}
	
	
	; --- Construction, Destruction, Meta-Functions ---
	
	__New(html:="", css:="", js:="", title:="Neutron")
	{
		static wb
		
		; Create necessary circular references
		this.bound := {}
		this.bound._OnMessage := this._OnMessage.Bind(this)
		
		; Bind message handlers
		for i, message in this.LISTENERS
			OnMessage(message, this.bound._OnMessage)
		
		; Create and save the GUI
		; TODO: Restore previous default GUI
		Gui, New, +hWndhWnd +Resize -DPIScale
		this.hWnd := hWnd
		
		; Enable shadow
		VarSetCapacity(margins, 16, 0)
		NumPut(1, &margins, 0, "Int")
		DllCall("Dwmapi\DwmExtendFrameIntoClientArea"
		, "UPtr", hWnd      ; HWND hWnd
		, "UPtr", &margins) ; MARGINS *pMarInset
		
		; When manually resizing a window, the contents of the window often "lag
		; behind" the new window boundaries. Until they catch up, Windows will
		; render the border and default window color to fill that area. On most
		; windows this will cause no issue, but for borderless windows this can
		; cause rendering artifacts such as thin borders or unwanted colors to
		; appear in that area until the rest of the window catches up.
		;
		; When creating a dark-themed application, these artifacts can cause
		; jarringly visible bright areas. This can be mitigated some by changing
		; the window settings to cause dark/black artifacts, but it's not a
		; generalizable approach, so if I were to do that here it could cause
		; issues with light-themed apps.
		;
		; Some borderless window libraries, such as rossy's C implementation
		; (https://github.com/rossy/borderless-window) hide these artifacts by
		; playing with the window transparency settings which make them go away
		; but also makes it impossible to show certain colors (in rossy's case,
		; Fuchsia/FF00FF).
		;
		; Luckly, there's an undocumented Windows API function in user32.dll
		; called SetWindowCompositionAttribute, which allows you to change the
		; window accenting policies. This tells the DWM compositor how to fill
		; in areas that aren't covered by controls. By enabling the "blurbehind"
		; accent policy, Windows will render a blurred version of the screen
		; contents behind your window in that area, which will not be visually
		; jarring regardless of the colors of your application or those behind
		; it.
		;
		; Because this API is undocumented (and unavailable in Windows versions
		; below 10) it's not a one-size-fits-all solution, and could break with
		; future system updates. Hopefully a better soultion for the problem
		; this hack addresses can be found for future releases of this library.
		;
		; https://withinrafael.com/2018/02/02/adding-acrylic-blur-to-your-windows-10-apps-redstone-4-desktop-apps/
		; https://github.com/melak47/BorderlessWindow/issues/13#issuecomment-309154142
		; http://undoc.airesoft.co.uk/user32.dll/SetWindowCompositionAttribute.php
		; https://gist.github.com/riverar/fd6525579d6bbafc6e48
		; https://vhanla.codigobit.info/2015/07/enable-windows-10-aero-glass-aka-blur.html
		
		Gui, Color, 0, 0
		VarSetCapacity(wcad, A_PtrSize+A_PtrSize+4, 0)
		NumPut(this.WCA_ACCENT_POLICY, &wcad, 0, "Int")
		VarSetCapacity(accent, 16, 0)
		; Use ACCENT_ENABLE_GRADIENT on Windows 11 to fix window dragging issues
		if(this.OS_MINOR_VER >= 22000)
			AccentState:= this.ACCENT_ENABLE_GRADIENT
		else
			AccentState:= this.ACCENT_ENABLE_BLURBEHIND
		NumPut(AccentState, &accent, 0, "Int")
		NumPut(&accent, &wcad, A_PtrSize, "Ptr")
		NumPut(16, &wcad, A_PtrSize+A_PtrSize, "Int")
		DllCall("SetWindowCompositionAttribute", "UPtr", hWnd, "UPtr", &wcad)
		
		; Creating an ActiveX control with a valid URL instantiates a
		; WebBrowser, saving its object to the associated variable. The "about"
		; URL scheme allows us to start the control on either a blank page, or a
		; page with some HTML content pre-loaded by passing HTML after the
		; colon: "about:<!DOCTYPE html><body>...</body>"
		
		; Read more about the WebBrowser control here:
		; http://msdn.microsoft.com/en-us/library/aa752085
		
		; For backwards compatibility reasons, the WebBrowser control defaults
		; to IE7 emulation mode. The standard method of mitigating this is to
		; include a compatibility meta tag in the HTML, but this requires
		; tampering to the HTML and does not solve all compatibility issues.
		; By tweaking the registry before and after creation of the control we
		; can opt-out of the browser emulation feature altogether with minimal
		; impact on the rest of the system.
		
		; Read more about browser compatibility modes here:
		; https://docs.microsoft.com/en-us/archive/blogs/patricka/controlling-webbrowser-control-compatibility
		
		RegRead, fbe, % this.KEY_FBE, % this.EXE_NAME
		RegWrite, REG_DWORD, % this.KEY_FBE, % this.EXE_NAME, 0
		Gui, Add, ActiveX, vwb hWndhWB x0 y0 w800 h600, about:blank
		if (fbe = "")
			RegDelete, % this.KEY_FBE, % this.EXE_NAME
		else
			RegWrite, REG_DWORD, % this.KEY_FBE, % this.EXE_NAME, % fbe
		
		; Save the WebBrowser control to reference later
		this.wb := wb
		this.hWB := hWB
		
		; Connect the web browser's event stream to a new event handler object
		ComObjConnect(this.wb, new this.WBEvents(this))
		
		; Compute the HTML template if necessary
		if !(html ~= "i)^<!DOCTYPE")
			html := Format(this.TEMPLATE, css, title, html, js)
		
		; Write the given content to the page
		this.doc.write(html)
		this.doc.close()
		
		; Inject the AHK objects into the JS scope
		this.wnd.neutron := this
		this.wnd.ahk := new this.Dispatch(this)
		
		; Wait for the page to finish loading
		while wb.readyState < 4
			Sleep, 50
		
		; Subclass the rendered Internet Explorer_Server control to intercept
		; its events, including WM_NCHITTEST and WM_NCLBUTTONDOWN.
		; Read more here: https://forum.juce.com/t/_/27937
		; And in the AutoHotkey documentation for RegisterCallback (Example 2)
		
		dhw := A_DetectHiddenWindows
		DetectHiddenWindows, On
		ControlGet, hWnd, hWnd,, Internet Explorer_Server1, % "ahk_id" this.hWnd
		this.hIES := hWnd
		ControlGet, hWnd, hWnd,, Shell DocObject View1, % "ahk_id" this.hWnd
		this.hSDOV := hWnd
		DetectHiddenWindows, %dhw%
		
		this.pWndProc := RegisterCallback(this._WindowProc, "", 4, &this)
		this.pWndProcOld := DllCall("SetWindowLong" (A_PtrSize == 8 ? "Ptr" : "")
		, "Ptr", this.hIES     ; HWND     hWnd
		, "Int", -4            ; int      nIndex (GWLP_WNDPROC)
		, "Ptr", this.pWndProc ; LONG_PTR dwNewLong
		, "Ptr") ; LONG_PTR
		
		; Stop the WebBrowser control from consuming file drag and drop events
		this.wb.RegisterAsDropTarget := False
		DllCall("ole32\RevokeDragDrop", "UPtr", this.hIES)
	}
	
	; Show an alert for debugging purposes when the class gets garbage collected
	; __Delete()
	; {
	; 	MsgBox, __Delete
	; }
	
	
	; --- Event Handlers ---
	
	_OnMessage(wParam, lParam, Msg, hWnd)
	{
		if (hWnd == this.hWnd)
		{
			; Handle messages for the main window
			
			if (Msg == this.WM_NCCALCSIZE)
			{
				; Size the client area to fill the entire window.
				; See this project for more information:
				; https://github.com/rossy/borderless-window
				
				; Fill client area when not maximized
				if !DllCall("IsZoomed", "UPtr", hWnd)
					return 0
				; else crop borders to prevent screen overhang
				
				; Query for the window's border size
				VarSetCapacity(windowinfo, 60, 0)
				NumPut(60, windowinfo, 0, "UInt")
				DllCall("GetWindowInfo", "UPtr", hWnd, "UPtr", &windowinfo)
				cxWindowBorders := NumGet(windowinfo, 48, "Int")
				cyWindowBorders := NumGet(windowinfo, 52, "Int")
				
				; Inset the client rect by the border size
				NumPut(NumGet(lParam+0, "Int") + cxWindowBorders, lParam+0, "Int")
				NumPut(NumGet(lParam+4, "Int") + cyWindowBorders, lParam+4, "Int")
				NumPut(NumGet(lParam+8, "Int") - cxWindowBorders, lParam+8, "Int")
				NumPut(NumGet(lParam+12, "Int") - cyWindowBorders, lParam+12, "Int")
				
				return 0
			}
			else if (Msg == this.WM_SIZE)
			{
				; Extract size from LOWORD and HIWORD (preserving sign)
				this.w := w := lParam<<48>>48
				this.h := h := lParam<<32>>48
				
				DllCall("MoveWindow", "UPtr", this.hWB, "Int", 0, "Int", 0, "Int", w, "Int", h, "UInt", 0)
				
				return 0
			}
			else if (Msg == this.WM_DESTROY)
			{
				; Clean up all our circular references so that the object may be
				; garbage collected.
				
				for i, message in this.LISTENERS
					OnMessage(message, this.bound._OnMessage, 0)
				ComObjConnect(this.wb)
				this.bound := []
			}
		}
		else if (hWnd == this.hIES || hWnd == this.hSDOV)
		{
			; Handle messages for the rendered Internet Explorer_Server
			
			pressed := (Msg == this.WM_KEYDOWN || Msg == this.WM_SYSKEYDOWN)
			released := (Msg == this.WM_KEYUP || Msg == this.WM_SYSKEYUP)
			
			if (pressed || released)
			{
				; Track modifier states
				if (bit := this.MODIFIER_BITMAP[wParam])
					this.modifiers := (this.modifiers & ~bit) | (pressed * bit)
				
				; Block disabled key combinations
				if (this.disabled_shortcuts[this.modifiers, wParam])
					return 0
				
				
				; When you press tab with the last tabbable item in the
				; document already selected, focus will be taken from the IES
				; control and moved to the SDOV control. The accelerator code
				; from the AutoHotkey installer uses a conditional loop in an
				; attempt to work around this behavior, but as implemented it
				; did not work correctly on my system. Instead, listen for the
				; tab up event on the SDOV and swap it for a tab down before
				; translating it. This should prevent the user from tabbing to
				; the SDOV in most cases, though there may still be some way to
				; tab to it that I am not aware of. A more elegant solution may
				; be to subclass the SDOV like was done for the IES, then
				; forward the WM_SETFOCUS message back to the IES control.
				; However, given the relative complexity of subclassing and the
				; fact that this message substution approach appears to work
				; just as well, we will use the message substitution. Consider
				; implementing the other approach if it turns out that the
				; undesirable behavior continues to manifest under some
				; circumstances.
				Msg := hWnd == this.hSDOV ? this.WM_KEYDOWN : Msg
				
				; Modified accelerator handling code from AutoHotkey Installer
				Gui +OwnDialogs ; For threadless callbacks which interrupt this.
				pipa := ComObjQuery(this.wb, "{00000117-0000-0000-C000-000000000046}")
				VarSetCapacity(kMsg, 48), NumPut(A_GuiY, NumPut(A_GuiX
				, NumPut(A_EventInfo, NumPut(lParam, NumPut(wParam
				, NumPut(Msg, NumPut(hWnd, kMsg)))), "uint"), "int"), "int")
				r := DllCall(NumGet(NumGet(1*pipa)+5*A_PtrSize), "ptr", pipa, "ptr", &kMsg)
				ObjRelease(pipa)
				
				if (r == 0) ; S_OK: the message was translated to an accelerator.
					return 0
				return
			}
		}
	}
	
	_WindowProc(Msg, wParam, lParam)
	{
		Critical
		hWnd := this
		this := Object(A_EventInfo)
		
		if (Msg == this.WM_NCHITTEST)
		{
			; Check to see if the cursor is near the window border, which
			; should be treated as the "non-client" drag-to-resize area.
			; https://autohotkey.com/board/topic/23969-/#entry155480
			
			; Extract coordinates from LOWORD and HIWORD (preserving sign)
			x := lParam<<48>>48, y := lParam<<32>>48
			
			; Get the window position for comparison
			WinGetPos, wX, wY, wW, wH, % "ahk_id" this.hWnd
			
			; Calculate positions in the lookup tables
			row := (x < wX + this.BORDER_SIZE) ? 1 : (x >= wX + wW - this.BORDER_SIZE) ? 3 : 2
			col := (y < wY + this.BORDER_SIZE) ? 1 : (y >= wY + wH - this.BORDER_SIZE) ? 3 : 2
			
			return this.HT_VALUES[col, row]
		}
		else if (Msg == this.WM_NCLBUTTONDOWN)
		{
			; Hoist nonclient clicks to main window
			return DllCall("SendMessage", "Ptr", this.hWnd, "UInt", Msg, "UPtr", wParam, "Ptr", lParam, "Ptr")
		}
		
		; Otherwise (since above didn't return), pass all unhandled events to the original WindowProc.
		Critical, Off
		return DllCall("CallWindowProc"
		, "Ptr", this.pWndProcOld ; WNDPROC lpPrevWndFunc
		, "Ptr", hWnd             ; HWND    hWnd
		, "UInt", Msg             ; UINT    Msg
		, "UPtr", wParam          ; WPARAM  wParam
		, "Ptr", lParam           ; LPARAM  lParam
		, "Ptr") ; LRESULT
	}
	
	; --- Instance Methods ---
	
	; Triggers window dragging. Call this on mouse click down. Best used as your
	; title bar's onmousedown attribute.
	DragTitleBar()
	{
		PostMessage, this.WM_NCLBUTTONDOWN, 2, 0,, % "ahk_id" this.hWnd
	}
	
	; Minimizes the Neutron window. Best used in your title bar's minimize
	; button's onclick attribute.
	Minimize()
	{
		Gui, % this.hWnd ":Minimize"
	}
	
	; Maximize the Neutron window. Best used in your title bar's maximize
	; button's onclick attribute.
	Maximize()
	{
		if DllCall("IsZoomed", "UPtr", this.hWnd)
		{
			Gui, % this.hWnd ":Restore"
			; remove this class from document body
			this.qs("body").classList.remove("neutron-maximized")
		}
		else
		{
			Gui, % this.hWnd ":Maximize"
			; add this class to document body
			this.qs("body").classList.add("neutron-maximized")
		}
	}
	
	; Closes the Neutron window. Best used in your title bar's close
	; button's onclick attribute.
	Close()
	{
		WinClose, % "ahk_id" this.hWnd
	}
	
	; Hides the Nuetron window.
	Hide()
	{
		Gui, % this.hWnd ":Hide"
	}
	
	; Destroys the Neutron window. Do this when you would no longer want to
	; re-show the window, as it will free the memory taken up by the GUI and
	; ActiveX control. This method is best used either as your title bar's close
	; button's onclick attribute, or in a custom window close routine.
	Destroy()
	{
		Gui, % this.hWnd ":Destroy"
	}
	
	; Shows a hidden Neutron window.
	Show(options:="",title:="")
	{
		w := RegExMatch(options, "w\s*\K\d+", match) ? match : this.w
		h := RegExMatch(options, "h\s*\K\d+", match) ? match : this.h
		
		; AutoHotkey sizes the window incorrectly, trying to account for borders
		; that aren't actually there. Call the function AHK uses to offset and
		; apply the change in reverse to get the actual wanted size.
		VarSetCapacity(rect, 16, 0)
		DllCall("AdjustWindowRectEx"
		, "Ptr", &rect ;  LPRECT lpRect
		, "UInt", 0x80CE0000 ;  DWORD  dwStyle
		, "UInt", 0 ;  BOOL   bMenu
		, "UInt", 0 ;  DWORD  dwExStyle
		, "UInt") ; BOOL
		w += NumGet(&rect, 0, "Int")-NumGet(&rect, 8, "Int")
		h += NumGet(&rect, 4, "Int")-NumGet(&rect, 12, "Int")
		
		Gui, % this.hWnd ":Show", %options% w%w% h%h%, %title%
	}
	
	; Loads an HTML file by name (not path). When running the script uncompiled,
	; looks for the file in the local directory. When running the script
	; compiled, looks for the file in the EXE's RCDATA. Files included in your
	; compiled EXE by FileInstall are stored in RCDATA whether they get
	; extracted or not. An easy way to get your Neutron resources into a
	; compiled script, then, is to put FileInstall commands for them right below
	; the return at the bottom of your AutoExecute section.
	;
	; Parameters:
	;   fileName - The name of the HTML file to load into the Neutron window.
	;              Make sure to give just the file name, not the full path.
	;
	; Returns: nothing
	;
	; Example:
	;
	; ; AutoExecute Section
	; neutron := new NeutronWindow()
	; neutron.Load("index.html")
	; neutron.Show()
	; return
	; FileInstall, index.html, index.html
	; FileInstall, index.css, index.css
	;
	Load(fileName)
	{
		; Complete the path based on compiled state
		if A_IsCompiled
			url := "res://" this.wnd.encodeURIComponent(A_ScriptFullPath) "/10/" fileName
		else
			url := A_WorkingDir "/" fileName
		
		; Navigate to the calculated file URL
		this.wb.Navigate(url)
		
		; Wait for the page to finish loading
		while this.wb.readyState < 3
			Sleep, 50
		
		; Inject the AHK objects into the JS scope
		this.wnd.neutron := this
		this.wnd.ahk := new this.Dispatch(this)
		
		; Wait for the page to finish loading
		while this.wb.readyState < 4
			Sleep, 50
	}
	
	; Shorthand method for document.querySelector
	qs(selector)
	{
		return this.doc.querySelector(selector)
	}
	
	; Shorthand method for document.querySelectorAll
	qsa(selector)
	{
		return this.doc.querySelectorAll(selector)
	}
	
	; Passthrough method for the Gui command, targeted at the Neutron Window
	; instance
	Gui(subCommand, value1:="", value2:="", value3:="")
	{
		Gui, % this.hWnd ":" subCommand, %value1%, %value2%, %value3%
	}
	
	; Changes the window AccentState to ACCENT_ENABLE_GRADIENT
	; and sets the specified fill color
	SetWindowFillColor(colorHex:="000000")
	{
		colorHex := this._HexToABGR(colorHex)
		VarSetCapacity(wcad, A_PtrSize+A_PtrSize+4, 0)
		NumPut(this.WCA_ACCENT_POLICY, &wcad, 0, "Int")
		VarSetCapacity(accent, 16, 0)
		NumPut(this.ACCENT_ENABLE_GRADIENT, &accent, 0, "Int")
		NumPut(colorHex, &accent, 8, "Int")
		NumPut(&accent, &wcad, A_PtrSize, "Ptr")
		NumPut(16, &wcad, A_PtrSize+A_PtrSize, "Int")
		DllCall("SetWindowCompositionAttribute", "UPtr", this.hWnd, "UPtr", &wcad)
	}

	; --- Static Methods ---
	
	; Given an HTML Collection (or other JavaScript array), return an enumerator
	; that will iterate over its items.
	;
	; Parameters:
	;     htmlCollection - The JavaScript array to be iterated over
	;
	; Returns: An Enumerable object
	;
	; Example:
	;
	; neutron := new NeutronWindow("<body><p>A</p><p>B</p><p>C</p></body>")
	; neutron.Show()
	; for i, element in neutron.Each(neutron.body.children)
	;     MsgBox, % i ": " element.innerText
	;
	Each(htmlCollection)
	{
		return new this.Enumerable(htmlCollection)
	}
	
	; Given an HTML Form Element, construct a FormData object
	;
	; Parameters:
	;   formElement - The HTML Form Element
	;   useIdAsName - When a field's name is blank, use it's ID instead
	;
	; Returns: A FormData object
	;
	; Example:
	;
	; neutron := new NeutronWindow("<form>"
	; . "<input type='text' name='field1' value='One'>"
	; . "<input type='text' name='field2' value='Two'>"
	; . "<input type='text' name='field3' value='Three'>"
	; . "</form>")
	; neutron.Show()
	; formElement := neutron.doc.querySelector("form") ; Grab 1st form on page
	; formData := neutron.GetFormData(formElement) ; Get form data
	; MsgBox, % formData.field2 ; Pull a single field
	; for name, element in formData ; Iterate all fields
	;     MsgBox, %name%: %element%
	;
	GetFormData(formElement, useIdAsName:=True)
	{
		formData := new this.FormData()
		
		for i, field in this.Each(formElement.elements)
		{
			; Discover the field's name
			name := ""
			try ; fieldset elements error when reading the name field
				name := field.name
			if (name == "" && useIdAsName)
				name := field.id
			
			; Filter against fields which should be omitted
			if (name == "" || field.disabled
				|| field.type ~= "^file|reset|submit|button$")
				continue
			
			; Handle select-multiple variants
			if (field.type == "select-multiple")
			{
				for j, option in this.Each(field.options)
					if (option.selected)
						formData.add(name, option.value)
				continue
			}
			
			; Filter against unchecked checkboxes and radios
			if (field.type ~= "^checkbox|radio$" && !field.checked)
				continue
			
			; Return the field values
			formData.add(name, field.value)
		}
		
		return formData
	}
	
	; Given a potentially HTML-unsafe string, return an HTML safe string
	; https://stackoverflow.com/a/6234804
	EscapeHTML(unsafe)
	{
		unsafe := StrReplace(unsafe, "&", "&amp;")
		unsafe := StrReplace(unsafe, "<", "&lt;")
		unsafe := StrReplace(unsafe, ">", "&gt;")
		unsafe := StrReplace(unsafe, """", "&quot;")
		unsafe := StrReplace(unsafe, "''", "&#039;")
		return unsafe
	}
	
	; Wrapper for Format that applies EscapeHTML to each value before passing
	; them on. Useful for dynamic HTML generation.
	FormatHTML(formatStr, values*)
	{
		for i, value in values
			values[i] := this.EscapeHTML(value)
		return Format(formatStr, values*)
	}
	
	; Converts any hex-formatted RGB color to ABGR format,
	; colorHex can be passed as "#ff00ff" or as 0xff00ff
	_HexToABGR(colorHex)
	{
		colorHex := StrReplace(colorHex, "0x", "")
		colorHex := StrReplace(colorHex, "#", "")
		return "0xff" SubStr(colorHex, 5, 2) 
			. SubStr(colorHex, 3 , 2) 
			. SubStr(colorHex, 1 , 2)
	}
	
	; --- Nested Classes ---
	
	; Proxies method calls to AHK function calls, binding a given value to the
	; first parameter of the target function.
	;
	; For internal use only.
	;
	; Parameters:
	;   parent - The value to bind
	;
	class Dispatch
	{
		__New(parent)
		{
			this.parent := parent
		}
		
		__Call(params*)
		{
			; Make sure the given name is a function
			if !(fn := Func(params[1]))
				throw Exception("Unknown function: " params[1])
			
			; Make sure enough parameters were given
			if (params.length() < fn.MinParams)
				throw Exception("Too few parameters given to " fn.Name ": " params.length())
			
			; Make sure too many parameters weren't given
			if (params.length() > fn.MaxParams && !fn.IsVariadic)
				throw Exception("Too many parameters given to " fn.Name ": " params.length())
			
			; Change first parameter from the function name to the neutron instance
			params[1] := this.parent
			
			; Call the function
			return fn.Call(params*)
		}
	}
	
	; Handles Web Browser events
	; https://docs.microsoft.com/en-us/previous-versions/windows/internet-explorer/ie-developer/platform-apis/aa768283%28v%3dvs.85%29
	;
	; For internal use only
	;
	; Parameters:
	;   parent - An instance of the Neutron class
	;
	class WBEvents
	{
		__New(parent)
		{
			this.parent := parent
		}
		
		DocumentComplete(wb)
		{
			; Inject the AHK objects into the JS scope
			wb.document.parentWindow.neutron := this.parent
			wb.document.parentWindow.ahk := new this.parent.Dispatch(this.parent)
		}
	}
	
	; Enumerator class that enumerates the items of an HTMLCollection (or other
	; JavaScript array).
	;
	; Best accessed through the .Each() helper method.
	;
	; Parameters:
	;   htmlCollection - The HTMLCollection to be enumerated.
	;
	class Enumerable
	{
		i := 0
		
		__New(htmlCollection)
		{
			this.collection := htmlCollection
		}
		
		_NewEnum()
		{
			return this
		}
		
		Next(ByRef i, ByRef elem)
		{
			if (this.i >= this.collection.length)
				return False
			i := this.i
			elem := this.collection.item(this.i++)
			return True
		}
	}
	
	; A collection similar to an OrderedDict designed for holding form data.
	; This collection allows duplicate keys and enumerates key value pairs in
	; the order they were added.
	class FormData
	{
		names := []
		values := []
		
		; Add a field to the FormData structure.
		;
		; Parameters:
		;   name - The form field name associated with the value
		;   value - The value of the form field
		;
		; Returns: Nothing
		;
		Add(name, value)
		{
			this.names.Push(name)
			this.values.Push(value)
		}
		
		; Get an array of all values associated with a name.
		;
		; Parameters:
		;   name - The form field name associated with the values
		;
		; Returns: An array of values
		;
		; Example:
		;
		; fd := new NeutronWindow.FormData()
		; fd.Add("foods", "hamburgers")
		; fd.Add("foods", "hotdogs")
		; fd.Add("foods", "pizza")
		; fd.Add("colors", "red")
		; fd.Add("colors", "green")
		; fd.Add("colors", "blue")
		; for i, food in fd.All("foods")
		;     out .= i ": " food "`n"
		; MsgBox, %out%
		;
		All(name)
		{
			values := []
			for i, v in this.names
				if (v == name)
					values.Push(this.values[i])
			return values
		}
		
		; Meta-function to allow direct access of field values using either dot
		; or bracket notation. Can retrieve the nth item associated with a given
		; name by passing more than one value in when bracket notation.
		;
		; Example:
		;
		; fd := new NeutronWindow.FormData()
		; fd.Add("foods", "hamburgers")
		; fd.Add("foods", "hotdogs")
		; MsgBox, % fd.foods ; hamburgers
		; MsgBox, % fd["foods", 2] ; hotdogs
		;
		__Get(name, n := 1)
		{
			for i, v in this.names
				if (v == name && !--n)
					return this.values[i]
		}
		
		; Allow iteration in the order fields were added, instead of a normal
		; object's alphanumeric order of iteration.
		;
		; Example:
		;
		; fd := new NeutronWindow.FormData()
		; fd.Add("z", "3")
		; fd.Add("y", "2")
		; fd.Add("x", "1")
		; for name, field in fd
		;     out .= name ": " field ","
		; MsgBox, %out% ; z: 3, y: 2, x: 1
		;
		_NewEnum()
		{
			return {"i": 0, "base": this}
		}
		Next(ByRef name, ByRef value)
		{
			if (++this.i > this.names.length())
				return False
			name := this.names[this.i]
			value := this.values[this.i]
			return True
		}
	}
}


html =
(
<body>
    <form id="xpform" onsubmit="ahk.Submitted(event)">
        <fieldset>
            <legend align="center">
                <h2>XP Script Settings</h2>
            </legend>
            <div class="row">
				<span>
					<input class="balloon" id="startInput" type="text" readonly>
					<label for="startInput">Start</label>
				</span>

                <span>
                    <input class="balloon" id="stopInput" type="text" readonly>
                    <label for="stopInput">Reload</label>
                </span>
				<span>
					<input class="balloon" id="closeInput" type="text" readonly>
					<label for="closeInput">Close</label>
				</span>
            </div>
			<div class="row row2">
				<span>
					<input class="balloon" id="menuInput" type="text" readonly>
					<label for="menuInput">Menu</label>
				</span>
				<div class="delaycontainer">
					<input class="balloon" id="delayInput" type="text" oninput="validateInput(this)">
					<label for="delayInput">Delay</label><span class="additionaldelay">+ 500ms</span>
				</div>
                <span>
                    <button class="button defaultbutton" id="resetButton" type="button">Reset to default</button>
                </span>
				<div class="subtext">
					<span class="lighttext">A delay between 2400~2900ms is advised. The additional 500ms delay is for anti-afk.</span>
				</div>
            </div>
        </fieldset>
		<fieldset>
			<legend align="center">
				<h2>Builds</h2>
			</legend>
			<div class="row">
				<span>
					<button class="altbutton" id="titan_build_info_button" type="button">Titan Build Info</button>
				</span>
				<div id="titan_build_info_modal" class="modal">
					<div class="modal-content">
						<h2>Titan Build Info</h2>
						<p><span>Exotic:</span>Ashens Wake</p>
						<p><span>Grenade:</span>Fusion Grenade</p>
						<p><span>Mods:</span>3x Grenade Kickstart</p>
						<p><span>Aspect/Fragment:</span>DO NOT use the Sol Invictus aspect</p>
						<span class="lighttext">100 Discpline is nice but not required!</span><br>
						<button class="smallbutton" id="titan_build_close_button" type="button">Close</button>
					</div>
				</div>
				<label>
					<div id="toggler">
						<input type="checkbox" id="titan_enable"><span>Current Mode: </span>
					</div>
				</label>
				<span>
					<button class="altbutton" id="hunter_build_info_button" type="button">Hunter Build Info</button>
				</span>
				<div id="hunter_build_info_modal" class="modal">
					<div class="modal-content">
						<h2>Hunter Build Info</h2>
						<p><span>Exotic:</span>Ophidia Spathe or Caliban's Hand</p>
						<p><span>Melee:</span>Proximity Explosive Knife</p>
						<p><span>Mods:</span>3x Melee Kickstart</p>
						<p><span>Aspect/Fragment:</span>Knock 'Em Down and Ember of Torches</p>
						<span class="lighttext">100 Strength is nice but not required!</span><br>
						<button class="smallbutton" id="hunter_build_close_button" type="button">Close</button>
					</div>
				</div>
			</div>
			<div class="subtext">
				<span class="lighttext">Titan's slightly better. Hunter's fine if it's all you have. Click "Current Mode" to switch modes.</span>
			</div>
		</fieldset>
		<div class="row">
			<p class="alerttext" id="alert1"></p>
			<span>
				<button class="button bigbutton" id="closeButton" type="button" onclick="ahk.closeButton(event)">Close Menu</button>
			</span>
			<span>
				<button class="button bigbutton" id="saveButton" type="submit">Save/Reload</button>
			</span>
		</div>
		<div class="subtext">
			<span class="lighttext">Checkpoint bot: <a id="copyJoinCode" href="#">/join CPBot#6289</a> - Bot's down or full? Ask in our Discord!</span>
		</div>
		<div id="copy_modal" class="modal">
			<div class="modal-content">
				<p>Join code copied to clipboard!</p>
			</div>
		</div>
		<div class="signature">
			<p>			
				<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-heart-fill" viewBox="0 0 16 16">
					<path fill-rule="evenodd" d="M8 1.314C12.438-3.248 23.534 4.735 8 15-7.534 4.736 3.562-3.248 8 1.314z"/>
				</svg>
				from <a href="#" onclick="ahk.antraClicked(event)">Antra</a> - <a href="#" onclick="ahk.discordClicked(event)">Join our Discord</a> for support and more scripts!
			</p>
		</div>
    </form>
</body>



)

css =
(
/* General Styles */
* {
    box-sizing: border-box;
}

body {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    margin: 0;
    padding: 0;
    font-family: "Open Sans", sans-serif;
    font-weight: 300;
    color: #fff;
    background: #393E46;
}

header {
    background: #222831;
    color: white;
}

h2 {
    text-align: center;
    font-size: 1.3em;
    font-weight: 800;
    margin: 0;
    padding: 0;
}

fieldset {
    padding-top: 5px;
    border: 2px solid rgba(0, 173, 181, 0.5);
}

legend {
    color: #EEE;
    text-align: center;
}

table {
    margin: 5px auto;
    table-layout: fixed;
}

.alerttext {
    margin: 5px 0;
    font-size: 0.9em;
    padding: 0;
    font-weight: 700;
    color: #f00;
    text-align: center;
}

.lighttext {
    color: #AAA !important;
}

/* Checkboxes */
.checkbox {
    display: block;
    width: 150px;
    position: relative;
    cursor: pointer;
    margin-bottom: 8px;
}

.checkbox input[type="checkbox"] {
    position: absolute;
    display: block;
    top: 0;
    left: 0;
    height: 100`%;
    width: 100`%;
    cursor: pointer;
    margin: 0;
    opacity: 0;
    z-index: 1;
}

.checkbox label {
    display: inline-block;
    vertical-align: top;
    text-align: left;
    padding-left: 1.5em;
    color: #EEE;
    z-index: 10;
}

.checkbox label:before {
    content: '';
    display: block;
    position: absolute;
    left: 0;
    top: 0;
    width: 18px;
    height: 18px;
    margin-right: 10px;
    background: #ddd;
    border-radius: 3px;
}

.checkbox label:after {
    content: '';
    display: block;
    position: absolute;
    top: 4px;
    left: 4px;
    width: 10px;
    height: 10px;
    border-radius: 2px;
    background: #00ADB5;
    opacity: 0;
    pointer-events: none;
}

.checkbox input:checked ~ label:after {
    opacity: 1;
}

.checkbox input:focus ~ label:before {
    background: #eee;
}

/* Modals */
.modal {
    display: none;
    position: fixed;
    z-index: 9999;
    padding-top: 80px;
    left: 0;
    top: 0;
    width: 100`%;
    height: 100`%;
    overflow: auto;
    background-color: rgba(0, 0, 0, 0.4);
}

.modal-content {
    text-align: center;
    background-color: #393E46;
    color: white;
    margin: auto;
    z-index: 9999;
    border: 2px solid rgba(0, 173, 181, 0.5);
    width: 80`%;
}

.modal-content p {
    padding: 0;
    margin: 0;
}

/* Copy Modal */
#copy_modal {
    padding-top: 100px;
}

#copy_modal modal-content {
    font-size: 2.5em;
    padding: 1em;
}

/* Signature */
.signature {
    width: 100`%;
    padding-top: 5px;
}

.signature a,
#copyJoinCode {
    color: #FFF;
    transition: color 0.8s;
    text-decoration: none;
    font-weight: bold;
}

.signature a:hover,
#copyJoinCode:hover {
    color: #2282e4;
}

.signature p {
    padding: 0;
    margin: auto 0 0 0;
    text-align: center;
    font-size: 1em;
    color: #AAA;
}

.signature svg {
    padding-top: 3px;
    width: 1.1em;
    height: 1.1em;
    fill: #BE1931;
}

/* Buttons */
.button {
    background-color: #00ADB5;
    width: 215px;
    position: relative;
    padding: 8px 0;
    top: -3px;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    font-size: 1em;
    border-radius: 3px;
    outline: 0;
    transition-duration: 0.4s;
    cursor: pointer;
    z-index: 1;
}

.defaultbutton {
    background-color: #222831;
    color: #EEE;
    border: 2px solid rgba(0, 173, 181, 0.5);
}

.defaultbutton:hover {
    background-color: #00ADB5;
    color: white;
}

.bigbutton {
    font-size: 1.3em;
    margin: 5px 0 0 0;
    background-color: #222831;
    color: #EEEEEE;
    border: 2px solid rgba(0, 173, 181, 0.5);
}

.bigbutton:hover {
    background-color: #00ADB5;
    color: white;
}

.altbutton {
    outline: 0;
    width: 175px;
    transition-duration: 0.4s;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    padding: 10px;
    font-size: 1em;
    margin: 0 5px;
    background-color: #222831;
    color: #EEEEEE;
    border: 2px solid rgba(0, 173, 181, 0.5);
    border-radius: 3px;
}

.altbutton:hover {
    background-color: #00ADB5;
    color: white;
}

.smallbutton {
	outline: 0;
	transition-duration: 0.4s;
	cursor: pointer;
	text-align: center;
	text-decoration: none;
	display: inline-block;
	padding:10px;
	font-size:1em;
	background-color: #222831;
	color: #EEEEEE;
	border: 2px solid #00b5ae;
	border-radius: 3px;
	margin: 5px 0;
}
.smallbutton:hover {
  background-color: #00b5ae;
  color: white;
}

/* Other Styles */
.row {
    margin: 0;
    max-width: 800px;
    position: relative;
    z-index: 1;
    text-align: center;
}

.row2 {
    padding-top: 10px;
}

.row:before {
    position: absolute;
    content: "";
    display: block;
    top: 0;
    left: -5000px;
    height: 100`%;
    z-index: -1;
    background: inherit;
}

.row span {
    position: relative;
    display: inline-block;
    margin: 0 10px;
}

/* Delay Container */
.delaycontainer {
    display: inline-block;
    position: relative;
    margin: 0 10px;
}

/* Additional Delay */
.additionaldelay {
    position: absolute !important;
    width: 70px !important;
    top: 11px !important;
    margin-left: -107px !important;
}

/* Subtext */
.subtext {
    padding-top: 5px;
    text-align: center;
}

/* Toggle Button Styles */
.togglebuttonHunter:hover {
    background-color: #F28338 !important;
    color: white;
}

.togglebuttonHunter {
    border: 2px solid #F28338;
    font-weight: 900;
}

.togglebuttonTitan:hover {
    background-color: #AD88C0 !important;
    color: white;
}

.togglebuttonTitan {
    border: 2px solid #AD88C0;
    font-weight: 900;
}

/* Toggler Styles */
#toggler {
    outline: 0;
    width: 235px;
    transition-duration: 0.4s;
    cursor: pointer;
    text-align: center;
    text-decoration: none;
    display: inline-block;
    padding: 10px;
    font-size: 1em;
    margin: 0 10px;
    background-color: #222831;
    color: #EEEEEE;
    border-radius: 3px;
}

label #toggler input {
    position: absolute;
    top: -4000px;
}

#toggler input + span:after {
    content: 'Hunter';
}

#toggler input:checked + span:after {
    content: 'Titan';
}

/* Balloon Styles */
.mini-balloon {
    display: inline-block;
    z-index: 999;
    position: absolute;
    text-align: center;
    width: 28px;
    color: #EEE;
    background: #222831;
    bottom: 1px;
    border: 0;
    border-radius: 3px;
    outline: 0;
}

.balloon {
    display: inline-block;
    width: 215px;
    padding: 11px 0 10px 15px;
    font-family: "Open Sans", sans;
    font-weight: 400;
    font-size: 1em;
    color: #EEE;
    background: #222831;
    border: 0;
    text-indent: 60px;
    border-radius: 3px;
    outline: 0;
    transition: all 0.3s ease-in-out;
}

.balloon + label {
    display: inline-block;
    position: absolute;
    top: 8px;
    width: 60px;
    padding: 3px;
    left: 0;
    bottom: 8px;
    margin: 0 0 0 9px;
    color: #EEE;
    font-size: 1em;
    font-weight: 700;
    text-shadow: 0 1px 0 rgba(19, 74, 70, 0);
    transition: all 0.3s ease-in-out;
    background: rgba(0, 173, 181, 0.5);
}

.balloon:focus,
.balloon:active {
    color: #EEE;
    text-indent: 0;
    background: #2D333B;
}

.balloon:hover {
    text-indent: 0;
}

.balloon:focus::placeholder,
.balloon:active::placeholder,
.balloon:hover::placeholder {
    color: #aaa;
}

.balloon:focus + label,
.balloon:active + label,
.balloon:hover + label {
    color: #fff;
    text-shadow: 0 1px 0 rgba(19, 74, 70, 0.5);
    background: #00ADB5;
    transform: translateY(-40px);
}

.balloon:focus + label:after,
.balloon:active + label:after,
.balloon:hover + label:after {
    border-top: 4px solid #00ADB5;
}

)

js =
(
	// Function to simulate sleep (only used for delaying the DOM loaded checkbox logic, as otherwise it does not run correctly - IE8 moment)
	function sleep(milliseconds, callback) {
		setTimeout(callback, milliseconds);
	}
	
	// Checkbox logic (for toggling between titan and hunter mode)
	var checkbox = document.getElementById('titan_enable');
	var parentElement = checkbox.parentElement;
	
	document.addEventListener('DOMContentLoaded', function() {
		sleep(500, function() {
			if (checkbox.checked) {
				parentElement.classList.add('togglebuttonTitan');
				parentElement.classList.remove('togglebuttonHunter');
			} else {
				parentElement.classList.add('togglebuttonHunter');
				parentElement.classList.remove('togglebuttonTitan');
			}
		});
	});
	
	checkbox.addEventListener('change', function() {
		if (checkbox.checked) {
			parentElement.classList.add('togglebuttonTitan');
			parentElement.classList.remove('togglebuttonHunter');
		} else {
			parentElement.classList.add('togglebuttonHunter');
			parentElement.classList.remove('togglebuttonTitan');
		}
	});
	
	// Copy Join Code Logic
	document.getElementById("copyJoinCode").addEventListener("click", function(event) {
		event.preventDefault();
		const textToCopy = event.target.textContent;
		
		const tempInput = document.createElement("input");
		tempInput.style.position = "absolute";
		tempInput.style.left = "-1000px";
		tempInput.value = textToCopy;
		document.body.appendChild(tempInput);
		
		tempInput.select();
		document.execCommand("copy");
		
		document.body.removeChild(tempInput);
		
		const modal = document.getElementById("copy_modal");
		modal.style.display = "block";
		
		setTimeout(function() {
			modal.style.display = "none";
		}, 2000);
	});
	
	// Modal Setup Function (for the information modals)
	function setupModal(modalId, openBtnId, closeBtnId) {
		var modal = document.getElementById(modalId);
		var openModalBtn = document.getElementById(openBtnId);
		var closeModalBtn = document.getElementById(closeBtnId);
	  
		openModalBtn.addEventListener("click", function() {
			modal.style.display = "block";
		});
	  
		closeModalBtn.addEventListener("click", function() {
			modal.style.display = "none";
		});
	  
		window.addEventListener("click", function(event) {
			if (event.target === modal) {
				modal.style.display = "none";
			}
		});
	  
		// Add event listener for the Escape key
		document.addEventListener("keydown", function(event) {
			if (event.key === "Esc") {
				modal.style.display = "none";
			}
		});
	}
	
	// Setup Modals
	setupModal("titan_build_info_modal", "titan_build_info_button", "titan_build_close_button");
	setupModal("hunter_build_info_modal", "hunter_build_info_button", "hunter_build_close_button");
	
	// Before Unload Event (if the user tries to refresh the page)
	window.addEventListener("beforeunload", function(event) {
		event.preventDefault();
		event.returnValue = "This will clear all values, are you sure you want to refresh?";
	});
	
	// Ensure Unique Values
	function ensureUniqueValue(inputId, value) {
		var inputs = document.querySelectorAll('input[type="text"]');
		for (var i = 0; i < inputs.length; i++) {
			if (inputs[i].id !== inputId && inputs[i].value === value) {
				document.getElementById('alert1').textContent = "Whatever you are pressing is already another bind.";
				return false;
			}
		}
		document.getElementById('alert1').textContent = "";
		return true;
	}
	
	// Input Validation For Delay
	function validateInput(input) {
		input.value = input.value.replace(/[^0-9]/g, '');
	
		const num = parseInt(input.value, 10);
		if (isNaN(num)) {
			input.value = "";
		} else {
			input.value = Math.min(9999, num); // Clamp the value to a maximum of 9999
		}
	}
	
	// Setup Input
	function setupInput(inputId) {
		var keyInput = document.getElementById(inputId);
	
		keyInput.addEventListener('focus', function () {
			document.addEventListener('keydown', onKeyDown);
		});
	
		keyInput.addEventListener('blur', function () {
			document.removeEventListener('keydown', onKeyDown);
		});
	
		function onKeyDown(event) {
			var keyPressed = event.key;
			if (ensureUniqueValue(inputId, keyPressed)) {
				keyInput.value = keyPressed;
			}
			event.preventDefault();
		}
	}
	
	setupInput('startInput');
	setupInput('stopInput');
	setupInput('closeInput');
	setupInput('menuInput');
	
	// Reset Button Logic
	document.getElementById("resetButton").addEventListener("click", function() {
		document.getElementById("startInput").value = "F4";
		document.getElementById("stopInput").value = "F5";
		document.getElementById("closeInput").value = "F8";
		document.getElementById("menuInput").value = "F9";
		document.getElementById("delayInput").value = "2800";
	});
	
)

title = Antra's Tabbed Out XP Script v1.1.1
;make da neutron
neutron := new NeutronWindow(html, css, js, title)
;add some settings, both self explanatory
neutron.Gui("+LabelNeutron +AlwaysOnTop")

;make a vigem virtual 360 controller
360Controller := new ViGEmXb360()

;make an overlay that is attached to d2 and only active while d2 is active
overlay := new ShinsOverlayClass("ahk_exe destiny2.exe")

;read settings for the script
gosub, readfromini

;set status as 0 e.g. not started for the overlay
status = 0

return

; neutron events, from clicking links/buttons/blah blah...
antraClicked(neutron, event)
{
	event.preventDefault()
	Run, https://ko-fi.com/Antrament
}

discordClicked(neutron, event)
{
    event.preventDefault()
	Run, https://discord.gg/KGyjysA5WY
}

closeButton(neutron, event)
{
    event.preventDefault()
	neutron.Hide()
	if (A_IsSuspended) {
		Suspend, Toggle
	}
}

Submitted(neutron, event)
{
    event.preventDefault()
    formData := neutron.GetFormData(event.target)
    global menuInput := formData.menuInput
    global closeInput := formData.closeInput
    global stopInput := formData.stopInput
    global startInput := formData.startInput
    global delayInput := formData.delayInput
	global titan_enable := formData.titan_enable
    gosub, writetoini
}
Return

readfromini:
	iniread, startInput, xpStuff.ini, xpScriptBinds, startInput, F4
	iniread, stopInput, xpStuff.ini, xpScriptBinds, stopInput, F5
	iniread, closeInput, xpStuff.ini, xpScriptBinds, closeInput, F8
	iniread, menuInput, xpStuff.ini, xpScriptBinds, menuInput, F9
	iniread, delayInput, xpStuff.ini, xpScriptDelays, delayInput, 2800
	iniread, titan_enable, xpStuff.ini, xpScriptMode, titan_enable, "on"
	iniread, initialOpen, xpStuff.ini, xpScriptMisc, initialOpen, 1
	neutron.doc.getElementById("startInput").value := startInput
	neutron.doc.getElementById("stopInput").value := stopInput
	neutron.doc.getElementById("closeInput").value := closeInput
	neutron.doc.getElementById("menuInput").value := menuInput
	neutron.doc.getElementById("delayInput").value := delayInput
	neutron.doc.getElementById("titan_enable").checked := titan_enable
	if (menuInput == closeInput || menuInput == stopInput || menuInput == startInput || closeInput == stopInput || closeInput == startInput || stopInput == startInput) {
		neutron.doc.getElementById("alert1").innertext := "You have overlapping binds!" ; this will basically only trigger if the user manually edits the xpStuff.ini file and inputs overlapping binds
		show = 1
		neutron.Show("h433")
		if (!A_IsSuspended) {
			Suspend, Toggle
		}
	} else {
		hotkey, %startInput%, start_bind
		hotkey, %stopInput%, stop_bind
		hotkey, %closeInput%, close_bind
		hotkey, %menuInput%, menu_bind
		neutron.doc.getElementById("alert1").innertext := "" ; remove any alert that may exist, because everything is ok
		show = 0
		neutron.Hide()
		if (A_IsSuspended) {
			Suspend, Toggle
		}
	}
	if (initialOpen) {
		gosub, writetoini
	}
return


writetoini:
	iniwrite, %startInput%, xpStuff.ini, xpScriptBinds, startInput
	iniwrite, %stopInput%, xpStuff.ini, xpScriptBinds, stopInput
	iniwrite, %closeInput%, xpStuff.ini, xpScriptBinds, closeInput
	iniwrite, %menuInput%, xpStuff.ini, xpScriptBinds, menuInput
	iniwrite, %delayInput%, xpStuff.ini, xpScriptDelays, delayInput
	iniwrite, %titan_enable%, xpStuff.ini, xpScriptMode, titan_enable
	if (initialOpen) {
		initialOpen = 0
		iniwrite, %initialOpen%, xpStuff.ini, xpScriptMisc, initialOpen
		reload
	} else {
	    reload
	}
return

start_bind:
	status = 1
	Loop {
		360Controller.Axes.LY.SetState(0) ; move backwards
		Loop 100 { ; 100 is a reasonable amount of casts to do before going back to the main loop to move backwards again for anti-afk
			if (titan_enable) {
				360Controller.Buttons.LB.SetState(true) ; throw grenade
			} else { ; if not titan, then hunter
				360Controller.Buttons.RB.SetState(true) ; throw melee
			}
			Sleep 500 ; this delay is for both anti-afk every 150 casts and allowing the ability to be cast (ability sometimes does not cast if no delay between button set true and set false)
			360Controller.Axes.LY.SetState(50) ; stop moving backwards
			360Controller.Buttons.LB.SetState(false) ; stop throwing grenade 
			360Controller.Buttons.RB.SetState(false) ; stop throwing melee
			Sleep % delayInput ; delayInput = delay set in the menu
		}
	}
	
Return

stop_bind:
	Reload
Return

close_bind:
	ExitApp
Return

menu_bind:
    Suspend, Permit
    if (!show) {
        show = 1
        neutron.Show("h433")
        if (!A_IsSuspended) {
            Suspend, Toggle
        }
    } else {
        show = 0
        neutron.hide()
        if (A_IsSuspended) {
            Suspend, Toggle
        }
    }
Return