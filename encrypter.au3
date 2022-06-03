#include "include\audio.au3"
#include <FileConstants.au3>
encrypt()
; #FUNCTION# ====================================================================================================================
; Name ..........: encrypt
; Description ...: Function that will allow you to encrypt sounds
; Syntax ........: encrypt()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func encrypt()
	$filetoencr = FileOpenDialog("Select zip or dat file containing the sounds", @ScriptDir & "\", "Package files (*.dat;*.zip)|Sounds (*.flac;*.ogg;*.mp3;*.wav)")
	If @error Then
		MsgBox(16, "error", "you did not select any file.")
		Exit
	EndIf
	$savefile = FileSaveDialog("Save the encrypted file as...", "", "dat file (*.dat)|zip file (*.zip)|Flac file (*.flac)|MP3 file (*.mp3)|Ogg file (*.ogg)|Wav file (*.wav)", $FD_FILEMUSTEXIST)
	If $savefile = "" Then
		MsgBox(16, "Error", "it is important that you choose a destination file before proceeding.")
		Exit
	EndIf
	Beep(2500, 100)
	Beep(2500, 75)
	$gui = GUICreate("working...")
	GUISetState(@SW_SHOW)
	$comaudio.Encrypt($filetoencr, $savefile)
	GUIDelete($gui)
	Beep(1250, 200)
	MsgBox(48, "Done", "File encripted")
	FileDelete($filetoencr)
EndFunc   ;==>encrypt
