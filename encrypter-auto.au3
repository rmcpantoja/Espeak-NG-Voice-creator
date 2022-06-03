#RequireAdmin
#include "include\audio.au3"
#include "include\zip.au3"
ConsoleWrite("verifying administrator privileges" & @CRLF)
If Not IsAdmin() Then
	ConsoleWriteError("It was impossible to run the script with administrator rights." & @CRLF)
	Sleep(200)
	Exit
Else
	ConsoleWrite("It's admin: Yes" & @CRLF)
EndIf
encrypt()
; #FUNCTION# ====================================================================================================================
; Name ..........: encrypt
; Description ...: function to encrypt sounds, but through console. This app must be compiled as console
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
	ConsoleWrite(@ScriptDir & " " & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ": Starting the sounds encryption process..." & @CRLF)
	;Creating the zip:
	_Zip_Create(@ScriptDir & "\tempsounds.zip")
	ConsoleWrite(@ScriptDir & " " & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ": Zip file created. Adding contents..." & @CRLF)
	Sleep(200)
	_Zip_AddFolderContents(@ScriptDir & "\tempsounds.zip", @ScriptDir & "\sounds")
	If @error Then
		ConsoleWriteError(@ScriptDir & " " & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & "Error: An error occurred while creating the sounds zip file." & @CRLF & "Error code: " & @error & @CRLF)
		Sleep(100)
		Exit
	Else
		ConsoleWrite(@ScriptDir & " " & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ": " & @ScriptDir & "\tempsounds.zip created successfully!" & @CRLF)
	EndIf
	$filetoencr = @ScriptDir & "\tempsounds.zip"
	$savefile = @ScriptDir & "\sounds.dat"
	ConsoleWrite(@ScriptDir & " " & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ": working..." & @CRLF)
	$comaudio.Encrypt($filetoencr, $savefile)
	ConsoleWrite(@ScriptDir & " " & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ": Done!" & @CRLF & "File encripted as: " & $savefile & ". Deleting the zip file..." & @CRLF)
	If FileDelete($filetoencr) = 1 Then
		ConsoleWrite(@ScriptDir & " " & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & ": " & $filetoencr & " has been deleted." & @CRLF)
	Else
		ConsoleWriteError(@ScriptDir & " " & @YEAR & "-" & @MON & "-" & @MDAY & " " & @HOUR & ":" & @MIN & ":" & @SEC & "Error: An error occurred while deleting the zip file. It does not exist or has already been removed." & @CRLF)
	EndIf
EndFunc   ;==>encrypt
