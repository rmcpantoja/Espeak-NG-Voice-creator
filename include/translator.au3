;UDF to translate your applications into different languages.
;This UDF was created by Mateo Cedillo
#include-once
Global $trslt_Ver = "1.0.1"
; #FUNCTION# ====================================================================================================================
; Name ..........: GetLanguageName
; Description ...: Get the name of a specific language and returns in a string
; Syntax ........: GetLanguageName($sFile)
; Parameters ....: $sFile                - the string containing the name of the language file without the extension.
; Return values .: 0 when there is no name, or the language name when true
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GetLanguageName($sFile)
	$nlgname = IniRead(@ScriptDir & "\lng\" & $sFile & ".lang", "Language info", "Name", "")
	If $nlgname = "" Then
		MsgBox(16, "language engine error", "The language name is not valid")
		Return 0
	Else
		Return $nlgname
	EndIf
EndFunc   ;==>GetLanguageName
; #FUNCTION# ====================================================================================================================
; Name ..........: GetLanguageCode
; Description ...: gets the language code, for example: En, es, pt... Etc.
; Syntax ........: GetLanguageCode($sFile)
; Parameters ....: $sFile                - the string containing the name of the language file without the extension.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GetLanguageCode($sFile)
	$nlgcode = IniRead(@ScriptDir & "\lng\" & $sFile & ".lang", "Language info", "Code", "")
	If $nlgcode = "" Then
		Return 0
	Else
		Return $nlgcode
	EndIf
EndFunc   ;==>GetLanguageCode
; #FUNCTION# ====================================================================================================================
; Name ..........: GetLanguageAuthors
; Description ...: Get the author(s) of a specific language file
; Syntax ........: GetLanguageAuthors($sFile)
; Parameters ....: $sFile                - the string containing the name of the language file without the extension.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GetLanguageAuthors($sFile)
	$nlgauthors = IniRead(@ScriptDir & "\lng\" & $sFile & ".lang", "Language info", "Author", "")
	If $nlgauthors = "" Then
		Return 0
	Else
		Return $nlgauthors
	EndIf
EndFunc   ;==>GetLanguageAuthors
; #FUNCTION# ====================================================================================================================
; Name ..........: GetLanguageCopyright
; Description ...: Get the copyright for a specific language
; Syntax ........: GetLanguageCopyright($sFile)
; Parameters ....: $sFile                - the string containing the name of the language file without the extension.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GetLanguageCopyright($sFile)
	$nlgcpr = IniRead(@ScriptDir & "\lng\" & $sFile & ".lang", "Language info", "Copyright", "")
	If $nlgcpr = "" Then
		Return 0
	Else
		Return $nlgcpr
	EndIf
EndFunc   ;==>GetLanguageCopyright
; #FUNCTION# ====================================================================================================================
; Name ..........: GetLanguageVersion
; Description ...: get the version of a language file
; Syntax ........: GetLanguageVersion($sFile)
; Parameters ....: $sFile                - the string containing the name of the language file without the extension.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func GetLanguageVersion($sFile)
	$nlgversion = IniRead(@ScriptDir & "\lng\" & $sFile & ".lang", "Language info", "Version", "")
	If $nlgversion = "" Then
		MsgBox(16, "language engine error", "The language version is not valid")
		Return 0
	Else
		Return $nlgversion
	EndIf
EndFunc   ;==>GetLanguageVersion
; #FUNCTION# ====================================================================================================================
; Name ..........: translate
; Description ...: this is the base function that allows you to translate strings, this is stored in lng\language.lang following the structure.
; Syntax ........: translate($sLanguageName, $sString)
; Parameters ....: $sLanguageName        - the string containing the name of the language file without the extension.
;                  $sString              - text string to be translated.
; Return values .: If all goes well, it returns the translated text; otherwise, return the original text
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func translate($sLanguageName, $sString)
	$strings = IniRead(@ScriptDir & "\lng\" & $sLanguageName & ".lang", "Strings", $sString, "")
	If $strings = "" Then
		If Not $sString = "" Then
			Return $sString
		Else
			MsgBox(16, "language engine error", "This translation is corrupt!")
			Return 0
		EndIf
	Else
		Return $strings
	EndIf
EndFunc   ;==>translate
