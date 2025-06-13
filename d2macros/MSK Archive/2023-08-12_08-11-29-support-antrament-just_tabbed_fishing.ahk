if not A_IsAdmin {
	Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"
}
#Persistent
#SingleInstance, Force
SetBatchLines, -1
Process, Priority,, R

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
		_DpadStates := {1:0, 8:0, 2:0, 4:0}
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
		this.bits := (a_ptrsize == 8)
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

		

		this._cacheTargetImageFile := this.mcode("U4tMJBQPr0wkEIXJfiGLRCQIi1QkDI0ciI20JgAAAACLCIPABIPCBIlK/DnYdfG4AQAAAFvDkJCQkJCQkJCQkA==|RQ+vwUWFwH50TI1JD0GNQP9JKdFJg/kedm6D+AN2aUWJwTHAQcHpAknB4QQPH0AA8w9vBAEPEQQCSIPAEEw5yHXuRInAg+D8QfbAA3QvQYnBRosUiUaJFIpEjUgBRTnIfhtNY8mDwAJGixSJRokUikE5wH4ISJiLDIGJDIK4AQAAAMMPH0QAAEGJwDHADx8ARIsMgUSJDIJJicFIg8ABTTnBdey4AQAAAMOQkJCQkJA=")
		
		this.scanTypes := []
		this.scanTypes["LRTB"] := 0
		this.scanTypes["RLTB"] := 2
		this.scanTypes["LRBT"] := 1
		this.scanTypes["RLBT"] := 3
		this.scanTypes["TBRL"] := 7
		this.scanTypes["TBLR"] := 6
		this.scanTypes["BTRL"] := 5
		this.scanTypes["BTLR"] := 4
		this.scanTypes[0] := 0

		if (!this.desktop and !this.hwnd := winexist(title)) {
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
		c := DllCall(this._ScanPixelCountRegion,"Ptr",this.dataPtr,"Uint",color&0xFFFFFF,"int",(this.autoUpdate?0:x1),"int",(this.autoUpdate?0:y1),"int",w,"int",h,"uchar",variance,"int")
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
	}
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
	GetClientRect(byref w, byref h) {
		if (!DllCall("GetClientRect", "Ptr", this.hwnd, "Ptr", this.tBufferPtr))
			return 0
		w := NumGet(this.tBufferPtr,8,"int")
		h := NumGet(this.tBufferPtr,12,"int")
		if (w <= 0 or h <= 0)
			return 0
		return 1
	}
	GetWindowRect(byref w, byref h) {
		if (!DllCall("GetWindowRect", "Ptr", this.hwnd, "Ptr", this.tBufferPtr))
			return 0
		x := NumGet(this.tBufferPtr,0,"int")
		y := NumGet(this.tBufferPtr,4,"int")
		w := NumGet(this.tBufferPtr,8,"int") - x
		h := NumGet(this.tBufferPtr,12,"int") - y
		if (w <= 0 or h <= 0)
			return 0
		return 1
	}
	AppendFunc(pos,str) {
		local
		p := this.mcode(str)
		pp := (this.bits ? 24 : 16) + (pos * a_ptrSize)
		numput(p,this.dataPtr,pp,"ptr")
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

preciseSleep(s) {
    DllCall("QueryPerformanceFrequency", "Int64*", QPF)
    DllCall("QueryPerformanceCounter", "Int64*", QPCB)
    While (((QPCA - QPCB) / QPF * 1000) < s)
        DllCall("QueryPerformanceCounter", "Int64*", QPCA)
    return ((QPCA - QPCB) / QPF * 1000) 
}

360Controller := new ViGEmXb360()
scan := new ShinsImageScanClass()
return

F2::Exitapp
F3::Reload
F4::
WinGetPos, x, y, w, h, ahk_exe destiny2.exe
startWidth := w * 0.35
startHeight := h * 0.6
regionWidth := w * 0.25
regionHeight := h * 0.1
360Controller.buttons.x.setState(true)
preciseSleep(800)
360Controller.buttons.x.setState(false)
Loop {
    if (scan.pixelCountRegion(0x5B5B5B, x + startWidth, y + startHeight, regionWidth, regionHeight) > 30) {
        360Controller.buttons.x.setState(true)
        preciseSleep(800)
        360Controller.buttons.x.setState(false)
    }
}
return