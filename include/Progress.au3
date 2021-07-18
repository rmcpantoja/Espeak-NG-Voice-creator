#include-once
Func CreateAudioProgress($numero)
	If $numero < 0 Then
		;msgbox(0, "Error", "Wrong value")
	EndIf
	If $numero > 100 Then
		;msgbox(0, "Error", "Wrong value")
	EndIf
	Local $iFreqStart = 110
	Local $iFreqEnd = 2.00
	Local $count = 0
	$count = $numero * 16.5
		$progress = $iFreqStart * 1.5
		beep($count, 60)
	;msgbox(0, "count", $count)
EndFunc   ;==>CreateAudioProgress
Func progresReverse()
	For $iFreq = $iFreqEnd To $iFreqStart Step -0.02
		$tin.pitchshift = $iFreq
		$tin.play()
		$count = $count - 1
		Sleep(50)
	Next
	MsgBox(0, "_WinAPI_Beep Example", "Results: " & $count)
EndFunc   ;==>progresReverse
