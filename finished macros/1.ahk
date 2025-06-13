`::
Reload
return

[::
Loop
{	
	Send, 1
	Sleep 100
	Send, r
	sleep 100
	Send, {Lbutton Down}
	Sleep 1000
	Send, {Lbutton Up}
	sleep 100
}
return

]::
Loop
{
	Send, 2
	Sleep 100
	Send, {Lbutton Down}
	Sleep 2000
	Send, {Lbutton Up}
	Sleep 100
}
return