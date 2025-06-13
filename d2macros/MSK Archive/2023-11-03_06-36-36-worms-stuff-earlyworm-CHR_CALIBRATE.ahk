;
;	the file that sets reference points for your installation.
;

#NoEnv
#SingleInstance Force
;#NoTrayIcon

Process, Priority,, R
SetBatchLines, -1							;defines script execution speed globally
SetWorkingDir %A_ScriptDir%
SetMouseDelay, 0
CoordMode,Pixel,Window
CoordMode,ToolTip,Window
CoordMode,Mouse,Window
CoordMode,Caret,Window
CoordMode,Menu,Window


SetWorkingDir, %A_ScriptDir%
pathCommon := SubStr(A_WorkingDir,1,InStr(A_WorkingDir,"\",,0))
fileGameIn := A_AppData . "\Bungie\DestinyPC\prefs\cvars.xml"
fileScriptOut := A_WorkingDir . "\REFERENCEPOINTS.ini"

;survey environment
global winAnchorX
global winAnchorY
global winWidth
global winHeight

WinGetPos,winAnchorX,winAnchorY,winWidth,winHeight,Destiny 2

global winCenterX
winCenterX := winWidth/2

global winCenterY
winCenterY := winHeight/2

;temp variables
global xTrash := 0
global yTrash := 0
global yCheck0 := 0
global yCheck1 := 0
global yCheck2 := 0
global Anchor := 0
global Start := 0
global Stop := 0

;anchor point variables
global xAnchorClusterR			;search for ammo bar with any ammo color scanning bottom right to top left, first match is this X
global yAnchorClusterBR			;use previous x anchor to find lowest point of ammo bar, this is also the cluster bound
global yAnchorClusterTR			;by searching from above to below, this value is found close to the highest point on the ammo bar
global xAnchorClusterL			;found by searching for 0xFFFFFF in the charged grenade left boundary
global yAnchorClusterBL			;found by searching lowest 0xFFFFFF at this x coord, also determines sparrow probe
global yAnchorClusterTL			;found by using difference of yAnchorClusterUR from top of ammo bar

;pivot point variables, anchors that are the focus of mathematical operations to establish probe points
global xPivotSeparatorR			;equal to xAnchorClusterBR
global yPivotSeparatorR			;search in ammo bar for separator color, 0xCBCBCB at 4 brightness, y value will be used to determine the y values of all weapons
global xPivotSeparatorL			;used to find probe site for sparrow
global yPivotSeparatorL			;likewise
global yPivotAmmoBarT			;highest point of ammo bar
global yPivotAmmoBarB			;lowest point of ammo bar



;probe points, main output of file. probe points are the reference points to find the current state of the cluster when used by the main chromodynamics script

;probe x value for location of ammo bar
global xProbeAmmo

;probe y values for each section of the bar and the separator location
global yProbeAmmoDrawn
global yProbeAmmoStow0
global yProbeAmmoStow1

;probe x range of affinities in cluster
global xProbeAffinityLeft
global xProbeAffinityRight

;probe y range for drawn weapon (no champ stunner)
global yProbeAffinityDrawnTopBasic
global yProbeAffinityDrawnBotBasic

;probe y range for drawn weapon (has champ stunner)
global yProbeAffinityDrawnTopStun
global yProbeAffinityDrawnBotStun

;probe y range for stowed weapon 0
global yProbeAffinityMidStowTop
global yProbeAffinityMidStowBot

;probe y range for stowed weapon 1
global yProbeAffinityLowStowTop
global yProbeAffinityLowStowBot

;probe anchor for grenade, second and third y values are for second and third charges
global xProbeGrenadeR
global xProbeGrenadeL
global yProbeGrenadeTR
global yProbeGrenadeTL
global yProbeGrenadeBR
global yProbeGrenadeBL
global yProbeGrenade2
global yProbeGrenade3

;probe anchor for melee, second and third y values are for second and third 
global xProbeMeleeR
global xProbeMeleeL
global yProbeMeleeTR
global yProbeMeleeTL
global yProbeMeleeBR
global yProbeMeleeBL
global yProbeMelee2
global yProbeMelee3

;probe anchor for class ability, second and third y values are for second and third 
global xProbeClassL
global xProbeClassR
global yProbeClassTR
global yProbeClassTL
global yProbeClassBR
global yProbeClassBL
global yProbeClass2
global yProbeClass3

;probe anchor for super charge intervals
global xProbeSuperQ0
global xProbeSuperQ1
global xProbeSuperQ2
global xProbeSuperQ3
global xProbeSuperQ4
global yProbeSuperQ0
global yProbeSuperQ1
global yProbeSuperQ2
global yProbeSuperQ3
global yProbeSuperQ4



;known colors (only 4 brightness supported atm)
global clrPri:= 0xF1F1F1
global clrSpc:= 0x7AF48B
global clrHvy:= 0xB286FF
global clrSeparator:= 0xCBCBCB
global clrMenuArc:= 0x79EBF3
global clrMenuSolar:= 0xF36F26
global clrMenuStasis:= 0x252A46
global clrMenuStrand:= 0x38E266
global clrMenuVoid:= 0xB082CB
global clrSuper:= 0xF5DC56

If FileExist(fileScriptOut)
	FileDelete,%fileScriptOut%

If Not WinExist("Destiny 2")
{
	MsgBox,Destiny is not running`, cancelling calibration.
	Return
}

WinActivate, Destiny 2


;index by first anchor (right of separator bar), 0xCBCBCB at brightness 4. notify if failure

PixelSearch,xAnchorClusterR,yPivotSeparatorR,winWidth/2,winHeight/2,winWidth/4,winHeight,clrSeparator,0,RGB Fast
xPivotSeparatorR := xAnchorClusterR - 2

PixelSearch,xAnchorClusterL,yPivotSeparatorL,0,winHeight,xPivotSeparatorR,yPivotSeparatorR,clrSeparator,0,RGB Fast
xPivotSeparatorL := xAnchorClusterL + 2

;tooltip,separator R,xPivotSeparatorR,yPivotSeparatorR,1
;tooltip,separator L,xPivotSeparatorL,yPivotSeparatorL,2

;variables readied: xAnchorClusterR,xAnchorClusterL,yPivotSeparatorR,xPivotSeparatorL,yPivotSeparatorL



;establish ammo bar top and bottom pivots

PixelSearch,xTrash,yCheck0,xPivotSeparatorR,winHeight/2,xPivotSeparatorR,winHeight,clrPri,0,RGB Fast
if ErrorLevel
	yCheck0 := 1000000
PixelSearch,xTrash,yCheck1,xPivotSeparatorR,winHeight/2,xPivotSeparatorR,winHeight,clrSpc,0,RGB Fast
if ErrorLevel
	yCheck1 := 1000000
PixelSearch,xTrash,yCheck2,xPivotSeparatorR,winHeight/2,xPivotSeparatorR,winHeight,clrHvy,0,RGB Fast
if ErrorLevel
	yCheck2 := 1000000
yPivotAmmoBarT := min(yCheck0,yCheck1,yCheck2),yCheck0:="",yCheck1:="",yCheck2:=""

PixelSearch,xTrash,yCheck0,xPivotSeparatorR,winHeight,xPivotSeparatorR,winHeight/2,clrPri,0,RGB Fast
if ErrorLevel
	yCheck0 := -1000000
PixelSearch,xTrash,yCheck1,xPivotSeparatorR,winHeight,xPivotSeparatorR,winHeight/2,clrSpc,0,RGB Fast
if ErrorLevel
	yCheck1 := -1000000
PixelSearch,xTrash,yCheck2,xPivotSeparatorR,winHeight,xPivotSeparatorR,winHeight/2,clrHvy,0,RGB Fast
if ErrorLevel
	yCheck2 := -1000000
yPivotAmmoBarB := max(yCheck0,yCheck1,yCheck2)

;use pivots to calculate ammo probe sites

yProbeAmmoDrawn := (yPivotSeparatorR + yPivotAmmoBarT) / 2
yProbeAmmoStow0 := ((3 * yPivotSeparatorR) + yPivotAmmoBarB) / 4
yProbeAmmoStow1 := (yPivotSeparatorR + 3 * yPivotAmmoBarB) / 4
xProbeAmmo := xPivotSeparatorR - 1

;variables readied: xProbeAmmo, yProbeAmmoDrawn, yProbeAmmoStow0, yProbeAmmoStow1, all ammo bar pivots



;use ammo bar probes to find ability widths

PixelSearch,xProbeClassR,yTrash,xProbeAmmo,yPivotSeparatorL,0,yPivotSeparatorL,0xFFFFFF,0,RGB Fast

PixelSearch,xProbeClassL,yTrash,xProbeClassR - 1,yTrash,0,yTrash,0xFFFFFF,0,RGB Fast

PixelSearch,xProbeMeleeR,yTrash,xProbeClassL - 1,yTrash,0,yTrash,0xFFFFFF,0,RGB Fast

PixelSearch,xProbeMeleeL,yTrash,xProbeMeleeR - 1,yTrash,0,yTrash,0xFFFFFF,0,RGB Fast

PixelSearch,xProbeGrenadeR,yTrash,xProbeMeleeL - 1,yTrash,0,yTrash,0xFFFFFF,0,RGB Fast

PixelSearch,xProbeGrenadeL,yTrash,xProbeGrenadeR - 1,yTrash,0,yTrash,0xFFFFFF,0,RGB Fast

;use ability widths to find ability heights, left and right sparrow probes
yProbeGrenadeBR := PixelFindLineEnd(yPivotSeparatorL,yProbeAmmoStow1,xProbeGrenadeR,1,0xFFFFFF)
yProbeGrenadeBL := PixelFindLineEnd(yPivotSeparatorL,yProbeAmmoStow1,xProbeGrenadeL,1,0xFFFFFF)
yProbeGrenadeTR := PixelFindLineEnd(yProbeAmmoDrawn,yPivotAmmoBarT,xProbeGrenadeR,1,0xFFFFFF)
yProbeGrenadeTL := PixelFindLineEnd(yProbeAmmoDrawn,yPivotAmmoBarT,xProbeGrenadeL,1,0xFFFFFF)

yProbeMeleeBR := PixelFindLineEnd(yPivotSeparatorL,yProbeAmmoStow1,xProbeMeleeR,1,0xFFFFFF)
yProbeMeleeBL := PixelFindLineEnd(yPivotSeparatorL,yProbeAmmoStow1,xProbeMeleeL,1,0xFFFFFF)
yProbeMeleeTR := PixelFindLineEnd(yProbeAmmoDrawn,yPivotAmmoBarT,xProbeMeleeR,1,0xFFFFFF)
yProbeMeleeTL := PixelFindLineEnd(yProbeAmmoDrawn,yPivotAmmoBarT,xProbeMeleeL,1,0xFFFFFF)

yProbeClassBR := PixelFindLineEnd(yPivotSeparatorL,yProbeAmmoStow1,xProbeClassR,1,0xFFFFFF)
yProbeClassBL := PixelFindLineEnd(yPivotSeparatorL,yProbeAmmoStow1,xProbeClassL,1,0xFFFFFF)
yProbeClassTR := PixelFindLineEnd(yProbeAmmoDrawn,yPivotAmmoBarT,xProbeClassR,1,0xFFFFFF)
yProbeClassTL := PixelFindLineEnd(yProbeAmmoDrawn,yPivotAmmoBarT,xProbeClassL,1,0xFFFFFF)

xProbeSuperQ0 := xProbeGrenadeL
xProbeSuperQ1 := .75 * xProbeSuperQ0 + .25 * xProbeAmmo
xProbeSuperQ2 := .5 * xProbeSuperQ0 + .5 * xProbeAmmo
xProbeSuperQ3 := .25 * xProbeSuperQ0 + .75 * xProbeAmmo

tooltip,TR,xProbeGrenadeR,yProbeGrenadeTR,1
tooltip,TL,xProbeGrenadeL,yProbeGrenadeTL,2
tooltip,BR,xProbeGrenadeR,yProbeGrenadeBR,3
tooltip,BL,xProbeGrenadeL,yProbeGrenadeBL,4

tooltip,TR,xProbeMeleeR,yProbeMeleeTR,5
tooltip,TL,xProbeMeleeL,yProbeMeleeTL,6
tooltip,BR,xProbeMeleeR,yProbeMeleeBR,7
tooltip,BL,xProbeMeleeL,yProbeMeleeBL,8

tooltip,TR,xProbeClassR,yProbeClassTR,9
tooltip,TL,xProbeClassL,yProbeClassTL,10
tooltip,BR,xProbeClassR,yProbeClassBR,11
tooltip,BL,xProbeClassL,yProbeClassBL,12

PixelGetColor,clrTemp,xProbeAmmo,yProbeAmmoDrawn,RGB

switch clrTemp
{
	case 0xB286FF:
		label = heavy
	case 0xF1F1F1:
		label = primary
	case 0x7AF48B:
		label = special
}

tooltip,%label%,xProbeAmmo,yProbeAmmoDrawn,13

PixelGetColor,clrTemp,xProbeAmmo,yProbeAmmoStow0,RGB

switch clrTemp
{
	case 0xB286FF:
		label = heavy
	case 0xF1F1F1:
		label = primary
	case 0x7AF48B:
		label = special
}

tooltip,%label%,xProbeAmmo,yProbeAmmoStow0,14

PixelGetColor,clrTemp,xProbeAmmo,yProbeAmmoStow1,RGB

switch clrTemp
{
	case 0xB286FF:
		label = heavy
	case 0xF1F1F1:
		label = primary
	case 0x7AF48B:
		label = special
}

tooltip,%label%,xProbeAmmo,yProbeAmmoStow1,15

;not in a spot im okay with but this is just a demo
yProbeGrenade2 := 2 * yProbeGrenadeBL - yProbeGrenadeBR
xprobeGrenade2 := .5 * xProbeGrenadeL + .5 * xProbeGrenadeR
tooltip,charge 2,xprobeGrenade2,yprobegrenade2,19


msgbox, script paused before ending`, just to show the tooltips know where to go `:`)
return

;^`::ExitApp


;start is where your search starts, stop is the max u want this to search, anchor is the coordinate you want the line to be searched at
;mode determines if the scan is horizontal (0) or vertical (1), clrObject is the color of line ur searching, RGB in 0xNNNNNN form
PixelFindLineEnd(Start,Stop,Anchor,modeSearch,clrObject)
{
	clrSubject := clrObject
	if modeSearch
	{
		if (Start < Stop)
		{
			while clrSubject = clrObject
			{
				PixelGetColor,clrSubject,Anchor,Start + A_Index - 1,RGB
				indexLast := Start + A_Index - 1
				if Start + A_Index - 1 = Stop
					return, 0
				;tooltip,%clrSubject%,Anchor,Start + A_Index - 1, 4
			}
			return, indexLast
		}
		else if (Start > Stop)
		{
			while clrSubject = clrObject
			{
				;tooltip,teststartlrgr,Anchor,Start - A_Index + 1, 4
				PixelGetColor,clrSubject,Anchor,Start - A_Index + 1,RGB
				indexLast := Start - A_Index + 1
				if Start - A_Index + 1 = Stop
					return, 0
			}
			return, indexLast
		}
		
	}
	else
	{
		if (Start < Stop)
		{
			while clrSubject = clrObject
			{
				tooltip,teststartsmlr,Anchor,Start + A_Index - 1, 4
				PixelGetColor,clrSubject,Start + A_Index - 1,Anchor,RGB
				indexLast := Start + A_Index - 1
				if Start + A_Index - 1 = Stop
					return, 0
			}
			return, indexLast
		}
		else if (Start > Stop)
		{
			while clrSubject = clrObject
			{
				tooltip,teststartsmlr,Anchor,Start - A_Index + 1, 4
				PixelGetColor,clrSubject,Start - A_Index + 1,Anchor,RGB
				indexLast := Start - A_Index + 1
				if Start - A_Index + 1 = Stop
					return, 0
			}
			return, indexLast
		}
	}
}