
SetBatchLines -1

CounterBefore := 
SleepSleep(s)
{
    DllCall("QueryPerformanceFrequency", "Int64*", freq)
    DllCall("QueryPerformanceCounter", "Int64*", CounterBefore)
    While (((counterAfter - CounterBefore) / freq * 1000) < s)
        DllCall("QueryPerformanceCounter", "Int64*", CounterAfter)
		global Counter := CounterBefore/10000
    return ((counterAfter - CounterBefore) / freq * 1000) 

}

F1::
{
    loopCount := 11
    sum := 0
    ms := 20

    loop, % loopcount 
	{
        sum += SleepSleep(ms)
		d := d " " Counter - Counter0
		Counter0 = %Counter%
	}
		
	Loop, Parse, d, %A_Space%
	{
	   IfLess A_Index,3, Continue
	   s += A_LoopField
	   c++
	}
    avg := sum / loopcount 


    MsgBox % "Avg: " A_Tab avg " ms`n"
            .  "Diff " A_Tab avg - ms " ms" 
    MsgBox target:%ms%`n`nTick counter average = %avg%`nvalues: %d%`nsum: %s%

    return
}

F2::
        DllCall("QueryPerformanceFrequency", "Int64*", newfreq)
        DllCall("QueryPerformanceCounter", "Int64*", newCounterBefore)
        SleepSleep(30)
        DllCall("QueryPerformanceCounter", "Int64*", newCounterAfter)
        MsgBox % "Elapsed QPC time is " . (newCounterAfter - newCounterBefore) / newfreq * 1000 " ms"
return

f3::reload