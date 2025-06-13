Scan := New ShinsImageScanClass()
Overlay := new ShinsOverlayClass("Destiny 2")
SetTimer, UpdateOverlay, 200
UpdateOverlay:
    If WinExist("Destiny 2") {
        WinGetPos, x, y, w, h, ahk_exe destiny2.exe
        StartWidth := w * 0.325
        StartHeight := h * 0.55
        RegionWidth := w * 0.35
        RegionHeight := h * 0.25
		If (Overlay.BeginDraw()) { 
			Switch Status
			{
				Case 0:
					Overlay.DrawText("F2 close, F4 start fishing, F8 center window`nsupport + more scripts: discord.gg/KGyjysA5WY", 10, 0, 32, 0xFFFFFFFF, "Courier")
				Case 1:
					Overlay.DrawText("F2 close, F3 pause`nTrying to find the X...", 10, 0, 32, 0xFFFFFFFF, "Courier")
					Overlay.DrawText("This is the region being searched:", StartWidth, StartHeight - 60, 32, 0xFFFF0000, "Courier")
					Overlay.DrawRectangle(StartWidth, StartHeight, RegionWidth, RegionHeight, 0xFFFF0000, 4)
					Overlay.DrawText("Your brightness should be 7`nIf this is here for a while, ask for help!", StartWidth, StartHeight + RegionHeight, 32, 0xFFFF0000, "Courier")
				Case 2:
					Overlay.DrawText("F2 close, F3 pause`nFish caught: " fish, 10, 0, 32, 0xFFFFFFFF, "Courier")
			
				Case 3:
					Overlay.DrawText("F2 close, F3 pause`nX not found for roughly 1 minute!`nPaused script, jiggling to prevent afk kick.", 10, 0, 32, 0xFFFFFFFF, "Courier")
			}
			Overlay.EndDraw()
		}
    }
    Else {
        GoSub, HideOverlay
    }
Return
HideOverlay:
    Overlay.BeginDraw()
    Overlay.EndDraw()
Return