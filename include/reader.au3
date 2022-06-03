#include-once
#include <File.au3>
#include "jfw.au3"
#include "kbc.au3"
#include "log.au3"
#include "menu_nvda.au3"
#include "NVDAControllerClient.au3"
#include "sapi.au3"
#include <StringConstants.au3>
#include "translator.au3"
Global $idioma, $sSpeechHistory = "", $movement = 1, $historyEnhabled = True
Global $rd_Ver = "1.3"
;This is a script for interacting whit screen readers.
;this is a more extended version of the original reader.
;Author: Mateo Cedillo.
; #FUNCTION# ====================================================================================================================
; Name ..........: speaking
; Description ...: Speak any text, detecting screen reader first
; Syntax ........: speaking($sText [, $bInterrupt = false, , $bEnableHistory = False])
; Parameters ....: $sText                - the string or text to be spoken.
;                  $interrupt           - [optional] Configure if you want to enable other text speech interruption to speak this one, which means that any previously read text will be interrupted by this new one, if set to true; Otherwise, it waits until the previous text input is finished speaking and then speaks the new text. Default is false (Don't interrupt).
;                  $bEnableHistory           - [optional] Enhable's speech history support and adds that item to the list of history entries that can later be navigated with the keys. Default is false (disabled).
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: Yes
; ===============================================================================================================================
Func speaking($sText, $bInterrupt = False, $bEnableHistory = False)
	If IniRead(@ScriptDir & "\config\config.st", "accessibility", "Speak Whit", "") = "" Then
		$speak = autodetect()
	Else
		$inicheck = IniRead(@ScriptDir & "\config\config.st", "accessibility", "Speak Whit", "")
		Select
			Case $inicheck = "NVDA" Or $inicheck = "JAWS" Or $inicheck = "Sapi"
				$speak = $inicheck
			Case Else
				MsgBox(16, "ReaderEx", translate($idioma, "Your text-to-speech settings are invalid. Autodetecting..."))
				$speak = autodetect()
		EndSelect
	EndIf
	Select
		Case $speak = "NVDA"
			If @AutoItX64 = 1 Then
				_nvdaControllerClient_Load(@ScriptDir & "\nvdaControllerClient64.dll")
			Else
				_nvdaControllerClient_Load()
			EndIf
			If @error Then
				MsgBox(16, translate($idioma, "error"), translate($idioma, "Cant load the NVDA DLL file"))
			Else
				If $bInterrupt Then _NVDAControllerClient_CancelSpeech()
				_NVDAControllerClient_SpeakText($sText)
				_NVDAControllerClient_BrailleMessage($sText)
			EndIf
		Case $speak = "Sapi"
			If not $bInterrupt Then
				speak($sText)
			Else
				speak($sText, 3)
			EndIf
		Case $speak = "JAWS"
			JFWSpeak($sText)
		Case Else
			MsgBox(16, translate($idioma, "Error"), translate($idioma, "Unable to determine text-to-speech output"))
			autodetect()
	EndSelect
	If $bEnableHistory And $historyEnhabled Then
		writeinlog("ReaderEx: Speech history activated")
		$sSpeechHistory &= $sText & @CRLF
		HotKeySet("{home}", "SpeechHistory")
		HotKeySet("{pgdn}", "SpeechHistory")
		HotKeySet("{PGUP}", "SpeechHistory")
		HotKeySet("{end}", "SpeechHistory")
		HotKeySet("{del}", "SpeechHistory")
		HotKeySet("{bs}", "SpeechHistory")
		HotKeySet("{c}", "SpeechHistory")
		speaking(translate($idioma, "Speech history screen activated. Use home, end, back and page forward to navigate through messages. Press delete key to clear history entries, or back space to disable history forever. If an element is added, it will appear in the list."))
	Else
	EndIf
EndFunc   ;==>speaking
;internal:
; #FUNCTION# ====================================================================================================================
; Name ..........: disableHotkeys
; Description ...: [internal] Disable speech history and interaction keys with it.
; Syntax ........: disableHotkeys()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func disableHotkeys()
	writeinlog("disabling hotkeys")
	$historyEnhabled = False
	HotKeySet("{home}")
	HotKeySet("{pgdn}")
	HotKeySet("{PGUP}")
	HotKeySet("{end}")
	HotKeySet("{del}")
	HotKeySet("{c}")
EndFunc   ;==>disableHotkeys
; #FUNCTION# ====================================================================================================================
; Name ..........: SpeechHistory
; Description ...: speech history support
; Syntax ........: SpeechHistory()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func SpeechHistory()
	$aNavigator = StringSplit(StringTrimRight($sSpeechHistory, 1), @LF)
	Sleep(10)
	writeinlog(@HotKeyPressed)
	Switch @HotKeyPressed
		Case "{HOME}"
			If IsArray($aNavigator) Then
				$movement = 1
				speaking(translate($idioma, "Home"))
				speaking($aNavigator[$movement])
				Beep(1100, 50)
			Else
				speaking(translate($idioma, "No history"))
			EndIf
		Case "{PGUP}"
			If IsArray($aNavigator) Then
				$movement = $movement - 1
				If $movement <= 1 Then
					$movement = 1
					speaking(translate($idioma, "Home"))
					Beep(1100, 50)
				EndIf
				speaking($aNavigator[$movement])
			Else
				speaking(translate($idioma, "no history"))
			EndIf
		Case "{PGDN}"
			If IsArray($aNavigator) Then
				$movement = $movement + 1
				If $movement >= $aNavigator[0] Then
					$movement = $aNavigator[0]
					speaking(translate($idioma, "End"))
					Beep(2200, 50)
				EndIf
				speaking($aNavigator[$movement])
			Else
				speaking(translate($idioma, "no history"))
			EndIf
		Case "{END}"
			If IsArray($aNavigator) Then
				$movement = $aNavigator[0]
				speaking(translate($idioma, "End"))
				speaking($aNavigator[$movement])
				Beep(2200, 50)
			Else
				speaking(translate($idioma, "no history"))
			EndIf
		Case "{c}"
			If IsArray($aNavigator) Then
				clipPut($aNavigator[$movement])
				speaking(translate($idioma, "copied to clipboard") &": " &$aNavigator[$movement])
			Else
				speaking(translate($idioma, "no history"))
			EndIf
		Case "{DEL}"
			$aNavigator = ""
			$sSpeechHistory = ""
			speaking(translate($idioma, "Speech history cleared"))
		case "{bs}"
			disableHotkeys()
			speaking(translate($idioma, "History off"))
	EndSwitch
EndFunc   ;==>SpeechHistory
; #FUNCTION# ====================================================================================================================
; Name ..........: autodetect
; Description ...: autodetects which screen reader is being used
; Syntax ........: autodetect()
; Parameters ....: None
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func autodetect()
	If ProcessExists("NVDA.exe") Then
		Return "NVDA"
	EndIf
	If ProcessExists("JFW.exe") Then
		Return "JAWS"
	EndIf
	If Not ProcessExists("NVDA.exe") Or ProcessExists("JFW.exe") Then
		Return "sapi"
	EndIf
EndFunc   ;==>autodetect
; #FUNCTION# ====================================================================================================================
; Name ..........: CreateTTsDialog
; Description ...: simulate a dialog with tts
; Syntax ........: CreateTTsDialog($sDialogName, $text [, $sTtsString = " press enter to continue, space to repeat information."])
; Parameters ....: $sDialogName                - string containing the title of the dialog
;                  $sText                - the string containing the text for the dialog. If it is a multiline text, don't worry, it displays it correctly as if it were a document.
;                  $sTtsString           - [optional] A dll struct value. Default is " press enter to continue.
;                  space to repeat information."- An unknown value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func CreateTtsDialog($sDialogName, $sText, $sTtsString = translate($idioma, "press enter to continue, space to repeat information."))
	disableHotkeys()
	;Identifies if the dialog has more than one line. If so, we will have the user scroll through the lines with the arrows.
	if StringInStr($sText, @lf) then
		$isMultiLine = true
		$sTtsString = translate($idioma, "Use the arrows to read this dialog and enter to continue")
		$separateML = StringSplit($sText, @lf)
		$dmove = 1
		speaking($sDialogName & "  " &translate($idioma, "Dialog") & @LF & $separateml[1] & @lf & $SttsString, true)
	Else
		$isMultiLine = false
		speaking($sDialogName & "  " &translate($idioma, "Dialog") & @LF & $sText & @lf & $SttsString, true)
	EndIF
	While 1
		$active_window = WinGetProcess("")
		If $active_window = @AutoItPID Then
		Else
			Sleep(10)
			ContinueLoop
		EndIf
		If _IsPressed($spacebar) Or _IsPressed($left) Or _IsPressed($right) Then
			if $isMultiLine then
				speaking($separateml[$dmove])
			Else
				speaking($sText & @LF & $sTtsString)
			EndIF
			While _IsPressed($spacebar) Or _IsPressed($left) Or _IsPressed($right)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($down) then
			if $isMultiLine then
				$dmove = $dmove +1
				If $dmove >= $separateML[0] Then
					$dmove = $separateml[0]
					speaking(translate($idioma, "Press enter to continue"))
				EndIF
				speaking($separateML[$dmove])
			Else
				speaking($sText & @LF & $sTtsString)			
			EndIF
			While _IsPressed($down)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($up) then
			if $isMultiLine then
				$dmove = $dmove -1
				If $dmove <= 1 Then $dmove = 1
				speaking($separateML[$dmove])
			Else
				speaking($sText & @LF & $sTtsString)			
			EndIF
			While _IsPressed($up)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($home) then
			if $isMultiLine then
				$dmove = 1
				speaking($separateML[$dmove])
			Else
				speaking($sText & @LF & $sTtsString)			
			EndIF
			While _IsPressed($home)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($end) then
			if $isMultiLine then
				$dmove = $separateml[0]
				speaking($separateML[$dmove])
			Else
				speaking($sText & @LF & $sTtsString)			
			EndIF
			While _IsPressed($end)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($caps) and _IsPressed($tab) or _IsPressed($insert) and _IsPressed($tab) then
			speaking($sDialogName &", " &translate($idioma, "Dialog"))
			While _IsPressed($caps) and _IsPressed($tab) or _IsPressed($insert) and _IsPressed($tab)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($tab) then
			speaking($sDialogName)
			While _IsPressed($tab)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($control) And _IsPressed($c) Then
			if $isMultiLine then
				ClipPut($separateml[$dmove])
			Else
				ClipPut($sText)
			EndIf
			speaking(translate($idioma, "Copied to clipboard") &". " & clipGet())
			While _IsPressed($control) And _IsPressed($c)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($enter) Then
			sleep(100)
			ExitLoop
			While _IsPressed($enter)
				Sleep(50)
			WEnd
		EndIf
		Sleep(10)
	WEnd
EndFunc   ;==>TTsDialog
; #FUNCTION# ====================================================================================================================
; Name ..........: createTtsDocument
; Description ...: Document reader, interactive document, document manager with tts, etc. If i had to give a fuller description of this itself i would say its a greath document reader but based on tts and keyboard shortcuts.
; Syntax ........: createTtsDocument($filetoread, $title)
; Parameters ....: $filetoread          - A floating point number value.
;                  $title               - A dll struct value.
; Return values .: None
; Author ........: Mateo Cedillo
; Modified ......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......: No
; ===============================================================================================================================
Func createTtsDocument($filetoread, $title)
	disableHotkeys()
	writeinlog("ReaderEx.au3: Loading document mode...")
	writeinlog("Using ReaderEx version: " & $rd_Ver)
	$move_doc = 0
	$textselector = 0
	Local $r_file = FileReadToArray($filetoread)
	Local $iCountLines = @extended
	$not = 0
	$pages = "0"
	$docError = 0
	$selectionmode = 0
	$sprate = "0"
	Local $textselected = ""
	If @error Then
		speaking(translate($idioma, "Error reading file..."))
		writeinlog("Document mode: File to read: " & $filetoread & " error. Error reading file.")
		$docError = 1
	Else
		speaking($title & " " & translate($idioma, "document.") & @CRLF & translate($idioma, "Selection mode off"))
		writeinlog("Document mode: Dialog: " & $title & @CRLF & "file to read: " & $filetoread)
		writeinlog("Document information: Lines: " & $iCountLines)
	EndIf
	HotKeySet("{f1}")
	For $foundPages = 0 To $iCountLines Step 30
		$pages = $pages + 1
	Next
	writeinlog("Document mode: Total number of pages: " & $pages)
	While 1
		If $docError = 1 Then ExitLoop
		$active_window = WinGetProcess("")
		If $active_window = @AutoItPID Then
		Else
			Sleep(10)
			ContinueLoop
		EndIf
		If _IsPressed($f1) Then
			writeinlog("Document mode: f1 pressed")
			speaking(translate($idioma, "Interaction commands:") & @CRLF & translate($idioma, "Use the up and down arrows to read the document.") & @CRLF & translate($idioma, "Use the home and end keys to go to the beginning or end of the document.") & @CRLF & translate($idioma, "Use page up and page down to go forward or backward ten lines.") & @CRLF & translate($idioma, "Use control+d and control+u to go forward or backward one page.") & @CRLF & translate($idioma, "Press the s and r keys to enhable automatic reading. A to read all content from start to end, r to read from cursor position to end.") &@crlf &translate($idioma, "Use control+shift+s to open selection mode, which will allow you to select multiple text marks and perform editing commands and operations.") & @CRLF & translate($idioma, "Press the I key to open the print options, which will allow you to print the entire document or specific content.") & @CRLF & translate($idioma, "Use the editing commands to cut, copy, paste and select all the text.") & @CRLF & translate($idioma, "Escape to exit document mode."))
			While _IsPressed($f1)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($f2) Then
			writeinlog("Document mode: f2 pressed")
			speaking(translate($idioma, "Information commands:") & @CRLF & translate($idioma, "Press the e key to spell the current line.") & @CRLF & translate($idioma, "Use the l key to speak the line number you are on.") & @CRLF & translate($idioma, "Use the T key to check the number of total and remaining lines of the document.") & @CRLF & translate($idioma, "Press SHIFT+P to see the total number of pages in the document (useful for printing, for example).") & @CRLF & translate($idioma, "Commands to check number of words:") & @CRLF & translate($idioma, "1: Speaks the total number of words in the entire document.") & @CRLF & translate($idioma, "2: Speaks the total number of words in the current line.") & @CRLF & translate($idioma, "3: Speaks the total number of words filled in the selection."), True)
			While _IsPressed($f2)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($f3) Then
			writeinlog("Document mode: f3 pressed")
			speaking(translate($idioma, "Voice commands:") & @CRLF & translate($idioma, "Press the plus (+) key to increase the reading speed.") & @CRLF & translate($idioma, "Press the minus or dash (-) key to decrease the reading speed."), True)
			While _IsPressed($f3)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($home) Then
			writeinlog("Home pressed")
			If $selectionmode = 1 Then
				If Not $textselected = "" Then
					speaking(translate($idioma, "Unselected"), True)
					$textselected = ""
				EndIf
			EndIf
			$move_doc = "0"
			speaking($r_file[$move_doc], True)
			writeinlog($move_doc)
			While _IsPressed($home)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($page_down) Then
			writeinlog("PGDN pressed")
			If $selectionmode = 1 Then
				For $I = $move_doc To $move_doc + 9
					If $move_doc >= $iCountLines - 1 Then
						$move_doc = $iCountLines - 1
					Else
						$textselected &= $r_file[$I] & @CRLF
						$move_doc = $move_doc + 1
					EndIf
				Next
				speaking(translate($idioma, "Ten lines have been selected"), True)
				speaking($r_file[$move_doc], True)
				writeinlog("Selected line: " & $move_doc)
			Else
				$move_doc = $move_doc + 10
				If $move_doc >= $iCountLines Then
					$move_doc = $iCountLines - 1
					speaking(translate($idioma, "document end. Press escape to back."), True)
				EndIf
				speaking($r_file[$move_doc], True)
				writeinlog("line: " & $move_doc)
			EndIf
			While _IsPressed($page_down)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($page_up) Then
			If $selectionmode = 1 Then
				$textselector = 10
				For $I = $move_doc To $move_doc - 9 Step -1
					If $move_doc <= 0 Then
						$move_doc = "0"
					Else
						$textselected &= $r_file[$I - $textselector] & @CRLF
						$textselector = $textselector - 2
						$move_doc = $move_doc - 1
					EndIf
				Next
				speaking(translate($idioma, "Ten lines have been selected"))
				speaking($r_file[$move_doc], True)
				writeinlog("Selected line: " & $move_doc)
			Else
				$move_doc = $move_doc - 10
				If $move_doc <= 0 Then $move_doc = "0"
				speaking($r_file[$move_doc], True)
				writeinlog("Line: " & $move_doc)
			EndIf
			While _IsPressed($page_up)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($control) And _IsPressed($d) Then
			writeinlog("Control+d pressed. Forwarding page")
			If $selectionmode = 1 Then
				writeinlog("Selection mode on. Selecting the page...")
				For $I = $move_doc To $move_doc + 29
					If $move_doc >= $iCountLines - 1 Then
						$move_doc = $iCountLines - 1
					Else
						$textselected &= $r_file[$I] & @CRLF
						$move_doc = $move_doc + 1
					EndIf
				Next
				speaking(translate($idioma, "Page was selected"))
				speaking($r_file[$move_doc], True)
			Else
				$move_doc = $move_doc + 30
				If $move_doc >= $iCountLines Then
					$move_doc = $iCountLines - 1
					speaking(translate($idioma, "document end. Press escape to back."), True)
				EndIf
				speaking($r_file[$move_doc], True)
				writeinlog("Line: " & $move_doc)
			EndIf
			While _IsPressed($control) And _IsPressed($d)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($control) And _IsPressed($u) Then
			writeinlog("Control+U pressed")
			If $selectionmode = 1 Then
				writeinlog("Selection mode on. Selecting page...")
				$textselector = 30
				For $I = $move_doc To $move_doc - 29 Step -1
					If $move_doc <= 0 Then
						$move_doc = "0"
					Else
						$textselected &= $r_file[$I - $textselector] & @CRLF
						$textselector = $textselector - 2
						$move_doc = $move_doc - 1
					EndIf
				Next
				speaking(translate($idioma, "Page was selected"))
				speaking($r_file[$move_doc], True)
			Else
				$move_doc = $move_doc - 30
				If $move_doc <= 0 Then $move_doc = "0"
				speaking($r_file[$move_doc], True)
				writeinlog("Line: " & $move_doc)
			EndIf
			While _IsPressed($control) And _IsPressed($u)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($end) Then
			If $selectionmode = 1 Then
				If Not $textselected = "" Then
					speaking(translate($idioma, "Unselected"), True)
					$textselected = ""
				EndIf
			EndIf
			$move_doc = $iCountLines - 1
			speaking($r_file[$move_doc] & @CRLF & translate($idioma, "document end. Press escape to back."), True)
			writeinlog("Line: " & $move_doc)
			While _IsPressed($end)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($up) Then
			$move_doc = $move_doc - 1
			If $move_doc <= 0 Then
				If $selectionmode = 1 Then speaking(translate($idioma, "You have reached the home of the document, there is nothing else to select."), True)
				$move_doc = "0"
			EndIf
			If $selectionmode = 1 Then
				$textselected &= $r_file[$move_doc] & @CRLF
				speaking(translate($idioma, "Was selected") & " " & $r_file[$move_doc], True)
			Else
				speaking($r_file[$move_doc], True)
				writeinlog("Line: " & $move_doc)
			EndIf
			While _IsPressed($up)
				If $selectionmode = 1 Then Beep(4000, 50)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($down) Then
			$move_doc = $move_doc + 1
			If $move_doc >= $iCountLines Then
				If $selectionmode = 1 Then speaking(translate($idioma, "You have reached the end of the document, there is nothing else to select."))
				speaking(translate($idioma, "document end. Press escape to back."), True)
				$move_doc = $iCountLines - 1
			EndIf
			If $selectionmode = 1 Then
				$textselected &= $r_file[$move_doc] & @CRLF
				speaking(translate($idioma, "Was selected") & " " & $r_file[$move_doc], True)
			Else
				speaking($r_file[$move_doc], True)
				writeinlog("Line: " & $move_doc)
			EndIf
			While _IsPressed($down)
				If $selectionmode = 1 Then Beep(4000, 50)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($l) Then
			writeinlog("L pressed")
			speaking(translate($idioma, "Line:") & " " & $move_doc + 1, True)
			While _IsPressed($l)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($e) Then
			writeinlog("E pressed")
			$lenght = StringLen($r_file[$move_doc])
			$remove = -1
			$remover = $lenght
			$beep = 200
			For $spell = 1 To $lenght
				$remove = $remove + 1
				$remover = $remover - 1
				speaking(StringTrimLeft(StringTrimRight($r_file[$move_doc], $remover), $remove))
				If StringTrimLeft(StringTrimRight($r_file[$move_doc], $remover), $remove) = " " Then speaking(translate($idioma, "Space"))
				If StringTrimLeft(StringTrimRight($r_file[$move_doc], $remover), $remove) = ":" Then speaking(translate($idioma, "Colon"))
				If StringTrimLeft(StringTrimRight($r_file[$move_doc], $remover), $remove) = "," Then speaking(translate($idioma, "Comma"))
				If StringTrimLeft(StringTrimRight($r_file[$move_doc], $remover), $remove) = "-" Then speaking(translate($idioma, "Dash"))
				If StringTrimLeft(StringTrimRight($r_file[$move_doc], $remover), $remove) = "'" Then speaking(translate($idioma, "Apostrofe"))
				If StringTrimLeft(StringTrimRight($r_file[$move_doc], $remover), $remove) = '"' Then speaking(translate($idioma, "Quotes"))
				If StringTrimLeft(StringTrimRight($r_file[$move_doc], $remover), $remove) = "(" Then speaking(translate($idioma, "Open parentheses"))
				If StringTrimLeft(StringTrimRight($r_file[$move_doc], $remover), $remove) = ")" Then speaking(translate($idioma, "Close parentheses"))
				$beep = $beep + 1
			Next
			While _IsPressed($e)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($t) Then
			writeinlog("T pressed")
			speaking(translate($idioma, "total lines:") & " " & $iCountLines & @CRLF & translate($idioma, "Remaining lines:") & " " & $iCountLines - $move_doc - 1, True)
			While _IsPressed($t)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($shift) And _IsPressed($p) Then
			writeinlog("SHIFT+P pressed")
			speaking(translate($idioma, "Total number of pages:") & " " & $pages, True)
			While _IsPressed($shift) And _IsPressed($p)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($tPlus) Then
			writeinlog("plus normal keyboard pressed")
			If IniRead(@ScriptDir & "\config\config.st", "accessibility", "Speak Whit", "") = "Sapi" Or autodetect() = "Sapi" Then
				$sprate = $sprate + 1
				sprate($sprate)
				If $sprate > 10 Then
					speaking(translate($idioma, "Maximum speed"), True)
					$sprate = 10
				Else
					speaking(translate($idioma, "Reading speed") & " " & $sprate, True)
				EndIf
			Else
				speaking(translate($idioma, "This command is not supported in") & " " & autodetect() & ".", True)
			EndIf
			While _IsPressed($tPlus)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($tMinus) Then
			writeinlog("dash normal keyboard pressed")
			If IniRead(@ScriptDir & "\config\config.st", "accessibility", "Speak Whit", "") = "Sapi" Or autodetect() = "Sapi" Then
				$sprate = $sprate - 1
				sprate($sprate)
				If $sprate <= -10 Then
					speaking(translate($idioma, "Minimum speed"), True)
					$sprate = -10
				Else
					speaking(translate($idioma, "reading speed") & " " & $sprate, True)
				EndIf
			Else
				speaking(translate($idioma, "This command is not supported in") & " " & autodetect() & ".", True)
			EndIf
			While _IsPressed($tMinus)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($control) And _IsPressed($c) Then
			If $textselected = "" Then
				speaking(translate($idioma, "You have not selected text to copy!"), True)
			Else
				If Not ClipPut($textselected) = 0 Then
					speaking(translate($idioma, "the text has been copied to that clipboard"), True)
				Else
					speaking(translate($idioma, "An error occurred while sending text"), True)
				EndIf
				If $selectionmode = 1 Then $selectionmode = 0
			EndIf
			While _IsPressed($control) And _IsPressed($c)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($control) And _IsPressed($a) Then
			$textselected = ""
			speaking(translate($idioma, "Selecting all..."), True)
			For $selecting = 0 To $iCountLines - 1
				$textselected &= $r_file[$selecting] & @CRLF
			Next
			speaking(translate($idioma, "All text was selected"), True)
			If $selectionmode = 1 Then $selectionmode = 0
			While _IsPressed($control) And _IsPressed($a)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($control) And _IsPressed($shift) And _IsPressed($s) Then
			If Not $selectionmode = 0 Then
				speaking(translate($idioma, "He left the selection mode"), True)
				$selectionmode = 0
			Else
				speaking(translate($idioma, "Entered to the selection mode"), True)
				$selectionmode = 1
			EndIf
			While _IsPressed($control) And _IsPressed($shift) And _IsPressed($s)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($t1) Then
			$fixingdocumentwords = StringStripWS(FileRead($filetoread), $STR_STRIPSPACES)
			$counter = StringSplit($fixingdocumentwords, " ")
			speaking(translate($idioma, "Total number of words in the entire document:") & " " & $counter[0], True)
			If $counter[0] = 0 Then speaking(translate($idioma, "There are no words"))
			While _IsPressed($t1)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($t2) Then
			$fx = StringStripWS($r_file[$move_doc], $STR_STRIPSPACES)
			$ct = StringSplit($fx, " ")
			speaking(translate($idioma, "Total number of words in this line:") & " " & $ct[0], True)
			If $ct[0] = 0 Then speaking(translate($idioma, "There are no words"))
			While _IsPressed($t2)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($t3) Then
			If Not $textselected = "" Then
				$fx2 = StringStripWS($textselected, $STR_STRIPSPACES)
				$ct2 = StringSplit($fx2, " ")
				speaking(translate($idioma, "Total number of words based on the selection:") & " " & $ct2[0], True)
			Else
				speaking(translate($idioma, "No text selected!"))
			EndIf
			While _IsPressed($t3)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($s) Then
			writeinlog("S pressed")
			speaking(translate($idioma, "Automatic reading mode activated") &". " &translate($idioma, "Reading all the content."))
			for $Iread = 0 to $iCountLines -1
				$move_doc = $Iread
				speaking($r_file[$Iread])
				sleep(10)
			Next
			speaking(translate($idioma, "Done"))
			While _IsPressed($s)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($r) Then
			writeinlog("R pressed")
			speaking(translate($idioma, "Automatic reading mode activated") &". " &translate($idioma, "Reading from position at cursor."))
			for $Iread = $move_doc to $iCountLines -1
				$move_doc = $Iread
				speaking($r_file[$Iread])
				sleep(10)
			Next
			speaking(translate($idioma, "Done"))
			While _IsPressed($r)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($I) Then
			writeinlog("I pressed")
			$prtemp = @TempDir & "\prtemp.txt"
			$printmenu = reader_create_menu(translate($idioma, "Print options, use the arrows to navigate and enter to start"), translate($idioma, "Print the entire document") & "|" & translate($idioma, "Print selection") & "|" & translate($idioma, "Close this menu"), 1, translate($idioma, "OF"))
			Select
				Case $printmenu = 1
					$estaimpreso = _FilePrint($filetoread)
					If $estaimpreso Then
						Beep(1960, 200)
						MsgBox(48, translate($idioma, "Done"), translate($idioma, "The document has been printed successfully!"))
					Else
						MsgBox(16, translate($idioma, "Error"), translate($idioma, "The document could not be printed.") & @CRLF & translate($idioma, "Error code:") & " " & @error)
					EndIf
				Case $printmenu = 2
					If $textselected = "" Then
						MsgBox(16, translate($idioma, "Error"), translate($idioma, "No text selected!"))
					Else
						$tempcreate = FileOpen($prtemp, 1)
						If Not FileWrite($tempcreate, $textselected) Then MsgBox(16, translate($idioma, "Error"), translate($idioma, "Cannot set temporary file with contents of selected text to print"))
						Sleep(1000)
						$isPrinted = _FilePrint($prtemp)
						If $isPrinted Then
							Beep(1960, 200)
							MsgBox(48, translate($idioma, "Done"), translate($idioma, "the document has been printed successfully!"))
						Else
							MsgBox(16, translate($idioma, "Error"), translate($idioma, "The document could not be printed.") & @CRLF & translate($idioma, "Error code:") & " " & @error)
						EndIf
					EndIf
					If FileExists($prtemp) Then FileDelete($prtemp)
				Case $printmenu = 3
					ContinueLoop
			EndSelect
			While _IsPressed($I)
				Sleep(50)
			WEnd
		EndIf
		If _IsPressed($escape) Then
			writeinlog("Escape pressed")
			$newfilename = ""
			$not = 0
			If Not $textselected = "" Then
				writeinlog("there are selected elements. Opening menu.")
				$sabemenu = reader_create_menu(translate($idioma, "Attention! you have selected items. Would you like to save them?"), translate($idioma, "Copy to clipboard") & "|" & translate($idioma, "Save to a text file") & "|" & translate($idioma, "Don't save") & "|" & translate($idioma, "Cancel"), 1, translate($idioma, "OF"))
				writeinlog("Menu item selected: " & $sabemenu)
				Select
					Case $sabemenu = 1
						ClipPut($textselected)
						speaking(translate($idioma, "Copied to clipboard"), True)
						Sleep(1000)
						ExitLoop
					Case $sabemenu = 2
						$savefile = FileSaveDialog(translate($idioma, "Save document elements..."), @ScriptDir & "\documents", translate($idioma, "Text files (*.txt)"), $FD_FILEMUSTEXIST)
						If $savefile = "" Then
							$createname = StringSplit($r_file[0], " ")
							For $I = 1 To 3
								$newfilename &= $createname[$I] & " "
							Next
							If StringInStr($newfilename, ",") Then $newfilename = StringReplace($newfilename, ",", "")
							If StringInStr($newfilename, ":") Then $newfilename = StringReplace($newfilename, ":", "")
							$savefile = @ScriptDir & "\documents\" & StringStripWS($newfilename, $STR_STRIPTRAILING) & ".txt"
						EndIf
						Beep(400, 70)
						speaking(translate($idioma, "Saving file, please wait..."))
						$txtfile = FileOpen($savefile, 1)
						FileWrite($txtfile, $textselected)
						Sleep(2000)
						Beep(200, 70)
						speaking(translate($idioma, "Finished"))
						Sleep(500)
						ExitLoop
					Case $sabemenu = 3
						$textselected = ""
						ExitLoop
					Case $sabemenu = 4
						ContinueLoop
				EndSelect
			EndIf
			While _IsPressed($escape)
				Sleep(50)
			WEnd
			Return $move_doc
		EndIf
		Sleep(10)
	WEnd
EndFunc   ;==>createTtsDocument
