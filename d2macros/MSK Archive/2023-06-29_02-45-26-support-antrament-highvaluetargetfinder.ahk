F3::reload
F4::
Loop {
	imagesearch, Px, Py, 0, 900, 190, 1200, *70, high.png
	if (errorlevel = 2) {
		MsgBox, imagesearch could not run, try running as administrator?
	}
	else if (errorlevel = 1) {
		FileAppend, can't find`n, log.txt
	}
	else {
		SoundPlay, <FILE LOCATION HERE>
		break
	}
}