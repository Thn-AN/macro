#singleinstance force

F2::
{
	send, {e up}
	sleep 100
	exitapp
}
F3::
{
	send, {e up}
	sleep 100
	reload
}
F4::
{
	loop {
		loop {
                imagesearch, Px, Py, a_screenwidth*0.4, a_screenheight*0.5, a_screenwidth*0.65, a_screenheight*0.7, *70, e.png
			if (errorlevel = 2) {
				MsgBox, imagesearch could not run, try running as administrator?
			}
			else {
				break
			}
		}
	send, {e down}
	sleep, 800
	send, {e up}
	}
}
