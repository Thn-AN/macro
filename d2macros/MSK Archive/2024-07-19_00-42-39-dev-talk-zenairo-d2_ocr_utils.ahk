#Requires AutoHotkey v1.1.27+
#SingleInstance, Force
SendMode Input
CoordMode, Mouse, Screen
CoordMode, Pixel, Screen
SetWorkingDir, %A_ScriptDir%
SetBatchLines, -1
SetKeyDelay, -1
SetMouseDelay, -1
DetectHiddenWindows, On

#Include %A_ScriptDir%/interface_catalog.ahk
#Include %A_ScriptDir%/Gdip_ALL.ahk
pToken := Gdip_Startup()
global D2_SENSITIVITY := 0
global DEBUG := true

; Game Window Initialization
; =================================== ;
    ; will be coordinates of destinys client area (actual game window not including borders)
    global DESTINY_X := 0
    global DESTINY_Y := 0
    global DESTINY_WIDTH := 0
    global DESTINY_HEIGHT := 0
    global D2_WINDOW_HANDLE := -1

    find_d2()

    ; if (DESTINY_WIDTH > 1280 || DESTINY_HEIGHT > 720) ; make sure they are actually on windowed mode :D
    ; {
    ;     MsgBox, % "This script is only designed to work with the game in windowed and a resolution of 1280x720. Your resolution is " DESTINY_WIDTH "x" DESTINY_HEIGHT "."
    ;     ExitApp
    ; }
; =================================== ;

; Keybind loading
; =================================== ; 
    keys_we_press := [
        ,"ui_open_start_menu_settings_tab"]

    global key_binds := get_d2_keybinds(keys_we_press) ; this gives us a dictionary of keybinds

    for key, value in key_binds ; make sure the keybinds are set (except for settings, dont technically need that one but having it bound speeds it up)
    {
        if (!value)
        {
            if (key != "ui_open_start_menu_settings_tab")
            {
                MsgBox, % "You need to set the keybind for " key " in the game settings."
                ExitApp
            }
        }
    }
; =================================== ;

Return

F2::
{
    ;black_and_white("d2_official_ui", 0, "d2_official_ui.jpg", 97)
    ;MsgBox, Complete
    ;Return

    WinActivate, ahk_id %D2_WINDOW_HANDLE%nn

    PreciseSleep(500)

    ;mouse_settings()

    d2_click( 0.5 * DESTINY_WIDTH, 0.5 * DESTINY_HEIGHT, 0)

    PreciseSleep(500)

    D2_SENSITIVITY := get_interface_element("InspectedItemName")

    MsgBox, Your sensitivity is: %D2_SENSITIVITY%
}

Look( x, y, sens:=6 )
{
    deg := deg * ( (54545.5 / sens) / 360)
    DllCall("mouse_event", uint, 1, int, deg, int, 0)
}

get_d2_keybinds(k) ; very readable function that parses destiny 2 cvars file for keybinds
{
    FileRead, f, % A_AppData "\Bungie\DestinyPC\prefs\cvars.xml"
    if ErrorLevel 
        return False
    b := {}, t := {"shift": "LShift", "control": "LCtrl", "alt": "LAlt", "menu": "AppsKey", "insert": "Ins", "delete": "Del", "pageup": "PgUp", "pagedown": "PgDn", "keypad`/": "NumpadDiv", "keypad`*": "NumpadMult", "keypad`-": "NumpadSub", "keypad`+": "NumpadAdd", "keypadenter": "NumpadEnter", "leftmousebutton": "LButton", "middlemousebutton": "MButton", "rightmousebutton": "RButton", "extramousebutton1": "XButton1", "extramousebutton2": "XButton2", "mousewheelup": "WheelUp", "mousewheeldown": "WheelDown", "escape": "Esc"}
    for _, n in k 
        RegExMatch(f, "<cvar\s+name=""`" n `"""\s+value=""([^""]+)""", m) ? b[n] := t.HasKey(k2 := StrReplace((k1 := StrSplit(m1, "!")[1]) != "unused" ? k1 : k1[2], " ", "")) ? t[k2] : k2 : b[n] := "unused"
    return b
}

mouse_settings()
{
    Send, {Esc}
    Sleep, 300
    Send, {Esc}
    Sleep, 300
    Send, {Esc}
    Sleep, 300
    if (!key_binds["ui_open_start_menu_settings_tab"])
    {
        Send, {F1}
        Sleep, 3000
        d2_click(1144, 38, 0)
        Sleep, 100
        d2_click(1144, 38)
    }
    else
        Send, % "{" key_binds["ui_open_start_menu_settings_tab"] "}"
}

get_interface_element(element_name, b_w:=true)
{
    pD2WindowBitmap := Gdip_BitmapFromHWND(D2_WINDOW_HANDLE)
    ; result := Gdip_SaveBitmapToFile(pD2WindowBitmap, "D2Window.png")

    ; Get the dimensions of the image
    width := Gdip_GetImageWidth(pD2WindowBitmap)
    height := Gdip_GetImageHeight(pD2WindowBitmap)

    ; Crop boundaries are as follows: [ left, top, right, bottom ]
    ; Define the percentages to crop
    leftCropPercent := UI_CATALOG[element_name][1]
    topCropPercent := UI_CATALOG[element_name][2]
    rightCropPercent := UI_CATALOG[element_name][3]
    bottomCropPercent := UI_CATALOG[element_name][4]

    ; Calculate the crop region based on percentages
    cropX := Round(leftCropPercent * width)
    cropY := Round(topCropPercent * height)
    cropWidth := Round(rightCropPercent * width) - cropX
    cropHeight := Round(bottomCropPercent * height) - cropY

    ; Create a new bitmap with the cropped dimensions
    pElementBitmap := Gdip_CreateBitmap(cropWidth, cropHeight)
    G := Gdip_GraphicsFromImage(pElementBitmap)
    Gdip_DrawImage(G, pD2WindowBitmap, 0, 0, cropWidth, cropHeight, cropX, cropY, cropWidth, cropHeight)
    
    Gdip_DisposeImage(pD2WindowBitmap)

    if (DEBUG)
    {
        result := Gdip_SaveBitmapToFile(pElementBitmap, element_name ".png")
    }

    if (b_w)
    {
        black_and_white(element_name, pElementBitmap)
    }

    return image_to_text(element_name)

    ; Gdip_DeleteGraphics(G)

    ; Clean up GDI+ objects
    ; Gdip_DisposeImage(pBitmap)
    ; Gdip_DisposeImage(pCroppedBitmap)
    ; Gdip_Shutdown(pToken)
}

image_to_text(element_name)
{
    ; Define the path to Capture2Text executable and the image file
    capture2textPath := A_ScriptDir . "\Capture2Text\Capture2Text_CLI.exe"
    imagePath := A_ScriptDir . "\" element_name "_b_w.png"
    ocrResultFile := A_ScriptDir . "\ocr_result.txt"

    ; Run Capture2Text with the image file
    RunWait, %capture2textPath% -i "%imagePath%" -l English -o "%ocrResultFile%", , Hide

    ; Read the OCR result from the output file
    FileRead, ocrResult, %ocrResultFile%

    ; Clean up the output file
    ; FileDelete, %A_ScriptDir%\ocr_result.txt

    return ocrResult
}

black_and_white(element_name, pBitmap, file:=false, threshold:=97)
{
    if (file)
    {
        ; Load the image
        imagePath := A_ScriptDir . "\" file
        pBitmap := Gdip_CreateBitmapFromFile(imagePath)
    }

    ; Convert the image to grayscale
    convert_to_grayscale(pBitmap)

    ; Apply a threshold to convert the image to black and white
    apply_threshold(pBitmap, threshold)

    ; Save the processed image for verification
    Gdip_SaveBitmapToFile(pBitmap, A_ScriptDir . "\" element_name "_b_w.png")
}

; Convert the image to grayscale
convert_to_grayscale(pBitmap)
{
    width := Gdip_GetImageWidth(pBitmap)
    height := Gdip_GetImageHeight(pBitmap)
    pGraphics := Gdip_GraphicsFromImage(pBitmap)
    Gdip_SetSmoothingMode(pGraphics, 6)

    loop, % width
    {
        x := A_Index - 1
        loop, % height
        {
            y := A_Index - 1
            ARGB := Gdip_GetPixel(pBitmap, x, y)
            a := (ARGB >> 24) & 0xFF
            r := (ARGB >> 16) & 0xFF
            g := (ARGB >> 8) & 0xFF
            b := ARGB & 0xFF
            gray := (r * 0.299 + g * 0.587 + b * 0.114)
            gray := Round(gray)
            newColor := (a << 24) | (gray << 16) | (gray << 8) | gray
            Gdip_SetPixel(pBitmap, x, y, newColor)
        }
    }

    Gdip_DeleteGraphics(pGraphics)
}

; Apply a threshold to convert the image to black and white
apply_threshold(pBitmap, threshold := 97)
{
    width := Gdip_GetImageWidth(pBitmap)
    height := Gdip_GetImageHeight(pBitmap)
    pGraphics := Gdip_GraphicsFromImage(pBitmap)
    Gdip_SetSmoothingMode(pGraphics, 2)

    loop, % width
    {
        x := A_Index - 1
        loop, % height
        {
            y := A_Index - 1
            ARGB := Gdip_GetPixel(pBitmap, x, y)
            gray := ARGB & 0xFF
            newColor := (gray >= threshold) ? 0xFFFFFFFF : 0xFF000000
            Gdip_SetPixel(pBitmap, x, y, newColor)
        }
    }

    Gdip_DeleteGraphics(pGraphics)
}

capture_sens(hWnd)
{
    pToken := Gdip_Startup()
    pBitmap := Gdip_BitmapFromHWND(hWnd)
    result := Gdip_SaveBitmapToFile(pBitmap, "sens.png")

    ; Get the dimensions of the image
    width := Gdip_GetImageWidth(pBitmap)
    height := Gdip_GetImageHeight(pBitmap)

    ; Define the percentages to crop
    ; For most gear.
    topCropPercent := 0.25
    leftCropPercent := 0.83
    bottomCropPercent := 0.275
    rightCropPercent := 0.87
    ; For emblems. Could retry with different settings if no results.
    ; topCropPercent := 0.025
    ; leftCropPercent := 0.12
    ; bottomCropPercent := 0.20
    ; rightCropPercent := 0.70

    ; Calculate the crop region based on percentages
    cropX := Round(leftCropPercent * width)
    cropY := Round(topCropPercent * height)
    cropWidth := Round(rightCropPercent * width) - cropX
    cropHeight := Round(bottomCropPercent * height) - cropY

    ; Create a new bitmap with the cropped dimensions
    pCroppedBitmap := Gdip_CreateBitmap(cropWidth, cropHeight)
    G := Gdip_GraphicsFromImage(pCroppedBitmap)
    Gdip_DrawImage(G, pBitmap, 0, 0, cropWidth, cropHeight, cropX, cropY, cropWidth, cropHeight)

    scalar := 1

    ; Calculate the new dimensions based on the scalar
    newWidth := Round(cropWidth * scalar)
    newHeight := Round(cropHeight * scalar)

    ; Create a new bitmap for the resized image
    pResizedBitmap := Gdip_CreateBitmap(newWidth, newHeight)
    GResized := Gdip_GraphicsFromImage(pResizedBitmap)
    Gdip_SetInterpolationMode(GResized, 7) ; Set interpolation mode to high quality
    Gdip_DrawImage(GResized, pCroppedBitmap, 0, 0, newWidth, newHeight, 0, 0, cropWidth, cropHeight)

    ; Save the cropped image
    result := Gdip_SaveBitmapToFile(pResizedBitmap, "sens.png")

    ; Clean up GDI+ objects
    Gdip_DeleteGraphics(G)
    Gdip_DisposeImage(pBitmap)
    Gdip_DisposeImage(pCroppedBitmap)
    Gdip_Shutdown(pToken)
}

; Other Functions
; =================================== ;
find_d2() ; find the client area of d2
{
    ; Detect the Destiny 2 game window
    WinGet, Destiny2ID, ID, ahk_exe destiny2.exe
    D2_WINDOW_HANDLE := Destiny2ID
    
    ; Get the dimensions of the game window's client area
    WinGetPos, X, Y, Width, Height, ahk_id %Destiny2ID%
    if(Y < 1) {
        WinMove, ahk_exe destiny2.exe,, X, 1
    }
    WinGetPos, X, Y, Width, Height, ahk_id %Destiny2ID%
    VarSetCapacity(Rect, 16)
    DllCall("GetClientRect", "Ptr", WinExist("ahk_id " . Destiny2ID), "Ptr", &Rect)
    ClientWidth := NumGet(Rect, 8, "Int")
    ClientHeight := NumGet(Rect, 12, "Int")

    ; Calculate border and title bar sizes
    BorderWidth := (Width - ClientWidth) // 2
    TitleBarHeight := Height - ClientHeight - BorderWidth

    ; Update the global vars
    DESTINY_X := X + BorderWidth
    DESTINY_Y := Y + TitleBarHeight
    DESTINY_WIDTH := ClientWidth
    DESTINY_HEIGHT := ClientHeight
    return
}

d2_click(x, y, press_button:=1) ; click somewhere on d2
{
    Click, % DESTINY_X + x " " DESTINY_Y + y " " press_button
    return
}

PreciseSleep(s) ; awesome sleep function wow
{
    DllCall("QueryPerformanceFrequency", "Int64*", QPF)
    DllCall("QueryPerformanceCounter", "Int64*", QPCB)
    While (((QPCA - QPCB) / QPF * 1000) < s)
        DllCall("QueryPerformanceCounter", "Int64*", QPCA)
    return ((QPCA - QPCB) / QPF * 1000) 
}
; =================================== ;