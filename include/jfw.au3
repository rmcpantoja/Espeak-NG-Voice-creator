$o_speech = ObjCreate("jfwapi")
If @error Then
	Sleep(10)
	;msgbox(16, "Error", "Failed to initialize object")
	;exit
EndIf
; #FUNCTION# ====================================================================================================================
; Name ..........: JFWSpeak
; Description ...: Speak the selected text, sending this text to the JAWS screen reader
; Syntax ........: JFWSpeak($text)
; Parameters ....: $text                - A dll struct value.
; Return values .: None
; Author ........: angel
; Modified ......: 
; Remarks .......: 
; Related .......: 
; Link ..........: 
; Example .......: No
; ===============================================================================================================================
Func JFWSpeak($text)
	$o_speech.saystring($text, -1)
	;$o_speech = ""
	Return 1 ;
EndFunc   ;==>JFWSpeak
