;####################
; My discord is antrament - this is a server with more macro/script shit + support: https://discord.gg/KGyjysA5WY
;####################



; HAHAHAH THIS SCRIPT SUCKS SO FUCKING MUCH
; MAJOR REFACTORING NEEDED
; BUT IT WORKS SO WHATEVER!
#ifwinactive ahk_exe destiny2.exe
#noenv
#Persistent ; don't close until exitapp is encountered or the user terminates the process
#SingleInstance, Force ; do not allow multiple instances of this script to be open
SetBatchLines, -1 ; never automatically sleep.
sendmode input ; input is roughly 25% faster than event from my testing - SetKeyDelay, SetMouseDelay, SetDefaultMouseSpeed, etc. are ignored during input (there is no delay) and there is no reason this script would fallback to event or play (https://www.autohotkey.com/docs/v1/lib/Send.htm#SendInputUnavail)
SetWinDelay, -1 ; after windowing commands... dont delay (this is not really needed, but whatever, doesn't hurt)
SetControlDelay, -1 ; after control commands... dont delay (also not really needed, but who cares, doesn't hurt)




; !!!!!!!!!!!!!!!!!!!!
; WARNING: this shit is kind of dangerous!
if not A_IsAdmin {
    Run *RunAs "%A_AhkPath%" "%A_ScriptFullPath%"
}
Process, Priority,, R ; basically, set the scripts priority to realtime in task manager (or "high" if not ran as admin) - there is no real reason to do this, setting as A would probably be fine or more likely; exactly the same but apparently for some it's good? maybe placebo. whatever, it doesnt break anything so...
; !!!!!!!!!!!!!!!!!!!!!


preciseSleep(s) {
    DllCall("QueryPerformanceFrequency", "Int64*", QPF)
    DllCall("QueryPerformanceCounter", "Int64*", QPCB)
    While (((QPCA - QPCB) / QPF * 1000) < s)
        DllCall("QueryPerformanceCounter", "Int64*", QPCA)
    return ((QPCA - QPCB) / QPF * 1000) 
}

; Neutron.ahk v1.0.0
; Copyright (c) 2020 Philip Taylor (known also as GeekDude, G33kDude)
; https://github.com/G33kDude/Neutron.ahk
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
; 
;
; slightly edited by Antra
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
static VERSION := "1.0.0"
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
, VK_TAB := 0x09
, VK_SHIFT := 0x10
, VK_CONTROL := 0x11
, VK_MENU := 0x12
, VK_F5 := 0x74
, HT_VALUES := [[13, 12, 14], [10, 1, 11], [16, 15, 17]]
, KEY_FBE := "HKEY_CURRENT_USER\Software\Microsoft\Internet Explorer\MAIN"
. "\FeatureControl\FEATURE_BROWSER_EMULATION"
, ACCENT_ENABLE_GRADIENT := 1
, ACCENT_ENABLE_BLURBEHIND := 3
, WCA_ACCENT_POLICY := 19
, EXE_NAME := A_IsCompiled ? A_ScriptName : StrSplit(A_AhkPath, "\").Pop()
, OS_MINOR_VER := StrSplit(A_OSVersion, ".")[3]
LISTENERS := [this.WM_DESTROY, this.WM_SIZE, this.WM_NCCALCSIZE
, this.WM_KEYDOWN, this.WM_KEYUP, this.WM_SYSKEYDOWN, this.WM_SYSKEYUP
, this.WM_LBUTTONDOWN]
border_size := 6
w := 800
h := 600
MODIFIER_BITMAP := {this.VK_SHIFT: 1<<0, this.VK_CONTROL: 1<<1
, this.VK_MENU: 1<<2}
modifiers := 0
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
doc[]
{
get
{
return this.wb.Document
}
}
wnd[]
{
get
{
return this.wb.Document.parentWindow
}
}
__New(html:="", css:="", js:="", title:="Neutron")
{
static wb
this.bound := {}
this.bound._OnMessage := this._OnMessage.Bind(this)
for i, message in this.LISTENERS
OnMessage(message, this.bound._OnMessage)
Gui, New, +hWndhWnd +Resize -DPIScale
this.hWnd := hWnd
VarSetCapacity(margins, 16, 0)
NumPut(1, &margins, 0, "Int")
DllCall("Dwmapi\DwmExtendFrameIntoClientArea"
, "UPtr", hWnd
, "UPtr", &margins)
Gui, Color, 0, 0
VarSetCapacity(wcad, A_PtrSize+A_PtrSize+4, 0)
NumPut(this.WCA_ACCENT_POLICY, &wcad, 0, "Int")
VarSetCapacity(accent, 16, 0)
if(this.OS_MINOR_VER >= 22000)
AccentState:= this.ACCENT_ENABLE_GRADIENT
else
AccentState:= this.ACCENT_ENABLE_BLURBEHIND
NumPut(AccentState, &accent, 0, "Int")
NumPut(&accent, &wcad, A_PtrSize, "Ptr")
NumPut(16, &wcad, A_PtrSize+A_PtrSize, "Int")
DllCall("SetWindowCompositionAttribute", "UPtr", hWnd, "UPtr", &wcad)
RegRead, fbe, % this.KEY_FBE, % this.EXE_NAME
RegWrite, REG_DWORD, % this.KEY_FBE, % this.EXE_NAME, 0
Gui, Add, ActiveX, vwb hWndhWB x0 y0 w800 h600, about:blank
if (fbe = "")
RegDelete, % this.KEY_FBE, % this.EXE_NAME
else
RegWrite, REG_DWORD, % this.KEY_FBE, % this.EXE_NAME, % fbe
this.wb := wb
this.hWB := hWB
ComObjConnect(this.wb, new this.WBEvents(this))
if !(html ~= "i)^<!DOCTYPE")
html := Format(this.TEMPLATE, css, title, html, js)
this.doc.write(html)
this.doc.close()
this.wnd.neutron := this
this.wnd.ahk := new this.Dispatch(this)
while wb.readyState < 4
Sleep, 50
dhw := A_DetectHiddenWindows
DetectHiddenWindows, On
ControlGet, hWnd, hWnd,, Internet Explorer_Server1, % "ahk_id" this.hWnd
this.hIES := hWnd
ControlGet, hWnd, hWnd,, Shell DocObject View1, % "ahk_id" this.hWnd
this.hSDOV := hWnd
DetectHiddenWindows, %dhw%
this.pWndProc := RegisterCallback(this._WindowProc, "", 4, &this)
this.pWndProcOld := DllCall("SetWindowLong" (A_PtrSize == 8 ? "Ptr" : "")
, "Ptr", this.hIES
, "Int", -4
, "Ptr", this.pWndProc
, "Ptr")
this.wb.RegisterAsDropTarget := False
DllCall("ole32\RevokeDragDrop", "UPtr", this.hIES)
}
_OnMessage(wParam, lParam, Msg, hWnd)
{
if (hWnd == this.hWnd)
{
if (Msg == this.WM_NCCALCSIZE)
{
if !DllCall("IsZoomed", "UPtr", hWnd)
return 0
VarSetCapacity(windowinfo, 60, 0)
NumPut(60, windowinfo, 0, "UInt")
DllCall("GetWindowInfo", "UPtr", hWnd, "UPtr", &windowinfo)
cxWindowBorders := NumGet(windowinfo, 48, "Int")
cyWindowBorders := NumGet(windowinfo, 52, "Int")
NumPut(NumGet(lParam+0, "Int") + cxWindowBorders, lParam+0, "Int")
NumPut(NumGet(lParam+4, "Int") + cyWindowBorders, lParam+4, "Int")
NumPut(NumGet(lParam+8, "Int") - cxWindowBorders, lParam+8, "Int")
NumPut(NumGet(lParam+12, "Int") - cyWindowBorders, lParam+12, "Int")
return 0
}
else if (Msg == this.WM_SIZE)
{
this.w := w := lParam<<48>>48
this.h := h := lParam<<32>>48
DllCall("MoveWindow", "UPtr", this.hWB, "Int", 0, "Int", 0, "Int", w, "Int", h, "UInt", 0)
return 0
}
else if (Msg == this.WM_DESTROY)
{
for i, message in this.LISTENERS
OnMessage(message, this.bound._OnMessage, 0)
ComObjConnect(this.wb)
this.bound := []
}
}
else if (hWnd == this.hIES || hWnd == this.hSDOV)
{
pressed := (Msg == this.WM_KEYDOWN || Msg == this.WM_SYSKEYDOWN)
released := (Msg == this.WM_KEYUP || Msg == this.WM_SYSKEYUP)
if (pressed || released)
{
if (bit := this.MODIFIER_BITMAP[wParam])
this.modifiers := (this.modifiers & ~bit) | (pressed * bit)
if (this.disabled_shortcuts[this.modifiers, wParam])
return 0
Msg := hWnd == this.hSDOV ? this.WM_KEYDOWN : Msg
Gui +OwnDialogs
pipa := ComObjQuery(this.wb, "{00000117-0000-0000-C000-000000000046}")
VarSetCapacity(kMsg, 48), NumPut(A_GuiY, NumPut(A_GuiX
, NumPut(A_EventInfo, NumPut(lParam, NumPut(wParam
, NumPut(Msg, NumPut(hWnd, kMsg)))), "uint"), "int"), "int")
r := DllCall(NumGet(NumGet(1*pipa)+5*A_PtrSize), "ptr", pipa, "ptr", &kMsg)
ObjRelease(pipa)
if (r == 0)
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
x := lParam<<48>>48, y := lParam<<32>>48
WinGetPos, wX, wY, wW, wH, % "ahk_id" this.hWnd
row := (x < wX + this.BORDER_SIZE) ? 1 : (x >= wX + wW - this.BORDER_SIZE) ? 3 : 2
col := (y < wY + this.BORDER_SIZE) ? 1 : (y >= wY + wH - this.BORDER_SIZE) ? 3 : 2
return this.HT_VALUES[col, row]
}
else if (Msg == this.WM_NCLBUTTONDOWN)
{
return DllCall("SendMessage", "Ptr", this.hWnd, "UInt", Msg, "UPtr", wParam, "Ptr", lParam, "Ptr")
}
Critical, Off
return DllCall("CallWindowProc"
, "Ptr", this.pWndProcOld
, "Ptr", hWnd
, "UInt", Msg
, "UPtr", wParam
, "Ptr", lParam
, "Ptr")
}
DragTitleBar()
{
PostMessage, this.WM_NCLBUTTONDOWN, 2, 0,, % "ahk_id" this.hWnd
}
Minimize()
{
Gui, % this.hWnd ":Minimize"
}
Maximize()
{
if DllCall("IsZoomed", "UPtr", this.hWnd)
{
Gui, % this.hWnd ":Restore"
this.qs("body").classList.remove("neutron-maximized")
}
else
{
Gui, % this.hWnd ":Maximize"
this.qs("body").classList.add("neutron-maximized")
}
}
Close()
{
WinClose, % "ahk_id" this.hWnd
}
Hide()
{
Gui, % this.hWnd ":Hide"
}
Destroy()
{
Gui, % this.hWnd ":Destroy"
}
Show(options:="",title:="")
{
w := RegExMatch(options, "w\s*\K\d+", match) ? match : this.w
h := RegExMatch(options, "h\s*\K\d+", match) ? match : this.h
VarSetCapacity(rect, 16, 0)
DllCall("AdjustWindowRectEx"
, "Ptr", &rect
, "UInt", 0x80CE0000
, "UInt", 0
, "UInt", 0
, "UInt")
w += NumGet(&rect, 0, "Int")-NumGet(&rect, 8, "Int")
h += NumGet(&rect, 4, "Int")-NumGet(&rect, 12, "Int")
Gui, % this.hWnd ":Show", %options% w%w% h%h%, %title%
}
Load(fileName)
{
if A_IsCompiled
url := "res://" this.wnd.encodeURIComponent(A_ScriptFullPath) "/10/" fileName
else
url := A_WorkingDir "/" fileName
this.wb.Navigate(url)
while this.wb.readyState < 3
Sleep, 50
this.wnd.neutron := this
this.wnd.ahk := new this.Dispatch(this)
while this.wb.readyState < 4
Sleep, 50
}
qs(selector)
{
return this.doc.querySelector(selector)
}
qsa(selector)
{
return this.doc.querySelectorAll(selector)
}
Gui(subCommand, value1:="", value2:="", value3:="")
{
Gui, % this.hWnd ":" subCommand, %value1%, %value2%, %value3%
}
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
Each(htmlCollection)
{
return new this.Enumerable(htmlCollection)
}
GetFormData(formElement, useIdAsName:=True)
{
formData := new this.FormData()
for i, field in this.Each(formElement.elements)
{
name := ""
try
name := field.name
if (name == "" && useIdAsName)
name := field.id
if (name == "" || field.disabled
|| field.type ~= "^file|reset|submit|button$")
continue
if (field.type == "select-multiple")
{
for j, option in this.Each(field.options)
if (option.selected)
formData.add(name, option.value)
continue
}
if (field.type ~= "^checkbox|radio$" && !field.checked)
continue
formData.add(name, field.value)
}
return formData
}
EscapeHTML(unsafe)
{
unsafe := StrReplace(unsafe, "&", "&amp;")
unsafe := StrReplace(unsafe, "<", "&lt;")
unsafe := StrReplace(unsafe, ">", "&gt;")
unsafe := StrReplace(unsafe, """", "&quot;")
unsafe := StrReplace(unsafe, "''", "&#039;")
return unsafe
}
FormatHTML(formatStr, values*)
{
for i, value in values
values[i] := this.EscapeHTML(value)
return Format(formatStr, values*)
}
_HexToABGR(colorHex)
{
colorHex := StrReplace(colorHex, "0x", "")
colorHex := StrReplace(colorHex, "#", "")
return "0xff" SubStr(colorHex, 5, 2)
. SubStr(colorHex, 3 , 2)
. SubStr(colorHex, 1 , 2)
}
class Dispatch
{
__New(parent)
{
this.parent := parent
}
__Call(params*)
{
if !(fn := Func(params[1]))
throw Exception("Unknown function: " params[1])
if (params.length() < fn.MinParams)
throw Exception("Too few parameters given to " fn.Name ": " params.length())
if (params.length() > fn.MaxParams && !fn.IsVariadic)
throw Exception("Too many parameters given to " fn.Name ": " params.length())
params[1] := this.parent
return fn.Call(params*)
}
}
class WBEvents
{
__New(parent)
{
this.parent := parent
}
DocumentComplete(wb)
{
wb.document.parentWindow.neutron := this.parent
wb.document.parentWindow.ahk := new this.parent.Dispatch(this.parent)
}
}
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
class FormData
{
names := []
values := []
Add(name, value)
{
this.names.Push(name)
this.values.Push(value)
}
All(name)
{
values := []
for i, v in this.names
if (v == name)
values.Push(this.values[i])
return values
}
__Get(name, n := 1)
{
for i, v in this.names
if (v == name && !--n)
return this.values[i]
}
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

    <form id="movementForm" onsubmit="ahk.Submitted(event)">
        <fieldset>
            <legend>
                <h2>Ground Skate</h2>
            </legend>
			<span class="lighttext">Issues? Use #movement-discussion!<span>
            <div class="ballscontainer">
                <span class="balls">
                    <input class="balloon" style="width:170px" id="ground_skate_bind" type="text" readonly>
					<label for="ground_skate_bind">Bind</label>
                </span>
				<span>
					<button class="smallbutton" id="ground_skate_configure_button" type="button">Configure</button>
				</span>
				<div id="ground_skate_configure_modal" class="modal">
				<div class="modal-content">
					<h1>Ground Skate Configuration</h1>
					<fieldset>
						<legend>
							<h2>Skate Delays</h2>
						</legend>
						<span class="lighttext">Recommended: 25, 35, 0</span>
						<div class="ballscontainer">
							<div class="balls" style="margin-top:5px;">
								<input class="balloon" style="width: 120px;" id="ground_skate_delay_1" type="text" oninput="validateInput(this)" maxlength="4">
								<label for="ground_skate_delay_1">First</label>
							</div>
							<div class="balls" style="margin-top:5px;">
								<input class="balloon" style="width: 120px;" id="ground_skate_delay_2" type="text" oninput="validateInput(this)" maxlength="4">
								<label for="ground_skate_delay_2">Second</label>
							</div>
							<div class="balls" style="margin-top:5px;">
								<input class="balloon" style="width: 120px;" id="ground_skate_delay_3" type="text" oninput="validateInput(this)" maxlength="4">
								<label for="ground_skate_delay_3">Third</label>
							</div>
						</div>
					</fieldset>
					<fieldset>
						<legend>
							<h2>Auto Swaps</h2>
						</legend>
						<div class="checkbox" style="display:block;">
							<input type="checkbox" id="ground_skate_swap_p" name="ground_skate_swap_p">
							<label for="ground_skate_swap_p">Primary <input class="mini-balloon" type="text" id="ground_skate_swap_p_delay" oninput="validateInput(this)" maxlength="4"><span style="margin-left:40px;">ms <span style="font-weight:900;">after</span> skating</span></label>
						</div>
						<div class="checkbox" style="display:block;">
							<input type="checkbox" id="ground_skate_swap_s">
							<label for="ground_skate_swap_s">Secondary <input class="mini-balloon" type="text" id="ground_skate_swap_s_delay" oninput="validateInput(this)" maxlength="4"><span style="margin-left:40px;">ms <span style="font-weight:900;">after</span> skating</span></label>
						</div>
						<div class="checkbox" style="display:block;">
							<input type="checkbox" id="ground_skate_swap_h">
							<label for="ground_skate_swap_h">Heavy <input class="mini-balloon" type="text" id="ground_skate_swap_h_delay" oninput="validateInput(this)" maxlength="4"><span style="margin-left:40px;">ms <span style="font-weight:900;">before</span> skating</span></label>
						</div>
					</fieldset>
					<div style="text-align:center;">
						<button class="smallbutton" id="ground_skate_configure_close_button" type="button">Close</button>
						<button class="smallbutton" id="ground_skate_configure_save_button" type="button">Save/Reload</button><br>
						<span class="lighttext" style="font-size:0.9em">Only the save/reload button outside this menu works</span>
					</div>
				</div>
			</div>
				<span>
					<button class="altbutton" id="ground_skate_info_button" type="button">Info</button>
				</span>
				<div id="ground_skate_info_modal" class="modal">
					<div class="modal-content">
						<h1>Ground Skate Info</h1>
						<p><span style="font-weight:900;">Required ability:</span> Well of Radiance or Shatterdive.</p>
						<p><span style="font-weight:900;">Required surface:</span> Flat or sloped ground.</p>
						<p style="font-weight:900;padding-bottom;0;margin-bottom:0;">Order of operations:</p>
						<p style="padding:0;margin:0;font-size:0.8em;">jump > delay 1 > light attack > delay 2 > jump > delay 3 > ability</p>
						<button class="smallbutton" id="ground_skate_info_close_button" type="button">Close</button>
					</div>
				</div>
				<label>
					<div id="toggler">
						<input type="checkbox" id="ground_skate_enable"><span></span>
					</div>
				</label>
            </div>
		</fieldset>









	<div class="row">
		<span class="alerttext" id="alert1"></span>
	</div>










	<fieldset>
		<legend>
			<h2>Edge Skate</h2>
		</legend>
		<span class="lighttext">Errors will appear above this text.<span>
		<div class="ballscontainer">
			<span class="balls">
				<input class="balloon" style="width:170px" id="edge_skate_bind" type="text" readonly>
				<label for="edge_skate_bind">Bind</label>
			</span>
			<span>
				<button class="button smallbutton" id="edge_skate_configure_button" type="button">Configure</button>
			</span>
			<div id="edge_skate_configure_modal" class="modal">
			<div class="modal-content">
				<h1>Edge Skate Configuration</h1>
				<fieldset>
					<legend>
						<h2>Skate Delays</h2>
					</legend>
					<span class="lighttext">Recommended: 25, 35<span>
					<div class="ballscontainer">
						<div class="balls" style="margin-top:5px;">
							<input class="balloon" style="width: 120px;" id="edge_skate_delay_1" type="text" oninput="validateInput(this)" maxlength="4">
							<label for="edge_skate_delay_1">First</label>
						</div>
						<div class="balls" style="margin-top:5px;">
							<input class="balloon" style="width: 120px;" id="edge_skate_delay_2" type="text" oninput="validateInput(this)" maxlength="4">
							<label for="edge_skate_delay_2">Second</label>
						</div>
					</div>
				</fieldset>
				<fieldset>
					<legend>
						<h2>Auto Swaps</h2>
					</legend>
					<div class="checkbox" style="display:block;">
						<input type="checkbox" id="edge_skate_swap_p">
						<label for="edge_skate_swap_p">Primary <input class="mini-balloon" type="text" id="edge_skate_swap_p_delay" oninput="validateInput(this)" maxlength="4"><span style="margin-left:40px;">ms <span style="font-weight:900;">after</span> skating</span></label>
					</div>
					<div class="checkbox" style="display:block;">
						<input type="checkbox" id="edge_skate_swap_s">
						<label for="edge_skate_swap_s">Secondary <input class="mini-balloon" type="text" id="edge_skate_swap_s_delay" oninput="validateInput(this)" maxlength="4"><span style="margin-left:40px;">ms <span style="font-weight:900;">after</span> skating</span></label>
					</div>
					<div class="checkbox" style="display:block;">
						<input type="checkbox" id="edge_skate_swap_h">
						<label for="edge_skate_swap_h">Heavy <input class="mini-balloon" type="text" id="edge_skate_swap_h_delay" oninput="validateInput(this)" maxlength="4"><span style="margin-left:40px;">ms <span style="font-weight:900;">before</span> skating</span></label>
					</div>
				</fieldset>
				<div style="text-align:center;">
					<button class="smallbutton" id="edge_skate_configure_close_button" type="button">Close</button>
					<button class="smallbutton" id="edge_skate_configure_save_button" type="button">Save/Reload</button><br>
					<span class="lighttext" style="font-size:0.9em">Only the save/reload button outside this menu works</span>
				</div>

			</div>
		</div>
			<span>
				<button class="altbutton" id="edge_skate_info_button" type="button">Info</button>
			</span>
			<div id="edge_skate_info_modal" class="modal">
				<div class="modal-content">
					<h2>Edge Skate Info</h2>
					<p><span style="font-weight:900;">Required ability:</span> Nearly all Supers or Shatterdive.</p>
					<p><span style="font-weight:900;">Required surface:</span> Edge or VERY steep slope.</p>
					<p style="padding-bottom0;margin-bottom:0;font-weight:900;">Order of operations:</p>
					<p style="padding:0;margin:0;font-size:0.8em;">heavy attack > delay 1 > ability > delay 2 > jump</p>
					<button class="smallbutton" id="edge_skate_info_close_button" type="button">Close</button>
				</div>
			</div>
			<label>
			<div id="toggler">
				<input type="checkbox" id="edge_skate_enable"><span></span>
			</div>
		</label>
		</div>

	</fieldset>

	
	<div class="checkbox" style="display:block;margin:5px 0;">
		<input type="checkbox" id="skate_shatter_mode">
		<label for="skate_shatter_mode">Shatter Mode</label>
	</div>

	<div class="row">
		<span>
			<button class="button smallbutton" id="destiny_binds_configure_button" type="button">Configure Destiny Binds</button>
		</span>
		<div id="destiny_binds_configure_modal" class="modal" style="text-align:left;">
			<div class="modal-content">
				<h1>Destiny Binds Configuration</h1>
				<fieldset>
					<legend>
						<h2>You have been pranked</h2>
					</legend>
					<span class="lighttext">For now you gotta just manually edit the movementStuff.ini file while the script is closed - sorry!</span>
				</fieldset>
				<div style="text-align:center;">
					<button class="smallbutton" id="destiny_binds_close_button" type="button">Close</button>
					<button class="smallbutton" id="destiny_binds_save_button" type="button">Save/Reload</button><br>
					<span class="lighttext" style="font-size:0.9em">Only the save/reload button outside this menu works</span>
				</div>
			</div>
		</div>
		<span>
			<button class="altbutton" id="saveButton" type="submit">Save/Reload</button>
		</span>
	</div>

			

    </form>

	<div class="signature">
		<p><a href="#" onclick="ahk.discordClicked(event)">Join our Discord</a> for support and more scripts!</p>
		<p style="color:white;font-size:0.8em">!!this is an unfinished script!!</p>
		<p style="color:white;font-size:0.7em">could you tell by that shatter checkbox?<br>there is likely a more updated version in the discord btw</p>
	</div>

</body>

)

css =
(

tr {
	color:#EEE;
}
.signature {
	margin-top:5px;
	width: 100`%;
}

	.signature p {
		padding:0;
		margin:auto 0 0 0;
		text-align: center;
		font-size: 1em;
		color: #AAA;
	}

	.signature .much-heart{
		display: inline-block;
		position: relative;
		margin: 0 4px;
		height: 10px;
		width: 10px;
		background: #AC1D3F;
		border-radius: 4px;
		-ms-transform: rotate(45deg);
		-webkit-transform: rotate(45deg);
		transform: rotate(45deg);
	}

	.signature .much-heart::before, 
	.signature .much-heart::after {
		display: block;
		content: '';
		position: absolute;
		margin: auto;
		height: 10px;
		width: 10px;
		border-radius: 5px;
		background: #AC1D3F;
		top: -4px;
	}

	.signature .much-heart::after {
		bottom: 0;
		top: auto;
		left: -4px;
	}
	


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
	
	h1 {
		font-size:1.4em;
		margin: 0 0 5px 0;
		padding: 0;
		color:white;
	}
	h2 {
		font-size:1.2em;
	  margin: 0;
	  padding: 0;
	}
	
	/* Form Styles */
	fieldset {
	  border: 2px solid rgba(0, 173, 181, 0.5);
	  margin-bottom:10px;
	}
	
	legend {
	  color: #EEE;
	}
	
	table {
		margin:5px auto;
		table-layout: fixed;
	}

	
	.lighttext {
	  color: #AAA !important;
	}

	.alerttext {
		font-size:1.2em;
		font-weight:900;
		color:red !important;
	}
	
	/* Checkbox Styles */
	.checkbox {
		display: inline-block;
		position: relative;
		cursor: pointer;
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

	.mini-balloon {
		display: inline-block;
		z-index: 999;
		position: absolute;
		text-align:center;
		width: 40px;
		color: #EEE;
		background: #222831;
		bottom: 1px;
		border: 0;
		border-radius: 3px;
		outline: 0;
	  }
	  
	  .balloon {
		transition: all 0.3s ease-in-out;

		display: inline-block;
		width: 105px;
		padding: 11px 0 10px 15px;
		font-family: "Open Sans", sans;
		font-weight: 400;
		font-size: 1em;
		color: #EEE;
		background: #222831;
		border: 0;
		text-indent: 65px;
		border-radius: 3px;
		outline: 0;
	  }
	  
	  .balloon + label {
		transition: all 0.3s ease-in-out;

		display: inline-block;
		position: absolute;
		top: 8px;
		width: 65px;
		padding: 3px;
		left: 0;
		bottom: 8px;
		margin: 0 0 0 9px;
		color: #EEE;
		font-size: 1em;
		font-weight: 700;
		text-shadow: 0 1px 0 rgba(19, 74, 70, 0);
		background: rgba(0, 173, 181, 0.5);
	  }
	  
	  /*  THIS IS THE LITTLE ARROW! */
	  .balloon + label:after {
		transition: all 0.3s ease-in-out;

		position: absolute;
		content: "";
		width: 0;
		height: 0;
		top: 100`%;
		left: 50`%;
		margin-left: -3px;
		border-left: 3px solid transparent;
		border-right: 3px solid transparent;
		border-top: 3px solid rgba(0, 173, 181, 0);
	  }
	  .balloon:focus + label:after,
	  .balloon:active + label:after,
	  .balloon:hover + label:after {
		border-top: 4px solid #00ADB5;
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
	  




	  #toggler {
		outline: 0;
		transition-duration: 0.4s;
		cursor: pointer;
		text-align: center;
		text-decoration: none;
		display: inline-block;
		padding:10px;
		font-size:1em;
		margin: 0 5px;
		background-color: #222831;
		color: #EEEEEE;
		border-radius: 3px;
	}
	

	
	label #toggler input {
		position:absolute;
		top:-40px;
	}
	


	#toggler input + span:after {
		content: 'Enable'
	}

	#toggler input:checked + span:after {
		content: 'Disable'
	}



















	.altbutton {
	  outline: 0;
	  transition-duration: 0.4s;
	  cursor: pointer;
	  text-align: center;
	  text-decoration: none;
	  display: inline-block;
	  padding:10px;
	  font-size:1em;
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
		margin: 0 5px;
		background-color: #222831;
		color: #EEEEEE;
		border: 2px solid #00b5ae;
		border-radius: 3px;
	}
	.smallbutton:hover {
	  background-color: #00b5ae;
	  color: white;
	}


	  
	  .togglebuttonGREEN:hover {
		background-color: #32AA32 !important;
		color: white;
	  }	
	  .togglebuttonGREEN {
		border: 2px solid rgba(50, 255, 50, 0.5);
	  }

	  
	  .togglebuttonRED:hover {
		background-color: #AA3232 !important;
		color: white;
		
	  }
	  .togglebuttonRED {
		border: 2px solid rgba(255, 50, 50, 0.5);
		
	  }

	
	/* Miscellaneous Styles */
	.row {
	  margin: 0;
	  max-width: 800px;
	  position: relative;
	  text-align:center;
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
	
	.balls {
      text-align: center;
	  position: relative;
	  display: inline-block;
	}

    .ballscontainer {
        display:block;
    }
	
	.modal {
		display: none;
		position: fixed;
		z-index: 1;
		padding-top: 30px; 
		left: 0;
		top: 0;
		width: 100`%;
		height: 100`%; 
		overflow: auto; 
		background-color: #393E46;
		background-color: rgba(0,0,0,0.4); 
	}

	/* Modal Content */
	.modal-content {
		background-color: #393E46;
		color:white;
		margin: auto;
		padding: 20px;
		border: 2px solid rgba(0, 173, 181, 0.5);
		width: 90`%;
	}



)

js =
(
	//TODO:
	//UPDATE THIS TO BE ONLY ONE ADDED OR REMOVED CLASS!!! 
	//ALSO UPDATE IT TO BE LESS STUPID! CHECKBOX, CHECKBOX1, ETC. IS DUMB - USE A SETUP

	function sleep(milliseconds, callback) {
		setTimeout(callback, milliseconds);
	  }

	var checkbox = document.getElementById('ground_skate_enable');
	var parentElement = checkbox.parentElement;
	var checkbox1 = document.getElementById('edge_skate_enable');
	var parentElement1 = checkbox1.parentElement;
	document.addEventListener('DOMContentLoaded', function() {
		sleep(20, function() {
			if (checkbox.checked) {
				parentElement.classList.add('togglebuttonRED');
				parentElement.classList.remove('togglebuttonGREEN');
			} else {
				parentElement.classList.add('togglebuttonGREEN');
				parentElement.classList.remove('togglebuttonRED');
			}
			if (checkbox1.checked) {
				parentElement1.classList.add('togglebuttonRED');
				parentElement1.classList.remove('togglebuttonGREEN');
			} else {
				parentElement1.classList.add('togglebuttonGREEN');
				parentElement1.classList.remove('togglebuttonRED');
			}
		});
	});
	


	checkbox.addEventListener('change', function() {
	  if (checkbox.checked) {
		parentElement.classList.add('togglebuttonRED');
		parentElement.classList.remove('togglebuttonGREEN');
	  } else {
		parentElement.classList.add('togglebuttonGREEN');
		parentElement.classList.remove('togglebuttonRED');
	  }
	});

	checkbox1.addEventListener('change', function() {
	  if (checkbox1.checked) {
		parentElement1.classList.add('togglebuttonRED');
		parentElement1.classList.remove('togglebuttonGREEN');
	  } else {
		parentElement1.classList.add('togglebuttonGREEN');
		parentElement1.classList.remove('togglebuttonRED');
	  }
	});


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
  
	
	setupModal("edge_skate_configure_modal", "edge_skate_configure_button", "edge_skate_configure_close_button");
	setupModal("edge_skate_info_modal", "edge_skate_info_button", "edge_skate_info_close_button");
	setupModal("ground_skate_configure_modal", "ground_skate_configure_button", "ground_skate_configure_close_button");
	setupModal("ground_skate_info_modal", "ground_skate_info_button", "ground_skate_info_close_button");
	setupModal("destiny_binds_configure_modal", "destiny_binds_configure_button", "destiny_binds_close_button");
		
	window.addEventListener("beforeunload", function (event) {
		event.preventDefault();
		event.returnValue = "This will clear all values, are you sure you want to refresh?";
	  });
	  
	  function ensureUniqueValue(inputId, value) {
		var inputs = document.querySelectorAll('input[type="text"]');
		for (var i = 0; i < inputs.length; i++) {
		  if (inputs[i].id !== inputId && inputs[i].value === value) {
			document.getElementById('alert1').textContent = "Whatever you pressed is already a bind!";
			return false;
		  }
		}
		document.getElementById('alert1').textContent = "";
		return true;
	  }
	  
	  function validateInput(input) {
		input.value = input.value.replace(/[^0-9]/g, '');
	  
		const num = parseInt(input.value, 10);
		if (isNaN(num)) {
		  input.value = '';
		} else {
		  input.value = Math.min(999, num);
		}
	  }

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
		  if (inputId === 'brightnessInput' && /^[1-7]$/.test(keyPressed)) {
			if (ensureUniqueValue(inputId, keyPressed)) {
			  keyInput.value = keyPressed;
			}
		  } else if (inputId !== 'brightnessInput') {
			if (ensureUniqueValue(inputId, keyPressed)) {
			  keyInput.value = keyPressed;
			}
		  }
		  event.preventDefault();
		}
	  }
	  
	  setupInput('ground_skate_bind');
	  setupInput('edge_skate_bind');



)

title = Antra's Movement Script v1.0.0
neutron := new NeutronWindow(html, css, js, title)
neutron.Gui("+LabelNeutron +AlwaysOnTop")
gosub, readfromini
return

antraClicked(neutron, event)
{
	Run, https://ko-fi.com/Antrament
}

discordClicked(neutron, event)
{
	Run, https://discord.gg/KGyjysA5WY
}

closeButton(neutron, event)
{
	neutron.Hide()
	if (A_IsSuspended) {
		Suspend, Toggle
	}
}

Submitted(neutron, event)
{
    event.preventDefault()
    formData := neutron.GetFormData(event.target)
    ;
    ; skate settings
    ;
	;##### Super skates
    global ground_skate_bind := formData.ground_skate_bind
    global ground_skate_enable := formData.ground_skate_enable
    global ground_skate_delay_1 := formData.ground_skate_delay_1
    global ground_skate_delay_2 := formData.ground_skate_delay_2
    global ground_skate_delay_3 := formData.ground_skate_delay_3
    global ground_skate_delay_4 := formData.ground_skate_delay_4
    global ground_skate_delay_5 := formData.ground_skate_delay_5
    global ground_skate_swap_p := formData.ground_skate_swap_p
	global ground_skate_swap_p_delay := formData.ground_skate_swap_p_delay
    global ground_skate_swap_s := formData.ground_skate_swap_s
	global ground_skate_swap_s_delay := formData.ground_skate_swap_s_delay
    global ground_skate_swap_h := formData.ground_skate_swap_h
	global ground_skate_swap_h_delay := formData.ground_skate_swap_h_delay
    

    global edge_skate_bind := formData.edge_skate_bind
    global edge_skate_enable := formData.edge_skate_enable
    global edge_skate_delay_1 := formData.edge_skate_delay_1
    global edge_skate_delay_2 := formData.edge_skate_delay_2
    global edge_skate_delay_3 := formData.edge_skate_delay_3
    global edge_skate_delay_4 := formData.edge_skate_delay_4
    global edge_skate_delay_5 := formData.edge_skate_delay_5
    global edge_skate_swap_p := formData.edge_skate_swap_p
    global edge_skate_swap_s := formData.edge_skate_swap_s
    global edge_skate_swap_h := formData.edge_skate_swap_h
    

	global skate_shatter_mode := formData.skate_shatter_mode

	
    ;
    ; destiny settings
    ;

    global grenade_bind := formData.grenade
    global super_bind := formData.super_bind
    global melee_charged_bind := formData.super_bind
    global air_move_bind := formData.air_move_bind
    global heavy_attack_bind := formData.heavy_attack_bind
    global light_attack_bind := formData.light_attack_bind
    global toogle_crouch_bind := formData.toogle_crouch_bind
    global primary_weapon_bind := formData.primary_weapon_bind
    global special_weapon_bind := formData.special_weapon_bind
    global heavy_weapon_bind := formData.heavy_weapon_bind
    global jump_bind := formData.jump_bind
    global block_bind := formData.block_bind

    ;
    ; script settings
    ;

    global menu_bind := formData.menu_bind
    global easy_mode := formData.easy_mode



    gosub, writetoini


}
Return

readfromini:


iniread, ground_skate_bind, movementStuff.ini, groundSkate, ground_skate_bind, 4
iniread, ground_skate_enable, movementStuff.ini, groundSkate, ground_skate_enable, "on"
iniread, ground_skate_delay_1, movementStuff.ini, groundSkate, ground_skate_delay_1, 25
iniread, ground_skate_delay_2, movementStuff.ini, groundSkate, ground_skate_delay_2, 35
iniread, ground_skate_delay_3, movementStuff.ini, groundSkate, ground_skate_delay_3, 0
iniread, ground_skate_delay_4, movementStuff.ini, groundSkate, ground_skate_delay_4, 0
iniread, ground_skate_delay_5, movementStuff.ini, groundSkate, ground_skate_delay_5, 0
iniread, ground_skate_swap_p, movementStuff.ini, groundSkate, ground_skate_swap_p, "on"
iniread, ground_skate_swap_p_delay, movementStuff.ini, groundSkate, ground_skate_swap_p_delay, 500
iniread, ground_skate_swap_s, movementStuff.ini, groundSkate, ground_skate_swap_s, %A_SPACE%
iniread, ground_skate_swap_s_delay, movementStuff.ini, groundSkate, ground_skate_swap_s_delay, 500
iniread, ground_skate_swap_h, movementStuff.ini, groundSkate, ground_skate_swap_h, "on"
iniread, ground_skate_swap_h_delay, movementStuff.ini, groundSkate, ground_skate_swap_h_delay, 800

iniread, edge_skate_bind, movementStuff.ini, edgeSkate, edge_skate_bind, 5
iniread, edge_skate_enable, movementStuff.ini, edgeSkate, edge_skate_enable, "on"
iniread, edge_skate_delay_1, movementStuff.ini, edgeSkate, edge_skate_delay_1, 25
iniread, edge_skate_delay_2, movementStuff.ini, edgeSkate, edge_skate_delay_2, 35
iniread, edge_skate_delay_3, movementStuff.ini, edgeSkate, edge_skate_delay_3, 0
iniread, edge_skate_delay_4, movementStuff.ini, edgeSkate, edge_skate_delay_4, 0
iniread, edge_skate_delay_5, movementStuff.ini, edgeSkate, edge_skate_delay_5, 0
iniread, edge_skate_swap_p, movementStuff.ini, edgeSkate, edge_skate_swap_p, "on"
iniread, edge_skate_swap_p_delay, movementStuff.ini, edgeSkate, edge_skate_swap_p_delay, 500
iniread, edge_skate_swap_s, movementStuff.ini, edgeSkate, edge_skate_swap_s, %A_SPACE%
iniread, edge_skate_swap_s_delay, movementStuff.ini, edgeSkate, edge_skate_swap_s_delay, 500
iniread, edge_skate_swap_h, movementStuff.ini, edgeSkate, edge_skate_swap_h, "on"
iniread, edge_skate_swap_h_delay, movementStuff.ini, edgeSkate, edge_skate_swap_h_delay, 800


iniread, skate_shatter_mode, movementStuff.ini, mode, skate_shatter_mode, %A_SPACE%

	;UNUSED vvvvvv
    iniread, strand_skate_bind, movementStuff.ini, script_settings, strand skate bind, 6
    iniread, suppress_skate_bind, movementStuff.ini, script_settings, suppress skate bind, 7
    iniread, valiant_skate_bind, movementStuff.ini, script_settings, valiant skate bind, 8
    iniread, lament_skate_bind, movementStuff.ini, script_settings, lament skate bind, 8

    iniread, snap_skate_bind, movementStuff.ini, script_settings, snap skate skate bind, 9
    iniread, auto_jump_light_skate, movementStuff.ini, script_settings, auto jump after light, 0
    iniread, auto_jump_heavy_skate, movementStuff.ini, script_settings, auto jump after heavy, 0
    iniread, auto_jump_strand_skate, movementStuff.ini, script_settings, auto jump after strand, 0
    iniread, auto_jump_snap_skate, movementStuff.ini, script_settings, auto jump after snap, 0
    iniread, shatter_mode, movementStuff.ini, script_settings, shatter mode, 0
    iniread, lament_mode, movementStuff.ini, script_settings, lament mode, 0
    iniread, eager_mode, movementStuff.ini, script_settings, eager mode, 1
    iniread, menu_bind, movementStuff.ini, script_settings, menu bind, F9
    iniread, primary_swap, movementStuff.ini, script_settings, primary swap, 0
    iniread, secondary_swap, movementStuff.ini, script_settings, secondary swap, 0
    iniread, heavy_swap, movementStuff.ini, script_settings, heavy swap, 1
    iniread, delay_1, movementStuff.ini, script_settings, delay 1, 25
    iniread, delay_2, movementStuff.ini, script_settings, delay 2, 35
    iniread, delay_3, movementStuff.ini, script_settings, delay 3, 0
    iniread, auto_jump_delay, movementStuff.ini, script_settings, auto jump delay, 400
    iniread, weapon_swap_delay, movementStuff.ini, script_settings, weapon swap delay, 750
    iniread, weapon_swapback_delay, movementStuff.ini, script_settings, weapon swap back delay, 400
	;UNUSED ^^^^^^


    iniread, super, movementStuff.ini, destiny_settings, super, f
    iniread, melee_charged, movementStuff.ini, destiny_settings, melee_charged, .
    iniread, air_move, movementStuff.ini, destiny_settings, air_move, x
    iniread, heavy_attack, movementStuff.ini, destiny_settings, heavy_attack, rbutton
    iniread, light_attack, movementStuff.ini, destiny_settings, light_attack, lbutton
    iniread, toggle_crouch, movementStuff.ini, destiny_settings, toggle_crouch, control
    iniread, primary_weapon, movementStuff.ini, destiny_settings, primary_weapon, 1
    iniread, special_weapon, movementStuff.ini, destiny_settings, special_weapon, 2
    iniread, heavy_weapon, movementStuff.ini, destiny_settings, heavy_weapon, 3
    iniread, jump, movementStuff.ini, destiny_settings, jump, space
    iniread, block, movementStuff.ini, destiny_settings, block, c 



	neutron.doc.getElementById("ground_skate_bind").value := ground_skate_bind
	neutron.doc.getElementById("ground_skate_enable").checked := ground_skate_enable
	neutron.doc.getElementById("ground_skate_delay_1").value := ground_skate_delay_1
    neutron.doc.getElementById("ground_skate_delay_2").value := ground_skate_delay_2
    neutron.doc.getElementById("ground_skate_delay_3").value := ground_skate_delay_3
    neutron.doc.getElementById("ground_skate_swap_p").checked := ground_skate_swap_p
	neutron.doc.getElementById("ground_skate_swap_p_delay").value := ground_skate_swap_p_delay
	neutron.doc.getElementById("ground_skate_swap_s").checked := ground_skate_swap_s
	neutron.doc.getElementById("ground_skate_swap_s_delay").value := ground_skate_swap_s_delay
	neutron.doc.getElementById("ground_skate_swap_h").checked := ground_skate_swap_h
	neutron.doc.getElementById("ground_skate_swap_h_delay").value := ground_skate_swap_h_delay

	neutron.doc.getElementById("edge_skate_bind").value := edge_skate_bind
	neutron.doc.getElementById("edge_skate_enable").checked := edge_skate_enable
	neutron.doc.getElementById("edge_skate_delay_1").value := edge_skate_delay_1
    neutron.doc.getElementById("edge_skate_delay_2").value := edge_skate_delay_2
    neutron.doc.getElementById("edge_skate_delay_3").value := edge_skate_delay_3
    neutron.doc.getElementById("edge_skate_swap_p").checked := edge_skate_swap_p
	neutron.doc.getElementById("edge_skate_swap_p_delay").value := edge_skate_swap_p_delay
	neutron.doc.getElementById("edge_skate_swap_s").checked := edge_skate_swap_s
	neutron.doc.getElementById("edge_skate_swap_s_delay").value := edge_skate_swap_s_delay
	neutron.doc.getElementById("edge_skate_swap_h").checked := edge_skate_swap_h
	neutron.doc.getElementById("edge_skate_swap_h_delay").value := edge_skate_swap_h_delay



	neutron.doc.getElementById("skate_shatter_mode").checked := skate_shatter_mode




	neutron.doc.getElementById("strand_skate_bind").value := strand_skate_bind
    neutron.doc.getElementById("suppress_skate_bind").value := suppress_skate_bind
    neutron.doc.getElementById("valiant_skate_bind").value := valiant_skate_bind
    neutron.doc.getElementById("lament_skate_bind").value := lament_skate_bind
	neutron.doc.getElementById("snap_skate_bind").value := snap_skate_bind
	neutron.doc.getElementById("menu_bind").value := menu_bind
	neutron.doc.getElementById("light_Checkbox").checked := light_Checkbox
	neutron.doc.getElementById("heavy_Checkbox").checked := heavy_Checkbox
	neutron.doc.getElementById("strand_Checkbox").checked := strand_Checkbox
	neutron.doc.getElementById("snap_Checkbox").checked := snap_Checkbox

	if (BIGBALLSAREONME) {
		neutron.doc.getElementById("alert1").innertext := "You have overlapping binds!"
		show = 1
		neutron.Show("w500 h440")
		if (!A_IsSuspended) {
			Suspend, Toggle
		}
	} else {
		menu_bind = F9
		hotkey, %menu_bind%, menu_bind
		if(ground_skate_enable) {
			hotkey, %ground_skate_bind%, ground_skate_bind
		}
		if(edge_skate_enable) {
			hotkey, %edge_skate_bind%, edge_skate_bind
		}
		neutron.doc.getElementById("alert1").innertext := ""
		show = 0
		neutron.hide("w500 h440")
		if (A_IsSuspended) {
			Suspend, Toggle
		}
	}
	if (initialOpen = 0) {
		gosub, writetoini
	}
return


writetoini:
	iniwrite, %ground_skate_bind%, movementStuff.ini, groundSkate, ground_skate_bind
	iniwrite, %ground_skate_enable%, movementStuff.ini, groundSkate, ground_skate_enable
	iniwrite, %ground_skate_delay_1%, movementStuff.ini, groundSkate, ground_skate_delay_1
	iniwrite, %ground_skate_delay_2%, movementStuff.ini, groundSkate, ground_skate_delay_2
	iniwrite, %ground_skate_delay_3%, movementStuff.ini, groundSkate, ground_skate_delay_3
	iniwrite, %ground_skate_delay_4%, movementStuff.ini, groundSkate, ground_skate_delay_4
	iniwrite, %ground_skate_delay_5%, movementStuff.ini, groundSkate, ground_skate_delay_5
	iniwrite, %ground_skate_swap_p%, movementStuff.ini, groundSkate, ground_skate_swap_p
	iniwrite, %ground_skate_swap_p_delay%, movementStuff.ini, groundSkate, ground_skate_swap_p_delay
	iniwrite, %ground_skate_swap_s%, movementStuff.ini, groundSkate, ground_skate_swap_s
	iniwrite, %ground_skate_swap_s_delay%, movementStuff.ini, groundSkate, ground_skate_swap_s_delay
	iniwrite, %ground_skate_swap_h%, movementStuff.ini, groundSkate, ground_skate_swap_h
	iniwrite, %ground_skate_swap_h_delay%, movementStuff.ini, groundSkate, ground_skate_swap_h_delay


	iniwrite, %edge_skate_bind%, movementStuff.ini, edgeSkate, edge_skate_bind
	iniwrite, %edge_skate_enable%, movementStuff.ini, edgeSkate, edge_skate_enable
	iniwrite, %edge_skate_delay_1%, movementStuff.ini, edgeSkate, edge_skate_delay_1
	iniwrite, %edge_skate_delay_2%, movementStuff.ini, edgeSkate, edge_skate_delay_2
	iniwrite, %edge_skate_delay_3%, movementStuff.ini, edgeSkate, edge_skate_delay_3
	iniwrite, %edge_skate_delay_4%, movementStuff.ini, edgeSkate, edge_skate_delay_4
	iniwrite, %edge_skate_delay_5%, movementStuff.ini, edgeSkate, edge_skate_delay_5
	iniwrite, %edge_skate_swap_p%, movementStuff.ini, edgeSkate, edge_skate_swap_p
	iniwrite, %edge_skate_swap_p_delay%, movementStuff.ini, edgeSkate, edge_skate_swap_p_delay
	iniwrite, %edge_skate_swap_s%, movementStuff.ini, edgeSkate, edge_skate_swap_s
	iniwrite, %edge_skate_swap_s_delay%, movementStuff.ini, edgeSkate, edge_skate_swap_s_delay
	iniwrite, %edge_skate_swap_h%, movementStuff.ini, edgeSkate, edge_skate_swap_h
	iniwrite, %edge_skate_swap_h_delay%, movementStuff.ini, edgeSkate, edge_skate_swap_h_delay

	iniwrite, %skate_shatter_mode%, movementStuff.ini, mode, skate_shatter_mode



	iniwrite, %menu_bind%, movementStuff.ini, Misc, menu_bind



    iniwrite, %super%, movementStuff.ini, destiny_settings, super
    iniwrite, %melee_charged%, movementStuff.ini, destiny_settings, melee_charged
    iniwrite, %air_move%, movementStuff.ini, destiny_settings, air_move
    iniwrite, %heavy_attack%, movementStuff.ini, destiny_settings, heavy_attack
    iniwrite, %light_attack%, movementStuff.ini, destiny_settings, light_attack
    iniwrite, %toggle_crouch%, movementStuff.ini, destiny_settings, toggle_crouch
    iniwrite, %primary_weapon%, movementStuff.ini, destiny_settings, primary_weapon
    iniwrite, %special_weapon%, movementStuff.ini, destiny_settings, special_weapon
    iniwrite, %heavy_weapon%, movementStuff.ini, destiny_settings, heavy_weapon
    iniwrite, %jump%, movementStuff.ini, destiny_settings, jump
    iniwrite, %block%, movementStuff.ini, destiny_settings, block




	reload
return





menu_bind:
    Suspend, Permit ; this makes it so this bind is not stopped during suspend
    if (!show) {
        show = 1
        neutron.Show("w500 h440")
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


ground_skate_bind:
	if(ground_skate_swap_h){	
		send {%heavy_weapon%}
		PreciseSleep(ground_skate_swap_h_delay)
	}
	send {%jump%}
	PreciseSleep(ground_skate_delay_1)
	send {%light_attack%}
	PreciseSleep(ground_skate_delay_2)
	send {%jump%}
	PreciseSleep(ground_skate_delay_3)
	if(skate_shatter_mode){
		send {%air_move%}
	} else {
		send {%super%}
	}
	if(ground_skate_swap_p){
		PreciseSleep(ground_skate_swap_p_delay)
		send {%primary_weapon%}
	}
	if(ground_skate_swap_s){
		PreciseSleep(ground_skate_swap_s_delay)
		send {%special_weapon%}
	}
return



edge_skate_bind:
	if(edge_skate_swap_h){	
		send {%heavy_weapon%}
		PreciseSleep(edge_skate_swap_h_delay)
	}
	send {%heavy_attack%}
	PreciseSleep(edge_skate_delay_1)	
	send {%jump%}
	PreciseSleep(edge_skate_delay_2)
	if(skate_shatter_mode){
		send {%air_move%}
	} else {
		send {%super%}
	}
	if(edge_skate_swap_p){
		PreciseSleep(edge_skate_swap_p_delay)
		send {%primary_weapon%}
	}
	if(edge_skate_swap_s){
		PreciseSleep(edge_skate_swap_s_delay)
		send {%special_weapon%}
	}
return