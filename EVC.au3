#AutoIt3Wrapper_Compile_Both=N
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Change2CUI=N
#AutoIt3Wrapper_Res_Description=Espeak ng voice creator create diferent voices for espeak
#AutoIt3Wrapper_Res_Fileversion=0.3.0.0
;#AutoIt3Wrapper_Res_Fileversion_Use_Template=%YYYY.%MO.%DD.0
#AutoIt3Wrapper_Res_Fileversion_AutoIncrement=p
;#AutoIt3Wrapper_Res_Fileversion_First_Increment=y
#AutoIt3Wrapper_Res_ProductName=Espeak ng voice creator
#AutoIt3Wrapper_Res_ProductVersion=0.3.0.0
#AutoIt3Wrapper_Res_CompanyName=MT Programs
#AutoIt3Wrapper_Res_LegalCopyright=© 2018-2022 MT Programs, All rights reserved
;#AutoIt3Wrapper_Res_Language=12298
;#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7 -v1 -v2 -v3
#AutoIt3Wrapper_Run_Tidy=n
;#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so
;#AutoIt3Wrapper_Versioning=v
;#AutoIt3Wrapper_Run_Before="buildsounds.bat"
;#AutoIt3Wrapper_Run_After=encrypter-auto.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;Espeak NG Voice creator (Rewritten)
;I liked version 0.1 of October 2020, without a doubt, because I had a lot of fun with it creating new voices, and best of all, I keep them, but unfortunately the code does not.
;I hope that this new rewritten version will not be lost anymore. In fact, I'll post it to the web as soon as I'm done and update within all my stuff swite and be more careful with this. However, I doubt that this is of interest because the espeak synthesizer is not so accepted by people and a little hated, you could say, because of the voice.
;And here the code:
; #pragma compile(Icon, C:\Program Files\AutoIt3\Icons\au3.ico)
#pragma compile(UPX, False)
;#pragma compile(Compression, 2)
#pragma compile(inputboxres, false)
#pragma compile(FileDescription, Espeak NG Voice Creator - Create diferent voices for espeak NG sintesizer)
#pragma compile(ProductName, Espeak NG Voice Creator)
#pragma compile(ProductVersion, 0.3.0.0)
#pragma compile(Fileversion, 0.3.0.1)
#pragma compile(InternalName, "mateocedillo.EVC")
#pragma compile(LegalCopyright, © 2018-2022 MT Programs, All rights reserved)
#pragma compile(CompanyName, 'MT Programs')
;Include:
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <fileConstants.au3>
#include <GUIConstantsEx.au3>
#include <Include\kbc.au3>
#include "include\Progress.au3"
#include "include\Reader.au3"
#include "updater.au3"
Opt("GUIOnEventMode",1)
Opt("GUICloseOnESC", 0)
global $program_ver = "0.3"
global $idioma = IniRead(@ScriptDir & "\config\config.st", "General settings", "language", "")
if not fileExists ("config") then
DirCreate("config")
EndIf
Select
Case $idioma = ""
Selector()
Case Else
checkupd()
EndSelect
Func Selector()
Local $widthCell, $msg, $iOldOpt
Global $langGUI = GUICreate("Language Selection")
Global $seleccionado = "0"
$widthCell = 70
$iOldOpt = Opt("GUICoordMode", $iOldOpt)
$beep = "0"
$busqueda = "0"
Dim $langcodes[50]
GUICtrlCreateLabel("Select language:", -1, 0)
GUISetBkColor(0x00E0FFFF)
$recolectalosidiomasporfavor = FileFindFirstFile(@ScriptDir & "\lng\*.lang")
If $recolectalosidiomasporfavor = -1 Then
MsgBox(16, "Fatal error", "We cannot find the language files. Please download the program again...")
EndIf
Local $Recoleccion = "", $obteniendo = ""
While 1
$beep = $beep + 1
$busqueda = $busqueda + 1
$Recoleccion = FileFindNextFile($recolectalosidiomasporfavor)
If @error Then
;MsgBox(16, "Error", "We cannot find the language files or they are corrupted.")
CreateAudioProgress("100")
ExitLoop
EndIf
$splitCode = StringLeft($Recoleccion, 2)
$obteniendo &= GetLanguageName($splitCode) & ", " & GetLanguageCode($splitCode) & "|"
$langcodes[$busqueda] = GetLanguageCode($splitCode)
CreateAudioProgress($beep)
Sleep(100)
WEnd
$langcount = StringSplit($obteniendo, "|")
Global $Choose = GUICtrlCreateCombo("", 100, 50, 200, 30, BitOR($CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL))
GUICtrlSetOnEvent(-1, "seleccionar")
GUICtrlSetData($Choose, $obteniendo)
Global $idBtn_OK = GUICtrlCreateButton("OK", 155, 50, 70, 30)
GUICtrlSetOnEvent(-1, "save")
Global $idBtn_Close = GUICtrlCreateButton("Close", 180, 50, 70, 30)
GUICtrlSetOnEvent(-1, "_exit")
GUISetState(@SW_SHOW)
Global $LEER = ""
While 1
If $seleccionado = "1" Then ExitLoop
WEnd
GUIDelete($langGUI)
checkupd()
EndFunc
Func seleccionar()
Global $LEER = GUICtrlRead($Choose)
Global $queidiomaes = StringSplit($LEER, ",")
EndFunc
Func save()
IniWrite(@ScriptDir & "\config\config.st", "General settings", "language", StringStripWS($queidiomaes[2], $STR_STRIPLEADING))
$seleccionado = "1"
IniWrite(@ScriptDir & "\config\config.st", "General settings", "language", StringStripWS($queidiomaes[2], $STR_STRIPLEADING))
$idioma = IniRead(@ScriptDir & "\config\config.st", "General settings", "language", "")
EndFunc
func checkupd()
global $main_u = GUICreate(translate($idioma, "Checking version..."))
GUISetState(@SW_SHOW)
sleep(100)
speaking(translate($idioma, "Checking version..."))
checkversion()
sleep(100)
GUIDelete($main_u)
endfunc
func checkversion()
Local $yourexeversion = $program_ver
$fileinfo = InetGet("https://www.dropbox.com/s/mxxplt275lmxt1r/EVCWeb.dat?dl=1", @TempDir &"\EVCWeb.dat")
$latestver = iniRead (@TempDir & "\EVCWeb.dat", "updater", "LatestVersion", "")
select
Case $latestVer > $yourexeversion
CreateTTSDialog(translate($idioma, "update available!"), translate($idioma, "You have the version") &" " &$yourexeversion &", " &translate($idioma, "And is available the") &$latestver& ". Press enter to download.")
GUIDelete($main_u)
_Updater_Update("EVC.exe", "none", "EVCExtract.zip")
case else
GUIDelete($main_u)
main()
endselect
InetClose($fileinfo)
If @Compiled Then FileDelete(@tempDir &"\EVCWeb.dat")
GUIDelete($main_u)
endfunc
Func Main()
if @compiled then FileDelete(@tempDir & "\EVCWeb.dat")
$Gui_main = guicreate("Espeak NG Voice Creator Version " &$program_ver)
speaking(translate($idioma, "Loading"))
HotKeySet("{F1}", "playhelp")
Local $idCreatebutton = GUICtrlCreateButton(translate($idioma, "Create voice"), 10, 50, 100, 20)
GuiCtrlSetOnEvent(-1, "crearvoz")
Local $idManualbutton = GUICtrlCreateButton(translate($idioma, "User Manual"), 80, 50, 100, 20)
GuiCtrlSetOnEvent(-1, "playhelp")
Local $idChangesbutton = GUICtrlCreateButton(translate($idioma, "Changes"), 80, 120, 100, 20)
GuiCtrlSetOnEvent(-1, "readchanges2")
Local $idGithubBTN = GUICtrlCreateButton("Github", 80, 190, 100, 20)
GuiCtrlSetOnEvent(-1, "github")
Local $idExitbutton = GUICtrlCreateButton(translate($idioma, "E&xit"), 130, 50, 75, 20)
GuiCtrlSetOnEvent(-1, "_exit")
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
GUISetState(@SW_SHOW)
While 1
WEnd
EndFunc
Func Crearvoz()
Speaking(translate($idioma, "Preparing your Voice..."))
CreateBeepProgress("0")
;Declaring variables:
global $voicename = "Voice" &Random(1, 1000, 1)
Global $isKlatt = Random(1, 10, 1)
Global $Klatt = Random(1, 6, 1)
Global $gender = "None " &Random(15, 80, 1)
Global $Speed = Random(90, 115, 1)
Global $F0param1 = Random(75, 150, 1)
Global $F0param2 = Random(55, 160, 1)
Global $F0param3 = Random(75, 155, 1)
Global $F1param1 = Random(60, 150, 1)
Global $F1param2 = Random(65, 170, 1)
Global $F1param3 = Random(70, 165, 1)
Global $F2param1 = Random(65, 155, 1)
Global $F2param2 = Random(70, 135, 1)
Global $F2param3 = Random(60, 140, 1)
Global $F3param1 = Random(60, 145, 1)
Global $F3param2 = Random(50, 150, 1)
Global $F3param3 = Random(65, 155, 1)
Global $F4param1 = Random(60, 160, 1)
Global $F4param2 = Random(45, 150, 1)
Global $F4param3 = Random(50, 145, 1)
Global $F4param4 = Random(48, 158, 1)
Global $F5param1 = Random(65, 160, 1)
Global $F5param2 = Random(50, 150, 1)
Global $F5param3 = Random(30, 140, 1)
Global $F6param1 = Random(45, 142, 1)
Global $F6param2 = Random(55, 150, 1)
Global $F6param3 = Random(55, 150, 1)
Global $F7param1 = Random(70, 155, 1)
Global $F7param2 = Random(50, 134, 1)
Global $F7param3 = Random(58, 140, 1)
Global $F8param1 = Random(60, 140, 1)
Global $F8param2 = Random(52, 142, 1)
Global $F8param3 = Random(40, 140, 1)
Global $isConsonants = Random(1, 5, 1)
Global $IsVoicing = Random(1, 5, 1)
global $isBreath = Random(1, 5, 1)
Global $IsEcho = Random(1, 5, 1)
Global $IsStress = Random(1, 5, 1)
Global $Intonation = Random(1, 3, 1)
Global $Pitch1 = Random(70, 200, 1)
Global $Pitch2 = Random(120, 300, 1)
Global $Echo1 = Random(1, 100, 1)
Global $Echo2 = Random(10, 10000, 1)
Global $stressAdd1 = Random(10, 200, 1)
Global $stressAdd2 = Random(10, 120, 1)
Global $stressAdd3 = Random(5, 185, 1)
Global $stressAdd4 = Random(8, 230, 1)
Global $stressAdd5 = Random(5, 160, 1)
Global $stressAdd6 = Random(10, 235, 1)
Global $stressAdd7 = Random(15, 210, 1)
Global $stressAdd8 = Random(20, 400, 1)
Global $Voicing = Random(30, 100, 1)
Global $Consonants1 = Random(30, 150, 1)
Global $Consonants2 = Random(40, 250, 1)
Global $Flutter = Random(1, 5, 1)
Global $roughness = Random(1, 5, 1)
Global $breath1 = Random(1, 30, 1)
Global $breath2 = Random(1, 15, 1)
Global $breath3 = Random(1, 20, 1)
Global $breath4 = Random(1, 20, 1)
Global $breath5 = Random(1, 40, 1)
Global $breath6 = Random(1, 35, 1)
Global $breath7 = Random(1, 30, 1)
Global $breath8 = Random(10, 105, 1)
Global $breathw1 = Random(200, 300, 1)
Global $breathw2 = Random(200, 255, 1)
Global $breathw3 = Random(1, 20, 1)
Global $breathw4 = Random(50, 100, 1)
Global $breathw5 = Random(100, 200, 1)
Global $breathw6 = Random(100, 200, 1)
Global $breathw7 = Random(200, 300, 1)
Global $breathw8 = Random(100, 250, 1)
Speaking(translate($idioma, "Creating Your Voice: Your Voice ID is:") &" " &$voicename &". " &translate($idioma, "Please do not close this window until further notice."))
CreateBeepProgress("5")
Local $voicefile = FileOpen("voices\" &$voicename,$FO_OVERWRITE  + $FO_CREATEPATH)
If $voicefile = -1 Then
MsgBox(16, translate($idioma, "error"), translate($idioma, "An error occurred while opening the file."))
EndIf
FileWrite($VoiceFile, "##This voice has been created with Espeak NG Voice Creator##" &@crlf &"language variant" &@crlf &"name " &$voicename &@crlf &"##Properties##" &@crlf)
CreateBeepProgress("10")
If $isKlatt = "1" then
FileWrite($VoiceFile, "klatt " &$Klatt &@crlf)
CreateBeepProgress("15")
EndIF
FileWrite($VoiceFile, "gender " &$gender &@crlf &"flutter " &$flutter &@crlf)
CreateBeepProgress("20")
FileWrite($VoiceFile, "##voice creation##" &@crlf &"formant 0 " &$f0param1 &" " &$f0param2 &" " &$f0param3 &@crlf &"formant 1 " &$f1param1 &" " &$f1param2 &" " &$f1param3 &@crlf &"formant 2 " &$f2param1 &" " &$f2param2 &" " &$f2param3 &@crlf &"formant 3 " &$f3param1 &" " &$f3param2 &" " &$f3param3 &@crlf &"formant 4 " &$f4param1 &" " &$f4param2 &" " &$f4param3 &@crlf)
CreateBeepProgress("30")
FileWrite($VoiceFile, "formant 5 " &$f5param1 &" " &$f5param2 &" " &$f5param3 &@crlf &"formant 6 " &$f6param1 &" " &$f6param2 &" " &$f6param3 &@crlf &"formant 7 " &$f7param1 &" " &$f7param2 &" " &$f7param3 &@crlf &"formant 8 " &$f8param1 &" " &$f8param2 &" " &$f8param3 &@crlf)
CreateBeepProgress("40")
FileWrite($VoiceFile, "##misceanellous##" &@crlf &"intonation " &$intonation &@crlf &"pitch " &$pitch1 &" " &$pitch2 &@crlf)
CreateBeepProgress("50")
If $isEcho = "1" then
FileWrite($VoiceFile, "echo " &$echo1 &" " &$echo2 &@crlf)
CreateBeepProgress("55")
EndIf
FileWrite($VoiceFile, "roughness " &$roughness &@crlf)
CreateBeepProgress("60")
If $isBreath = "1" then
FileWrite($VoiceFile, "breath " &$breath1 &" " &$breath2 &" " &$breath3 &" " &$breath4 &" " &$breath5 &" " &$breath6 &" " &$breath7 &" " &$breath8 &@crlf)
CreateBeepProgress("65")
FileWrite($VoiceFile, "breathw " &$breathw1 &" " &$breathw2 &" " &$breathw3 &" " &$breathw4 &" " &$breathw5 &" " &$breathw6 &" " &$breathw7 &" " &$breathw8 &@crlf)
CreateBeepProgress("70")
EndIf
If $isConsonants = "1" then
FileWrite($VoiceFile, "consonants " &$consonants1 &" " &$consonants2 &@crlf)
CreateBeepProgress("75")
EndIf
If $isVoicing = "1" then
FileWrite($VoiceFile, "voicing " &$voicing &@crlf)
CreateBeepProgress("80")
EndIf
FileWrite($VoiceFile, "speed " &$speed &@crlf)
CreateBeepProgress("85")
If $isStress = "1" then
FileWrite($VoiceFile, "stressLength 0 1 2 3 4 5 6 7" &@crlf &"stressAdd " &$stressAdd1 &" " &$stressAdd2 &" " &$stressAdd3 &" " &$stressAdd4 &" " &$stressAdd5 &" " &$stressAdd6 &" " &$stressAdd7 &" " &$stressAdd8 &@crlf)
CreateBeepProgress("90")
EndIf
sleep(5000)
FileClose($voicefile)
CreateBeepProgress("95")
Speaking(translate($idioma, "Voice created successfully!"))
CreateBeepProgress("100")
MsgBox(48, translate($idioma, "Voice created"), translate($idioma, "The voice has been created successfully!"))
EndFunc
Func _Exit()
Exit
EndFunc
func playhelp()
Local $manualdoc = "documentation\" &$idioma &"\manual.txt"
Global $DocOpen = FileOpen($manualdoc, $FO_READ)
ToolTip(translate($idioma, "opening..."))
speaking(translate($idioma, "opening..."))
sleep(50)
If $DocOpen = -1 Then MsgBox(16, translate($idioma, "Error"), translate($idioma, "An error occurred while reading the file."))
ToolTip("")
Global $openned = FileRead($DocOpen)
global $manualw = GUICreate(translate($idioma, "User manual"))
Local $idMyedit = GUICtrlCreateEdit($openned, 8, 50, 120, 50, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY))
$idExitGUI = GUICtrlCreateButton("close", 100, 50, 130, 75)
GuiCtrlSetOnEvent($idExitGUI, "closefile")
GUISetOnEvent($GUI_EVENT_CLOSE, "closefile")
GUISetState(@SW_SHOW)
EndFunc
func closefile()
FileClose($DocOpen)
GuiDelete($manualw)
Speaking(translate($idioma, "Window closed"))
EndFunc
func ReadChanges2()
Local $doc = "documentation\" &$idioma &"\changes.txt"
Local $DocOpen = FileOpen($doc, $FO_READ)
ToolTip(translate($idioma, "Opening..."))
speaking(translate($idioma, "Opening..."))
sleep(50)
If $DocOpen = -1 Then MsgBox(16, translate($idioma, "error"), translate($idioma, "An error occurred while reading the file."))
Local $openned = FileRead($DocOpen)
global $manualwindow = GUICreate(translate($idioma, "changes"))
Local $idMyedit = GUICtrlCreateEdit($openned, 8, 92, 121, 97, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY))
$idExitGUI2 = GUICtrlCreateButton("close", 100, 50, 130, 75)
GuiCtrlSetOnEvent($idExitGUI2, "closefile2")
GUISetOnEvent($GUI_EVENT_CLOSE, "closefile2")
GUISetState(@SW_SHOW)
EndFunc
func closefile2()
FileClose($DocOpen)
GUIDelete($manualwindow)
EndFunc
func github()
ShellExecute("https://github.com/rmcpantoja/")
EndFunc