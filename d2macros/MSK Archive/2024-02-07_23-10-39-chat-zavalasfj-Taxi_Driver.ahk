watch_for_text(target_text) {
    while true {
        ; Capture the current screen
        screenshot := Screenshot()

        ; Check if the target text is present on the screen
        if (ImageSearch(target_text, screenshot)) {
            play_macro()
            break
        }

        ; Wait for a short period before checking again
        Sleep, 1000
    }
}

play_macro() {
    ; Replace this with the path to your macro file or any other action you want to perform
    macro_file_path := "C:\Users\aiden\Desktop\Blue Armor Farm\Taxi"
    
    ; Perform the action to play the macro here
    ; For demonstration purposes, we'll print a message
    MsgBox, Playing macro file: %macro_file_path%
}

; Replace "Has Joined your Fireteam" with the actual text you want to monitor
watch_for_text("Has Joined your Fireteam")

Screenshot() {
    CoordMode, Pixel, Screen
    ImageSearch, FoundX, FoundY, 0, 0, A_ScreenWidth, A_ScreenHeight, *32 %A_ScriptDir%\target_text.png
    return %ErrorLevel%
}
