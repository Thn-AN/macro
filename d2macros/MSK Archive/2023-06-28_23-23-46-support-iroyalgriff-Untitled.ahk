image = C:\Users\itzta\Documents\Destiny 2\pic.png
sound = C:\Users\itzta\Documents\Destiny 2\r2d2.wav
F3::
WinGetPos,,, width, height, A
Loop {
 Sleep, 200
 ImageSearch, x,, 2560, 1440, width, height, %image%
 SoundPlay, % ErrorLevel ? "" : sound, Wait
} Until (x = "")
Return