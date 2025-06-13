F3::reload
F4::
Loop {
	Send, {RButton down}
	imagesearch, Px, Py, 0, 900, 190, 1200, *70, high.png
	if (errorlevel = 2) {
		MsgBox, imagesearch could not run, try running as administrator?
	}
	else if (errorlevel = 1) {
		FileAppend, can't find`n, log.txt
	}
	else {
		SoundPlay, C:\Users\itzta\Documents\Destiny 2\r2d2.wav
		return
	}
}

esc::exitapp