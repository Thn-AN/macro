6::
loop{
mousemove, 1095, 55, 0
click
sleep 2000
mousemove, 590, 380, 0
click
sleep 2000
send {right}
sleep 2000
mousemove, 865, 775, 0
sleep 500

loop 9{
click, down
sleep 3000
click, up
sleep 1500
}

send {n}
sleep 1000
mousemove, 520, 385, 0
sleep 1000
mousemove, 410, 380, 3
sleep 500

loop 9{
send {f down}
sleep 2000
send {f up}
sleep 1000
}



}





7::reload
8::exitapp