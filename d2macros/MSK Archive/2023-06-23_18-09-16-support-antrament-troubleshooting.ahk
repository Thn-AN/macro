#singleinstance force

F4::
{
	imagesearch, Px, Py, 0, 0, a_screenwidth, a_screenheight, *10, image.png
		if (errorlevel = 2) {
			MsgBox, imagesearch could not run             
		}
		else if (errorlevel = 1) {
			MsgBox, image could not be found on screen
		}
		else {
			MsgBox, image found!
		}
}