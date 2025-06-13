;####################
; My discord is antrament - this is a server with more macro/script shit + support: https://discord.gg/KGyjysA5WY
; The main function of this script was made by Orchrist
; VERSION 1.6.0
;####################
#Requires AutoHotkey >=1.1.36 <1.2
#NoEnv
#Persistent
#SingleInstance, Force
#ifwinactive ahk_exe destiny2.exe ; only have hotkeys work if d2 is active


;;; CREDIT TO @.zovc for updates to the recommended settings. All comments with "Z-" were modifications made by him
; Z- If you need to check what size the script is reading your game window to be, delete the semi-colon on the line below. Save and reload script.
;MsgBox, , , D2 is scaled at %D2Width% x %D2Height%


; Z- Separated these because they dont really change between diff aspect ratios
;;/////////////////////////////////////////////////////////////////////////////////////////////////////////
global initialaim 	:= 4350			; (4350) How long to move the reticle towards the right when aiming for the run path
global prearcsleep 	:= 4700			; (4700) How long you run forward before starting the arc when running to the chest
global arcsleep 	:= 2000			; (2000) How long you arc to the left towards the chest
global postarcsleep := 2400			; (2400) How long you run forward after the arc is completed. This should end up so you can open the chest

;; Setup for Screen resolution differences
;;/////////////////////////////////////////////////////////////////////////////////////////////////////////
WinGetPos, , , D2Width, D2Height, Destiny 2
global fasttravelsleep := 2100		; Z- Default timing to the most common value across ratios. As a fallback in the event no ratio is recognized.
global orbitlauncherright := 900	; ^  How long cursor moves to the right when launching the landing from orbit
global orbitlauncherdown := 550		; ^  How long cursor moves to the down when launching the landing from orbit

;; 43:18 resolution (3440x1440)
if ((D2Width/D2Height) == (43/18)) {
	global fasttravelsleep := 1525		; How long your cursor scrolls to click on the Landing fast travel
}
;; 16:9 resolution (1920x1080, 2560x1440)
if ((D2Width/D2Height) == (16/9)) {
	global fasttravelsleep := 2100		; How long your cursor scrolls to click on the Landing fast travel
}
;; 16:10 resolution (1920x1200)
if ((D2Width/D2Height) == (16/10)) {
	global fasttravelsleep := 2100		; How long your cursor scrolls to click on the Landing fast travel
}
;; 32:9 resolution (5140x1440)
if ((D2Width/D2Height) == (32/9)) {
	global fasttravelsleep := 2100		; How long your cursor scrolls to click on the Landing fast travel
}

;; 32:9 resolution (5140x1440)
if ((D2Width/D2Height) == (32/9)) {
	global fasttravelsleep := 2100		; How long your cursor scrolls to click on the Landing fast travel
}

;; 21:9 resolution (5140x1440)
if ((D2Width/D2Height) == (21/9)) {
	global fasttravelsleep := 2100		; How long your cursor scrolls to click on the Landing fast travel
	global orbitlauncherright := 1000	; How long cursor moves to the right when launching the landing from orbit
	global orbitlauncherdown := 400		; How long cursor moves to the down when launching the landing from orbit
}    


;Error if screen ratio is not currently supported
;;/////////////////////////////////////////////////////////////////////////////////////////////////////////
if ((D2Width/D2Height) != (16/9) && (D2Width/D2Height) != (43/18) && (D2Width/D2Height) != (32/9) && (D2Width/D2Height) != (16/10) ){
MsgBox, 262404, , % "Your Screen aspect ratio is not currently supported for this script.`nMake sure you are running in Windowed Fullscreen and with the correct settings.`n`nThe script will default to 16:9 settings.`nWould you like to continue anyway?"
IfMsgBox No
	ExitApp
else
	WinActivate, Destiny 2
	; Z- just making sure it reactivates D2, since the overlay doesnt show if D2 isnt actively selected
}

;; Antra's bag of tricks
	;; PreciseSleep
		PreciseSleep(s)
		{
			DllCall("QueryPerformanceFrequency", "Int64*", QPF)
			DllCall("QueryPerformanceCounter", "Int64*", QPCB)
			While (((QPCA - QPCB) / QPF * 1000) < s)
				DllCall("QueryPerformanceCounter", "Int64*", QPCA)
			return ((QPCA - QPCB) / QPF * 1000) 
		}

	;; ViGE Wrapper DLL Creation
		if FileExist(A_Temp "\vigemwrapper.dll") {
		} else
		{
		; ok, this requires some explaining.
		; so far the biggest issue i've encountered with people is the fucking up of the vigemwrapper - 
		; its location, its size, its name, it becoming corrupted by extracting from a zip.
		; thus i present to you, the "ultimate solution" that is very stupid but ultra consistent - 
		; build the file from base64 and place it in a place where the average user can't tamper with it. lol.
		; also, sometimes the download from github would just corrupt? has happened to like 5 people, real strange
		; i thought corrupt downloads were a thing of the past but i guess not with this apparently ultra fragile file
			wrapperbase64 := "
			( LTrim Join
			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
			)"
			wrapperbase64 .= "
			( LTrim Join
			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
			UGxCMtzl+mrbSnchKHx5SanJQgrcpdNM1syqEosFMCzAmSoveLdKWSZrSWUV4OTrC+YaM4w51HCSoQIeryazphoIqSJvkEyzCSZN
			dmWVaR55lc/pV4GthdqlQmg6t8Ri1ZvN6NB2E8msqrGYDCXVZVUm8hCWzlplMleV1NaayuaYLLYqK5mhnzNTn6uLZT3OERdlVpcV
			WSqXV5dUEZswraigwlxzS1FmbW2RCRtNt1jL0tMXZMw3pC8k1q5yP6UN4qI8a10RWJObyEzWbllN0TJzTUlZKdAIFqzIWgH0lxWZ
			6iqBq7k8DuM5rF4sf0sJFNpZW5XVkH5JjJ0CkWBLrGQvnyszoT2ENZVhelqZxVqhNR2szFZNacrLL8w0xsRp2cjDSFFRZl1dtrlk
			Jc8w9IeXQIpqbWZTKRhFMgIwYHxFILOVldVouaRYp8hSaypFM1dUwarh2YFheu7XYcWrXY0eFrvD3WQKCHZOeanvupQf6e4RVgUY
			QXmNG7+oiurhFLLStBIsOezsM+fMnVmQk6f3jCeS0NWIDCArmUVHanEc1aZbKnBcyBEcCknsSheZSBqBtaGiqLyyCi04NhVJcMEu
			r1wOjCiqLjGjvMGKryJEx2pWllRVrvEUmapXVZprqvEWhJA4H4yaapQ0rAHLQB2RG6Y6U6nN2q2gH/THNKKktnL8Ssv4Wyqrx5ea
			rePNtmpr5UrT+KqY8THj2TC7YVSYSmq9i8mbojnWqsySWivQjnMI/fGcRFhuTc1NttpsW3UpsloPswvk8yGWFFaarbaSqrnV0Cic
			p/eJ51YzwZZ5JJNNmUOIRQwzutfiQTjfMm1mM3DCaK4B02Ah94gL3NrjBpGNATkWPlNjzob5DLQazSYLMjBHNNtmMq82gpmoMa8s
			qS6FUdjQapConq3nlBGVF7SATi4AkgsIzV8Na/LKAmBghgXNB6aISpBVaUGuM+TcymXmEvPqTFATC1kekOMRXT4aPgNgkHVAbZZp
			mW35cpPZTeWvj+/j/mbsW0tUJ8vfd3+RlZ0L8OwzUeWL3/3jiopun2tMSMso9NiA9HS/5cvAjtKJzmxwr+14bM/P4NH28LO8IjAY
			ReyzPHcVf/hp6qLcEphOFcaSsnTI2aorb7aZimqtZszBuldlSi+cXFWycllZSVFZXEJJeWJSWYk2ftmyJG28KbY8viQpAYClZSZT
			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
			)"
			wrapperbase64 .= "
			( LTrim Join
			I9On3PF10PSf1s/XbDhz4o05bzeqTn2+oDVZfvBq5jtX7n7k80tb0i/FPfGN5cGWz9+xHIzYnGBZeKz9psVfDnrFOvSJfr9Ja/52
			wsynk1JbP/8uSZm08q8X3zFHfXFpwWMfT7n4I1e7uC7o+zXJL7184TdDPr3YNvlopeRk1D7ruXvvGvLwlfvS459o3PFi7UdvVw49
			dV+S8lFy20Zrv1e2XCrtDDspu0raY2cGbBu/ubZ/q+GMakxrbdraRa0DH5V+0Tl7d/hCUfDDMcdftAf/6dFhf+48OOfp3/6lOST/
			3RceGTj/3Sen5Y99OXCqvc++9t/fH6uef/+cv3xw367slN+OFI+ccfvGMR2bnsoq3rF/0ZbsBRFPj+yzxbQpIq/8zs+3PRJb9sV9
			t+zdr5bfMV8YXFMgXhiac2/gy4+JLPftHRZ275Y3tv4lt1Qi2zW+33MbDDLu9uh7trQ8vvmNk3/s916ZY/OkqMJncm+eH/vp8YUN
			d4SdeWzQ7x585pDsTO3Z3y4+/dzr1hHDFszXPHnvvir56vZJv5/+UHLs6EXtCdq2P94/Yf5vTkaPPLxnygcOzVPLQp+YcSb+9Tnq
			uR++tvNMccVvc0YFz7hZGvpQvxmbZ65899vAl8TO+zZZd+e/aw15caT8zj+8lPG8xH7Pb8d8vW147uBBt8Y89dSdK7c/1fzZF/Jn
			Co8Wb3quYyD3ZO4X90z4eMUs9dwHigfe+fEbb8XOMCfnxd26dOtD6uq9UQlf3zRvbHiG4JvhnVNu1yzacfF45aQ9hptDUx5r/eJI
			euNbjyl0CWNjdQ//YN/QfH/9hQdbFZNS+935fb+h8o+inv726ZY/bPqg4CllyOIXBrZqN4/TbTh9ZF3DowUbFW+ojw+6+S/vzQue
			vWdD5HNT3zDd93px8ldHt901dfAuyft/aP7d0OFXxXuP3PXCwL0bzUEdittvX7Fv4V1Df9SmNurHDlqdNH6+JPH1P+86vqr46/Uf
			v9r/0OS002nbl9j3DXzhb02vPPLeQsXBNS/9ed3A2/qevT7+mwEvDB1yR/TvVOfXrFOVjdgeYz/96dlna76++vqVMPk3A5NJ3eHH
			BlsnPly1r3L4oQnvz8m7MnqSY+bgIamHvj9/x987Xh83bf2aN85cu+vzk4uOfjj2+QN/Cx7ETXvzOeu6vRfOPsBdiZpyed/qZT+d
			TLlrmnzKXNWaTX9YfNvNl44cPBQ3+LdDol+6/uIL73z310HfTOgsSlL+9N6Smqg1lkVvx69efs4S8M6rk95/acWp3/74u4f//P2J
			xC/Xr3zO6mxZX/Yht+py/P1fPnL12psvvXLo8phZM2Me2TL1ubazffrfnV/yzo7QTfddOBl/y5iGwNB19+asufz5XmN9ZemZ5LVz
			6sc+f5Np/6LE6I80T+/Q35r4ccJTtdO2/HXL/jPHAuLffL7h0zm3PBQytnzO/ZsqZ0wYOe7VGN2rxrHLYrkHn+rX8frA8Gmmx8lb
			OxaU15xfNvW1z5dvrntlc+NfGv/ywrsPzs/cl129dfzy5yv23RlvsNmub05TfHcqQbv+WbVu3z2v/2Hgn19vueXt8T9+1XDvXWv/
			X3tfHh9Vsexf58yaMJkkk20iiQx7whISElZlyU4gCyQBgnBNJslABiaZOJNAAIEAgqKsiiIu3CCIoHABERQRWRVQuQjIvYIgi4go
			CooIsv+q6pzJzJCgvvs+7/P++L3AfLuqq7u6uk6fPt2zVH9/6Oug9CnzJ14+885OxdoTgz7Yaim3njj/8rVe1xZ3adK+cPzmcXc/
			7vVGxfV9iy418z35fvnXU3dctzgLp1h/OVw4vuhSnP3x0qID/1rx+ZZF726tXP/dZ3es2yYvv7x++8QtimNnVix+9fqyUXNHdPzy
			yvdtm/YeVDXh75O/f/7dC5+2iJ9y963+Bwq3TT4dN1nT+8wH3aLebPL5W89afg85GOEzc0jEzevfhZavLZ88+dEBh5vFHDiRnv3u
			iaPzLj1wLOmzyUfnTunz9Wc392z6t771obXpM29s+arnjVd77e84IK3lz3fn7xxsXT1n654V/RSDFx+fXv5+YP6R7IyDP15Ql9yK
			fa1qq6F8Yab17LKqoGe3a5bZDuUdmLzv9zfm5732bok9/sMF8V+vHdprY7+JPw+cEPB9/4InV0YWHvvb3ndb/s2y7f3TW4ZdGrHh
			0ubS9uV1+/ZtKDq0wTjtg28ffLiv7p1lp4b7Xsqrifq473ffDqhZs86Z/1JBzOnTrxetOlfQfUnICk3QjdKlL0y7/HvwC7dG7Ll0
			Z/T1uJn2Lsc3qIb2eervs9LDj2bMHfOGX2Dky9EXfT7qtOFR/z7Z+3W3fdr22ZT31I2z8yZdGV2W+tGXpzdGXp91NfXhqsF3/vGB
			X8s2fTU/7B7vd2jAzthrsXMXKW9sm+5//q5QOmVOy6ERN0vuWLvZ9lzM6da/euHrseohM8c9d/Ou7sP5bX7Imb0za9uP733z1bQ1
			i6MG1H349MFfbzctTH3j3N2iy0fvtjQOe2xD5PWoE7OvdCpV4aLlkb9lBg8N7r2hxeW3bBuf+vLYmhlDXv/s4uW27ywvCn1d+dSp
			aatGHnp/i67z2+tKR208tOgfra2FmZ9OX//bjuVzOo288PKXK/oYDxmHT2rfpnfCcv8sxfq4Lu9k2Q4v/KlH/LixowJ/fFZ8q3Lb
			tz+f2Nznu683X1vy0LUli4d8FKZbOfXi/P2Wcc8v/PKREzdtW1KfbNntrXU7/LTPXNUMH5Q9fa54qiDa+Ixj9ch8xWfL3/eLWJV8
			NeuNgVlNEh8MmvPawYSzZVVZP4S2mWvZMeIb+7ffbBtdmVblG9Ynqk+rove6Om5e2bT06Rvth1/94vbjo37t0XLe9t2zZ129fHRQ
			xLzm596eMiHmxZ/+/o/viufuafb4raHd7lzZ9O+/FY77tOePM9ffDuvw9xFfffX4xX+efa/6vext/+x996J5zLWOF87HfPbywYQJ
			3baZbkxotfa3rTentjk58KMFWZk53/zcZ+2SbVc3X0v6KX2/6o20ybcmjv7mUvTWuLnL1xV8c3fXmGahs3u2aH3y0TX2cQfyJy09
			92pU9vdzHuugvTYqbs8P2z/bunjiOws6vTblH4uWTy069eKPTVY926lu5lxNr2cfuJIR06vDpqhHo0/1arNx8yPLFW8XXl359hcr
			n9B/kjjY58q4mi++7vVmu2vjb0/Pun1C+GXl+Tzh8V+jLOaDBxbqf7+VOz+615tPZJ/vn7zyi10L28W9npGQX3WtZppjUeCR8Nxb
			/cvm+7Y9aBp0pMmGld/8svNCwbZB46pfi0iZVZe5/veNn/Z54m6T4VMc2kXzjyw5sOJS9uwmTXp9cXCLcKx97uaI0PRJb0//ftOM
			k3fSpu2+82zWt29kjn99m+2hKPsT37760vOLSn5JLGm7M6b9jE5vv2fN6znXPqHnul+3nf91hpi498kuQ9p12375ge+HDSz9qcr/
			zeab/X/dvfOMsPmref+a+a/MG4eW6g4dqvjituP25aVfZRWGjXrkwxtVZ7Wr7DPUmbu6+kzYcvnKjcXLd9n3Hpk26O8BY9punTdh
			0FMzdg3bO3y+1Z771Ad+71wban5pVE7zvMiclv9uUfJITbPL8XvL93Y9u2vvgRbjmtvTPx65y7m37YJn5p9M/Hh/1otfP9lr3uOh
			11Vn5yW+/Kn5pW0PLUif/9hXwR8+PWLarciNQeMjNgePT7owUZvT4qsF8XHjRrwS1SXq26iQHyd06w+vP/DR3NxZl9+OPpnxwrg+
			nw74fm1dwmjLne0TOpsufrov9rdme35QHh0WvuGuOXRRRf9R51YcWLxicuvlNbc+Ge6w+c3PvD5qrVC6ofjZTUsU72c1Hfto8OHo
			Vue7nRu9aeSB/et7RJp/CR5b906H/pdWPz6/0xuxh3uX7/q5zTObKkbfPv7Jlz6P3b00YvKpjz7e9dtXL7x3NTXtkTebrqsyTWw9
			vMONtbMj5iVcXlow/Kb1zUdm+y0J3XY4+NJKR8AnZX1CDnR6sZl2wyfatPDvLp8MSr+89+W2H965fDbrm6PrVvudKRjSqibNdNH/
			0JJd55587NZzCzrkdX9h4d5zDzhO6Zoc2Tn9wLWUa7r8/CGDF3VL+KLV0m5NY9YPfDl27aNxF5e0WJS/7sCyyOQxV18Ymt+j/fVj
			y3/76eXF2fsvPdfk5zsTCm5+rNbNm9r70ZpH51xXaa/XXQoUJkfGX+hX6vSbd/X3RZOjs5vEpvxDOLz5u5vt0/oV/XJ4xRhF6K1v
			OyfHHet351fdp9NvFx/8wDjt6oXYY+8pL/5rxoS0Zldv7/GbveHdqNtblz/44+0lvYepHhq94dreJTE9zv+meXzrhJR3zywafDP3
			vQlhKyZP3tOxx8gNX8Kxo2DT3N7eb0uo48clSftKrWmTS3JXf+7/6Pnr9uToj15edgl+6NAzqGfsXFtmcVJakvPlW0P8QieVm5qF
			T2rd94JYfeS5qLPjll3cHf/+2Oy6mBUVr1/c3UX9r2W2ouq8f9tTxhfvu7SwJMaWXa3oTn+506bQO+hJef2TBPnL+PS9xLEJMbEx
			8bHxcbQfBhXYECvpbIzJuO/H9PdwpPOqHNaKUfx90y/6AHwuYt7gPFiexG83Qcv0wRn0PuI7yNdqkE+y2V1fcsaivkObbWrmQ3E8
			bgjxELqbW6evX0Xh62nSia/2gvR97TEgvSdJ+SFSfX7Re/2RQGe/SbwCpO+Q0vemBTlPKZeTvg+/yk/qpRo6hK3Sq8GmJezhmxms
			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
			0LaTuKWh34jPQ3eZu+3zo7gIitq5PP+b+BL8s517tL4KFyROW6e8JNTBrzJ3RE/cTZlT6ohTtHd7vg6a1HN3xDoIrud8FUuhpbuk
			Yhl0rOeMitehF3M0YzZXrPTS+aaXzje9dL7lpXONl861Xjrf9tL5jpfOd7x0bvTS+a6Xzs1eOj/w0vmhl84PvXRu89K5w0vnLi+d
			H3vp3Oulc6+Xzn1eOj/10rnfS+fnXjoPeek85KXzsJfOI146/+2l85iXzuNeOo976TzhpfOkl87TXjrPeuk856XznJfO77x0fu+l
			84KXzoteOn/20vmzl85fvHT+6qXzNy+dv3vpvOGl84aXzpteOm976bzrpVMUPHUqBU+dSsFTp0rw1KkRPHX6CJ46dUI6cwtgha6/
			Qi8UyNzI8BqFv7Bd5npqlyoChLoOEnc1cJvCIHwhc7H6G4pgoaCjiwtRhgg1Mtda314ZJtTJnC04T2kUimKIewGGhD+jbCokdGIZ
			r4UjhZsSB6+Ev6GMFHSxEndJt0f5oDBf5nbp9yib8VtQtHa7aNSpTPXc6vAZipb13PzwIFUrITNOqrcsuFDVWqjqLHFvBW9SRQkD
			4yVbPtH58jeeBNiuI1ygvxdrwly02IBWwLE/lO71bzxHKulGEbaq3PRzqnvLeGoYY2w8516duG9lbR9riG5uJPoxLn8liN7Z0wfT
			jr6H4c+kaij2o3cB41nnsb+seU3Qn0kb0xzFfWmruxelqyNJo1gnRVhTgFlJOWMa1JLKSP5pFUzthnO7W4LutX+FgejxOm9awbYp
			G7Htv9r63SB361mG/7x10iOyHgUkGxr30v1wDNuzJ9RN/xBIelr4unOWh1COVN6zLcljf72tv97if2bbHSXlnNRTTkfOaaElbM1e
			XRTiyhHBFujOt7FOSdqR/XzO+H91/6/u/1TdN30IH2Y8o+O7iemTGqKP8FOgO+d8FMzzCdNP8xPnJOcc5rtPquU5S5xhfIV/ddGJ
			pd+yVb9rqXwPtkTN+TVKd+sJrG0dS09wzhmeZxJ4blwXInLUCB8IB1ph+MhI7wM0h9G69hDNOcMgw6cG98PttFOFYZCmqxGsnP8Y
			43jGqYyzEMeIC5gmvCMuhgfDFArOYWyOK93j2jTFUbikH474fHARrloDfUYqDnL+YlgVMgbp24FOpE+HUc55fMqTnqdxVWfWLUA6
			MOx5XJtl+DyvuA6+YTNQw0bty5gj+D+P651437WITuW7mD8x/BiWD/c7iXR//VlFoPBV0AVFuMA9FVoH/KYIBHqnQwdNdTqlj6D3
			a6vcB5OUyYyZymhhWVB7iBPItmDoGD4Oc/aGtYeD3LtgqNNPUh6EyJAZXL4Gy5BmHWOETD+jnKSMQHxJmSiQtYnCK+F1SurFesQW
			aNti2KR7D2m931Yl0TuUg9DCM8phiD8rzWztLOGg7prSivRdRGOYUuUDa3RpilawPyhO1QE6GZNUOlikT1cthg/Cs1XXIcr3DeV1
			6OSbr1oqbDcOV5EPp6hWoYYZqh2Iz6jWIz6v2sz6Nwsfal9DabB+lep7IdFnneoXgfq4SggIp/dG4rQHVb+A6PelShDpXY+j0Fl3
			XOUjkj2BImkIR2ytjhapVhxjD8ZExgzGQYzDGM2MVkYfCIAXcewFw6uIRngNMQLeQDTBasRWsB4xCjYhdoAtiLGwHTEBPkLsDp8g
			PgwHEPvCF4hP4F7BB56CEMTZcAHXG5/DTUGDsjuIX4IganCHokQ8BRrEs+CLeB78EH+EAMSfIQjxCoQi/o5908AtiBDp8d0MUSm0
			QNQKrUUtBAjnQAvBQgiiUbiAGCF0wnyTkIDYSuiBJfOxpAYKuNYI1lAkkLZS4XnEMoH02wRqq1KgdqsEsqFGIHseF8i2WkEjquAp
			4RXE2cIS1LyQ232R232F263jdpdzuyuxXS2sE1YiviOsQXxPeBvxA87fzmV2c/m9XPcz1vM56tRDK/EblR6ixIuq5tAEfRgDAxTd
			NTGQzPiQ4kd1DMQr1iO2VyxHbKmYjthU0QUxSNEBsYlCjahQ3FbFQAlryFOkYt3hipGaZGiPOUWsWSHmIZaIVGYZ07sYkxWUc0pJ
			ZU4zfsMIKkKB0cTYnLEvYyJjEWMtYx3jUsbTUl0112JMZAQNa2Psy1ir5bqM2xkTfQjNjLWMUxnrGJcybmfcwXiK8TQj+HK7jCbG
			5ox9GRMZixjNjLWMdYzbGU8xQhPWwNiXsYixlnF7E/YYI+gI++q4DGMt43bGU4zgx9oY+zIWMdYy1jFuZzzFCHouz9iXsYixlrGO
			cSnjdj21voPpU0yfZhr8iRb8WQ/TzZnuy3Qi00VMm5meyviE/3DSz/RSxu2MOxhPMZ5mPBtIJXcbCFOCCc8yPhFC2CqUpYylYYRK
			I+FyxpRwLs/4xANcvimXZyyN4PKRXJ4x5UEuz/hEMy5v4vKMpc0JI/EetwsbhJ3CQPFd8Zg4UDFFsUqxTyEoWyjjlSOVq5WfKY2q
			StVeHJcC+PEnNyNUsYzdkRPw2SyCP+6YDDwzBuBzOgia8mceC7VzEJsb0wUXHa/MRHoo45WgX+mz6mDCHgbCbaGU/0+mbzPeEDOx
			wREKwnDGiYyeddcEzRZddZeH/tpAA+EIBWE440TG5UrCo3pCre5XQQvd+Re0PRApZpUC55kUXH8EQCoi7ghwjyTi3K7BHkcjitCO
			f4XXHlHE2Z680xFRhEz2Uhb6RIRsoM/BctAj9Hu9IKQH0eiCXEQR8iAM6XxEEQaj3+i3eeFID+XfpxYwPoJXSMTVDeFwaIY5IxBF
			KMbVj4izVkvEUmiNOBJtFGAUoghlaKMAVkQRRqONuFthLEcbcWXIWAGdMMeOKEIlxCH9GKIIDvp+AzgRRaiCLkhXI4owCbohTmYP
			TYGHEH3RD75oiQbO+b3i9wiolJXKhcp2qofw6esPoUoBn2CBoNJSGgRJYZSGwHBOw+A7BaXhcJfTphDA5SJhHtdrBp9zfnPI0lHa
			EuL9KW0NwzltC9M4jYbVnLaH1SpKO8I0TjvBIk7joJzTeHjfh9IucJjTbnDdSGkPmM78Q7AB200R/i5cNIqYLhVWh1O6TJgfrgBl
			La1O/T1C4QUZvY/aFmARf4zpnbdK76YBjtPO+VGJ3om0dqX0/aXmKoCt6+TvP6lo7SvymKMRp8YXjTYtiDzS/GGu4A+fCpBtGWl2
			WKudMRw3LUYOnJbPcbKcMQXFdoqVBQ8nSyHSehcXFiYUxkIGhWGyOCj0SVFcPVdldyBHsU4wGWNxVFhs8Z0hxVpCv3Q0O8YXdf6T
			5lKqzba8MnvJmAR4OMteWm2z9IZESIL0ZPCI7FCYm5qVMyQxszAtMSMzNcVLlDQ4rzAxOTk1L68xaXJiZmZSYvKAwsTM3NTElGGo
			KT0jLz81955yLnFyTnZ2anJ+Y238YQk5zMLg7IzsjPyMxMyMR+5nSHZOfmFazuDshi00LsnOyU4F71gOwwamNqg8JDU3LyMnuzAr
			Iy8rMT+5HxTnO6wUcyazMTupqYGZg9PTU1MKM7JhoFSkgIKkoSgjLSM5MR+1uQQpeQne+VJsnJiMHCBRZkZ6v/ykROxkTmZOrmd7
			9VZ45WKTeDEzUmRr7uluYVpuamphXmZOPivPTR2Yk5sPBYPzklx0cX5ZdXlxZgE4XYSUk+vKQYKCvmVaRlYxj/neLElzraPKPMWe
			vNzCMFcLw1wtuHKQ8GphmHcLw+5pYdg9LQyDsWZbtaWwEJLtzqpqhxnKnSV2h81aDPU6wF3c5e9ku81m4XvLGZNuqbA4rCV/KUzh
			/eLs3Ru+UKJJMsRSUWp3ZJSy3fXMWBdBRQY68H4tqZLLuLnKeirPUpUy0FwKuRQHqdRmy7dn2pHKt1eXlFUikdhIlEXJcZZSsDoT
			G4046BmKkGO7UZwxpOWJa6jVgYx7WpF4EuZUWCSmRHJ5jCutLC1GurzSYXE6GxGj4Z5icnGaxVJabC4Zk2spsVjHYqYUBrFh/p8H
			YWw0WGKjMRhdERQfdo/j3mMKC5OwPWvFqDSrxYYyj0HcUOgenn9UsRGhawA0lNRf9kY0WhrJzDZXoWOk2G8NpUl4TzTMTXdYLBWN
			9aY0G821OO7TUWniuV9P7yfNJGmx2YG3mr0xMV2LLHtVY7I8Cvt2H1lSdVUV3rWNVKq0lFjNtvvKpedlg/xyS1WZHW+AUhRaq8bn
			WkZaHJaKEgs47dUOTNKrraUWoLBl+FS14CwjjV+cOZi/X9xTzinHguZRUiWzw5JaU1JmrkCebuM0h708xeock0w3IFRU22wSlVpR
			KkUygCTLKGuFTGdg0Uo7x0uDZKujBBNqxXMQ8OThlTHUbK2SSbxK2DISNG9QZ2jKkMIk5OJSAbKqqyw1HrykvNwCtsrUGlyUsLts
			Fjkr2zLOgxtoripjMt1SxWl9jIVEOWYC547EGhVMYF+ZIPtwLiH3FFsxzbYjDLXYbAPoTIA8a2k+xVQdQvM7U5J9cnDJ/EbjrXIU
			VrItrwwdDnmPVVNSUm2j0HYgOdFy/4Cm94sVm4UKrBQGMsVis4yiHJyRvQZcXpWc68k6GVM4/BTkVFoqhjqsVdJwQBMd/OAxk5+q
			qhzW4mouS/Ht6DK781xezLdWeWZLCz+OADnO7hjjFqTWVFkqaIA2VEGekcN4NBRSqAtHOYd8NdvuWypZDqfI5RqKUyzOEoe10luY
			ZjOPcrpZqf+sINdiM9cw5WyoS54SG7OhcryDphe3aKAZHZFIUfEaK463X4WHIFcKxsj5VdZiqw1vfLc0r7qSb/HBFeXmCrx9S5Px
			Rs+TY4O4iyWNr5LuE5proVQaWqU8WvF2G483g0Tz+gSKCeiJ5zIq1+K028bSXNAw7q8cC5jIPOsEt0Vp1gqOiehaxUihE/HedGXI
			HYuRrx5JkqWxn2+XflWCuoqdEiWZTJS0PuDrgj3rZ3aWQRkBqqxMMjstdIcDGUwzIt3M+XbOwj7mYxGmpUUcn8GBU5hzqBWJPIp5
			KpHZdgdl2KsRaf7Fi4OLKwr3SI958Ao4XJ9b4iLqp8dMCoVaLN95rl67rk3MQOxXibUSJa4dFEfS9N44ecS3lhcmWIzdX9JA0jWh
			geTeNr0mJZoAvDNoqkfPW8zlPPXKZFL1SHrMuFj0Y5YcZMflZVnCU5lEplhG4j3j4rJwiDjGy4xTSthUvhAZaCI/D5iQTAa6rom2
			UXY0u6wcaN8J6GmcG1FrcpmlZIyzWqrNywQYxZhYWZliLzdbK1gix/eUc5L5aVY/3UCavXS8PPLc+5oYjyfmfxab+i/GAP/rIaz/
			KFo4hbKlIKkefUi32YvptvPKdN1pebh1aCjESyXtLqQVPd5lzAwhK/iGN9vSzFbPyK2SLKnaKQ2fRqWu+yLRRrc9ziBSBxqUk+Xy
			+w4NxNKDY3CFO7jt/RrKtlel2asrGrGyoSTRMaqa4ubmVFfljMyVBsa9teTBkWV14mOmpKxRu1DzQBvFeMVlkLuAFbviuKc8Lo3Q
			+lKp2j2ybHsaDt88m91DQGFncf7xMLkYF0e45ijl1Y87X5oppUWb1YkZxfxMhxRclQA9e/Lt8t3AUys9N8FrHHBOCm6RSnAJy89V
			oPivMLhSnibl9TbY6qkKKXE9HWiuQDavX2JcsmN8ZZUd9VNsbXwk4s6FJGxjUrXVRhwt03GXVs0ML8vrOSfuODCp32NLy3X3Jlvm
			iz0Z95bbo7RXRrEX55oMpUX0SCtmyZvIe/dxHPtbDljtsbf8w2Lyk9IrT1Yvz7LeyjwyUzlgMffdczeC0zuhx3tvNAV7cDElEnKS
			hQ9SSllN/a4FbG6SH9T1exZwuslyRtxdD6xywEAn2KzFTtcskWI1j6rA54y1xHnvrOJaIcpX3Vm/Y0jFUVJayuHQ+THhlFeMOBZo
			O+KkfshjyIocb+txzTDQYbHhiKpf0UjRlqmEw+Op7gTn+PJiu02izR6Ld6eHe+mNCF7ZOF1XIbHGqwCz5BJe9oHnJkDKKR0npX80
			RnA6cf7ZAOEynqODM8wE9BzGfQuYCVJxF2BzQon8jKtvONdSiauS+ueXZ3sNRA3fN8IFvZQ2/r5s/XRS35y8M/VoxZXDq0iZdnrQ
			7pLem1tpwHlnORtm3btHcbr3J04Y5yKK5ZSWGtLDB5Idduf9+iW/3yztGHkWQAfTFhGr2SvwKUpLBpxz0ngvAdKWAnKKR9MpIXYp
			SfY6NMR1hEjKvaeJeBwvwiZITYP0FAfp/USctcA11zHjerOWaX6DkWysLyNxrvdSmUmleO0ZvB6VTxlwSAm9yzbO4qDnDG2fqxr3
			iPQokMjGVppQ4lFMWj9JC2PvYdhg8OHFqiiVSYeUpOIOVFpJW4ji1TRTQy0uwTiLS8BUpXTjx3fmoyBkrmsCc1m4x8i21FTV7yaY
			5qUkP/4q6PwrnCqllErTEElt5EAU6ZwU+SAuHhggB4a3lCaNp2UhXfIqXDM6B1jGN1hCS0+4UQ5zZdl41/3smjV45nO9BVGfSbO1
			FAbSI5OemXIYefmkifpHML+BarO5eXtlYUaFheYFNOBeg6SxXc9lOLNx+5HjSC2vrKLYn+BjhhqwgpM/kJoIsTAJYmAixGEKqnjo
			jNgVErBcDJSCjX7jr7FgDQtAGH3LQYp56+DYtBRptBQgnnKdHKeUIn925aihYzkuqgVLl3DEUwtHiK3XOagHpEAythqH5eOQSoNU
			rNcdX7EQjzmJmB+LL0pTEeP5F9BJaF88R+JNxFyKT9oF9cRh7XutiOe4pX9mRTzH9U3i+L5kSyxqjUfdCfivG+aTjV3xlcStU3tU
			tju+UqAH0l2RjsM6pCMOX/Tpv6cV0MublzzoyUuW3Mezf1q7EksV36+2IgYg8N4a4EfXvCcUoH8mUTgGbN2OOijC7AiOmOsuLY0O
			yMhHz1HcWTvmUwzdcSizcmRXipRr4vivFB2Xxgn5uZrjyI7l2LNmzCmRrYLEJLxSXdmbnfHVHdtLRm8no8/T0J9x6FVpHBBFHu2B
			NHmfpJ3pSDp/bwsBxo0qrjmpfivx9cJbnW/mNbGB9t0JI4aEJ5yaRV8jFNVGhQkEJUd9UItKjRCowwyj0iQIohIEIQJLGYkwqgBl
			RjWIiEYNKCgxaqXUYHIRrVQgCkYN1tC4hIEBLiIYs31YkZF0ikZFFBhFtY9CHaijz3VNZMcpOg35lFJBoCRQEagJNARaAh+CAAI6
			tktpQBDVGlGtEtVq1GbkT4lJEahMohBh1JpUgtGoUql0Jo2hNVOG6AgV9tLQ2keWBUb4uYSBEShVqA1aLqFVmoAAnYC+0RChUUZh
			FpqvwVKt8BWrMSmwpEaj1SgCgwN1gcFctRRZQyz904Jo6Ej/dAGC4kEIeBDon9JXMMRyyVg1GWoY6GtSGlpjKhlgwld3UhmAKgO4
			YD9S2Z3+UeXunNddqvywXPlhrKxGe7CXaLAKzVShU/qKAogi4GUV0ZgAEE0g9gWxlr5kIpIE/RUggkmEviLUimot1kmh6wB0HYCu
			A1DfSaeaCDUqVqM1kYF9tfgfL7yhH9GAnuiHzZEJ+gi9zKfghTHYNGyWwUYutZETbdhKvgjUWIGAgw7TEfgqousMdMWBrj1wM/la
			/E/NlBJNakuxroZzAou4SIEW/8tFCuQiBaJMjFCR2Xocw3p9ZAT5zJUYMrRkrCEjMkKDvGFQ4GBRHaFRhxiGiXpRVOtlUq/G9G+C
			Hl2gx3GsN5h9NcpIg0VrsBis6CVDucoEyFP3rHiTYI3Ax4gxU7wSLKPSKPR6PQ1+NAPJCLrBtCqyiBQaLHrsDiKVFCNVWvIXJpRq
			KfWhvtXOwP8BGhUqJHKWoXYOEtQ8NkyaTVRG72PisoG1C6jbvmQB5io06AGpM1qTKAZBQJCgwzZrZ0iZepwEIuka+2oACcz316j1
			)"
			wrapperbase64 .= "
			( LTrim Join
			THB7aAVZGKmKVHGfUAIKg0WqLKHB6qNRGqwGS4TBIrsQhyk2Rb4NgiABnRRY+yrriTDULlaxT2kkBwFb+Tp5SEBLyOPkJrTKJOi1
			aBXekqJeq0U5tqbxMdSuMtSuMdSuJwM3om0qvR9OI/rA2s2BtVsDa3eo6f6onaExSX0hT6Azsbsb9RFqvkCky6gPxE6GGGr3oVo9
			e3UVWl67X0AvAuejaZIcLyfSJiEIs/DCsYnYxCoaFHhb4TCSKsruRL2G2iOG2qOG2hOinq90BE1KIl+fwNpvDbWndTR51H4fWPtT
			YO0vksVHpeQEFhW1Iv3yS++lV4u+YbfhaNYGaLU4jPRcZarg27k+KrmewpR3rWe1gvy7/Qcp3Eu+GDoUl2XZdvdbMXwalFMgRYFT
			A7XS0QUAWQJExGSn5td/HtHBFS58bEJMl5jOqEsfXC+kD2JsZt4SBlMtU73ExKVNAjRNslSMppWoqd+uTaNsuNCzODrmVVlsE+j8
			I50AGnm9CdBTgC71HwmYdq4y1Vdt4VqQt/DQYuocG9etI0J3gAECpGVJe2KTx5rdZJPWkSbcvpistIk286bPNM5aVWbCRbdU2JRU
			7TSlOHBD6oiRbIqLiesSE9cVH1TYgz9QDBAuQHCj2wXpu0pfhB+llJxbSN/0SxBgRKjHwQ4AXoeCbkEZnZvbO2j3IWXMjORtN5qX
			v3nn1BiqkdxzRKXDThsv5wheunessFR5HpI7ArdlrmN0RzT6Zjmfons2wd3+HaJN0OjfzwmedhYm2x249M6iN4z5qxkWi3S8Ff7d
			bQ2mvo0r+f/iT+BraLzPOSGxjeTTXz98FfQVoNTji26lyv/aOR/+rCugPnWf8+GK5+X++++eWQCwTrn7L5wVUiefFeL65zorZAXH
			cJLOCimX9x8UHC2L2zPz7oTOcrj3nAippEk+LcJ1doN7rW2tP3HDzOc3uM5/GMcr8zKkCC1emunUC1qbm9ArDnmF7gD+6er/2Jkm
			ufx91T8/0yQbJSO5l1a2MeY+HgEeW1r483NKujB2ZRvou7H3P6Pkr7Zdv2/Ev9l4hf+T80dWNXr2SIsGNrRo1MPuE0g6yhTF6X+E
			+/fnZ5H8J/0sgAj4ozNK/rNxDOg9bQO9jZ9B4r6ODwPFFkqUd7jlqM/G98Qf13OdXvJ/f//tv1iB40AGdPnfNuT//v43/v4fAAAA
			AAAAQlNKQgEAAQAAAAAADAAAAHY0LjAuMzAzMTkAAAAABQBsAAAAGAkAACN+AACECQAAcAsAACNTdHJpbmdzAAAAAPQUAADwAAAA
			I1VTAOQVAAAQAAAAI0dVSUQAAAD0FQAApAQAACNCbG9iAAAAAAAAAAIAAApXHaIJCQMAAAD6ATMAFsQAAQAAAEcAAAAIAAAAFwAA
			AB0AAAAeAAAAZQAAAAIAAAAYAAAACQAAAAEAAAABAAAAAQAAAAoAAAABAAAABQAAAAEAAAACAAAAAABBBQEAAAAAAAYAXwqtBQoA
			vwqQCgYA3wJWCAYAHAMkCAYAcAIkCAoAeAc6CgoA2Qp+AA4AzgJWCAoAbgqQCgoAzQl+AAoADwp+AAoA9gh+AAoA1Qh+AAoAIQp+
			AAoAKwc6CgYAOwKtBQYA3QGtBRIAkQbZBhIAIQnZBhIAAAfZBg4A+AZWCBIAOQnZBg4AMQLoCQYAOwDfAA4ASQBWCAYAaACtBQ4A
			vwJWCAYAdwCtBQoAbAl+AAoAwwd+AAYAegStBQYA3AStBQYAqwCtBQoAZgc6CgoAywoHAAoAtQkHAAoAAAoHAAoA6ggHAAoABwc6
			CgoASwkHAAYAWwDfAAYAhQYnBgYASgs8BgYAGwI8BgYAvgWtBQYAZQatBQYAlgXEABYAggXmBQYAkAXEABYApwHmBQYA0QGtBQYA
			3geoBAYAkAmtBQYADwk8BgYAIwGoBAYAUgetBQYA7wNWCAYAXARWCAYACAMkCO8AkAgAAAYASwM8BgYA0gM8BgYAswM8BgYAQwQ8
			BgYADwQ8BgYAKAQ8BgYAYgM8BgYANwM3CAYA+gI3CAYAlgM8BgYAfQO5BAAAAAC7AAAAAAABAAEAgQEQAMQKmQcFAAEAAgABABAA
			pwCZBwUAAgAEAIMBEABvAAAABQAIAA0AAQAQAAEAmQcFAAsADQCDARAAtAAAAAUADgAUAIABEADDBs4ABQARABQAAAAAAP0KAAAF
			ABYAHgAxAIMBFwAhAI0HPQAhAPUKQQABABAFRQABAPUHSAABABQISAABAKwHSwAWAC0AfwEWADQAjgEWAFQAnAEhAI0HrQEhAPUK
			sgEBABAFRQAWAC0AfwEWADQAjgEWAFQAEQIxADMFRQAxAMABIgIxAMcIKwIxALsIKwIRABgBNAJTgNoFSwBTgM4ASwBQIAAAAACR
			GNcHEwABAFcgAAAAAJYIuwozAAEAXiAAAAAAkRjXBxMAAQBqIAAAAACGGNEHGwABAKggAAAAAIYAKwVYAAEAvyAAAAAAhgCdAmUA
			AQDQIAAAAACGAKwCdQADAOEgAAAAAIYAYwKEAAUA8SAAAAAAhgCHApMABgACIQAAAACGAOoKGwAIABchAAAAAIYA/gSsAAgAPCEA
			AAAAgQBwAXgBCQABIwAAAACGGNEHGwALADQjAAAAAIYAKwVYAAsASyMAAAAAhgCdAsIBCwBcIwAAAACGAKwC1QENAG0jAAAAAIYA
			6gobAA8AgiMAAAAAhgD+BKwADwCkIwAAAACBAHABCQIQAOAkAAAAAJEA0wQ3AhIA9CQAAAAAkQApC24CEwBcJQAAAACRAHoGjQIU
			AJAlAAAAAJEAXQXKAhYAFCYAAAAAkQBdBeICFwA0JgAAAACRAFIF+QIZAFwmAAAAAJEAdggwAxoAHCcAAAAAlgAZC3oDHQDcJwAA
			AACRGNcHEwAfACsoAAAAAJYA4wQTAB8AAAABAHYGAAACALkCAAABAKkJAAACALkCAAABAE4GAAABAHYGAAACALkCAAABACIFAAAB
			ANIGAAACAKYEAAABAHYGAAACALkCAAABAKkJAAACALkCAAABACIFAAABANIGAAACAKYEAAABAEwCAAABACwCAAABAKABAAACAPwF
			AAABACgCAAABAK0IAAACACwCAAABAJ0FAAABAMcIAAACALsIAAADABICAAABANIGAAACAKYEGQDRBxsAIQDRByQAEQDRBxsAQQDR
			BxsACQDRBxsAMQDRB04AOQDRBxsASQBmChsAUQCdAlwAUQChCWwAUQD6AHwAUQCHAooAMQDqCpoAeQDRB6AAMQBbAaYAgQDvAbcA
			kQBcAr4AoQAIBsYADABcAuQADABzCu8AoQAXBsYAFABcAuQAFABzCu8AHADKAQsBJADKAR8B6QC/BygB8QAQAS0B8QC0BS0B8QB/
			BC0BAQFYCjEB6QDmBy0B6QAFCC0BAQFTCzkBoQDKAT8BLABcAuQALABzCu8ANADKAWoBEQHRB04AGQHRBxsAIQGdArcBIQGhCcoB
			EQHqCtsBOQHRB6AAEQFbAeIBPABcAuQAPABzCu8AQQHmBy0BQQEFCC0BQQG1Bi0BRADKAWoBUQEBAlgAaQHIBUwCaQGfCFICWQEK
			AlkCYQEBAlgAAQGuCV8CYQGBBmgCeQHIAn0CeQECAYUCWQE+C6kCAQH1BK8CWQFoBbQCgQHRB7sCiQHRBxsAeQFYBsUCmQFUAhsA
			TACIBNkCeQHqBPUCAQF/ClgAAQFfCxIDAQFYChcDWQEHAR4DWQEHASgDoQGmB1QDqQEBAlgAVAANC2EDoQF6ClQDYQHRB2cDVACk
			BWwDYQEFCXQDWQEHAW4CVADRBxsATADRBxsATAAMAWwDuQG3AYQDwQHRB6AAaQGUBIsDyQHRB6wD0QHRBxsA2QHRB9kD6QHRB2cD
			8QHRB2cD+QHRB2cDAQLRB2cDCQLRB2cDEQLRB2cDGQLRB2cDIQLRBxkEKQLRB2cDMQLRB2cDOQLRB2cDDgBYAJIDDgBcAJ0DIQAL
			AB8AIQATACoALgAbAx4ELgATA/sDLgALA/sDLgADAwEELgD7AukDLgDzAvsDLgDrAvsDLgDjAvsDLgDbAukDLgDTAuADLgDLAroD
			LgDDArEDLgAjA0gELgArA1UEQAALAB8AgQAjAB8AgwALAB8AwwALAB8A4wALAB8ABAEjAB8AoQEjAB8A5AEjAB8AVACxAOkBPgJ3
			ApcC8AIBA0cDAgABAAAAvwo4AAIAAgADANcA8wABARYBTgFeAe0B/QHRAlkDBIAAAAEAAAAAAAAAAAAAAAAAmQcAAAQAAAAAAAAA
			AAAAAAEA1gAAAAAAAQAPABAAAAAAAAAAAACmCgAAAAAEAAAAAAAAAAAAAAABAEACAAAAAAQAAAAAAAAAAAAAAAoApAYAAAAABAAA
			AAAAAAAAAAAAAQCtBQAAAAAAAAAAAgAAAC8BAAAEAAMABgAFAAAAAFhiMzYwAE5lZmFyaXVzLlZpR0VtLkNsaWVudC5UYXJnZXRz
			Llhib3gzNjAAPD5wX18wADw+cF9fMQBJRW51bWVyYWJsZWAxAENhbGxTaXRlYDEAPD5wX18yAERpY3Rpb25hcnlgMgBGdW5jYDMA
			PD5vX18xNABGdW5jYDQATmVmYXJpdXMuVmlHRW0uQ2xpZW50LlRhcmdldHMuRHVhbFNob2NrNABEczQAQWN0aW9uYDUAPD5vX185
			ADxNb2R1bGU+AFN5c3RlbS5JTwBDb3N0dXJhAG1zY29ybGliAFN5c3RlbS5Db2xsZWN0aW9ucy5HZW5lcmljAFNldERQYWQAUmVh
			ZABMb2FkAEFkZABnZXRfUmVkAGlzQXR0YWNoZWQASW50ZXJsb2NrZWQAY29zdHVyYS5uZWZhcml1cy52aWdlbWNsaWVudC5kbGwu
			Y29tcHJlc3NlZABhZGRfRmVlZGJhY2tSZWNlaXZlZABPbkZlZWRiYWNrUmVjZWl2ZWQAPFZpR0VtQ2xpZW50PmtfX0JhY2tpbmdG
			aWVsZABzb3VyY2UAQ29tcHJlc3Npb25Nb2RlAEV4Y2hhbmdlAG51bGxDYWNoZQBJbnZva2UASURpc3Bvc2FibGUAUnVudGltZVR5
			cGVIYW5kbGUAR2V0VHlwZUZyb21IYW5kbGUAZ2V0X05hbWUAR2V0TmFtZQByZXF1ZXN0ZWRBc3NlbWJseU5hbWUAZnVsbG5hbWUA
			RXhwcmVzc2lvblR5cGUAU3lzdGVtLkNvcmUAY3VsdHVyZQBEaXNwb3NlAENyZWF0ZQBTZXREcGFkU3RhdGUARGVidWdnZXJCcm93
			c2FibGVTdGF0ZQBTZXRTcGVjaWFsQnV0dG9uU3RhdGUAU2V0QnV0dG9uU3RhdGUAU2V0QXhpc1N0YXRlAHN0YXRlAENhbGxTaXRl
			AFdyaXRlAER5bmFtaWNBdHRyaWJ1dGUAQ29tcGlsZXJHZW5lcmF0ZWRBdHRyaWJ1dGUAR3VpZEF0dHJpYnV0ZQBEZWJ1Z2dhYmxl
			QXR0cmlidXRlAERlYnVnZ2VyQnJvd3NhYmxlQXR0cmlidXRlAENvbVZpc2libGVBdHRyaWJ1dGUAQXNzZW1ibHlUaXRsZUF0dHJp
			YnV0ZQBBc3NlbWJseVRyYWRlbWFya0F0dHJpYnV0ZQBUYXJnZXRGcmFtZXdvcmtBdHRyaWJ1dGUAQXNzZW1ibHlGaWxlVmVyc2lv
			bkF0dHJpYnV0ZQBBc3NlbWJseUNvbmZpZ3VyYXRpb25BdHRyaWJ1dGUAQXNzZW1ibHlEZXNjcmlwdGlvbkF0dHJpYnV0ZQBDb21w
			aWxhdGlvblJlbGF4YXRpb25zQXR0cmlidXRlAEFzc2VtYmx5UHJvZHVjdEF0dHJpYnV0ZQBBc3NlbWJseUNvcHlyaWdodEF0dHJp
			YnV0ZQBBc3NlbWJseUNvbXBhbnlBdHRyaWJ1dGUAUnVudGltZUNvbXBhdGliaWxpdHlBdHRyaWJ1dGUAQnl0ZQBnZXRfQmx1ZQBU
			cnlHZXRWYWx1ZQBhZGRfQXNzZW1ibHlSZXNvbHZlAFN5c3RlbS5UaHJlYWRpbmcAU3lzdGVtLlJ1bnRpbWUuVmVyc2lvbmluZwBD
			dWx0dXJlVG9TdHJpbmcAQXR0YWNoAGdldF9MZW5ndGgARW5kc1dpdGgAU3Vic2NyaWJlRmVlZGJhY2sAX2ZlZWRiYWNrQ2FsbGJh
			Y2sAY2FsbGJhY2sAT2tDaGVjawBudWxsQ2FjaGVMb2NrAFZpR0VtV3JhcHBlci5kbGwAUmVhZFN0cmVhbQBMb2FkU3RyZWFtAEdl
			dE1hbmlmZXN0UmVzb3VyY2VTdHJlYW0ARGVmbGF0ZVN0cmVhbQBNZW1vcnlTdHJlYW0Ac3RyZWFtAHNldF9JdGVtAFN5c3RlbQBn
			ZXRfR3JlZW4AQXBwRG9tYWluAGdldF9DdXJyZW50RG9tYWluAEZvZHlWZXJzaW9uAFN5c3RlbS5JTy5Db21wcmVzc2lvbgBkZXN0
			aW5hdGlvbgBVbmFyeU9wZXJhdGlvbgBCaW5hcnlPcGVyYXRpb24AU3lzdGVtLkdsb2JhbGl6YXRpb24AU3lzdGVtLlJlZmxlY3Rp
			b24AZGlyZWN0aW9uAHNldF9Qb3NpdGlvbgBTdHJpbmdDb21wYXJpc29uAGJ0bgBDb3B5VG8AZ2V0X0N1bHR1cmVJbmZvAENTaGFy
			cEFyZ3VtZW50SW5mbwBNaWNyb3NvZnQuQ1NoYXJwAGdldF9MZWROdW1iZXIAQXNzZW1ibHlMb2FkZXIAc2VuZGVyAE1pY3Jvc29m
			dC5DU2hhcnAuUnVudGltZUJpbmRlcgBDYWxsU2l0ZUJpbmRlcgBYYm94MzYwRmVlZGJhY2tSZWNlaXZlZEV2ZW50SGFuZGxlcgBE
			dWFsU2hvY2s0RmVlZGJhY2tSZWNlaXZlZEV2ZW50SGFuZGxlcgBSZXNvbHZlRXZlbnRIYW5kbGVyAFhib3gzNjBDb250cm9sbGVy
			AER1YWxTaG9jazRDb250cm9sbGVyAF9jb250cm9sbGVyAFZpR0VtV3JhcHBlcgBFbnRlcgBfbGFzdExpZ2h0QmFyQ29sb3IAZ2V0
			X0xpZ2h0YmFyQ29sb3IALmN0b3IALmNjdG9yAE1vbml0b3IAZ2V0X0xhcmdlTW90b3IAX2xhc3RMYXJnZU1vdG9yAGdldF9TbWFs
			bE1vdG9yAF9sYXN0U21hbGxNb3RvcgBTeXN0ZW0uRGlhZ25vc3RpY3MAU3lzdGVtLlJ1bnRpbWUuSW50ZXJvcFNlcnZpY2VzAFN5
			c3RlbS5SdW50aW1lLkNvbXBpbGVyU2VydmljZXMAUmVhZEZyb21FbWJlZGRlZFJlc291cmNlcwBEZWJ1Z2dpbmdNb2RlcwBHZXRB
			c3NlbWJsaWVzAHJlc291cmNlTmFtZXMAc3ltYm9sTmFtZXMAYXNzZW1ibHlOYW1lcwBEdWFsU2hvY2s0RFBhZFZhbHVlcwBYYm94
			MzYwQXhlcwBEdWFsU2hvY2s0QXhlcwBnZXRfRmxhZ3MAQXNzZW1ibHlOYW1lRmxhZ3MAQ1NoYXJwQXJndW1lbnRJbmZvRmxhZ3MA
			Q1NoYXJwQmluZGVyRmxhZ3MAWGJveDM2MEZlZWRiYWNrUmVjZWl2ZWRFdmVudEFyZ3MARHVhbFNob2NrNEZlZWRiYWNrUmVjZWl2
			ZWRFdmVudEFyZ3MAUmVzb2x2ZUV2ZW50QXJncwBTZXRBeGlzAGF4aXMARXF1YWxzAFhib3gzNjBSZXBvcnRFeHRlbnNpb25zAER1
			YWxTaG9jazRSZXBvcnRFeHRlbnNpb25zAFN5c3RlbS5MaW5xLkV4cHJlc3Npb25zAFhib3gzNjBCdXR0b25zAER1YWxTaG9jazRC
			dXR0b25zAER1YWxTaG9jazRTcGVjaWFsQnV0dG9ucwBOZWZhcml1cy5WaUdFbS5DbGllbnQuVGFyZ2V0cwBGb3JtYXQAT2JqZWN0
			AENvbm5lY3QAVmlHRW1UYXJnZXQARXhpdABUb0xvd2VySW52YXJpYW50AE5lZmFyaXVzLlZpR0VtLkNsaWVudABOZWZhcml1cy5W
			aUdFbUNsaWVudABnZXRfVmlHRW1DbGllbnQAWGJveDM2MFJlcG9ydABEdWFsU2hvY2s0UmVwb3J0AFNlbmRSZXBvcnQAX3JlcG9y
			dABQcm9jZXNzZWRCeUZvZHkAQ29udGFpbnNLZXkAUmVzb2x2ZUFzc2VtYmx5AFJlYWRFeGlzdGluZ0Fzc2VtYmx5AEdldEV4ZWN1
			dGluZ0Fzc2VtYmx5AG9wX0VxdWFsaXR5AElzTnVsbE9yRW1wdHkAAAAAABEwAHgAMAAwADAAMAAwADAAAAVPAEsAACkwAHgAewAw
			ADoAWAAyAH0AewAxADoAWAAyAH0AewAyADoAWAAyAH0AAAEAFy4AYwBvAG0AcAByAGUAcwBzAGUAZAAAD3sAMAB9AC4AewAxAH0A
			ACluAGUAZgBhAHIAaQB1AHMALgB2AGkAZwBlAG0AYwBsAGkAZQBuAHQAAFdjAG8AcwB0AHUAcgBhAC4AbgBlAGYAYQByAGkAdQBz
			AC4AdgBpAGcAZQBtAGMAbABpAGUAbgB0AC4AZABsAGwALgBjAG8AbQBwAHIAZQBzAHMAZQBkAAAAZQajJ5Nh2E2MqbftB5+FjwAI
			t3pcVhk04IkIsD9ffxHVCjoDAAABAwYSCQMgAAEEAQAAAAUgAQERFQgBAAAAAAAAAAQAABIJBAgAEgkDBhIZAwYSHQIGHAIGBQIG
			DgUgAQESCQMHAQ4DIAAOCAADARIdES0CBiACAREtAggAAwESHRExBQYgAgERMQUHAAIBEh0RNQUgAQERNQgAAwESHRE5AgYgAgER
			OQIFIAEBEh0FIAIBHBgFIAEBEj0EIAEBHAUHAw4CAgYAARJBEUUHAAISSRFNDhAABBJVEVkRXRJBFRJhARJJDBUSZQEVEmkDEm0c
			AgoAARUSZQETABJVAwYTAA0VEmUBFRJxBBJtHBwcCRUScQQSbRwcHAogAxMDEwATARMCCBUSaQMSbRwCCCACEwITABMBBCAAEnkD
			IAAFBwAEDg4cHBwFAAICDg4OAAMSVRFZEkEVEmEBEkkPFRJlARUSgIUFEm0cBQUOCxUSgIUFEm0cBQUODSAFARMAEwETAhMDEwQG
			IAIBHBJ1DgYVEmUBFRJxBBJtHBwcDQYVEmUBFRJpAxJtHAIQBhUSZQEVEoCFBRJtHAUFDgQGEoCJBAYSgI0KAAMBEoCNEYCVAgcg
			AgERgJUCCgADARKAjRGAmQYFIAIBBwYGIAEBEoCNBiABARKAnQMHAQIPFRJlARUSgIUFEm0cBQUFCxUSgIUFEm0cBQUFByACARwS
			gKEQBhUSZQEVEoCFBRJtHAUFBQgGFRKApQIOAggGFRKApQIODgIGCAYAAQ4SgKkNBwQdEoCtCBKArRKAsQUAABKAtQYgAB0SgK0F
			IAASgLEIAAMCDg4RgLkFIAASgKkIAAESgK0SgLEFBwIdBQgHIAMBHQUICAcgAwgdBQgICQACARKAvRKAvREHBRKArRKAvRKAwRKA
			xRKAvQUAABKArQQgAQIOBiABEoC9DgkgAgESgL0RgMkEIAEBCgYAARKAvQ4HFRKApQIODgggAgITABATAQ0AAhKAvRUSgKUCDg4O
			BAcBHQUDIAAKBwABHQUSgL0QBwYOHQUSgL0SgK0SgL0dBQQAAQIOBgADDg4cHAkAAhKArR0FHQUHAAESgK0dBRYAAxKArRUSgKUC
			Dg4VEoClAg4OEoCxDAcEEoCxEoCtHBKArQQAAQEcBxUSgKUCDgIFIAECEwAEIAEBDgcgAgETABMBBSAAEYDZCQACEoCtHBKA1QYA
			AggQCAgGIAEBEoDhCjIALgAyAC4AMAAOMQAuADYALgAyAC4AMAAEIAEBCAgBAAgAAAAAAB4BAAEAVAIWV3JhcE5vbkV4Y2VwdGlv
			blRocm93cwEGIAEBEYDxCAEABwEAAAAAEQEADFZpR0VtV3JhcHBlcgAABQEAAAAAFwEAEkNvcHlyaWdodCDCqSAgMjAxOQAABCAB
			AQIpAQAkYTMzODhiNTUtZjRlOS00YTNiLTk1ZTAtYmYzNjk0MDQyMWViAAAMAQAHMS4wLjAuMAAATQEAHC5ORVRGcmFtZXdvcmss
			VmVyc2lvbj12NC43LjIBAFQOFEZyYW1ld29ya0Rpc3BsYXlOYW1lFC5ORVQgRnJhbWV3b3JrIDQuNy4yAAAAAAARc+eYAAAAAAIA
			AAB3AAAApMEAAKSjAAAAAAAAAAAAAAAAAAAQAAAAAAAAAAAAAAAbpAAAUlNEU7MY8P9RrIREhdrYVvuH0rwBAAAARDpcRGF0YVxD
			b2RlXEdpdEh1YlxNaW5lXEFISy1WaUdFbS1CdXNcQyNcVmlHRW1XcmFwcGVyXFZpR0VtV3JhcHBlclxvYmpcRGVidWdcVmlHRW1X
			cmFwcGVyLnBkYgAARMIAAAAAAAAAAAAAXsIAAAAgAAAAAAAAAAAAAAAAAAAAAAAAAAAAAFDCAAAAAAAAAAAAAAAAX0NvckRsbE1h
			aW4AbXNjb3JlZS5kbGwAAAAAAP8lACBAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAQAQAAAAGAAAgAAAAAAA
			AAAAAAAAAAAAAQABAAAAMAAAgAAAAAAAAAAAAAAAAAAAAQAAAAAASAAAAFjgAAA8AwAAAAAAAAAAAAA8AzQAAABWAFMAXwBWAEUA
			UgBTAEkATwBOAF8ASQBOAEYATwAAAAAAvQTv/gAAAQAAAAEAAAAAAAAAAQAAAAAAPwAAAAAAAAAEAAAAAgAAAAAAAAAAAAAAAAAA
			AEQAAAABAFYAYQByAEYAaQBsAGUASQBuAGYAbwAAAAAAJAAEAAAAVAByAGEAbgBzAGwAYQB0AGkAbwBuAAAAAAAAALAEnAIAAAEA
			UwB0AHIAaQBuAGcARgBpAGwAZQBJAG4AZgBvAAAAeAIAAAEAMAAwADAAMAAwADQAYgAwAAAAGgABAAEAQwBvAG0AbQBlAG4AdABz
			AAAAAAAAACIAAQABAEMAbwBtAHAAYQBuAHkATgBhAG0AZQAAAAAAAAAAAEIADQABAEYAaQBsAGUARABlAHMAYwByAGkAcAB0AGkA
			bwBuAAAAAABWAGkARwBFAG0AVwByAGEAcABwAGUAcgAAAAAAMAAIAAEARgBpAGwAZQBWAGUAcgBzAGkAbwBuAAAAAAAxAC4AMAAu
			ADAALgAwAAAAQgARAAEASQBuAHQAZQByAG4AYQBsAE4AYQBtAGUAAABWAGkARwBFAG0AVwByAGEAcABwAGUAcgAuAGQAbABsAAAA
			AABIABIAAQBMAGUAZwBhAGwAQwBvAHAAeQByAGkAZwBoAHQAAABDAG8AcAB5AHIAaQBnAGgAdAAgAKkAIAAgADIAMAAxADkAAAAq
			AAEAAQBMAGUAZwBhAGwAVAByAGEAZABlAG0AYQByAGsAcwAAAAAAAAAAAEoAEQABAE8AcgBpAGcAaQBuAGEAbABGAGkAbABlAG4A
			YQBtAGUAAABWAGkARwBFAG0AVwByAGEAcABwAGUAcgAuAGQAbABsAAAAAAA6AA0AAQBQAHIAbwBkAHUAYwB0AE4AYQBtAGUAAAAA
			AFYAaQBHAEUAbQBXAHIAYQBwAHAAZQByAAAAAAA0AAgAAQBQAHIAbwBkAHUAYwB0AFYAZQByAHMAaQBvAG4AAAAxAC4AMAAuADAA
			LgAwAAAAOAAIAAEAQQBzAHMAZQBtAGIAbAB5ACAAVgBlAHIAcwBpAG8AbgAAADEALgAwAC4AMAAuADAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAwAAADAAAAHAyAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
			AAAAAAAAAA==
			)"

			wrapper := Base64Dec( wrapperbase64, jeff )

			Base64Dec( ByRef B64, ByRef Bin ) {  ; By SKAN / 18-Aug-2017
			Local Rqd := 0, BLen := StrLen(B64)                 ; CRYPT_STRING_BASE64 := 0x1
			DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",0x1
					, "UInt",0, "UIntP",Rqd, "Int",0, "Int",0 )
			VarSetCapacity( Bin, 128 ), VarSetCapacity( Bin, 0 ),  VarSetCapacity( Bin, Rqd, 0 )
			DllCall( "Crypt32.dll\CryptStringToBinary", "Str",B64, "UInt",BLen, "UInt",0x1
					, "Ptr",&Bin, "UIntP",Rqd, "Int",0, "Int",0 )
			Return Rqd
			}

			File := FileOpen(A_Temp "\vigemwrapper.dll", "w")
			File.RawWrite(jeff, wrapper)
			File.Close()
		}

	;; .Net framework shit
		; ==========================================================
		;                  .NET Framework Interop
		;      https://autohotkey.com/boards/viewtopic.php?t=4633
		; ==========================================================
		;
		;   Author:     Lexikos
		;   Version:    1.2
		;   Requires:	AutoHotkey_L v1.0.96+
		;   EDITED by Antra, this is not the original - do not reuse expecting that to be the case.
		;
			CLR_LoadLibrary(AssemblyName, AppDomain=0){
				if !AppDomain
					AppDomain := CLR_GetDefaultDomain()
				e := ComObjError(0)
				Loop 1 {
					if assembly := AppDomain.Load_2(AssemblyName)
						break
					static null := ComObject(13,0)
					args := ComObjArray(0xC, 1),  args[0] := AssemblyName
					typeofAssembly := AppDomain.GetType().Assembly.GetType()
					if assembly := typeofAssembly.InvokeMember_3("LoadWithPartialName", 0x158, null, null, args)
						break
					if assembly := typeofAssembly.InvokeMember_3("LoadFrom", 0x158, null, null, args)
						break
				}
				ComObjError(e)
				return assembly
			}

			CLR_CreateObject(Assembly, TypeName, Args*){
				if !(argCount := Args.MaxIndex())
					return Assembly.CreateInstance_2(TypeName, true)
				
				vargs := ComObjArray(0xC, argCount)
				Loop % argCount
					vargs[A_Index-1] := Args[A_Index]
				
				static Array_Empty := ComObjArray(0xC,0), null := ComObject(13,0)
				
				return Assembly.CreateInstance_3(TypeName, true, 0, null, vargs, null, Array_Empty)
			}

			CLR_CompileC#(Code, References="", AppDomain=0, FileName="", CompilerOptions=""){
				return CLR_CompileAssembly(Code, References, "System", "Microsoft.CSharp.CSharpCodeProvider", AppDomain, FileName, CompilerOptions)
			}

			CLR_CompileVB(Code, References="", AppDomain=0, FileName="", CompilerOptions=""){
				return CLR_CompileAssembly(Code, References, "System", "Microsoft.VisualBasic.VBCodeProvider", AppDomain, FileName, CompilerOptions)
			}

			CLR_StartDomain(ByRef AppDomain, BaseDirectory=""){
				static null := ComObject(13,0)
				args := ComObjArray(0xC, 5), args[0] := "", args[2] := BaseDirectory, args[4] := ComObject(0xB,false)
				AppDomain := CLR_GetDefaultDomain().GetType().InvokeMember_3("CreateDomain", 0x158, null, null, args)
				return A_LastError >= 0
			}

			CLR_StopDomain(ByRef AppDomain){	
				DllCall("SetLastError", "uint", hr := DllCall(NumGet(NumGet(0+RtHst:=CLR_Start())+20*A_PtrSize), "ptr", RtHst, "ptr", ComObjValue(AppDomain))), AppDomain := ""
				return hr >= 0
			}

			CLR_Start(Version="") {
				static RtHst := 0
				if RtHst
					return RtHst
				EnvGet SystemRoot, SystemRoot
				if Version =
					Loop % SystemRoot "\Microsoft.NET\Framework" (A_PtrSize=8?"64":"") "\*", 2
						if (FileExist(A_LoopFileFullPath "\mscorlib.dll") && A_LoopFileName > Version)
							Version := A_LoopFileName
				if DllCall("mscoree\CorBindToRuntimeEx", "wstr", Version, "ptr", 0, "uint", 0
				, "ptr", CLR_GUID(CLSID_CorRuntimeHost, "{CB2F6723-AB3A-11D2-9C40-00C04FA30A3E}")
				, "ptr", CLR_GUID(IID_ICorRuntimeHost,  "{CB2F6722-AB3A-11D2-9C40-00C04FA30A3E}")
				, "ptr*", RtHst) >= 0
					DllCall(NumGet(NumGet(RtHst+0)+10*A_PtrSize), "ptr", RtHst) ; Start
				return RtHst
			}

			CLR_GetDefaultDomain(){
				static defaultDomain := 0
				if !defaultDomain
				{
					if DllCall(NumGet(NumGet(0+RtHst:=CLR_Start())+13*A_PtrSize), "ptr", RtHst, "ptr*", p:=0) >= 0
						defaultDomain := ComObject(p), ObjRelease(p)
				}
				return defaultDomain
			}

			CLR_CompileAssembly(Code, References, ProviderAssembly, ProviderType, AppDomain=0, FileName="", CompilerOptions=""){
				if !AppDomain
					AppDomain := CLR_GetDefaultDomain()
				
				if !(asmProvider := CLR_LoadLibrary(ProviderAssembly, AppDomain))
				|| !(codeProvider := asmProvider.CreateInstance(ProviderType))
				|| !(codeCompiler := codeProvider.CreateCompiler())
					return 0

				if !(asmSystem := (ProviderAssembly="System") ? asmProvider : CLR_LoadLibrary("System", AppDomain))
					return 0
				
				StringSplit, Refs, References, |, %A_Space%%A_Tab%
				aRefs := ComObjArray(8, Refs0)
				Loop % Refs0
					aRefs[A_Index-1] := Refs%A_Index%
				
				prms := CLR_CreateObject(asmSystem, "System.CodeDom.Compiler.CompilerParameters", aRefs)
				, prms.OutputAssembly          := FileName
				, prms.GenerateInMemory        := FileName=""
				, prms.GenerateExecutable      := SubStr(FileName,-3)=".exe"
				, prms.CompilerOptions         := CompilerOptions
				, prms.IncludeDebugInformation := true
				
				compilerRes := codeCompiler.CompileAssemblyFromSource(prms, Code)
				
				if error_count := (errors := compilerRes.Errors).Count
				{
					error_text := ""
					Loop % error_count
						error_text .= ((e := errors.Item[A_Index-1]).IsWarning ? "Warning " : "Error ") . e.ErrorNumber " on line " e.Line ": " e.ErrorText "`n`n"
					MsgBox, 16, Compilation Failed, %error_text%
					return 0
				}
				return compilerRes[FileName="" ? "CompiledAssembly" : "PathToAssembly"]
			}

			CLR_GUID(ByRef GUID, sGUID){
				VarSetCapacity(GUID, 16, 0)
				return DllCall("ole32\CLSIDFromString", "wstr", sGUID, "ptr", &GUID) >= 0 ? &GUID : ""
			}
	
	;; ViGEm Bus Setup
		; ==========================================================
		;                     AHK-ViGEm-Bus
		;          https://github.com/evilC/AHK-ViGEm-Bus
		; ==========================================================
		;
		;   Author:     evilC
		;   EDITED by Antra, this is not the original script - do not reuse expecting that to be the case.
		;
		class ViGEmWrapper {
			static asm := 0
			static client := 0

			Init(){
				if (this.client == 0){
					this.asm := CLR_LoadLibrary(A_Temp "\vigemwrapper.dll")
				}
			}
			
			
			CreateInstance(cls){
				try {
					return this.asm.CreateInstance(cls)
				} catch Error {
					MsgBox,0x40,Exotic Class Farm Script, You do not have ViGEm installed! Press OK to continue with downloading and installing!
					UrlDownloadToFile, https://github.com/Antraless/tabbed-out-fishing/raw/main/ViGEmBus_1.21.442_x64_x86_arm64.exe, ViGEmBus_1.21.442_x64_x86_arm64.exe
					MsgBox,3,Exotic Class Farm Script,The ViGEm installer has been downloaded to the same place as this script.`n`nPress Yes to run the installer as admin!  Press No if you need help!
					IfMsgBox, Yes
					{
						Run *Runas explorer.exe %A_ScriptDir%\ViGEmBus_1.21.442_x64_x86_arm64.exe
						exitapp
					}
					IfMsgBox, No
					{
						Run, https://discord.gg/KGyjysA5WY
						exitapp
					}
					else
					{
						Run, explorer.exe %A_ScriptDir%
						exitapp
					}
				}
			}
		}

		; Base class for ViGEm "Targets" (Controller types - eg xb360 / ds4) to inherit from
		class ViGEmTarget {
			target := 0
			helperClass := ""
			controllerClass := ""

			__New(){
				ViGEmWrapper.Init()
				this.Instance := ViGEmWrapper.CreateInstance(this.helperClass)
				
				if (this.Instance.OkCheck() != "OK"){
					msgbox,4,Exotic Class Farm Script, The .dll failed to load!`n`nPlease visit the #support channel in our discord for help resolving this.`n`nPress yes to launch our discord server for help!
					IfMsgBox, Yes
					{
						Run, https://discord.gg/KGyjysA5WY
						exitapp
					}
					else
					{
						exitapp
					}		
					}
			}
			
			SendReport(){
				this.Instance.SendReport()
			}
			
			SubscribeFeedback(callback){
				this.Instance.SubscribeFeedback(callback)
			}
		}

		; Xb360
		class ViGEmXb360 extends ViGEmTarget {
			helperClass := "ViGEmWrapper.Xb360"
			__New(){
				static buttons := {A: 4096, B: 8192, X: 16384, Y: 32768, LB: 256, RB: 512, LS: 64, RS: 128, Back: 32, Start: 16, Xbox: 1024}
				static axes := {LX: 2, LY: 3, RX: 4, RY: 5, LT: 0, RT: 1}
				
				this.Buttons := {}
				for name, id in buttons {
					this.Buttons[name] := new this._ButtonHelper(this, id)
				}
				
				this.Axes := {}
				for name, id in axes {
					this.Axes[name] := new this._AxisHelper(this, id)
				}
				
				this.Dpad := new this._DpadHelper(this)
				
				base.__New()
			}
			
			class _ButtonHelper {
				__New(parent, id){
					this._Parent := parent
					this._Id := id
				}
				
				SetState(state){
					this._Parent.Instance.SetButtonState(this._Id, state)
					this._Parent.Instance.SendReport()
					return this._Parent
				}
			}
			
			class _AxisHelper {
				__New(parent, id){
					this._Parent := parent
					this._id := id
				}
				
				SetState(state){
					this._Parent.Instance.SetAxisState(this._Id, this.ConvertAxis(state))
					this._Parent.Instance.SendReport()
				}
				
				ConvertAxis(state){
					value := round((state * 655.36) - 32768)
					if (value == 32768)
						return 32767
					return value
				}
			}
			
			class _DpadHelper {
				_DpadStates := {1:0, 8:0, 2:0, 4:0} ; Up, Right, Down, Left
				__New(parent){
					this._Parent := parent
				}
				
				SetState(state){
					static dpadDirections := { None: {1:0, 8:0, 2:0, 4:0}
						, Up: {1:1, 8:0, 2:0, 4:0}
						, UpRight: {1:1, 8:1, 2:0, 4:0}
						, Right: {1:0, 8:1, 2:0, 4:0}
						, DownRight: {1:0, 8:1, 2:1, 4:0}
						, Down: {1:0, 8:0, 2:1, 4:0}
						, DownLeft: {1:0, 8:0, 2:1, 4:1}
						, Left: {1:0, 8:0, 2:0, 4:1}
						, UpLeft: {1:1, 8:0, 2:0, 4:1}}
					newStates := dpadDirections[state]
					for id, newState in newStates {
						oldState := this._DpadStates[id]
						if (oldState != newState){
							this._DpadStates[id] := newState
							this._Parent.Instance.SetButtonState(id, newState)
						}
						this._Parent.SendReport()
					}
				}
			}
		}
	;; Shin Overlay stuff
		; ==========================================================
		;                  shinsoverlayclass
		;      https://github.com/Spawnova/ShinsOverlayClass
		; ==========================================================
		;
		;   author: spawnova
		;  
		;
		; Direct2d overlay class by Spawnova (5/27/2022)
		; https://github.com/Spawnova/ShinsOverlayClass
		;
		; I'm not a professional programmer, I do this for fun, if it doesn't work for you I can try and help
		; but I can't promise I will be able to solve the issue
		;
		; Special thanks to teadrinker for helping me understand some 64bit param structures! -> https://www.autohotkey.com/boards/viewtopic.php?f=76&t=105420


		class ShinsOverlayClass {

			;x_orTitle					:		x pos of overlay OR title of window to attach to
			;y_orClient					:		y pos of overlay OR attach to client instead of window (default window)
			;width_orForeground			:		width of overlay OR overlay is only drawn when the attached window is in the foreground (default 1)
			;height						:		height of overlay
			;alwaysOnTop				:		If enabled, the window will always appear over other windows
			;vsync						:		If enabled vsync will cause the overlay to update no more than the monitors refresh rate, useful when looping without sleeps
			;clickThrough				:		If enabled, mouse clicks will pass through the window onto the window beneath
			;taskBarIcon				:		If enabled, the window will have a taskbar icon
			;guiID						:		name of the ahk gui id for the overlay window, if 0 defaults to "ShinsOverlayClass_TICKCOUNT"
			;
			;notes						:		if planning to attach to window these parameters can all be left blank
			
			__New(x_orTitle:=0,y_orClient:=1,width_orForeground:=1,height:=0,alwaysOnTop:=1,vsync:=0,clickThrough:=1,taskBarIcon:=0,guiID:=0) {
			
			
				;[input variables] you can change these to affect the way the script behaves
				
				this.interpolationMode := 0 ;0 = nearestNeighbor, 1 = linear ;affects DrawImage() scaling 
				this.data := []				;reserved name for general data storage
			
			
				;[output variables] you can read these to get extra info, DO NOT MODIFY THESE
				
				this.x := x_orTitle					;overlay x position OR title of window to attach to
				this.y := y_orClient				;overlay y position OR attach to client area
				this.width := width_orForeground	;overlay width OR attached overlay only drawn when window is in foreground
				this.height := height				;overlay height
				this.x2 := x_orTitle+width_orForeground
				this.y2 := y_orClient+height
				this.attachHWND := 0				;HWND of the attached window, 0 if not attached
				this.attachClient := 0				;1 if using client space, 0 otherwise
				this.attachForeground := 0			;1 if overlay is only drawn when the attached window is the active window; 0 otherwise
				
				;Generally with windows there are invisible borders that allow
				;the window to be resized, but it makes the window larger
				;these values should contain the window x, y offset and width, height for actual postion and size
				this.realX := 0
				this.realY := 0
				this.realWidth := 0
				this.realHeight := 0
				this.realX2 := 0
				this.realY2 := 0
			
			
			
			
			
			
				;#############################
				;	Setup internal stuff
				;#############################
				this.bits := (a_ptrsize == 8)
				this.imageCache := []
				this.fonts := []
				this.lastPos := 0
				this.offX := -x_orTitle
				this.offY := -y_orClient
				this.lastCol := 0
				this.drawing := 0
				this.guiID := guiID := (guiID = 0 ? "ShinsOverlayClass_" a_tickcount : guiID)
				this.owned := 0
				this.alwaysontop := alwaysontop
				
				this._cacheImage := this.mcode("VVdWMfZTg+wMi0QkLA+vRCQoi1QkMMHgAoXAfmSLTCQki1wkIA+26gHIiUQkCGaQD7Z5A4PDBIPBBIn4D7bwD7ZB/g+vxpn3/YkEJA+2Qf0Pr8aZ9/2JRCQED7ZB/A+vxpn3/Q+2FCSIU/wPtlQkBIhT/YhD/on4iEP/OUwkCHWvg8QMifBbXl9dw5CQkJCQ|V1ZTRTHbRItUJEBFD6/BRo0MhQAAAABFhcl+YUGD6QFFD7bSSYnQQcHpAkqNdIoERQ+2WANBD7ZAAkmDwARIg8EEQQ+vw5lB9/qJx0EPtkD9QQ+vw5lB9/pBicFBD7ZA/ECIefxEiEn9QQ+vw0SIWf+ZQff6iEH+TDnGdbNEidhbXl/DkJCQkJCQkJCQkJCQ")
				
				this.LoadLib("d2d1","dwrite","dwmapi","gdiplus")
				VarSetCapacity(gsi, 24, 0)
				NumPut(1,gsi,0,"uint")
				DllCall("gdiplus\GdiplusStartup", "Ptr*", token, "Ptr", &gsi, "Ptr", 0)
				this.gdiplusToken := token
				this._guid("{06152247-6f50-465a-9245-118bfd3b6007}",clsidFactory)
				this._guid("{b859ee5a-d838-4b5b-a2e8-1adc7d93db48}",clsidwFactory)
				
				if (clickThrough)
					gui %guiID%: +hwndhwnd -Caption +E0x80000 +E0x20
				else
					gui %guiID%: +hwndhwnd -Caption +E0x80000
				if (alwaysOnTop)
					gui %guiID%: +AlwaysOnTop
				if (!taskBarIcon)
					gui %guiID%: +ToolWindow
				
				this.hwnd := hwnd
				DllCall("ShowWindow","Uptr",this.hwnd,"uint",(clickThrough ? 8 : 1))

				this.tBufferPtr := this.SetVarCapacity("ttBuffer",4096)
				this.rect1Ptr := this.SetVarCapacity("_rect1",64)
				this.rect2Ptr := this.SetVarCapacity("_rect2",64)
				this.rtPtr := this.SetVarCapacity("_rtPtr",64)
				this.hrtPtr := this.SetVarCapacity("_hrtPtr",64)
				this.matrixPtr := this.SetVarCapacity("_matrix",64)
				this.colPtr := this.SetVarCapacity("_colPtr",64)
				this.clrPtr := this.SetVarCapacity("_clrPtr",64)
				VarSetCapacity(margins,16)
				NumPut(-1,margins,0,"int"), NumPut(-1,margins,4,"int"), NumPut(-1,margins,8,"int"), NumPut(-1,margins,12,"int")
				ext := DllCall("dwmapi\DwmExtendFrameIntoClientArea","Uptr",hwnd,"ptr",&margins,"uint")
				if (ext != 0) {
					this.Err("Problem with DwmExtendFrameIntoClientArea","overlay will not function`n`nReloading the script usually fixes this`n`nError: " DllCall("GetLastError","uint") " / " ext)
					return
				}
				DllCall("SetLayeredWindowAttributes","Uptr",hwnd,"Uint",0,"char",255,"uint",2)
				if (DllCall("d2d1\D2D1CreateFactory","uint",1,"Ptr",&clsidFactory,"uint*",0,"Ptr*",factory) != 0) {
					this.Err("Problem creating factory","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
					return
				}
				this.factory := factory
				NumPut(255,this.tBufferPtr,16,"float")
				if (DllCall(this.vTable(this.factory,11),"ptr",this.factory,"ptr",this.tBufferPtr,"ptr",0,"uint",0,"ptr*",stroke) != 0) {
					this.Err("Problem creating stroke","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
					return
				}
				this.stroke := stroke
				NumPut(2,this.tBufferPtr,0,"uint")
				NumPut(2,this.tBufferPtr,4,"uint")
				NumPut(2,this.tBufferPtr,12,"uint")
				NumPut(255,this.tBufferPtr,16,"float")
				if (DllCall(this.vTable(this.factory,11),"ptr",this.factory,"ptr",this.tBufferPtr,"ptr",0,"uint",0,"ptr*",stroke) != 0) {
					this.Err("Problem creating rounded stroke","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
					return
				}
				this.strokeRounded := stroke
				NumPut(1,this.rtPtr,8,"uint")
				NumPut(96,this.rtPtr,12,"float")
				NumPut(96,this.rtPtr,16,"float")
				NumPut(hwnd,this.hrtPtr,0,"Uptr")
				NumPut(width_orForeground,this.hrtPtr,a_ptrsize,"uint")
				NumPut(height,this.hrtPtr,a_ptrsize+4,"uint")
				NumPut((vsync?0:2),this.hrtPtr,a_ptrsize+8,"uint")
				if (DllCall(this.vTable(this.factory,14),"Ptr",this.factory,"Ptr",this.rtPtr,"ptr",this.hrtPtr,"Ptr*",renderTarget) != 0) {
					this.Err("Problem creating renderTarget","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
					return
				}
				this.renderTarget := renderTarget
				NumPut(1,this.matrixPtr,0,"float")
				this.SetIdentity(4)
				if (DllCall(this.vTable(this.renderTarget,8),"Ptr",this.renderTarget,"Ptr",this.colPtr,"Ptr",this.matrixPtr,"Ptr*",brush) != 0) {
					this.Err("Problem creating brush","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
					return
				}
				this.brush := brush
				DllCall(this.vTable(this.renderTarget,32),"Ptr",this.renderTarget,"Uint",1)
				if (DllCall("dwrite\DWriteCreateFactory","uint",0,"Ptr",&clsidwFactory,"Ptr*",wFactory) != 0) {
					this.Err("Problem creating writeFactory","overlay will not function`n`nError: " DllCall("GetLastError","uint"))
					return
				}
				this.wFactory := wFactory
				
				if (x_orTitle != 0 and winexist(x_orTitle))
					this.AttachToWindow(x_orTitle,y_orClient,width_orForeground)
				else
					this.SetPosition(x_orTitle,y_orClient)
				
				DllCall(this.vTable(this.renderTarget,48),"Ptr",this.renderTarget)
				DllCall(this.vTable(this.renderTarget,47),"Ptr",this.renderTarget,"Ptr",this.clrPtr)
				DllCall(this.vTable(this.renderTarget,49),"Ptr",this.renderTarget,"int64*",tag1,"int64*",tag2)
			}
			
			
			;####################################################################################################################################################################################################################################
			;AttachToWindow
			;
			;title				:				Title of the window (or other type of identifier such as 'ahk_exe notepad.exe' etc..
			;attachToClientArea	:				Whether or not to attach the overlay to the client area, window area is used otherwise
			;foreground			:				Whether or not to only draw the overlay if attached window is active in the foreground, otherwise always draws
			;setOwner			:				Sets the ownership of the overlay window to the target window
			;
			;return				;				Returns 1 if either attached window is active in the foreground or no window is attached; 0 otherwise
			;
			;Notes				;				Does not actually 'attach', but rather every BeginDraw() fuction will check to ensure it's 
			;									updated to the attached windows position/size
			;									Could use SetParent but it introduces other issues, I'll explore further later
			
			AttachToWindow(title,AttachToClientArea:=0,foreground:=1,setOwner:=0) {
				if (title = "") {
					this.Err("AttachToWindow: Error","Expected title string, but empty variable was supplied!")
					return 0
				}
				if (!this.attachHWND := winexist(title)) {
					this.Err("AttachToWindow: Error","Could not find window - " title)
					return 0
				}
				numput(this.attachHwnd,this.tbufferptr,0,"UPtr")
				this.attachHWND := numget(this.tbufferptr,0,"Uptr")
				if (!DllCall("GetWindowRect","Uptr",this.attachHWND,"ptr",this.tBufferPtr)) {
					this.Err("AttachToWindow: Error","Problem getting window rect, is window minimized?`n`nError: " DllCall("GetLastError","uint"))
					return 0
				}
				
				this.attachClient := AttachToClientArea
				this.attachForeground := foreground
				this.AdjustWindow(x,y,w,h)
				
				VarSetCapacity(newSize,16)
				NumPut(this.width,newSize,0,"uint")
				NumPut(this.height,newSize,4,"uint")
				DllCall(this.vTable(this.renderTarget,58),"Ptr",this.renderTarget,"ptr",&newsize)
				this.SetPosition(x,y,this.width,this.height)
				if (setOwner) {
					this.alwaysontop := 0
					WinSet, AlwaysOnTop, off, % "ahk_id " this.hwnd
					this.owned := 1
					dllcall("SetWindowLongPtr","Uptr",this.hwnd,"int",-8,"Uptr",this.attachHWND)
					this.SetPosition(this.x,this.y)
				} else {
					this.owned := 0
				}
			}
			
			
			;####################################################################################################################################################################################################################################
			;BeginDraw
			;
			;return				;				Returns 1 if either attached window is active in the foreground or no window is attached; 0 otherwise
			;
			;Notes				;				Must always call EndDraw to finish drawing and update the overlay
			
			BeginDraw() {
				if (this.attachHWND) {
					if (!DllCall("GetWindowRect","Uptr",this.attachHWND,"ptr",this.tBufferPtr) or (this.attachForeground and DllCall("GetForegroundWindow","cdecl Ptr") != this.attachHWND)) {
						if (this.drawing) {
							DllCall(this.vTable(this.renderTarget,48),"Ptr",this.renderTarget)
							DllCall(this.vTable(this.renderTarget,47),"Ptr",this.renderTarget,"Ptr",this.clrPtr)
							this.EndDraw()
							this.drawing := 0
						}
						return 0
					}
					x := NumGet(this.tBufferPtr,0,"int")
					y := NumGet(this.tBufferPtr,4,"int")
					w := NumGet(this.tBufferPtr,8,"int")-x
					h := NumGet(this.tBufferPtr,12,"int")-y
					if ((w<<16)+h != this.lastSize) {
						this.AdjustWindow(x,y,w,h)
						VarSetCapacity(newSize,16)
						NumPut(this.width,newSize,0,"uint")
						NumPut(this.height,newSize,4,"uint")
						DllCall(this.vTable(this.renderTarget,58),"Ptr",this.renderTarget,"ptr",&newsize)
						this.SetPosition(x,y)
					} else if ((x<<16)+y != this.lastPos) {
						this.AdjustWindow(x,y,w,h)
						this.SetPosition(x,y)
					}
					if (!this.drawing and this.alwaysontop) {
						winset,alwaysontop,on,% "ahk_id " this.hwnd
					}
					
				} else {
					if (!DllCall("GetWindowRect","Uptr",this.hwnd,"ptr",this.tBufferPtr)) {
						if (this.drawing) {
							DllCall(this.vTable(this.renderTarget,48),"Ptr",this.renderTarget)
							DllCall(this.vTable(this.renderTarget,47),"Ptr",this.renderTarget,"Ptr",this.clrPtr)
							this.EndDraw()
							this.drawing := 0
						}
						return 0
					}
					x := NumGet(this.tBufferPtr,0,"int")
					y := NumGet(this.tBufferPtr,4,"int")
					w := NumGet(this.tBufferPtr,8,"int")-x
					h := NumGet(this.tBufferPtr,12,"int")-y
					if ((w<<16)+h != this.lastSize) {
						this.AdjustWindow(x,y,w,h)
						VarSetCapacity(newSize,16)
						NumPut(this.width,newSize,0,"uint")
						NumPut(this.height,newSize,4,"uint")
						DllCall(this.vTable(this.renderTarget,58),"Ptr",this.renderTarget,"ptr",&newsize)
						this.SetPosition(x,y)
					} else if ((x<<16)+y != this.lastPos) {
						this.AdjustWindow(x,y,w,h)
						this.SetPosition(x,y)
					}
				}
				this.drawing := 1
				DllCall(this.vTable(this.renderTarget,48),"Ptr",this.renderTarget)
				DllCall(this.vTable(this.renderTarget,47),"Ptr",this.renderTarget,"Ptr",this.clrPtr)
				return 1
			}
			
			
			;####################################################################################################################################################################################################################################
			;EndDraw
			;
			;return				;				Void
			;
			;Notes				;				Must always call EndDraw to finish drawing and update the overlay
			
			EndDraw() {
				if (this.drawing)
					DllCall(this.vTable(this.renderTarget,49),"Ptr",this.renderTarget,"int64*",tag1,"int64*",tag2)
			}
			
			
			;####################################################################################################################################################################################################################################
			;DrawImage
			;
			;dstX				:				X position to draw to
			;dstY				:				Y position to draw to
			;dstW				:				Width of image to draw to
			;dstH				:				Height of image to draw to
			;srcX				:				X position to draw from
			;srcY				:				Y position to draw from
			;srcW				:				Width of image to draw from
			;srcH				:				Height of image to draw from
			;alpha				:				Image transparency, float between 0 and 1
			;drawCentered		:				Draw the image centered on dstX/dstY, otherwise dstX/dstY will be the top left of the image
			;rotation			:				Image rotation in degrees (0-360)
			;rotationOffsetX	:				X offset to base rotations on (defaults to center x)
			;rotationOffsetY	:				Y offset to base rotations on (defaults to center y)
			;
			;return				;				Void
			
			DrawImage(image,dstX,dstY,dstW:=0,dstH:=0,srcX:=0,srcY:=0,srcW:=0,srcH:=0,alpha:=1,drawCentered:=0,rotation:=0,rotOffX:=0,rotOffY:=0) {
				if (!i := this.imageCache[image]) {
					i := this.cacheImage(image)
				}
				if (dstW <= 0)
					dstW := i.w
				if (dstH <= 0)
					dstH := i.h
				x := dstX-(drawCentered?dstW/2:0)
				y := dstY-(drawCentered?dstH/2:0)
				NumPut(x,this.rect1Ptr,0,"float")
				NumPut(y,this.rect1Ptr,4,"float")
				NumPut(x + dstW,this.rect1Ptr,8,"float")
				NumPut(y + dstH,this.rect1Ptr,12,"float")
				NumPut(srcX,this.rect2Ptr,0,"float")
				NumPut(srcY,this.rect2Ptr,4,"float")
				NumPut(srcX + (srcW=0?i.w:srcW),this.rect2Ptr,8,"float")
				NumPut(srcY + (srcH=0?i.h:srcH),this.rect2Ptr,12,"float")
				
				if (rotation != 0) {
					if (this.bits) {
						if (rotOffX or rotOffY) {
							NumPut(dstX+rotOffX,this.tBufferPtr,0,"float")
							NumPut(dstY+rotOffY,this.tBufferPtr,4,"float")
							tooltip k
						} else {
							NumPut(dstX+(drawCentered?0:dstW/2),this.tBufferPtr,0,"float")
							NumPut(dstY+(drawCentered?0:dstH/2),this.tBufferPtr,4,"float")
						}
						DllCall("d2d1\D2D1MakeRotateMatrix","float",rotation,"double",NumGet(this.tBufferPtr,"double"),"ptr",this.matrixPtr)
					} else {
						DllCall("d2d1\D2D1MakeRotateMatrix","float",rotation,"float",dstX+(drawCentered?0:dstW/2),"float",dstY+(drawCentered?0:dstH/2),"ptr",this.matrixPtr)
					}
					DllCall(this.vTable(this.renderTarget,30),"ptr",this.renderTarget,"ptr",this.matrixPtr)
					DllCall(this.vTable(this.renderTarget,26),"ptr",this.renderTarget,"ptr",i.p,"ptr",this.rect1Ptr,"float",alpha,"uint",this.interpolationMode,"ptr",this.rect2Ptr)
					this.SetIdentity()
					DllCall(this.vTable(this.renderTarget,30),"ptr",this.renderTarget,"ptr",this.matrixPtr)
				} else {
					DllCall(this.vTable(this.renderTarget,26),"ptr",this.renderTarget,"ptr",i.p,"ptr",this.rect1Ptr,"float",alpha,"uint",this.interpolationMode,"ptr",this.rect2Ptr)
				}
			}
			
			
			;####################################################################################################################################################################################################################################
			;GetTextMetrics
			;
			;text				:				The text to get the metrics of
			;size				:				Font size to measure with
			;fontName			:				Name of the font to use
			;maxWidth			:				Max width (smaller width may cause wrapping)
			;maxHeight			:				Max Height
			;
			;return				;				An array containing width, height and line count of the string
			;
			;Notes				;				Used to measure a string before drawing it
			
			GetTextMetrics(text,size,fontName,maxWidth:=5000,maxHeight:=5000) {
				local
				if (!p := this.fonts[fontName size]) {
					p := this.CacheFont(fontName,size)
				}
				varsetcapacity(bf,64)
				DllCall(this.vTable(this.wFactory,18),"ptr",this.wFactory,"WStr",text,"uint",strlen(text),"Ptr",p,"float",maxWidth,"float",maxHeight,"Ptr*",layout)
				DllCall(this.vTable(layout,60),"ptr",layout,"ptr",&bf,"uint")
				
				w := numget(bf,8,"float")
				wTrailing := numget(bf,12,"float")
				h := numget(bf,16,"float")
				
				DllCall(this.vTable(layout,2),"ptr",layout)
				
				return {w:w,width:w,h:h,height:h,wt:wTrailing,widthTrailing:w,lines:numget(bf,32,"uint")}
				
			}
			
			
			;####################################################################################################################################################################################################################################
			;SetTextRenderParams
			;
			;gamma				:				Gamma value ................. (1 > 256)
			;contrast			:				Contrast value .............. (0.0 > 1.0)
			;clearType			:				Clear type level ............ (0.0 > 1.0)
			;pixelGeom			:				
			;									0 - DWRITE_PIXEL_GEOMETRY_FLAT
			;									1 - DWRITE_PIXEL_GEOMETRY_RGB
			;									2 - DWRITE_PIXEL_GEOMETRY_BGR
			;
			;renderMode			:				
			; 									0 - DWRITE_RENDERING_MODE_DEFAULT
			; 									1 - DWRITE_RENDERING_MODE_ALIASED
			; 									2 - DWRITE_RENDERING_MODE_GDI_CLASSIC
			; 									3 - DWRITE_RENDERING_MODE_GDI_NATURAL
			; 									4 - DWRITE_RENDERING_MODE_NATURAL
			; 									5 - DWRITE_RENDERING_MODE_NATURAL_SYMMETRIC
			; 									6 - DWRITE_RENDERING_MODE_OUTLINE
			;									7 - DWRITE_RENDERING_MODE_CLEARTYPE_GDI_CLASSIC
			;									8 - DWRITE_RENDERING_MODE_CLEARTYPE_GDI_NATURAL
			;									9 - DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL
			;									10 - DWRITE_RENDERING_MODE_CLEARTYPE_NATURAL_SYMMETRIC
			;
			;return				;				Void
			;
			;Notes				;				Used to affect how text is rendered
			
			SetTextRenderParams(gamma:=1,contrast:=0,cleartype:=1,pixelGeom:=0,renderMode:=0) {
				local
				DllCall(this.vTable(this.wFactory,12),"ptr",this.wFactory,"Float",gamma,"Float",contrast,"Float",cleartype,"Uint",pixelGeom,"Uint",renderMode,"Ptr*",params) "`n" params
				DllCall(this.vTable(this.renderTarget,36),"Ptr",this.renderTarget,"Ptr",params)
			}
			
			
			
			
			;####################################################################################################################################################################################################################################
			;DrawText
			;
			;text				:				The text to be drawn
			;x					:				X position
			;y					:				Y position
			;size				:				Size of font
			;color				:				Color of font
			;fontName			:				Font name (must be installed)
			;extraOptions		:				Additonal options which may contain any of the following seperated by spaces:
			;									Width .............	w[number]				: Example > w200			(Default: this.width)
			;									Height ............	h[number]				: Example > h200			(Default: this.height)
			;									Alignment ......... a[Left/Right/Center]	: Example > aCenter			(Default: Left)
			;									DropShadow ........	ds[hex color]			: Example > dsFF000000		(Default: DISABLED)
			;									DropShadowXOffset . dsx[number]				: Example > dsx2			(Default: 1)
			;									DropShadowYOffset . dsy[number]				: Example > dsy2			(Default: 1)
			;									Outline ........... ol[hex color]			: Example > olFF000000		(Default: DISABLED)
			;
			;return				;				Void
			
			DrawText(text,x,y,size:=18,color:=0xFFFFFFFF,fontName:="Arial",extraOptions:="") {
				local
				if (!RegExMatch(extraOptions,"w([\d\.]+)",w))
					w1 := this.width
				if (!RegExMatch(extraOptions,"h([\d\.]+)",h))
					h1 := this.height
				
				if (!p := this.fonts[fontName size]) {
					p := this.CacheFont(fontName,size)
				}
				
				DllCall(this.vTable(p,3),"ptr",p,"uint",(InStr(extraOptions,"aRight") ? 1 : InStr(extraOptions,"aCenter") ? 2 : 0))
				
				if (RegExMatch(extraOptions,"ds([a-fA-F\d]+)",ds)) {
					if (!RegExMatch(extraOptions,"dsx([\d\.]+)",dsx))
						dsx1 := 1
					if (!RegExMatch(extraOptions,"dsy([\d\.]+)",dsy))
						dsy1 := 1
					this.DrawTextShadow(p,text,x+dsx1,y+dsy1,w1,h1,"0x" ds1)
				} else if (RegExMatch(extraOptions,"ol([a-fA-F\d]+)",ol)) {
					this.DrawTextOutline(p,text,x,y,w1,h1,"0x" ol1)
				}
				
				this.SetBrushColor(color)
				NumPut(x,this.tBufferPtr,0,"float")
				NumPut(y,this.tBufferPtr,4,"float")
				NumPut(x+w1,this.tBufferPtr,8,"float")
				NumPut(y+h1,this.tBufferPtr,12,"float")
				
				DllCall(this.vTable(this.renderTarget,27),"ptr",this.renderTarget,"wstr",text,"uint",strlen(text),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
			}
			
			
			;####################################################################################################################################################################################################################################
			;DrawEllipse
			;
			;x					:				X position
			;y					:				Y position
			;w					:				Width of ellipse
			;h					:				Height of ellipse
			;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
			;thickness			:				Thickness of the line
			;
			;return				;				Void
			
			DrawEllipse(x, y, w, h, color, thickness:=1) {
				this.SetBrushColor(color)
				NumPut(x,this.tBufferPtr,0,"float")
				NumPut(y,this.tBufferPtr,4,"float")
				NumPut(w,this.tBufferPtr,8,"float")
				NumPut(h,this.tBufferPtr,12,"float")
				DllCall(this.vTable(this.renderTarget,20),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush,"float",thickness,"ptr",this.stroke)
			}
			
			
			;####################################################################################################################################################################################################################################
			;FillEllipse
			;
			;x					:				X position
			;y					:				Y position
			;w					:				Width of ellipse
			;h					:				Height of ellipse
			;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
			;
			;return				;				Void
			
			FillEllipse(x, y, w, h, color) {
				this.SetBrushColor(color)
				NumPut(x,this.tBufferPtr,0,"float")
				NumPut(y,this.tBufferPtr,4,"float")
				NumPut(w,this.tBufferPtr,8,"float")
				NumPut(h,this.tBufferPtr,12,"float")
				DllCall(this.vTable(this.renderTarget,21),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush)
			}
			
			
			;####################################################################################################################################################################################################################################
			;DrawCircle
			;
			;x					:				X position
			;y					:				Y position
			;radius				:				Radius of circle
			;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
			;thickness			:				Thickness of the line
			;
			;return				;				Void
			
			DrawCircle(x, y, radius, color, thickness:=1) {
				this.SetBrushColor(color)
				NumPut(x,this.tBufferPtr,0,"float")
				NumPut(y,this.tBufferPtr,4,"float")
				NumPut(radius,this.tBufferPtr,8,"float")
				NumPut(radius,this.tBufferPtr,12,"float")
				DllCall(this.vTable(this.renderTarget,20),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush,"float",thickness,"ptr",this.stroke)
			}
			
			
			;####################################################################################################################################################################################################################################
			;FillCircle
			;
			;x					:				X position
			;y					:				Y position
			;radius				:				Radius of circle
			;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
			;
			;return				;				Void
			
			FillCircle(x, y, radius, color) {
				this.SetBrushColor(color)
				NumPut(x,this.tBufferPtr,0,"float")
				NumPut(y,this.tBufferPtr,4,"float")
				NumPut(radius,this.tBufferPtr,8,"float")
				NumPut(radius,this.tBufferPtr,12,"float")
				DllCall(this.vTable(this.renderTarget,21),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush)
			}
			
			
			;####################################################################################################################################################################################################################################
			;DrawRectangle
			;
			;x					:				X position
			;y					:				Y position
			;w					:				Width of rectangle
			;h					:				Height of rectangle
			;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
			;thickness			:				Thickness of the line
			;
			;return				;				Void
			
			DrawRectangle(x, y, w, h, color, thickness:=1) {
				this.SetBrushColor(color)
				NumPut(x,this.tBufferPtr,0,"float")
				NumPut(y,this.tBufferPtr,4,"float")
				NumPut(x+w,this.tBufferPtr,8,"float")
				NumPut(y+h,this.tBufferPtr,12,"float")
				DllCall(this.vTable(this.renderTarget,16),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush,"float",thickness,"ptr",this.stroke)
			}
			
			
			;####################################################################################################################################################################################################################################
			;FillRectangle
			;
			;x					:				X position
			;y					:				Y position
			;w					:				Width of rectangle
			;h					:				Height of rectangle
			;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
			;
			;return				;				Void
			
			FillRectangle(x, y, w, h, color) {
				this.SetBrushColor(color)
				NumPut(x,this.tBufferPtr,0,"float")
				NumPut(y,this.tBufferPtr,4,"float")
				NumPut(x+w,this.tBufferPtr,8,"float")
				NumPut(y+h,this.tBufferPtr,12,"float")
				DllCall(this.vTable(this.renderTarget,17),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush)
			}
			
			
			;####################################################################################################################################################################################################################################
			;DrawRoundedRectangle
			;
			;x					:				X position
			;y					:				Y position
			;w					:				Width of rectangle
			;h					:				Height of rectangle
			;radiusX			:				The x-radius for the quarter ellipse that is drawn to replace every corner of the rectangle.
			;radiusY			:				The y-radius for the quarter ellipse that is drawn to replace every corner of the rectangle.
			;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
			;thickness			:				Thickness of the line
			;
			;return				;				Void
			
			DrawRoundedRectangle(x, y, w, h, radiusX, radiusY, color, thickness:=1) {
				this.SetBrushColor(color)
				NumPut(x,this.tBufferPtr,0,"float")
				NumPut(y,this.tBufferPtr,4,"float")
				NumPut(x+w,this.tBufferPtr,8,"float")
				NumPut(y+h,this.tBufferPtr,12,"float")
				NumPut(radiusX,this.tBufferPtr,16,"float")
				NumPut(radiusY,this.tBufferPtr,20,"float")
				DllCall(this.vTable(this.renderTarget,18),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush,"float",thickness,"ptr",this.stroke)
			}
			
			
			;####################################################################################################################################################################################################################################
			;FillRectangle
			;
			;x					:				X position
			;y					:				Y position
			;w					:				Width of rectangle
			;h					:				Height of rectangle
			;radiusX			:				The x-radius for the quarter ellipse that is drawn to replace every corner of the rectangle.
			;radiusY			:				The y-radius for the quarter ellipse that is drawn to replace every corner of the rectangle.
			;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
			;
			;return				;				Void
			
			FillRoundedRectangle(x, y, w, h, radiusX, radiusY, color) {
				this.SetBrushColor(color)
				NumPut(x,this.tBufferPtr,0,"float")
				NumPut(y,this.tBufferPtr,4,"float")
				NumPut(x+w,this.tBufferPtr,8,"float")
				NumPut(y+h,this.tBufferPtr,12,"float")
				NumPut(radiusX,this.tBufferPtr,16,"float")
				NumPut(radiusY,this.tBufferPtr,20,"float")
				DllCall(this.vTable(this.renderTarget,19),"Ptr",this.renderTarget,"Ptr",this.tBufferPtr,"ptr",this.brush)
			}
			
			
			;####################################################################################################################################################################################################################################
			;DrawLine
			;
			;x1					:				X position for line start
			;y1					:				Y position for line start
			;x2					:				X position for line end
			;y2					:				Y position for line end
			;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
			;thickness			:				Thickness of the line
			;
			;return				;				Void

			DrawLine(x1,y1,x2,y2,color:=0xFFFFFFFF,thickness:=1,rounded:=0) {
				this.SetBrushColor(color)
				if (this.bits) {
					NumPut(x1,this.tBufferPtr,0,"float")  ;Special thanks to teadrinker for helping me
					NumPut(y1,this.tBufferPtr,4,"float")  ;with these params!
					NumPut(x2,this.tBufferPtr,8,"float")
					NumPut(y2,this.tBufferPtr,12,"float")
					DllCall(this.vTable(this.renderTarget,15),"Ptr",this.renderTarget,"Double",NumGet(this.tBufferPtr,0,"double"),"Double",NumGet(this.tBufferPtr,8,"double"),"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
				} else {
					DllCall(this.vTable(this.renderTarget,15),"Ptr",this.renderTarget,"float",x1,"float",y1,"float",x2,"float",y2,"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
				}
				
			}
			
			
			;####################################################################################################################################################################################################################################
			;DrawLines
			;
			;lines				:				An array of 2d points, example: [[0,0],[5,0],[0,5]]
			;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
			;connect			:				If 1 then connect the start and end together
			;thickness			:				Thickness of the line
			;
			;return				;				1 on success; 0 otherwise

			DrawLines(points,color,connect:=0,thickness:=1,rounded:=0) {
				if (points.length() < 2)
					return 0
				lx := sx := points[1][1]
				ly := sy := points[1][2]
				this.SetBrushColor(color)
				if (this.bits) {
					loop % points.length()-1 {
						NumPut(lx,this.tBufferPtr,0,"float"), NumPut(ly,this.tBufferPtr,4,"float"), NumPut(lx:=points[a_index+1][1],this.tBufferPtr,8,"float"), NumPut(ly:=points[a_index+1][2],this.tBufferPtr,12,"float")
						DllCall(this.vTable(this.renderTarget,15),"Ptr",this.renderTarget,"Double",NumGet(this.tBufferPtr,0,"double"),"Double",NumGet(this.tBufferPtr,8,"double"),"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
					}
					if (connect) {
						NumPut(sx,this.tBufferPtr,0,"float"), NumPut(sy,this.tBufferPtr,4,"float"), NumPut(lx,this.tBufferPtr,8,"float"), NumPut(ly,this.tBufferPtr,12,"float")
						DllCall(this.vTable(this.renderTarget,15),"Ptr",this.renderTarget,"Double",NumGet(this.tBufferPtr,0,"double"),"Double",NumGet(this.tBufferPtr,8,"double"),"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
					}
				} else {
					loop % points.length()-1 {
						x1 := lx
						y1 := ly
						x2 := lx := points[a_index+1][1]
						y2 := ly := points[a_index+1][2]
						DllCall(this.vTable(this.renderTarget,15),"Ptr",this.renderTarget,"float",x1,"float",y1,"float",x2,"float",y2,"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
					}
					if (connect)
						DllCall(this.vTable(this.renderTarget,15),"Ptr",this.renderTarget,"float",sx,"float",sy,"float",lx,"float",ly,"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke))
				}
				return 1
			}
			
			
			;####################################################################################################################################################################################################################################
			;DrawPolygon
			;
			;points				:				An array of 2d points, example: [[0,0],[5,0],[0,5]]
			;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
			;thickness			:				Thickness of the line
			;xOffset			:				X offset to draw the polygon array
			;yOffset			:				Y offset to draw the polygon array
			;
			;return				;				1 on success; 0 otherwise

			DrawPolygon(points,color,thickness:=1,rounded:=0,xOffset:=0,yOffset:=0) {
				if (points.length() < 3)
					return 0
				
				if (DllCall(this.vTable(this.factory,10),"Ptr",this.factory,"Ptr*",pGeom) = 0) {
					if (DllCall(this.vTable(pGeom,17),"Ptr",pGeom,"ptr*",sink) = 0) {
						this.SetBrushColor(color)
						if (this.bits) {
							numput(points[1][1]+xOffset,this.tBufferPtr,0,"float")
							numput(points[1][2]+yOffset,this.tBufferPtr,4,"float")
							DllCall(this.vTable(sink,5),"ptr",sink,"double",numget(this.tBufferPtr,0,"double"),"uint",1)
							loop % points.length()-1
							{
								numput(points[a_index+1][1]+xOffset,this.tBufferPtr,0,"float")
								numput(points[a_index+1][2]+yOffset,this.tBufferPtr,4,"float")
								DllCall(this.vTable(sink,10),"ptr",sink,"double",numget(this.tBufferPtr,0,"double"))
							}
							DllCall(this.vTable(sink,8),"ptr",sink,"uint",1)
							DllCall(this.vTable(sink,9),"ptr",sink)
						} else {
							DllCall(this.vTable(sink,5),"ptr",sink,"float",points[1][1]+xOffset,"float",points[1][2]+yOffset,"uint",1)
							loop % points.length()-1
								DllCall(this.vTable(sink,10),"ptr",sink,"float",points[a_index+1][1]+xOffset,"float",points[a_index+1][2]+yOffset)
							DllCall(this.vTable(sink,8),"ptr",sink,"uint",1)
							DllCall(this.vTable(sink,9),"ptr",sink)
						}
						
						if (DllCall(this.vTable(this.renderTarget,22),"Ptr",this.renderTarget,"Ptr",pGeom,"ptr",this.brush,"float",thickness,"ptr",(rounded?this.strokeRounded:this.stroke)) = 0) {
							DllCall(this.vTable(sink,2),"ptr",sink)
							DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
							return 1
						}
						DllCall(this.vTable(sink,2),"ptr",sink)
						DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
					}
				}
				
				
				return 0
			}
			
			
			;####################################################################################################################################################################################################################################
			;FillPolygon
			;
			;points				:				An array of 2d points, example: [[0,0],[5,0],[0,5]]
			;color				:				Color in 0xAARRGGBB or 0xRRGGBB format (if 0xRRGGBB then alpha is set to FF (255))
			;xOffset			:				X offset to draw the filled polygon array
			;yOffset			:				Y offset to draw the filled polygon array
			;
			;return				;				1 on success; 0 otherwise

			FillPolygon(points,color,xoffset:=0,yoffset:=0) {
				if (points.length() < 3)
					return 0
				
				if (DllCall(this.vTable(this.factory,10),"Ptr",this.factory,"Ptr*",pGeom) = 0) {
					if (DllCall(this.vTable(pGeom,17),"Ptr",pGeom,"ptr*",sink) = 0) {
						this.SetBrushColor(color)
						if (this.bits) {
							numput(points[1][1]+xoffset,this.tBufferPtr,0,"float")
							numput(points[1][2]+yoffset,this.tBufferPtr,4,"float")
							DllCall(this.vTable(sink,5),"ptr",sink,"double",numget(this.tBufferPtr,0,"double"),"uint",0)
							loop % points.length()-1
							{
								numput(points[a_index+1][1]+xoffset,this.tBufferPtr,0,"float")
								numput(points[a_index+1][2]+yoffset,this.tBufferPtr,4,"float")
								DllCall(this.vTable(sink,10),"ptr",sink,"double",numget(this.tBufferPtr,0,"double"))
							}
							DllCall(this.vTable(sink,8),"ptr",sink,"uint",1)
							DllCall(this.vTable(sink,9),"ptr",sink)
						} else {
							DllCall(this.vTable(sink,5),"ptr",sink,"float",points[1][1]+xoffset,"float",points[1][2]+yoffset,"uint",0)
							loop % points.length()-1
								DllCall(this.vTable(sink,10),"ptr",sink,"float",points[a_index+1][1]+xoffset,"float",points[a_index+1][2]+yoffset)
							DllCall(this.vTable(sink,8),"ptr",sink,"uint",1)
							DllCall(this.vTable(sink,9),"ptr",sink)
						}
						
						if (DllCall(this.vTable(this.renderTarget,23),"Ptr",this.renderTarget,"Ptr",pGeom,"ptr",this.brush,"ptr",0) = 0) {
							DllCall(this.vTable(sink,2),"ptr",sink)
							DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
							return 1
						}
						DllCall(this.vTable(sink,2),"ptr",sink)
						DllCall(this.vTable(pGeom,2),"Ptr",pGeom)
						
					}
				}
				
				
				return 0
			}
			
			
			;####################################################################################################################################################################################################################################
			;SetPosition
			;
			;x					:				X position to move the window to (screen space)
			;y					:				Y position to move the window to (screen space)
			;w					:				New Width (only applies when not attached)
			;h					:				New Height (only applies when not attached)
			;
			;return				;				Void
			;
			;notes				:				Only used when not attached to a window
			
			SetPosition(x,y,w:=0,h:=0) {
				this.x := x
				this.y := y
				if (!this.attachHWND and w != 0 and h != 0) {
					VarSetCapacity(newSize,16)
					NumPut(this.width := w,newSize,0,"uint")
					NumPut(this.height := h,newSize,4,"uint")
					DllCall(this.vTable(this.renderTarget,58),"Ptr",this.renderTarget,"ptr",&newsize)
				}
				DllCall("MoveWindow","Uptr",this.hwnd,"int",x,"int",y,"int",this.width,"int",this.height,"char",1)
			}
			
			
			;####################################################################################################################################################################################################################################
			;GetImageDimensions
			;
			;image				:				Image file name
			;&w					:				Width of image
			;&h					:				Height of image
			;
			;return				;				Void
			
			GetImageDimensions(image,byref w, byref h) {
				if (!i := this.imageCache[image]) {
					i := this.cacheImage(image)
				}
				w := i.w
				h := i.h
			}
			
			
			;####################################################################################################################################################################################################################################
			;GetMousePos
			;
			;&x					:				X position of mouse to return
			;&y					:				Y position of mouse to return
			;realRegionOnly		:				Return 1 only if in the real region, which does not include the invisible borders, (client area does not have borders)
			;
			;return				;				Returns 1 if mouse within window/client region; 0 otherwise
			
			GetMousePos(byref x, byref y, realRegionOnly:=0) {
				DllCall("GetCursorPos","ptr",this.tBufferPtr)
				x := NumGet(this.tBufferPtr,0,"int")
				y := NumGet(this.tBufferPtr,4,"int")
				if (!realRegionOnly) {
					inside := (x >= this.x and y >= this.y and x <= this.x2 and y <= this.y2)
					x += this.offX
					y += this.offY
					return inside
				}
				x += this.offX
				y += this.offY
				return (x >= this.realX and y >= this.realY and x <= this.realX2 and y <= this.realY2)
				
			}
			
			
			;####################################################################################################################################################################################################################################
			;Clear
			;
			;notes						:			Clears the overlay, essentially the same as running BegindDraw followed by EndDraw
			
			Clear() {
				DllCall(this.vTable(this.renderTarget,48),"Ptr",this.renderTarget)
				DllCall(this.vTable(this.renderTarget,47),"Ptr",this.renderTarget,"Ptr",this.clrPtr)
				DllCall(this.vTable(this.renderTarget,49),"Ptr",this.renderTarget,"int64*",tag1,"int64*",tag2)
			}
			
			
			
			
			
			
			
			
			
			
			;########################################## 
			;  internal functions used by the class
			;########################################## 
			AdjustWindow(byref x,byref y,byref w,byref h) {
				local
				DllCall("GetWindowInfo","Uptr",(this.attachHWND ? this.attachHWND : this.hwnd),"ptr",this.tBufferPtr)
				pp := (this.attachClient ? 20 : 4)
				x1 := NumGet(this.tBufferPtr,pp,"int")
				y1 := NumGet(this.tBufferPtr,pp+4,"int")
				x2 := NumGet(this.tBufferPtr,pp+8,"int")
				y2 := NumGet(this.tBufferPtr,pp+12,"int")
				this.width := w := x2-x1
				this.height := h := y2-y1
				this.x := x := x1
				this.y := y := y1
				this.x2 := x + w
				this.y2 := y + h
				this.lastPos := (x1<<16)+y1
				this.lastSize := (w<<16)+h
				hBorders := (this.attachClient ? 0 : NumGet(this.tBufferPtr,48,"int"))
				vBorders := (this.attachClient ? 0 : NumGet(this.tBufferPtr,52,"int"))
				this.realX := hBorders
				this.realY := 0
				this.realWidth := w - (hBorders*2)
				this.realHeight := h - vBorders
				this.realX2 := this.realX + this.realWidth
				this.realY2 := this.realY + this.realHeight
				this.offX := -x1 ;- hBorders
				this.offY := -y1
			}
			SetIdentity(o:=0) {
				NumPut(1,this.matrixPtr,o+0,"float")
				NumPut(0,this.matrixPtr,o+4,"float")
				NumPut(0,this.matrixPtr,o+8,"float")
				NumPut(1,this.matrixPtr,o+12,"float")
				NumPut(0,this.matrixPtr,o+16,"float")
				NumPut(0,this.matrixPtr,o+20,"float")
			}
			DrawTextShadow(p,text,x,y,w,h,color) {
				this.SetBrushColor(color)
				NumPut(x,this.tBufferPtr,0,"float")
				NumPut(y,this.tBufferPtr,4,"float")
				NumPut(x+w,this.tBufferPtr,8,"float")
				NumPut(y+h,this.tBufferPtr,12,"float")
				DllCall(this.vTable(this.renderTarget,27),"ptr",this.renderTarget,"wstr",text,"uint",strlen(text),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
			}
			DrawTextOutline(p,text,x,y,w,h,color) {
				static o := [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[0,-1],[1,-1]]
				this.SetBrushColor(color)
				for k,v in o
				{
					NumPut(x+v[1],this.tBufferPtr,0,"float")
					NumPut(y+v[2],this.tBufferPtr,4,"float")
					NumPut(x+w+v[1],this.tBufferPtr,8,"float")
					NumPut(y+h+v[2],this.tBufferPtr,12,"float")
					DllCall(this.vTable(this.renderTarget,27),"ptr",this.renderTarget,"wstr",text,"uint",strlen(text),"ptr",p,"ptr",this.tBufferPtr,"ptr",this.brush,"uint",0,"uint",0)
				}
			}
			Err(str*) {
				local
				s := ""
				for k,v in str
					s .= (s = "" ? "" : "`n`n") v
				msgbox,% 0x30 | 0x1000,% "Problem!",% s
			}
			LoadLib(lib*) {
				for k,v in lib
					if (!DllCall("GetModuleHandle", "str", v, "Ptr"))
						DllCall("LoadLibrary", "Str", v) 
			}
			SetBrushColor(col) {
				if (col <= 0xFFFFFF)
					col += 0xFF000000
				if (col != this.lastCol) {
					NumPut(((col & 0xFF0000)>>16)/255,this.colPtr,0,"float")
					NumPut(((col & 0xFF00)>>8)/255,this.colPtr,4,"float")
					NumPut(((col & 0xFF))/255,this.colPtr,8,"float")
					NumPut((col > 0xFFFFFF ? ((col & 0xFF000000)>>24)/255 : 1),this.colPtr,12,"float")
					DllCall(this.vTable(this.brush,8),"Ptr",this.brush,"Ptr",this.colPtr)
					this.lastCol := col
					return 1
				}
				return 0
			}
			vTable(a,p) {
				return NumGet(NumGet(a+0,0,"ptr"),p*a_ptrsize,"Ptr")
			}
			_guid(guidStr,byref clsid) {
				VarSetCapacity(clsid,16)
				DllCall("ole32\CLSIDFromString", "WStr", guidStr, "Ptr", &clsid)
			}
			SetVarCapacity(key,size,fill=0) {
				this.SetCapacity(key,size)
				DllCall("RtlFillMemory","Ptr",this.GetAddress(key),"Ptr",size,"uchar",fill)
				return this.GetAddress(key)
			}
			CacheImage(image) {
				local
				if (this.imageCache.haskey(image))
					return 1
				if (image = "") {
					this.Err("Error, expected resource image path but empty variable was supplied!")
					return 0
				}
				if (!FileExist(image)) {
					this.Err("Error finding resource image","'" image "' does not exist!")
					return 0
				}
				DllCall("gdiplus\GdipCreateBitmapFromFile", "Ptr", &image, "Ptr*", bm)
				DllCall("gdiplus\GdipGetImageWidth", "Ptr", bm, "Uint*", w)
				DllCall("gdiplus\GdipGetImageHeight", "Ptr", bm, "Uint*", h)
				VarSetCapacity(r,16,0)
				NumPut(w,r,8,"uint")
				NumPut(h,r,12,"uint")
				VarSetCapacity(bmdata, 32, 0)
				DllCall("Gdiplus\GdipBitmapLockBits", "Ptr", bm, "Ptr", &r, "uint", 3, "int", 0x26200A, "Ptr", &bmdata)
				scan := NumGet(bmdata, 16, "Ptr")
				p := DllCall("GlobalAlloc", "uint", 0x40, "ptr", 16+((w*h)*4), "ptr")
				DllCall(this._cacheImage,"Ptr",p,"Ptr",scan,"int",w,"int",h,"uchar",255)
				DllCall("Gdiplus\GdipBitmapUnlockBits", "Ptr", bm, "Ptr", &bmdata)
				DllCall("gdiplus\GdipDisposeImage", "ptr", bm)
				VarSetCapacity(props,64,0)
				NumPut(28,props,0,"uint")
				NumPut(1,props,4,"uint")
				if (this.bits) {
					NumPut(w,this.tBufferPtr,0,"uint")
					NumPut(h,this.tBufferPtr,4,"uint")
					if (v := DllCall(this.vTable(this.renderTarget,4),"ptr",this.renderTarget,"int64",NumGet(this.tBufferPtr,"int64"),"ptr",p,"uint",4 * w,"ptr",&props,"ptr*",bitmap) != 0) {
						this.Err("Problem creating D2D bitmap for image '" image "'")
						return 0
					}
				} else {
					if (v := DllCall(this.vTable(this.renderTarget,4),"ptr",this.renderTarget,"uint",w,"uint",h,"ptr",p,"uint",4 * w,"ptr",&props,"ptr*",bitmap) != 0) {
						this.Err("Problem creating D2D bitmap for image '" image "'")
						return 0
					}
				}
				return this.imageCache[image] := {p:bitmap,w:w,h:h}
			}
			CacheFont(name,size) {
				if (DllCall(this.vTable(this.wFactory,15),"ptr",this.wFactory,"wstr",name,"ptr",0,"uint",400,"uint",0,"uint",5,"float",size,"wstr","en-us","ptr*",textFormat) != 0) {
					this.Err("Unable to create font: " name " (size: " size ")","Try a different font or check to see if " name " is a valid font!")
					return 0
				}
				return this.fonts[name size] := textFormat
			}
			__Delete() {
				DllCall("gdiplus\GdiplusShutdown", "Ptr*", this.gdiplusToken)
				DllCall(this.vTable(this.factory,2),"ptr",this.factory)
				DllCall(this.vTable(this.stroke,2),"ptr",this.stroke)
				DllCall(this.vTable(this.strokeRounded,2),"ptr",this.strokeRounded)
				DllCall(this.vTable(this.renderTarget,2),"ptr",this.renderTarget)
				DllCall(this.vTable(this.brush,2),"ptr",this.brush)
				DllCall(this.vTable(this.wfactory,2),"ptr",this.wfactory)
				guiID := this.guiID
				gui %guiID%:destroy
			}
			Mcode(str) {
				local
				s := strsplit(str,"|")
				if (s.length() != 2)
					return
				if (!DllCall("crypt32\CryptStringToBinary", "str", s[this.bits+1], "uint", 0, "uint", 1, "ptr", 0, "uint*", pp, "ptr", 0, "ptr", 0))
					return
				p := DllCall("GlobalAlloc", "uint", 0, "ptr", pp, "ptr")
				if (this.bits)
					DllCall("VirtualProtect", "ptr", p, "ptr", pp, "uint", 0x40, "uint*", op)
				if (DllCall("crypt32\CryptStringToBinary", "str", s[this.bits+1], "uint", 0, "uint", 1, "ptr", p, "uint*", pp, "ptr", 0, "ptr", 0))
					return p
				DllCall("GlobalFree", "ptr", p)
			}
		}

		; ==========================================================
		;                  ShinsImageScanClass
		;      https://github.com/Spawnova/ShinsImageScanClass
		; ==========================================================
		;
		;   Author: Spawnova
		;

		class ShinsImageScanClass {

			;title				:		ahk window title or other type of identifier, leave blank or set to 0 to scan the entire desktop
			;UseClientArea		:		If a window is specified it will use the client area (generally does not include title bar and menus)
			;							Otherwise it will include the entirety of the window, which also includes extra space on the sides
			;							and bottom used for mouse dragging
			__New(title:=0, UseClientArea:=1) {
			
				this.AutoUpdate 		:= 1 	;when disabled, requires you to call Update() manually to refresh pixel data, useful when you need to scan multiple things on 1 frame
				
				this.UseControlClick 	:= 0  	;when enabled attempts to use ControlClick to send clicks which works for background programs
												;not all programs will respond to this however, so it may be necessary to use normal clicks which have to be foreground
												
				this.WindowScale 		:= 1	;if windows has set the desktop scaling to anything other than 100% you can adjust with this variable, for instance if windows scaling is set to 150%, set this variable to 1.5
				
				;#############################
				;	Setup internal stuff
				;#############################
				this.LoadLib("gdiplus")
				VarSetCapacity(gsi, 24, 0)
				NumPut(1,gsi,0,"uint")
				DllCall("gdiplus\GdiplusStartup", "Ptr*", token, "Ptr", &gsi, "Ptr", 0)
				this.gdiplusToken := token
				
				this.bits := (a_ptrsize == 8) ;0=32,1=64
				this.desktop := (title = 0 or title = "")
				this.UseClientArea := UseClientArea
				this.imageCache := []
				this.offsetX := 0
				this.offsetY := 0
				
				if (this.desktop)
					coordmode,mouse,screen
				else if (UseClientArea)
					coordmode,mouse,client
				else
					coordmode,mouse,window
					
				this.tBufferPtr := tBufferPtr := this.SetVarCapacity("ttBuffer",1048576,0)
				this.dataPtr := dataPtr := this.SetVarCapacity("_data",1024,0)
				
				this._scanImage := this.mcode("VVdWU4PsHItEJDSLTCQwi3wkOIt0JDyLEItZCIlEJAyJfCQEi3wkQInViXQkCMHtEDnrD4bHAAAAi3EMD7fSOfIPg7kAAACLQQQp1g+2VCQEKeuJUBAPvlQkCMcAAAAAAMdABAAAAACJWAiJcAyJUBSF/3Q7g/8BdE6D/wJ0WYP/A3Q8g/8EdGeD/wV0aoP/BnRVg/8HdXWLRCQMiUwkMIlEJDSLQUDrCo20JgAAAACLQTCDxBxbXl9d/+CNdCYAi0E86+6NdgCLQTiDxBxbXl9d/+CNdCYAi0E0g8QcW15fXf/gjXQmAItBROvGjXYAi0FM676NdgCLQUjrto12ALj+////g8QcW15fXcO4/////+vxkJCQkJCQkJCQkJCQ|V1ZTiwJEi1kQi3QkQInHwe8QQTn7D4bVAAAAi1kUD7fAOdgPg8cAAABMi1EIQSn7KcNFD7bARQ++yUnHAgAAAABFiVoIQYlaDEWJQhBFiUoUhfZ0M4P+AXRGg/4CdFGD/gN0NIP+BHRng/4FdHKD/gZ0TYP+Bw+FfQAAAEiLQXjrCmYPH0QAAEiLQVhbXl9I/+BmDx9EAABIi0Fw6+5mkEiLQWhbXl9I/+BmDx9EAABIi0FgW15fSP/gZg8fRAAASIuBgAAAAOvDDx+AAAAAAEiLgZAAAADrsw8fgAAAAABIi4GIAAAA66MPH4AAAAAAuP7///9bXl/DuP/////r9Q==")
				this._scanImageArray := this.mcode("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")
				this._scanImageArrayRegion := this.mcode("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")
				this._scanImageCount := this.mcode("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")
				this._scanImageCountRegion := this.mcode("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")
				this._scanImageRegion := this.mcode("VVdWU4PsLItEJESLfCRYi0wkXItcJECLbCRIi1QkVIlEJBCLRCRMiXwkGIt8JGCJTCQciUQkCItEJFCJfCQMhcB5BAHF99iF0nkGAVQkCPfahe0PiNcBAACLTCQIhckPiMsBAACLTCQQiwmJz8HvEDn4D4yYAQAAD7fJOcoPjI0BAACLcwiJdCQUif45fCQUD4KKAQAAi3sMOc8Pgn8BAAAB6ANUJAgp8It0JBQpyonxg+kBOcaLdCQID0LBOdeNT/8PQtGLSwSJcQQx9oXAD0jGhdKJKQ9I1olBCA+2RCQYiVEMiUEQD75EJByJQRSLRCQMhcB0YYN8JAwBD4SGAAAAg3wkDAIPhJMAAACDfCQMA3Rcg3wkDAQPhLkAAACDfCQMBQ+ExgAAAIN8JAwGD4SLAAAAg3wkDAcPhfcAAACLRCQQiVwkQIlEJESLQ3DrFo20JgAAAACLTCQQiVwkQIlMJESLQ1CDxCxbXl9d/+CLRCQQiVwkQIlEJESLQ2jr5o20JgAAAACLRCQQiVwkQIlEJESLQ2CDxCxbXl9d/+CLRCQQiVwkQIlEJESLQ1iDxCxbXl9d/+CQjbQmAAAAAItEJBCJXCRAiUQkRItDeOuWjbQmAAAAAItEJBCJXCRAiUQkRIuDiAAAAOl4////kItEJBCJXCRAiUQkRIuDgAAAAOlg////ifaNvCcAAAAAuPz///+DxCxbXl9dw412ALj+////6+6J9o28JwAAAAC4/f///+veuP/////r15CQ|QVVBVFVXVlOLRCRYRItUJGCLXCRoRItcJHCLdCR4hcB5BUEBwPfYRYXSeQZFAdFB99pFhcAPiFUBAABFhckPiEwBAABEiyJFieVBwe0QRDnoD4wZAQAARQ+35EU54g+MDAEAAIt5EEQ57w+CEAEAAItpFEQ55Q+CBAEAAEQBwEUByg+220UPvttEKehFKeJEjWf/OceNff9BD0LERDnVRA9C10iLeQhEiQdFMcCFwEEPSMBFhdJEiU8ERQ9I0IlfEIlHCESJVwxEiV8UhfZ0MIP+AXRLg/4CdFaD/gN0MYP+BHRsg/4FdHeD/gZ0UoP+Bw+FoAAAAEiLQXjrBw8fAEiLQVhbXl9dQVxBXUj/4JBIi0Fw6+5mLg8fhAAAAAAASItBaFteX11BXEFdSP/gkEiLQWBbXl9dQVxBXUj/4JBIi4GAAAAA67sPH4AAAAAASIuBkAAAAOurDx+AAAAAAEiLgYgAAADrmw8fgAAAAAC4/P///1teX11BXEFdw2aQuP7////r7mYPH4QAAAAAALj9////6964/////+vXkJA=")
				this._scanPixel := this.mcode("V1ZTi1QkEItMJBiLXCQci3IMi0IEi3oID7bJiXAMi3QkFMcAAAAAAMdABAAAAACJeAiJcBCJSBSF23UMW4tCEF5f/+CNdCYAg/sBdDOD+wJ0PoP7A3Qhg/sEdFSD+wV0X4P7BnQ6g/sHdV1bi0IgXl//4JCNdCYAW4tCHF5f/+Bbi0IYXl//4JCNtCYAAAAAW4tCFF5f/+CQjbQmAAAAAFuLQiReX//gkI20JgAAAABbi0IsXl//4JCNtCYAAAAAW4tCKF5f/+BbuP////9eX8OQkJCQkJCQkJCQkJCQkJA=|TItREEiLQQhIxwAAAAAATIlQCEUPtsCJUBBEiUAURYXJdQ1I/2EYZg8fhAAAAAAAQYP5AXQyQYP5AnQ0QYP5A3QeQYP5BHQ4QYP5BXQ6QYP5BnQkQYP5B3UySP9hOGaQSP9hMA8fQABI/2EoDx9AAEj/YSAPH0AASP9hQA8fQABI/2FQDx9AAEj/YUi4/////8OQkJCQkJCQkJCQkJCQkA==")
				this._scanPixelCount := this.mcode("VVdWU4PsJIt0JDiLRCRAi0wkPIteCIt2DIgEJIlcJBCJdCQYhMAPhOQAAACF9g+OTAEAAInIx0QkHAAAAAAx9sH4EMdEJBQAAAAAD7bAiUQkBA+2xYlEJAiNBJ0AAAAAiUQkIA+2wYlEJAyQjXQmAItMJBCFyX5ui0QkOItcJByLTCQgiwCNFJ0AAAAAjSwIjRwQAdWNdgCLEw+2zitMJAiJ0A+20onPwfgQwf8fD7bAK0QkBDH5KfmJx8H/HzH4Kfg4yA9HyCtUJAyJ18H/HzH6Kfo40Q9D0TgUJIPe/4PDBDnddbKDRCQUAYtMJBCLRCQUAUwkHDlEJBgPhW////+DxCSJ8FteX13DkI10JgCLVCQYhdJ+aInYMe0x/zH2weACiQQkjXYAjbwnAAAAAItEJBCFwH4xi0QkOI0crQAAAACLEI0EGgMUJAHTjXYAixCB4v///wA50Q+UwoPABA+20gHWOcN154PHAQNsJBA5fCQYdbqDxCSJ8FteX13Dg8QkMfZbifBeX13DkJCQkA==|QVdBVkFVQVRVV1ZTSIPsGItBFESLcRCJRCQMSYnNRInFRYTAD4S+AAAAhcAPjgoBAACJ1w+2xkSJ80Ux/8H/EEGJxEUx0g+2ykAPtv8PHwBFhfZ+bEGJ2UmLdQBFKfGQRInIixSGD7bGRCngQYnAQcH4H0QxwEQpwEGJwInQD7bSwfgQD7bAKfhBicNBwfsfRDHYRCnYRDjAQQ9GwCnKQYnQQcH4H0QxwkQpwjjQD0LCQDjFQYPa/0GDwQFEOct1n0GDxwFEAfNEOXwkDHWBRInQSIPEGFteX11BXEFdQV5BX8MPH0QAAEGJw4XAfk1FifEx20Ux0mYPH4QAAAAAAEWF9n4qRInITYtFAEQp8JCJwUGLDIiB4f///wA5yg+UwYPAAQ+2yUEBykQ5yHXhg8MBRQHxQTnbdcbrk0Ux0uuOkJCQkJCQkJCQkJCQkJCQ")
				this._scanPixelCountRadius := this.mcode("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")
				this._scanPixelCountRegion := this.mcode("VVdWU4PsKItEJEyLdCREi1wkVItUJEABxotMJFCIHCSJdCQUhcB5DItEJESJdCREiUQkFIt0JEgBzol0JBCFyXkMi0QkSIl0JEiJRCQQi0wkRIXJD4jGAQAAi0QkSIXAD4i6AQAAi0QkPItMJBSLbCQQi3AIOc6NRv+JdCQYD0fBiUQkFInHi0QkPItADI1I/znoD0fNiUwkEITbD4TuAAAAOUwkSA+NagEAAInQD690JEjB6BAPtsCJRCQED7bGiUQkCItEJESJdCQcMfbB4AKJRCQkjQS9AAAAAIlEJCAPtsKJRCQMifaNvCcAAAAAi0QkFDlEJER9bItEJDyLXCQkiyiLRCQcweACAcMB6wNsJCABxY12AIsTD7bOK0wkCInQD7bSic/B+BDB/x8PtsArRCQEMfkp+YnHwf8fMfgp+DjID0fIK1QkDInXwf8fMfop+jjRD0PROBQkg97/g8MEOd11sotcJBiDRCRIAQFcJByLRCQQO0QkSA+Fb////4nwg8QoW15fXcOQjXQmADlMJEgPjXwAAACLRCREi3wkSItsJEjB4AIPr/6JRCQEi0QkFMHgAokEJDHAjXQmAIt0JBQ5dCREfTeLdCQ8i0wkBIsejTS9AAAAAAHxAdkDHCQB3o10JgCLGYHj////ADnaD5TDg8EED7bbAdg58XXng8UBA3wkGDlsJBB1soPEKFteX13Dg8QoMcBbXl9dw7j9////6Vn///+QkJCQkJA=|QVdBVkFVQVRVV1ZTSIPsGIuEJJAAAABBicREiUQkcESLhCSAAAAARIt0JHBIiUwkYIuMJIgAAABFAcZFhcB5DUSLRCRwRIl0JHBFicZGjTwJhcl5CUSJyUWJ+UGJz4tMJHCFyQ+IggEAAEWFyQ+IeQEAAEiLdCRgi14QjUv/RDnziVwkCEQPRvGLThREjUH/RDn5RQ9G+ITAD4TZAAAARTn5D409AQAAi3wkcIneidUPtsZBD6/xwe0QQYnFD7baRCn3QA+27THAiXwkDEQB9kQ5dCRwfXlIi3wkYItMJAxIiz9EjRQxZg8fhAAAAAAARInSiwyXD7bVRCnqQYnQQcH4H0QxwkQpwkGJ0InKD7bJwfoQD7bSKepBidNBwfsfRDHaRCnaRDjCQQ9G0CnZQYnIQcH4H0QxwUQpwTjKD0LRQTjUg9j/QYPCAUQ51nWgQYPBAQN0JAhFOc8PhW////9Ig8QYW15fXUFcQV1BXkFfw2YPH0QAAEU5+X1oQYnaid6LXCRwSItsJGBFD6/Ri3wkcDHARCnzRQHyDx9EAABEOfd9L0yLXQBCjQwTDx8AQYnIR4sEg0GB4P///wBEOcJBD5TAg8EBRQ+2wEQBwEE5ynXcQYPBAUEB8kU5z3XA6Xz///8xwOl1////uP3////pa////5CQkJCQkJCQkJA=")
				this._scanPixelArrayRegion := this.mcode("VbqQ0AMAV1ZTg+wkgXwkVJDQAwAPTlQkVItEJEiLXCRQi3QkOIt8JDyJVCQYi1QkQItsJESIXCQLi0wkTAHCiRQkhcB5C4tEJECJVCRAiQQkjRQpiVQkIIXJeQiJ6InViUQkIItEJECFwA+IoAEAAIXtD4iYAQAAiwwki0YIOciNUP+LRgwPR9GLTCQgiRQkOciNUP8PR9GJVCQghNsPhOwAAAA51Q+NYAEAAIn4x0QkHAAAAADB6BAPtsCJRCQMifgPtsSJRCQQifgPtsCJRCQUiwQkOUQkQA+NlQAAAIsGi1wkQIlEJATrDZCNdCYAg8MBORwkdHyLRgiLfCQED6/FAdiLFIeJ0Q+2xitEJBAPttLB+RAPtskrTCQMic/B/x8x+Sn5icfB/x8x+Cn4OMgPR8grVCQUidfB/x8x+in6ONEPQ9E4VCQLcqSJ2ItWBItMJBzB4BAB6IkEijlMJBgPhJkAAACDRCQcAYPDATkcJHWEg8UBOWwkIA+FUf///4tEJBzrfYn2jbwnAAAAADtsJCB9djHJiwQkOUQkQH1Oix6LRCRAiVwkBOsLjXYAg8ABOQQkdDeLVgiLXCQED6/VAcKLFJOB4v///wA5+nXficKLXgTB4hAB6okUizlMJBh0HIPBAYPAATkEJHXJg8UBOWwkIHWgicjrCI10JgCLRCQYg8QkW15fXcMxwOv0uP3////r7ZCQkJCQkJCQkA==|QVdBVkFVQVRVV1ZTSIPsGL+Q0AMAi6wkmAAAAESLlCSAAAAAi4QkkAAAAIH9kNADAA9P70GJxkSJRCRwi1wkcESLhCSIAAAARAHTRYXSeQxEi1QkcIlcJHBEidNDjTQIiXQkDEWFwHkLRYnIQYnxRIlEJAxEi0QkcEWFwA+IrQEAAEWFyQ+IpAEAAESLQRCLdCQMRY1Q/0E52ESLQRRBD0baRY1Q/0E58EQPR9ZEiVQkDITAD4TmAAAARTnRD41oAQAAQYnUD7bGMf8PtvJBwewQQYnHRQ+25DlcJHAPjaUAAABMiylEi1QkcOsQDx8AQYPCAUQ50w+EiwAAAItBEEEPr8FEAdBBi1SFAInQwfgQD7bARCngQYnAQcH4H0QxwEQpwEGJwA+2xg+20kQp+EGJw0HB+x9EMdhEKdhEOMBBD0bAKfJBidBBwfgfRDHCRCnCONAPQsJBOMZyk0SJ0kyLQQiJ+MHiEEQBykGJFIA5/Q+EoAAAAEGDwgGDxwFEOdMPhXX///9Bg8EBRDlMJAwPhUL///+J+Ot/Dx9EAABEidZFOdEPjX8AAABEi1wkcDH/QTnbfU5MixFEidjrB4PAATnDdD9Ei0EQRQ+vwUEBwEeLBIJBgeD///8AQTnQdd5BicRMi2kIQYn4QcHkEEUBzEeJZIUAOf10HIPAAYPHATnDdcFBg8EBRDnOdaSJ+OsHDx9EAACJ6EiDxBhbXl9dQVxBXUFeQV/DMcDr67j9////6+SQkJCQkJCQkJCQ")
				this._scanPixelPosition := this.mcode("VVdWU4tUJBSLdCQci0wkGItCCIt8JCCLXCQkOfAPho0AAAA5egwPhoQAAAAPr8eLEgHwvgEAAACLFIKJ0CX///8AOch0WTH2hNt0U4nPD7bricYPttLB7xDB/hAPtsSJ+w+2+yn+iffB/x8x/in+D7b5D7bNKfqJ18H/HzH6Kfo51g9N1inIicHB+R8xyCnIOcIPTcI5xQ+dwA+2wInGW4nwXl9dw412AI28JwAAAAC+/v///+vokJCQkJCQkJCQ|i0EQRItUJChEOcAPhp8AAABEOUkUD4aVAAAARA+vyEiLAUUByEKLDIBBuAEAAACJyCX///8AOdB0aEUxwEWE0nRgRQ+2ykGJ0kGJwA+2yUHB6hBBwfgQD7bERQ+20kUp0EWJwkHB+h9FMdBFKdBED7bSD7bWRCnRQYnKQcH6H0Qx0UQp0UE5yEEPTcgp0Jkx0CnQOcEPTMhFMcBBOclBD53ARInAw2YuDx+EAAAAAABBuP7////r6pCQkJCQkJCQ")
				this._scanPixelRegion := this.mcode("VVdWU4PsHIt8JDSLXCQ4i1QkQItEJDCLdCQ8i2wkRIl8JAiLfCRIjQwaiXwkDIt8JEyF0nkGidqJy4nRjVQ1AIXteQaJ9YnWieqF2w+I3gAAAIX2D4jWAAAAOUgID0ZICDlQDA9GUAyJ1YtQBIlyBIt0JAiJSggPtkwkDIkaiWoMiXIQiUoUhf90NYP/AXRQg/8CdFuD/wN0NoP/BHRxg/8FdHyD/wZ0V4P/Bw+FiwAAAIlEJDCLQCDrDJCNdCYAiUQkMItAEIPEHFteX13/4IlEJDCLQBzr7o20JgAAAACJRCQwi0AYg8QcW15fXf/giUQkMItAFIPEHFteX13/4IlEJDCLQCTrvo20JgAAAACJRCQwi0As666NtCYAAAAAiUQkMItAKOuejbQmAAAAALj9////g8QcW15fXcO4/////+vxkJCQkJCQkJCQkJCQ|VlOLRCQ4RItcJECLXCRIi3QkUEaNFACFwHkJRInARYnQQYnCQ40EC0WF23kJRYnLQYnBRInYRYXAD4jhAAAARYXJD4jYAAAARDlREEQPRlEQD7bbOUEUD0ZBFEWJ00GJwkiLQQhEiQBEiUgERIlYCESJUAyJUBCJWBSF9nQyg/4BdE2D/gJ0WIP+A3Qzg/4EdG6D/gV0eYP+BnRUg/4HD4WDAAAASItBOFteSP/gZpBIi0EYW15I/+APH4AAAAAASItBMFteSP/gDx+AAAAAAEiLQShbXkj/4A8fgAAAAABIi0EgW15I/+APH4AAAAAASItBQFteSP/gDx+AAAAAAEiLQVBbXkj/4A8fgAAAAABIi0FIW15I/+APH4AAAAAAuP3///9bXsO4/////+v2kA==")
				
				this.AppendFunc(0,"VVdWU4PsHItEJDCLQASLOItoBItYCItIEIk8JIt4DItAFIl8JBiJRCQEhcAPjr4AAAA5/Q+NlgAAAInIiVwkCMHoEA+2wIlEJAwPtsWJRCQQD7bBiUQkFIs0JItEJAg5xn1gi0QkMItQCIsAD6/VjTyQixS3idHB+RAPtskrTCQMicjB+B8xwSnBD7bGK0QkEA+20onDwfsfMdgp2DnBD0zIK1QkFInTwfsfMdop2jnRD03ROVQkBH0mg8YBOXQkCHWvg8UBOWwkGHWMjXQmALj/////6w+J9o28JwAAAADB5hCNBC6DxBxbXl9dw2aQO2wkGH3ai3wkMDkcJH05i1cIiwcPr9WNNJCLBCTrCJCDwAE5w3QhixSGgeL///8AOcp17IPEHMHgEFsB6F5fXcONtCYAAAAAg8UBOWwkGHW5642QkJCQkJCQkJCQkJCQ|QVdBVkFVQVRVV1ZTSIPsGEiLQQiLaBSLOESLWAREi1AIRItoDItYEIXtD47AAAAARTnrD42PAAAAD7bHQYncRA+2y4lEJAxBwewQRQ+25EQ5131mRItxEEyLOYn7RQ+v80KNBDNBixSHQYnQQcH4EEUPtsBFKeBEicDB+B9BMcBBKcAPtsYrRCQMD7bSicbB/h8x8CnwQTnAQQ9NwEQpyonWwf4fMfIp8jnQD0zCOcV9HoPDAUE52nWnQYPDAUU53XWMDx9EAAC4/////+sIkMHjEEKNBBtIg8QYW15fXUFcQV1BXkFfww8fhAAAAAAARTnrfdNEOdd9PkSLQRBMiwmJ+EUPr8PrDw8fgAAAAACDwAFBOcJ0IEKNFABBixSRgeL///8AOdp15sHgEEQB2OulZg8fRAAAQYPDAUU53XW064WQkJCQkJCQkJCQkJCQ")
				this.AppendFunc(1,"VVdWU4PsKItsJDyLRQSLeAiLEItwDItYBItIEItAFIl8JAiD7wGJFCSJdCQgiUQkBIl8JAyFwA+OywAAADnzD42jAAAAiciJXCQcwegQD7bAiUQkEA+2xYlEJBSNQv+JRCQkD7bBiUQkGIt8JAg5PCR9Y4tUJBwPr1UIi0UAi3QkDI08kIsUt4nRwfkQD7bJK0wkEInIwfgfMcEpwQ+2xitEJBQPttKJw8H7HzHYKdg5wQ9MyCtUJBiJ08H7HzHaKdo50Q9N0TlUJAR9I4PuATt0JCR1r4NEJBwBi0QkHDlEJCB1hY12ALj/////6wuQi1wkHMHmEI0EHoPEKFteX13DjbYAAAAAO1wkIH3ajXr/i3QkCDk0JH0+i1UIi0UAD6/TjTSQi0QkDOsLjXQmAIPoATn4dCGLFIaB4v///wA5ynXsg8QoweAQAdhbXl9dw420JgAAAACDwwE5XCQgdbDrhZCQkJCQkJCQkJCQkJA=|QVdBVkFVQVRVV1ZTSIPsGEiLQQiLcAiLWBSLOESLSAREi2AMRItAEESNbv+F2w+O7AAAAEU54Q+NswAAAESJwESJxQ+2xMHtEIlEJASNR/9AD7btiUQkDEEPtsCJRCQIOfd9dUSLcRBMizlFiepFD6/xQ40EMkGLFIdBidBBwfgQRQ+2wEEp6ESJwMH4H0ExwEEpwA+2xitEJAQPttJBicNBwfsfRDHYRCnYQTnARA9MwCtUJAhBidNBwfsfRDHaRCnaQTnQQQ9N0DnTfTJBg+oBRDtUJAx1mUGDwQFFOcwPhXr///9mLg8fhAAAAAAAuP/////rEWYPH4QAAAAAAEHB4hBDjQQKSIPEGFteX11BXEFdQV5BX8MPH4AAAAAARTnhfcuNX/859308RItREEyLGUSJ6EUPr9HrCw8fQACD6AE52HQhQo0UEEGLFJOB4v///wBEOcJ15sHgEEQByOumZg8fRAAAQYPBAUU5zHW36Xr///+QkJCQkJCQkJCQ")
				this.AppendFunc(2,"VVdWU4PsIItsJDSLVQSLAotyFIt6BItaCIkEJItCDItKEIl0JAiNUP+JVCQEhfYPjtMAAAA5xw+NowAAAI1H/4lcJAyJRCQcicjB6BAPtsCJRCQQD7bFiUQkFA+2wYlEJBiLNCSLRCQMOcZ9X4tUJAQPr1UIi0UAjTyQixS3idHB+RAPtskrTCQQicjB+B8xwSnBD7bGK0QkFA+20onDwfsfMdgp2DnBD0zIK1QkGInTwfsfMdop2jnRD03ROVQkCH0tg8YBOXQkDHWvg2wkBAGLRCQEO0QkHHWHkI10JgC4/////+sSifaNvCcAAAAAi0QkBMHmEAHwg8QgW15fXcONtCYAAAAAOcd91IPvAYl8JAiLfCQEORwkfTyLVQiLRQAPr9eNNJCLBCTrCo12AIPAATnDdCGLFIaB4v///wA5ynXsg8QgweAQWwH4Xl9dw420JgAAAACD7wE7fCQIdbbpev///5CQkJCQkJCQkJA=|QVdBVkFVQVRVV1ZTSIPsGEiLQQhEi0AMi2gUiziLUAREi1AIRItIEEGNWP+F7Q+O3AAAAEQ5wg+NowAAAI1C/0WJzIlEJAxEichBwewQRQ+2yQ+2xEUPtuRBicdEOdd9b0SLQRBIizFBiftED6/DQ40EA4sUhonQwfgQD7bARCngQYnFQcH9H0Qx6EQp6EGJxQ+2xg+20kQp+EGJxkHB/h9EMfBEKfBBOcVBD03FRCnKQYnVQcH9H0Qx6kQp6jnQD0zCOcV9KUGDwwFFOdp1n4PrATtcJAx1gw8fgAAAAAC4/////+sRZg8fhAAAAAAAQcHjEEGNBBtIg8QYW15fXUFcQV1BXkFfww8fgAAAAABEOcJ9y41y/0Q51307RItBEEyLGYn4RA+vw+sMDx9AAIPAAUE5wnQgQo0UAEGLFJOB4v///wBEOcp15cHgEAHY66ZmDx9EAACD6wE583W56Xz///+QkJCQkJCQkJCQkJA=")
				this.AppendFunc(3,"VVdWU4PsKIt8JDyLXwSLcwiLUwyLK4tDBIl0JAyLSxCD7gGLWxSJdCQQjXL/iWwkBIlcJAiJNCSF2w+O0AAAADnQD42oAAAAg+gBiUQkJInIwegQD7bAiUQkFA+2xYlEJBiNRf+JRCQgD7bBiUQkHItcJAw5XCQEfWKLFCQPr1cIiweLXCQQjSyQi1SdAInRwfkQD7bJK0wkFInIwfgfMcEpwQ+2xitEJBgPttKJxsH+HzHwKfA5wQ9MyCtUJByJ1sH+HzHyKfI50Q9N0TlUJAh9LYPrATtcJCB1roMsJAGLBCQ7RCQkdYeNtCYAAAAAuP/////rEYn2jbwnAAAAAIsEJMHjEAHYg8QoW15fXcM50H3cjWj/i0QkBIlsJAiLLCSNcP+LXCQMOVwkBH05i1cIiwcPr9WNHJCLRCQQ6weD6AE58HQhixSDgeL///8AOcp17IPEKMHgEFsB6F5fXcONtCYAAAAAg+0BO2wkCHW06Xr///+QkJCQkJCQkJCQ|QVdBVkFVQVRVV1ZTSIPsGEiLQQiLeAhEi0AMi3AUiyiLUASLWBBEjW//RY1Y/4X2D47aAAAARDnCD42hAAAAjUL/QYncRA+2y4lEJAwPtsdBwewQiUQkBI1F/0UPtuSJRCQIOf19bUSLcRBMizlFiepFD6/zQ40EMkGLFIdBidBBwfgQRQ+2wEUp4ESJwMH4H0ExwEEpwA+2xitEJAQPttKJw8H7HzHYKdhBOcBED0zARCnKidPB+x8x2inaQTnQRA9MwkQ5xn0nQYPqAUQ7VCQIdaFBg+sBRDtcJAx1hJC4/////+sRZg8fhAAAAAAAQcHiEEONBBpIg8QYW15fXUFcQV1BXkFfww8fgAAAAABEOcJ9y41y/0SNVf85/X04RItBEEyLCUSJ6EUPr8PrCIPoAUQ50HQgQo0UAEGLFJGB4v///wA52nXmweAQRAHY66ZmDx9EAABBg+sBQTnzdbvpev///5CQkJCQkJCQkJA=")
				this.AppendFunc(4,"VVdWU4PsIItEJDSLWASLewSLSwiLA4trDIl8JASLexSNcf+JNCSLUxCJfCQIhf8PjrsAAAA5yA+NowAAAIPoAYlEJBiJ0MHoEA+2wIlEJAwPtsaJRCQQD7bCiUQkFDlsJAR9a4tEJDSLEItACIP4AQ+F8gAAAIsEJI08gotEJASLDIcPtt0rXCQQidrB+h8x0ynTicoPtsnB+hAPttIrVCQMidbB/h8x8inyOdMPTNorTCQUic7B/h8x8SnxOcsPTcs5TCQIfXSDwAE5xXWxgywkAYsEJDtEJBh1go10JgC4/////+tdifaNvCcAAAAAOch97IPoAY00tQAAAACJRCQIi0QkBDnofUaLTCQ0i3wkNItZCIs/jQw3g/sBdBDpvAAAAI10JgCDwAE5xXQhixyBgeP///8AOdp17IsUJMHiEAHQg8QgW15fXcONdCYAgywkAYPuBIsEJDtEJAh1oul7////jXYAi3QkBI08hQAAAACJfCQcD6/GAwQkjTyCifCLD4nLwfsQD7bbK1wkDInawfofMdMp0w+21StUJBAPtsmJ1sH+HzHyKfI50w9M2itMJBSJysH6HzHRKdE5yw9NyzlMJAgPjW////+DwAEDfCQcOcV1quny/v//jXYAjQydAAAAAA+v2AMcJI08n+sTjbYAAAAAg8ABAc85xQ+ES////4sfgeP///8AOdN15+km////kJCQkJCQkJCQkA==|QVdBVkFVQVRVV1ZTSIPsGEiLQQhEi1AIi3gURIsIRItYBESLQAyLUBBBjUL/hf8PjrsAAABFOdEPjaoAAABBjXH/idWJdCQIwe0QD7b2D7bSQA+27UGJ90U5w315RItpEEyLIUWJ2UGD/QEPhe8AAABGjRQIQ4sclA+290GJ8kUp+kSJ1sH+H0Ex8kEp8kSJ1kGJ2g+220HB+hBFD7bSQSnqRYnVQcH9H0Ux6kUp6kQ51kQPTdYp04newf4fMfMp80E52kQPTNNEOdd9aEGDwQFFOch1m4PoATtEJAgPhXX///8PH0QAALj/////60yQRTnRffNBjXn/RTnDfVKLaRBIixlFidmD/QF0FenfAAAADx+AAAAAAEGDwQFFOch0L0aNFAhGixSTQYHi////AEQ50nXjweAQRAHISIPEGFteX11BXEFdQV5BX8MPH0AAg+gBOfh1ouuPDx+AAAAAAEUPr81EiVwkDEWNNAFFidlFifJDixyUQYnbD7b3D7bbQcH7EEUPtttBKetFidpBwfofRTHTRSnTQYnyRSn6RInWwf4fQTHyQSnyRTnTRQ9M2inTQYnaQcH6H0Qx00Qp00E520QPTNtEOd8PjWX///9Bg8EBRQHuRTnIdZREi1wkDOnw/v//Zi4PH4QAAAAAAESJ3g+v9QHG6xVmDx9EAABBg8EBAe5FOcgPhEH///9BifJGixSTQYHi////AEE50nXe6Q7///+QkJCQkJCQkJA=")
				this.AppendFunc(5,"VVdWU4PsJItsJDiLRQSLcASLOItQCItYDIl0JASLcBCLQBSJPCSJVCQciUQkCIXAD47aAAAAOdcPjbIAAACJ8IlcJAzB6BAPtsCJRCQQifAPtsSJRCQUifAPtsCJRCQYi3wkBItEJAw5x31ui0UIi1UAjTSFAAAAAA+vxwMEJIl0JCCNNIKLFonRwfkQD7bJK0wkEInIwfgfMcEpwQ+2xitEJBQPttKJw8H7HzHYKdg5wQ9MyCtUJBiJ08H7HzHaKdo50Q9N0TlUJAh9M4PHAQN0JCA5fCQMdayDBCQBiwQkOUQkHA+Fdf///5CNdCYAuP/////rEYn2jbwnAAAAAIsEJMHgEAH4g8QkW15fXcM5FCR924tMJAQ52X1Li0UIi1UAjTyFAAAAAA+vwQMEJI0MgotUJATrEI20JgAAAACDwgEB+TnTdB+LASX///8AOfB17IsEJIPEJFteweAQX10B0MONdCYAgwQkAYsEJDlEJBx1oOl2////kJCQkJCQ|QVdBVkFVQVRVV1ZTSIPsGEiLQQiLaBREixCLWAREi2gIRItIDESLWBCF7Q+O3wAAAEU56g+NpgAAAESJ2EWJ3A+2xEHB7BCJRCQIQQ+2w0UPtuSJRCQMRDnLfXJEi3EQQYnbTIs5id9FD6/eRQHTRInYQYsUh0GJ0EHB+BBFD7bARSngRInAwfgfQTHAQSnAD7bGK0QkCA+20onGwf4fMfAp8EE5wEQPTMArVCQMidbB/h8x8inyQTnQRA9MwkQ5xX0tg8cBRQHzQTn5daFBg8IBRTnVdYBmDx+EAAAAAAC4/////+sRZg8fhAAAAAAAQcHiEEGNBDpIg8QYW15fXUFcQV1BXkFfww8fgAAAAABFOep9y0Q5y30+i3EQidpIizlBidgPr9ZEAdLrDg8fAEGDwAEB8kU5wXQdidCLBIcl////AEQ52HXmQcHiEEONBALrpA8fQABBg8IBRTnVdbTpev///5CQkJCQkJCQkJA=")
				this.AppendFunc(6,"VVdWU4PsKItEJDyLWASLewyLSwiLcwSLaxSLA4tTEIl8JAyNWf+D7wGJdCQEiRwkiXwkCIXtD47EAAAAOcgPjbQAAACD6AGJRCQgidDB6BAPtsCJRCQQD7bGiUQkFI1G/4lEJBwPtsKJRCQYi3wkDDl8JAR9a4tEJDyLEItACIP4AQ+F+AAAAIsEJI08gotEJAiLDIcPtt0rXCQUidrB+h8x0ynTicoPtsnB+hAPttIrVCQQidbB/h8x8inyOdMPTNorTCQYic7B/h8x8SnxOcsPTcs5zX18g+gBOUQkHHWxgywkAYsEJDtEJCAPhXr///+NtgAAAAC4/////+tdkDnIffSD6AGJ34lEJBCLRCQEwecCjUj/i1wkDDlcJAR9R4tEJDyLKItwCItEJAiNXD0Ag/4BdBDpxAAAAI10JgCD6AE5wXQhizSDgeb///8AOfJ17IsUJMHiEAHQg8QoW15fXcONdCYAgywkAYPvBIsEJDlEJBB1n+l7////jXYAjQyFAAAAAPfZiUwkJItMJAgPr8EDBCSNPIKJyIsPicvB+xAPttsrXCQQidrB+h8x0ynTD7bVK1QkFA+2yYnWwf4fMfIp8jnTD0zaK0wkGInKwfofMdEp0TnLD03LOc0PjW////+D6AEDfCQkO0QkHHWq6er+//+J9o28JwAAAACNHLUAAAAAD6/wAzQk99uNbLUA6xCNdgCD6AEB3TnID4RD////i3UAgeb///8AOdZ15ukd////kJCQkJCQkJCQ|QVdBVkFVQVRVV1ZTSIPsGEiLQQhEi1gMi1AIRItQFIs4i3AEi1gQQY1r/41C/0WF0g+O2QAAADnXD43BAAAAD7bXg+8BRA+2+0GJ9UGJ1o1W/4l8JASJ34kUJMHvEEAPtv9FOd0PjYQAAABEi2EQSIsxiepBg/wBD4UCAQAASIlMJGBEjQQQQoschg+2z0GJyUUp8UWJyEHB+B9FMcFFKcFBidgPtttBwfgQRQ+2wEEp+EWJxEHB/B9FMeBFKeBFOcFFD03BRCn7QYncQcH8H0Qx40Qp40E52EQPTMNFOcJ9coPqATkUJHWZSItMJGCD6AE7RCQED4Vm////Dx9AALj/////61JmDx+EAAAAAAA5133sg+8BRI1W/0Q53n1QRItpEEyLCYnqQYP9AXQR6ewAAAAPH0AAg+oBQTnSdDBEjQQQR4sEgUGB4P///wBEOcN15MHgEAHQSIPEGFteX11BXEFdQV5BX8NmDx9EAACD6AE5+HWk64cPH4AAAAAAQQ+v1ESJXCQMSIlMJGBEiWwkCI0cAonqQYndRYnoQoschkGJ2Q+2zw+220HB+RBFD7bJQSn5RYnIQcH4H0UxwUUpwUGJyEUp8EWJw0HB+x9FMdhFKdhFOcFFD0zIRCn7QYnYQcH4H0Qxw0Qpw0E52UQPTMtFOcoPjVf///+D6gFFKeU7FCR1k0SLbCQIRItcJAxIi0wkYOnT/v//Dx9AAEGJ7EUPr+VBAcTrEw8fQACD6gFFKexEOdIPhDH///9FieBHiwSBQYHg////AEE52HXe6f3+//+QkJCQkJCQkJA=")
				this.AppendFunc(7,"VVdWU4PsLItsJECLRQSLeAyLMItQBItICItYEItAFIl8JBCD7wGJNCSJVCQIiUwkIIlEJAyJfCQEhcAPjt8AAAA5zg+NtwAAAInYwegQD7bAiUQkFA+2x4lEJBiNQv+JRCQoD7bDiUQkHIt8JBA5fCQIfXSLRQiLdCQEjRSFAAAAAPfaD6/GAwQkiVQkJItVAI08gosXidHB+RAPtskrTCQUicjB+B8xwSnBD7bGK0QkGA+20onDwfsfMdgp2DnBD0zIK1QkHInTwfsfMdop2jnRD03ROVQkDH01g+4BA3wkJDt0JCh1rIMEJAGLBCQ5RCQgD4Vx////jbQmAAAAALj/////6xGJ9o28JwAAAACLBCTB4BAB8IPELFteX13DOQwkfduNev+LdCQQOXQkCH1Oi0UIi1UAjTSFAAAAAA+vRCQEAwQk996NDIKLVCQE6w+NtgAAAACD6gEB8Tn6dB+LASX///8AOdh17IsEJIPELFteweAQX10B0MONdCYAgwQkAYsEJDlEJCB1m+lu////kJCQkJCQkJCQkJCQkJA=|QVdBVkFVQVRVV1ZTSIPsGEiLQQiLaAyLeBREiwhEi2AERItoCItYEI11/4X/D47tAAAARTnpD420AAAAidjB6BAPtsCJBCQPtseJRCQEQY1EJP+JRCQMD7bDiUQkCEE57H17RItxEEGJ8kyLOYnzRQ+v1kUBykSJ0EGLFIdBidBBwfgQRQ+2wEQrBCREicDB+B9BMcBBKcAPtsYrRCQED7bSQYnDQcH7H0Qx2EQp2EE5wEQPTMArVCQIQYnTQcH7H0Qx2kQp2kE50EEPTdA5130ug+sBRSnyO1wkDHWYQYPBAUU5zQ+Fc////w8fRAAAuP/////rEWYPH4QAAAAAAEHB4RBBjQQZSIPEGFteX11BXEFdQV5BX8MPH4AAAAAARTnpfctBjXwk/0E57H1BRItREInyTIsZQYnwQQ+v0kQByusQDx9AAEGD6AFEKdJBOfh0HInQQYsEgyX///8AOdh15UHB4RBDjQQB65sPHwBBg8EBRTnNdbHpcv///5CQ")
				
				
				this.AppendFunc(8,"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")
				this.AppendFunc(9,"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")
				this.AppendFunc(10,"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")
				this.AppendFunc(11,"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")
				this.AppendFunc(12,"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")
				this.AppendFunc(13,"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")
				this.AppendFunc(14,"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")
				this.AppendFunc(15,"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")	

				this._cacheTargetImageFile := this.mcode("U4tMJBQPr0wkEIXJfiGLRCQIi1QkDI0ciI20JgAAAACLCIPABIPCBIlK/DnYdfG4AQAAAFvDkJCQkJCQkJCQkA==|RQ+vwUWFwH50TI1JD0GNQP9JKdFJg/kedm6D+AN2aUWJwTHAQcHpAknB4QQPH0AA8w9vBAEPEQQCSIPAEEw5yHXuRInAg+D8QfbAA3QvQYnBRosUiUaJFIpEjUgBRTnIfhtNY8mDwAJGixSJRokUikE5wH4ISJiLDIGJDIK4AQAAAMMPH0QAAEGJwDHADx8ARIsMgUSJDIJJicFIg8ABTTnBdey4AQAAAMOQkJCQkJA=")
				
				this.scanTypes := []
				this.scanTypes["LRTB"] := 0
				this.scanTypes["RLTB"] := 2
				this.scanTypes["LRBT"] := 1
				this.scanTypes["RLBT"] := 3
				this.scanTypes["TBRL"] := 7
				this.scanTypes["TBLR"] := 6
				this.scanTypes["BTRL"] := 5
				this.scanTypes["BTLR"] := 4
				this.scanTypes[0] := 0

				if (!this.desktop and !this.hwnd := winexist(title)) {
					msgbox % "Could not find window: " title "!`n`nScanner will not function!"
					return
				}
				if (!this.GetRect(gw,gh))
					return
				
				this.width := gw
				this.height := gh
				this.srcDC := DllCall("GetDCEx", "Ptr", (this.desktop ? 0 : this.hwnd),"Uint",0,"Uint",(this.UseClientArea ? 0 : 1))
				this.dstDC := DllCall("CreateCompatibleDC", "Ptr", 0)
				NumPut(tBufferPtr,dataPtr+0,(this.bits ? 8 : 4),"Ptr")
				this.CreateDIB()
				
			}
			
			
			;####################################################################################################################################################################################################################################
			;Image
			;
			;image				:				Path to image file
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;&returnX			:				Variable to store the x result into
			;&returnY			:				Variable to store the y result into
			;centerResults		:				Return the results centered on the image
			;scanDir			:				Scanning direction, default = LRTB (scan left to right, from top to bottom)
			;
			;return				;				Returns 1 if the image was found; 0 otherwise
			
			Image(image,variance=0,ByRef returnX=0,ByRef returnY=0,centerResults=0,scanDir:=0) {
				if (!this.CacheImage(image))
					return 0
				if (this.AutoUpdate)
					this.Update()
				data := DllCall(this._ScanImage,"Ptr",this.dataPtr,"Ptr",this.imageCache[image],"uchar",variance,"uchar",centerResults,"int",this.scanTypes[scanDir],"int")
				if (data >= 0) {
					this.MapCoords(data,returnX,returnY)
					return 1
				}
				return 0
			}
			
			
			;####################################################################################################################################################################################################################################
			;ImageRegion
			;
			;image				:				Path to image file
			;x1					:				Top left starting x position
			;y1					:				Top left starting y position
			;w					:				Width of pixels to search, starting from x1
			;h					:				Height of pixels to search, starting from y1
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;&returnX			:				Variable to store the x result into
			;&returnY			:				Variable to store the y result into
			;centerResults		:				Return the results centered on the image
			;scanDir			:				Scanning direction, default = LRTB (scan left to right, from top to bottom)
			;
			;return				;				Returns 1 if the image was found in the specified region; 0 otherwise
			
			ImageRegion(image,x1,y1,w,h,variance=0,ByRef returnX=0,ByRef returnY=0,centerResults=0,scanDir:=0) {
				if (!this.CacheImage(image))
					return 0
				if (this.AutoUpdate)
					this.Update(x1,y1,w,h)
				data := DllCall(this._ScanImageRegion,"Ptr",this.dataPtr,"Ptr",this.imageCache[image],"int",(this.autoUpdate?0:x1),"int",(this.autoUpdate?0:y1),"int",w,"int",h,"uchar",variance,"uchar",centerResults,"int",this.scanTypes[scanDir],"int")
				if (data >= 0) {
					this.MapCoords(data,returnX,returnY)
					return 1
				}
				return 0
			}
			
			
			;####################################################################################################################################################################################################################################
			;ImageCount
			;
			;image				:				Path to image file
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;
			;return				;				Returns the amount of images found; 0 otherwise
			
			ImageCount(image,variance=0) {
				if (!this.CacheImage(image))
					return 0
				if (this.AutoUpdate)
					this.Update()
				c := DllCall(this._ScanImageCount,"Ptr",this.dataPtr,"Ptr",this.imageCache[image],"uchar",variance,"int")
				return (c > 0 ? c : 0)
			}
			
			
			;####################################################################################################################################################################################################################################
			;ImageCountRegion
			;
			;image				:				Path to image file
			;x1					:				Top left starting x position
			;y1					:				Top left starting y position
			;w					:				Width of pixels to search, starting from x1
			;h					:				Height of pixels to search, starting from y1
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;
			;return				;				Returns the amount of images found in the specified region; 0 otherwise
			
			ImageCountRegion(image,x1,y1,w,h,variance=0) {
				if (!this.CacheImage(image))
					return 0
				if (this.AutoUpdate)
					this.Update(x1,y1,w,h)
				c := DllCall(this._ScanImageCountRegion,"Ptr",this.dataPtr,"Ptr",this.imageCache[image],"int",(this.autoUpdate?0:x1),"int",(this.autoUpdate?0:y1),"int",w,"int",h,"uchar",variance,"int")
				return (c > 0 ? c : 0)
			}


			;####################################################################################################################################################################################################################################
			;ImageClosestToPoint
			;
			;image				:				Path to image file
			;pointX				:				x position of the point
			;pointY				:				y position of the point
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;&returnX			:				Variable to store the x result into
			;&returnY			:				Variable to store the y result into
			;centerResults		:				Value between 0-1, if enabled the positions returned will be centered as oposed to top left of the target image
			;									This also affects distance calculations for closest image
			;MaxRadius			:				Maximum circular radius to search in; lower values require images to be closer to the point
			;
			;return				;				Returns 1 if an image was found close enough to the point; 0 otherwise
			
			ImageClosestToPoint(image,pointX,pointY,variance=0,byref returnX=0,byref returnY=0,centerResults=0,maxRadius=9999) {
				if (!c := this.ImageArray(image,a,variance,centerResults))
					return 0
				min := maxRadius
				i := 0
				loop % c {
					xd := (a[a_index].x/this.windowScale) - pointX
					yd := (a[a_index].y/this.windowScale) - pointY
					dist := sqrt(xd*xd + yd*yd)
					if (dist < min) {
						min := dist
						i := a_index
					}
				}
				if (i = 0)
					return 0
				returnX := a[i].x
				returnY := a[i].y
				return 1
			}
			
			
			;####################################################################################################################################################################################################################################
			;ImageArray
			;
			;image				:				Path to image file
			;&array				:				An array which will hold all the image locations (first element would be array[1].x and array[1].y)
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;centerResults		:				Value between 0-1, if enabled the positions returned will be centered as oposed to top left of the target image
			;
			;return				;				Returns 1 (and updates &array) if any number of images were found; 0 otherwise
			
			ImageArray(image,byref array,variance=0,centerResults=0) {
				if (!this.CacheImage(image))
					return 0
				if (this.AutoUpdate)
					this.Update()
				count := DllCall(this._ScanImageArray,"Ptr",this.dataPtr,"Ptr",this.imageCache[image],"uchar",variance,"uchar",centerResults,"int")
				if (count > 0) {
					array := []
					loop % count {
						this.MapCoords(NumGet(this.tBufferPtr,(a_index-1)*4,"uint"),x,y)
						array.push({x:x,y:y})
					}
					return count
				}
				return 0
			}
			
			
			;####################################################################################################################################################################################################################################
			;ImageArrayRegion
			;
			;image				:				Path to image file
			;&array				:				An array which will hold all the image locations (first element would be array[1].x and array[1].y)
			;x1					:				Top left starting x position
			;y1					:				Top left starting y position
			;w					:				Width of pixels to search, starting from x1
			;h					:				Height of pixels to search, starting from y1
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;centerResults		:				Value between 0-1, if enabled the positions returned will be centered as oposed to top left of the target image
			;
			;return				;				Returns 1 (and updates &array) if any number of images were found in the specified region; 0 otherwise
			
			ImageArrayRegion(image,byref array,x1,y1,w,h,variance=0,centerResults=0) {
				if (!this.CacheImage(image))
					return 0
				if (this.AutoUpdate)
					this.Update(x1,y1,w,h)
				count := DllCall(this._ScanImageArrayRegion,"Ptr",this.dataPtr,"Ptr",this.imageCache[image],"int",(this.autoUpdate?0:x1),"int",(this.autoUpdate?0:y1),"int",w,"int",h,"uchar",variance,"uchar",centerResults,"int")
				if (count > 0) {
					array := []
					loop % count {
						this.MapCoords(NumGet(this.tBufferPtr,(a_index-1)*4,"uint"),x,y)
						array.push({x:x,y:y})
					}
					return count
				}
				return 0
			}
			
			
			;####################################################################################################################################################################################################################################
			;Pixel
			;
			;color				:				Color of pixel to find (can be in 0xRRGGBB or 0xAARRGGBB format; alpha is ignored)
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;&returnX			:				Variable to store the x result into
			;&returnY			:				Variable to store the y result into
			;scanDir			:				Scanning direction, default = LRTB (scan left to right, from top to bottom)
			;
			;return				;				Returns 1 if pixel was found; 0 otherwise
			
			Pixel(color,variance=0,ByRef returnX=0,ByRef returnY=0,scanDir:=0) {
				if (this.AutoUpdate)
					this.Update()
				data := DllCall(this._ScanPixel,"Ptr",this.dataPtr,"Uint",color&0xFFFFFF,"uchar",variance,"int",this.scanTypes[scanDir],"int")
				if (data >= 0) {
					this.MapCoords(data,returnX,returnY)
					return 1
				}
				return 0
			}
			
			
			;####################################################################################################################################################################################################################################
			;PixelRegion
			;
			;color				:				Color of pixel to find (can be in 0xRRGGBB or 0xAARRGGBB format; alpha is ignored)
			;x1					:				Top left starting x position
			;y1					:				Top left starting y position
			;w					:				Width of pixels to search, starting from x1
			;h					:				Height of pixels to search, starting from y1
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;&returnX			:				Variable to store the x result into
			;&returnY			:				Variable to store the y result into
			;scanDir			:				Scanning direction, default = LRTB (scan left to right, from top to bottom)
			;
			;return				;				Returns 1 if a pixel inside the specified region was found; 0 otherwise
			
			PixelRegion(color,x1,y1,w,h,variance=0,byref returnX=0,byref returnY=0,scanDir:=0) {
				if (this.AutoUpdate)
					this.Update(x1,y1,w,h)
				data := DllCall(this._ScanPixelRegion,"Ptr",this.dataPtr,"Uint",color&0xFFFFFF,"int",(this.autoUpdate?0:x1),"int",(this.autoUpdate?0:y1),"int",w,"int",h,"uchar",variance,"int",this.scanTypes[scanDir],"int")
				if (data >= 0) {
					this.MapCoords(data,returnX,returnY)
					return 1
				}
				return 0
			}
			
			
			;####################################################################################################################################################################################################################################
			;PixelPosition
			;
			;color				:				Color of pixel to match at a given position(can be in 0xRRGGBB or 0xAARRGGBB format; alpha is ignored)
			;pointX				:				X position
			;pointY				:				Y position
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;
			;return				;				Returns 1 if the color matched at the specified position; 0 otherwise
			
			PixelPosition(color,pointX,pointY,variance=0) {
				if (this.AutoUpdate)
					this.Update()
				c := DllCall(this._ScanPixelPosition,"Ptr",this.dataPtr,"Uint",color&0xFFFFFF,"uint",pointX,"uint",pointY,"uint",variance,"int")
				return (c == 1 ? 1 : 0)
			}
			
			
			;####################################################################################################################################################################################################################################
			;PixelCount
			;
			;color				:				Color of pixel to find (can be in 0xRRGGBB or 0xAARRGGBB format; alpha is ignored)
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;
			;return				;				Returns the amount of matching pixels; 0 otherwise
			
			PixelCount(color,variance=0) {
				if (this.AutoUpdate)
					this.Update()
				c := DllCall(this._ScanPixelCount,"Ptr",this.dataPtr,"Uint",color&0xFFFFFF,"uchar",variance,"int")
				return (c > 0 ? c : 0)
			}
			
			
			;####################################################################################################################################################################################################################################
			;PixelCountRegion
			;
			;color				:				Color of pixel to find (can be in 0xRRGGBB or 0xAARRGGBB format; alpha is ignored)
			;x1					:				Top left starting x position
			;y1					:				Top left starting y position
			;w					:				Width of pixels to search, starting from x1
			;h					:				Height of pixels to search, starting from y1
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;
			;return				;				Returns the amount of matching pixels in the specified region; 0 otherwise
			
			PixelCountRegion(color,x1,y1,w,h,variance=0) {
				if (this.AutoUpdate)
					this.Update(x1,y1,w,h)
				c := DllCall(this._ScanPixelCountRegion,"Ptr",this.dataPtr,"Uint",color&0xFFFFFF,"int",(this.autoUpdate?0:x1),"int",(this.autoUpdate?0:y1),"int",w,"int",h,"uchar",variance,"int")
				return (c > 0 ? c : 0)
			}
			
			
			
			;####################################################################################################################################################################################################################################
			;PixelCountRadius
			;
			;color				:				Color of pixel to find (can be in 0xRRGGBB or 0xAARRGGBB format; alpha is ignored)
			;pointX				:				X position
			;pointY				:				Y position
			;radius				:				Radius to search in
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;
			;return				;				Returns the amount of matching pixels in a specified radius; 0 otherwise
			
			PixelCountRadius(color,pointX,pointY,radius,variance=0) {
				if (this.AutoUpdate)
					this.Update()
				c := DllCall(this._ScanPixelCountRadius,"Ptr",this.dataPtr,"Uint",color&0xFFFFFF,"uint",pointX,"uint",pointY,"uint",radius,"uchar",variance,"int")
				return (c > 0 ? c : 0)
			}
			
			
			;####################################################################################################################################################################################################################################
			;PixelArrayRegion
			;
			;color				:				Color of pixel to find (can be in 0xRRGGBB or 0xAARRGGBB format; alpha is ignored)
			;x1					:				Top left starting x position
			;y1					:				Top left starting y position
			;w					:				Width of pixels to search, starting from x1
			;h					:				Height of pixels to search, starting from y1
			;variance			:				Value between 0-255, determines how close/far pixels must be to match the target color
			;maxResults			:				Maximum amount of results to find anything above 250k will be ignored
			;
			;return				;				Returns the amount of matching pixels in the specified region; 0 otherwise
			
			PixelArrayRegion(color,byref array,x1,y1,w,h,variance=0,maxResults=1000) {
				if (this.AutoUpdate)
					this.Update(x1,y1,w,h)
				count := DllCall(this._ScanPixelArrayRegion,"Ptr",this.dataPtr,"Uint",color&0xFFFFFF,"int",(this.autoUpdate?0:x1),"int",(this.autoUpdate?0:y1),"int",w,"int",h,"uchar",variance,"uint",maxResults,"int")
				if (count > 0) {
					array := []
					loop % count {
						this.MapCoords(NumGet(this.tBufferPtr,(a_index-1)*4,"uint"),x,y)
						array.push({x:x,y:y}) ;for large amounts of results, like 50k+ becomes a bottleneck to add to array
					}
					return count
				}
				return 0
			}
			
			
			;####################################################################################################################################################################################################################################
			;GetPixel
			;
			;pointX				:				X position
			;pointY				:				Y position
			;suppressWarning    :               Enable/Disable warning message when scanning outside the region
			;
			;return				;				Returns the pixel at the pointX,pointY location
			
			GetPixel(pointX,pointY,suppressWarning:=0) {
				if (this.AutoUpdate)
					this.Update()
				pointX<<=0,pointY<<=0
				if (pointX < 0 or pointY < 0 or pointX >= this.width or pointY >= this.height) {
					if (!suppressWarning)
						msgbox % "Cannot get a pixel at position: " pointX "," pointY " as it lies outside of the source region!`n`nYou can disable this warning using the 3rd param of GetPixel()"
					return 0
				}
				return NumGet(this.temp0,(pointX+pointY*this.width)*4,"uint") & 0xFFFFFF
			}
			
			
			;####################################################################################################################################################################################################################################
			;SaveImage
			;
			;name				:				Name to save to file to
			;x					:				X pos of region
			;y					:				Y pos of region
			;w					:				Width of region, defaults to entire image
			;h					:				Height of region, defaults to entire image
			;
			;notes				;				Saves the current pixel buffer to a png image
			
			SaveImage(name,x:=0,y:=0,w:=0,h:=0) {
				if (!InStr(name,".png"))
					name .= ".png"
				if (this.CheckWindow()) {
					if (x!=0 or y!=0 or w!=0 or h!=0) {
						dstDC := DllCall("CreateCompatibleDC", "Ptr", 0)
						VarSetCapacity(_scan,8)
						VarSetCapacity(bi,40,0)
						NumPut(w,bi,4,"int"),NumPut(-h,bi,8,"int"),NumPut(40,bi,0,"uint"),NumPut(1,bi,12,"ushort"),NumPut(32,bi,14,"ushort")
						hbm := DllCall("CreateDIBSection", "Ptr", dstDC, "Ptr", &bi, "uint", 0, "Ptr*", _scan, "Ptr", 0, "uint", 0, "Ptr")
						DllCall("SelectObject", "Ptr", dstDC, "Ptr", hbm)
						DllCall("gdi32\BitBlt", "Ptr", dstDC, "int", 0, "int", 0, "int", (w=0?this.width:w), "int", (h=0?this.height:h), "Ptr", this.srcDC, "int", x, "int", y, "uint", 0xCC0020) ;40
						DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr", hbm, "Ptr", 0, "Ptr*", bm)
					} else {
						DllCall("gdi32\BitBlt", "Ptr", this.dstDC, "int", 0, "int", 0, "int", this.width, "int", this.height, "Ptr", this.srcDC, "int", 0, "int", 0, "uint", 0xCC0020) ;40
						DllCall("gdiplus\GdipCreateBitmapFromHBITMAP", "Ptr", this.hbm, "Ptr", 0, "Ptr*", bm)
					}
				}
				
				;largely borrowed from tic function, encoder stuff is a pain
				DllCall("gdiplus\GdipGetImageEncodersSize", "uint*", nCount, "uint*", nSize)
				VarSetCapacity(ci, nSize)
				DllCall("gdiplus\GdipGetImageEncoders", "uint", nCount, "uint", nSize, "Ptr", &ci)
				if !(nCount && nSize) {
					msgbox % "Problem getting encoder information"
					return 0
				}
				Loop % nCount {
					sString := StrGet(NumGet(ci, (idx := (48+7*A_PtrSize)*(A_Index-1))+32+3*A_PtrSize), "UTF-16") ;Thanks tic, this particularily confused me!
					if (InStr(sString, "*.PNG")) {
						pCodec := &ci+idx
						break
					}
				}
				if (!pCodec) {
					msgbox % "Problem finding png codec"
					return 0
				}
				DllCall("gdiplus\GdipSaveImageToFile", "Ptr", bm, "Ptr", &name, "Ptr", pCodec, "uint", 0)
			}
			
			
			;####################################################################################################################################################################################################################################
			;Click
			;
			;pointX				:				X position to click
			;pointY				:				Y position to click
			;button				:				Type of click (left,right,middle)
			;
			;return				;				Returns 1 on success; 0 otherwise
			;
			;notes				:				ControlClick will not work for every application
			
			Click(pointX,pointY,button:="left") {
				if (this.UseControlClick) {
					t := "ahk_id " this.hwnd
					ControlClick, x%pointX% y%pointY%, %t%,,%button%,,NA D
					Sleep 300
					ControlClick, x%pointX% y%pointY%, %t%,,%button%,,NA U
				} else {
					if (!WinActive("ahk_id " this.hwnd)) {
						msgbox % "Attempting to click in target window but it is not active!`n`nIf you want to click inactive windows set 'UseControlClick' to true after initializing the class"
						return 0
					}
					click,%pointX%,%pointY%,%button%
				}
				return 1
			}
			
			
			;####################################################################################################################################################################################################################################
			;ClickDrag
			;
			;pointX1			:				X position to start click
			;pointY1			:				Y position to start click
			;pointX2			:				X position to end click
			;pointY2			:				Y position to end click
			;button				:				Type of click (left,right,middle)
			;
			;return				;				Returns 1 on success; 0 otherwise
			;
			;notes				:				ControlClick will not work for every application
			
			ClickDrag(pointX1,pointY1,pointX2,pointY2,button:="left") {
				if (this.UseControlClick) {
					t := "ahk_id " this.hwnd
					ControlClick, x%pointX1% y%pointY1%, %t%,,%button%,,NA D
					Sleep 10
					ControlClick, x%pointX2% y%pointY2%, %t%,,%button%,,NA U
				} else {
					if (!WinActive("ahk_id " this.hwnd)) {
						msgbox % "Attempting to click in target window but it is not active!`n`nIf you want to click inactive windows set 'UseControlClick' to true after initializing the class"
						return 0
					}
					MouseClickDrag,%button%,%pointX1%,%pointY1%,%pointX2%,%pointY2%
				}
				return 1
			}
			
			
			;####################################################################################################################################################################################################################################
			;ClickRegion
			;
			;pointX				:				X position to click
			;pointY				:				Y position to click
			;w					:				Width of region
			;h					:				Height of region
			;button				:				Type of click (left,right,middle)
			;
			;return				;				Returns 1 on success; 0 otherwise
			;
			;notes				:				Clicks randomly within the specified region
			
			ClickRegion(pointX,pointY,w,h,button:="left") {
				this.CheckRegion(pointX,pointY,w,h)
				pointX += this.Random(0,w)
				pointY += this.Random(0,h)
				return this.Click(pointX,pointY,button)
			}
			
			
			;####################################################################################################################################################################################################################################
			;GetImageDimensions
			;
			;image				:				Image file
			;&w					:				Variable to store the width result into
			;&h					:				Variable to store the height result into
			;
			;return				;				Returns void
			;
			;notes				:				Gets the width/height of a cached image
			
			GetImageDimensions(image,byref w, byref h) {
				if (!this.imageCache[image]) {
					this.cacheImage(image)
				}
				w := numget(this.imageCache[image],2,"ushort")
				h := numget(this.imageCache[image],0,"ushort")
			}
			
			
			
			SetTargetImageFile(image) {
				local
				if (image = "") {
					msgbox % "Error, expected resource image path but empty variable was supplied!"
					return 0
				}
				if (!FileExist(image)) {
					msgbox % "Error finding resource image: '" image "' does not exist!"
					return 0
				}

				DllCall("gdiplus\GdipCreateBitmapFromFile", "Ptr", &image, "Ptr*", bm)
				DllCall("gdiplus\GdipGetImageWidth", "Ptr", bm, "Uint*", w)
				DllCall("gdiplus\GdipGetImageHeight", "Ptr", bm, "Uint*", h)
				this.srcDC := DllCall("CreateCompatibleDC", "Ptr", 0)
				this.width := w
				this.height := h
				VarSetCapacity(_scan,8)
				VarSetCapacity(bi,40,0)
				NumPut(w,bi,4,"int")
				NumPut(-h,bi,8,"int")
				NumPut(40,bi,0,"uint")
				NumPut(1,bi,12,"ushort")
				NumPut(32,bi,14,"ushort")
				this.hbm2 := DllCall("CreateDIBSection", "Ptr", this.srcDC, "Ptr", &bi, "uint", 0, "Ptr*", _scan, "Ptr", 0, "uint", 0, "Ptr")
				this.temp02 := _scan
				NumPut(_scan,this.dataPtr,0,"Ptr")
				NumPut(this.width,this.dataPtr,(this.bits ? 16 : 8),"uint")
				NumPut(this.height,this.dataPtr,(this.bits ? 20 : 12),"uint")
				DllCall("SelectObject", "Ptr", this.srcDC, "Ptr", this.hbm2)
				
				
				VarSetCapacity(r,16,0)
				NumPut(w,r,8,"uint")
				NumPut(h,r,12,"uint")
				VarSetCapacity(bmdata, 32, 0)
				DllCall("Gdiplus\GdipBitmapLockBits", "Ptr", bm, "Ptr", &r, "uint", 3, "int", 0x26200A, "Ptr", &bmdata)
				scan := NumGet(bmdata, 16, "Ptr")
				if (!dllcall(this._cacheTargetImageFile,"ptr",scan,"ptr",_scan,"int",w,"int",h)) {
					msgbox % "Problem caching target image file!"
					return 0
				}
				DllCall("Gdiplus\GdipBitmapUnlockBits", "Ptr", bm, "Ptr", &bmdata)
				DllCall("gdiplus\GdipDisposeImage", "ptr", bm)
				this.CreateDib()
				this.AutoUpdate := 0
				this.Update()
				return 1
			}
			
			
			;########################################## 
			;  internal functions used by the class
			;########################################## 
			CheckRegion(byref x, byref y, byref w, byref h) {
				if (w < 0) {
					w := -w
					x -= w
				}
				if (h < 0) {
					h := -h
					y -= h
				}
			}
			CheckWindow() {
				if (this.desktop)
					return 1

				if (this.UseClientArea and !this.GetClientRect(w,h))
					return 0
				else if (!this.UseClientArea and !this.GetWindowRect(w,h))
					return 0
					
				if (w != this.width or h != this.height) {
					this.width := w
					this.height := h
					DllCall("DeleteObject","Ptr",this.hbm)
					this.CreateDIB()
				}
				return 1
			}
			MapCoords(d,byref x, byref y) {
				x := (this.offsetX + (d>>16)) * this.WindowScale
				y := (this.offsetY + (d&0xFFFF)) * this.WindowScale
			}
			CreateDIB() {
				VarSetCapacity(_scan,8)
				VarSetCapacity(bi,40,0)
				NumPut(this.width,bi,4,"int")
				NumPut(-this.height,bi,8,"int")
				NumPut(40,bi,0,"uint")
				NumPut(1,bi,12,"ushort")
				NumPut(32,bi,14,"ushort")
				this.hbm := DllCall("CreateDIBSection", "Ptr", this.dstDC, "Ptr", &bi, "uint", 0, "Ptr*", _scan, "Ptr", 0, "uint", 0, "Ptr")
				this.temp0 := _scan
				NumPut(_scan,this.dataPtr,0,"Ptr")
				NumPut(this.width,this.dataPtr,(this.bits ? 16 : 8),"uint")
				NumPut(this.height,this.dataPtr,(this.bits ? 20 : 12),"uint")
				DllCall("SelectObject", "Ptr", this.dstDC, "Ptr", this.hbm)
			}
			SetVarCapacity(key,size,fill=0) {
				this.SetCapacity(key,size)
				DllCall("RtlFillMemory","Ptr",this.GetAddress(key),"Ptr",size,"uchar",fill)
				return this.GetAddress(key)
			}
			__Delete() {
				DllCall("gdiplus\GdiplusShutdown", "Ptr*", this.gdiplusToken)
			}
			CacheImage(image) {
				local
				if (this.imageCache.haskey(image))
					return 1
				if (image = "") {
					msgbox % "Error, expected resource image path but empty variable was supplied!"
					return 0
				}
				if (!FileExist(image)) {
					msgbox % "Error finding resource image: '" image "' does not exist!"
					return 0
				}

				DllCall("gdiplus\GdipCreateBitmapFromFile", "Ptr", &image, "Ptr*", bm)
				DllCall("gdiplus\GdipGetImageWidth", "Ptr", bm, "Uint*", w)
				DllCall("gdiplus\GdipGetImageHeight", "Ptr", bm, "Uint*", h)
				VarSetCapacity(r,16,0)
				NumPut(w,r,8,"uint")
				NumPut(h,r,12,"uint")
				VarSetCapacity(bmdata, 32, 0)
				DllCall("Gdiplus\GdipBitmapLockBits", "Ptr", bm, "Ptr", &r, "uint", 3, "int", 0x26200A, "Ptr", &bmdata)
				scan := NumGet(bmdata, 16, "Ptr")
				p := DllCall("GlobalAlloc", "uint", 0x40, "ptr", 16+((w*h)*4), "ptr")
				NumPut((w<<16)+h,p+0,0,"uint")
				loop % ((w*h)*4)
					NumPut(NumGet(scan+0,a_index-1,"uchar"),p+0,a_index+7,"uchar")
				loop % (w*h)
					if (NumGet(scan+0,(a_index-1)*4,"uint") < 0xFF000000) {
						NumPut(1,p+4,"uint")
						break
					}
				DllCall("Gdiplus\GdipBitmapUnlockBits", "Ptr", bm, "Ptr", &bmdata)
				DllCall("gdiplus\GdipDisposeImage", "ptr", bm)
				this.ImageCache[image] := p
				return 1
			}
			Update(x:=0,y:=0,w:=0,h:=0,applyOffset:=1) {
				if (this.CheckWindow()) {
					if (applyOffset) {
						this.offsetX := x
						this.offsetY := y
					} else {
						this.offsetX := 0
						this.offsetY := 0
					}
					DllCall("gdi32\BitBlt", "Ptr", this.dstDC, "int", 0, "int", 0, "int", (w?w:this.width), "int", (h?h:this.height), "Ptr", this.srcDC, "int", x, "int", y, "uint", 0xCC0020) ;40
				}
			}
			GetRect(ByRef w, ByRef h) {
				if (this.desktop) {
					w := dllcall("GetSystemMetrics","int",78)
					h := dllcall("GetSystemMetrics","int",79)
					return 1
				}
				if (this.UseClientArea) {
					if (!this.GetClientRect(w,h)) {
						msgbox % "Problem with Client rectangle dimensions, is window minimized?`n`nScanner will not function!"
						return 0
					}
				} else {
					if (!this.GetWindowRect(w,h)) {
						msgbox % "Problem with Window rectangle dimensions, is window minimized?`n`nScanner will not function!"
						return 0
					}
				}
				return 1
			}
			GetClientRect(byref w, byref h) {
				if (!DllCall("GetClientRect", "Ptr", this.hwnd, "Ptr", this.tBufferPtr))
					return 0
				w := NumGet(this.tBufferPtr,8,"int")
				h := NumGet(this.tBufferPtr,12,"int")
				if (w <= 0 or h <= 0)
					return 0
				return 1
			}
			GetWindowRect(byref w, byref h) {
				if (!DllCall("GetWindowRect", "Ptr", this.hwnd, "Ptr", this.tBufferPtr))
					return 0
				x := NumGet(this.tBufferPtr,0,"int")
				y := NumGet(this.tBufferPtr,4,"int")
				w := NumGet(this.tBufferPtr,8,"int") - x
				h := NumGet(this.tBufferPtr,12,"int") - y
				if (w <= 0 or h <= 0)
					return 0
				return 1
			}
			Random(min,max) {
				random,result,min,max
				return result
			}
			AppendFunc(pos,str) {
				local
				p := this.mcode(str)
				pp := (this.bits ? 24 : 16) + (pos * a_ptrSize)
				numput(p,this.dataPtr,pp,"ptr")
			}
			Mcode(str) {
				local
				s := strsplit(str,"|")
				if (s.length() != 2)
					return
				if (!DllCall("crypt32\CryptStringToBinary", "str", s[this.bits+1], "uint", 0, "uint", 1, "ptr", 0, "uint*", pp, "ptr", 0, "ptr", 0))
					return
				p := DllCall("GlobalAlloc", "uint", 0, "ptr", pp, "ptr")
				if (this.bits)
					DllCall("VirtualProtect", "ptr", p, "ptr", pp, "uint", 0x40, "uint*", op)
				if (DllCall("crypt32\CryptStringToBinary", "str", s[this.bits+1], "uint", 0, "uint", 1, "ptr", p, "uint*", pp, "ptr", 0, "ptr", 0))
					return p
				DllCall("GlobalFree", "ptr", p)
			}
			LoadLib(lib*) {
				for k,v in lib
					if (!DllCall("GetModuleHandle", "str", v, "Ptr"))
						DllCall("LoadLibrary", "Str", v) 
			}
		}


        ; Create a new Xbox 360 controller

;; Start Script stuff

;; Status and count initialize
status = 0
count = 0
ResetCount = 0

360Controller := new ViGEmXb360()
overlay := new ShinsOverlayClass("ahk_exe destiny2.exe")

SetTimer, UpdateOverlay, 2000
gosub, UpdateOverlay
return

UpdateOverlay:
    if WinActive("ahk_exe destiny2.exe") {
        WinGetPos, x, y, w, h, ahk_exe destiny2.exe
        if (overlay.beginDraw()) {
            switch status {
                case 0:
                    overlay.drawText("| F3 to Launch from Orbit | F4 Start from inside The Landing |`n| F5 Stop | F8 Exit | Thrallway.com", 10, 0, 32, 0xFFFFFFFF, "Courier", "olFF000000")
                case 1:
                    overlay.drawText("| F5 Stop | F8 Exit | Thrallway.com |`n| " . count . " total runs | Current run in-loop - " . ResetCount . " |", 10, 0, 32, 0xFFFFFFFF, "Courier", "olFF000000")
				case 2:
                    overlay.drawText("| F5 Stop | F8 Exit | Thrallway.com", 10, 0, 32, 0xFFFFFFFF, "Courier", "olFF000000")
            }
            overlay.endDraw()
        } else {
                overlay := new ShinsOverlayClass("ahk_exe destiny2.exe")
        }
    } else {
        overlay.Clear()
        overlay := ""
    }
return

Start_Farm:
    Loop {
    ;; START
    ;; Reset your instance of the Landing after 35 runs for consistency
        if(ResetCount >= 35 || ResetCount == -1){
			ResetCount = 0
			if(inOrbit == 0) {						; Z - allows for launching from orbit
				360Controller.Buttons.Back.SetState(true)
				PreciseSleep(100)
				360Controller.Buttons.Back.SetState(false)
				PreciseSleep(1000)
				360Controller.Buttons.Y.SetState(true)
				PreciseSleep(4000)
				360Controller.Buttons.Y.SetState(false)
				PreciseSleep(10000)
			}
            360Controller.Buttons.Back.SetState(true)
            PreciseSleep(100)
            360Controller.Buttons.Back.SetState(false)
            PreciseSleep(2000)
			360Controller.Axes.LY.SetState(70)			; Z- Bounce the cursor because Bungo be Bungelin
			PreciseSleep(50)							; ↑
			360Controller.Axes.LY.SetState(50)			; ↑
			PreciseSleep(50)							; ↑
			360Controller.Axes.LY.SetState(30)			; ↑
			PreciseSleep(50)							; ↑
			360Controller.Axes.LY.SetState(50)			; ↑
			PreciseSleep(600)
            360Controller.Buttons.A.SetState(true)
            PreciseSleep(100)
            360Controller.Buttons.A.SetState(false)
            PreciseSleep(1000)
            360Controller.Axes.LX.SetState(0)
            PreciseSleep(fasttravelsleep)
            360Controller.Axes.LX.SetState(50)
            PreciseSleep(500)
			360Controller.Axes.LY.SetState(30)			; Z- bumps down the map cursor because its a little high for the LZ node sometimes
			PreciseSleep(100)							; ↑
			360Controller.Axes.LY.SetState(50)			; ↑
			PreciseSleep(200)
            360Controller.Buttons.A.SetState(true)
            PreciseSleep(2000)
            360Controller.Buttons.A.SetState(false)
            PreciseSleep(1000)
            360Controller.Axes.LX.SetState(100)
            PreciseSleep(orbitlauncherright)
            360Controller.Axes.LX.SetState(50)
            PreciseSleep(500)
            360Controller.Axes.LY.SetState(0)
            PreciseSleep(orbitlauncherdown)
            360Controller.Axes.LY.SetState(50)
            PreciseSleep(100)
            360Controller.Buttons.A.SetState(true)
            PreciseSleep(100)
            360Controller.Buttons.A.SetState(false)
            PreciseSleep(45000)
			inOrbit = 0								; Resets the inOrbit
        }

    ;; Fast Travel to the Landing, yes even after loading a fresh instance, this is for consistent reticle placement
        360Controller.Buttons.Back.SetState(true)
        PreciseSleep(1500)
        360Controller.Buttons.Back.SetState(false)
        PreciseSleep(1000)
        360Controller.Axes.LX.SetState(0)
        PreciseSleep(fasttravelsleep)
        360Controller.Axes.LX.SetState(50)
        PreciseSleep(300)
		360Controller.Axes.LY.SetState(30)			; Z- bumps down the map cursor because its a little high for the LZ node sometimes
		PreciseSleep(100)							; ↑
		360Controller.Axes.LY.SetState(50)			; ↑
		PreciseSleep(200)
        360Controller.Buttons.A.SetState(true)
        PreciseSleep(2000)
        360Controller.Buttons.A.SetState(false)
        PreciseSleep(10000)

    ;; FORCE CHEST SPAWN SPOT
        ;; Walk forward to avoid the shitty rock
        360Controller.Axes.LY.SetState(100)
		PreciseSleep(400)
        360Controller.Axes.LY.SetState(50)
		PreciseSleep(400)
		;; Aim Left towards pavillion
        360Controller.Axes.RX.SetState(20)
        PreciseSleep(1100)
        360Controller.Axes.RX.SetState(50)
        PreciseSleep(200)
        ;; Move forward to the force spawn location
        360Controller.Axes.LY.SetState(100)
        360Controller.Buttons.LS.SetState(true)
        PreciseSleep(100)
        360Controller.Buttons.LS.SetState(False)
        PreciseSleep(3000)
		;; Adjust aim mid run towards the right
		360Controller.Axes.RX.SetState(80)
		PreciseSleep(200)
		360Controller.Axes.RX.SetState(50)
		PreciseSleep(3800)
        360Controller.Axes.LY.SetState(50)
        PreciseSleep(500)
        ;; Aim towards next running patch
        360Controller.Axes.RX.SetState(80)
        PreciseSleep(initialaim)
        360Controller.Axes.RX.SetState(50)
		;; Sleep for chest spawns
        PreciseSleep(22000)
        ;PreciseSleep(500)

    ;; RUN AND LOOT CHEST
        ;; Run forward
        360Controller.Axes.LY.SetState(100)
        360Controller.Buttons.LS.SetState(true)
        PreciseSleep(100)
        360Controller.Buttons.LS.SetState(False)
        PreciseSleep(prearcsleep)
		;; Start arcing towards the left
		360Controller.Axes.RX.SetState(15)
		PreciseSleep(arcsleep)
		;; Stop arc
		360Controller.Axes.RX.SetState(50)
		PreciseSleep(postarcsleep)
		;; Stop running
        360Controller.Axes.LY.SetState(50)
        ;; Aim Down
        360Controller.Axes.RY.SetState(5)
        PreciseSleep(400)
        360Controller.Axes.RY.SetState(50)
        PreciseSleep(100)
        ;; Loot Chest
        360Controller.Buttons.X.SetState(true)
        PreciseSleep(2000)
        360Controller.Buttons.X.SetState(false)
        PreciseSleep(1000)
        ResetCount++
		Count++
    }
Return

F3::
	ResetCount = -1
	status = 1
	inOrbit = 1
	gosub, Start_Farm
Return

F4::
	status = 1
	ResetCount = -1
	inOrbit = 0
	gosub, Start_Farm
Return

F5::Reload

F8::ExitApp

F10::
	ResetCount = 34
Return