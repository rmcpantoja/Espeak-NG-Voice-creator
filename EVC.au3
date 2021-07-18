;Espeak NG Voice creator (Reescrito)
;La versión 0.1 de octubre de 2020 me ha  gustado, sin duda, porque me dibertí mucho con él creando nuevas voces, y lo mejor de todo es que las conservo, pero desafortunadamente el código no.
;Espero que esta nueva versión reescrita no se pierda más. De hecho, la suviré a la web en cuanto termine y actualizaré dentro de toda mi swite de cosas y seré más cuidadoso con esto. Sin embargo dudo un poco que esto tenga interés porque el sintetizador espeak no es tan aceptada por la gente y un poco odiado se podría decir, por la voz.
;E aquí el código:
; #pragma compile(Icon, C:\Program Files\AutoIt3\Icons\au3.ico)
;#pragma compile(Compression, 2)
#pragma compile(UPX, False)
#pragma compile(FileDescription, Espeak NG Voice Creator - Create diferent voices for espeak NG sintesizer)
#pragma compile(ProductName, Espeak NG Voice Creator)
#pragma compile(ProductVersion, 0.2.0.0)
#pragma compile(FileVersion, 0.2.0.0, 0.2.0.0)
#pragma compile(LegalCopyright, © 2018-2021 MT Programs, All rights reserved)
#pragma compile(CompanyName, 'MT Programs')
;Include:
#include <EditConstants.au3>
#include <fileConstants.au3>
#include <GUIConstantsEx.au3>
#include <Include\kbc.au3>
#include "Include\NVDAControllerClient.au3"
#include "include\Progress.au3"
#include "include\Reader.au3"
#Include "Include\sapi.au3"
#include "updater.au3"
#include <WindowsConstants.au3>
Opt("GUIOnEventMode",1)
global $program_ver = "0.3"
;$ejecucion = Register_Run("EVC")
sleep(50)
if not fileExists ("config") then
DirCreate("config")
EndIf
checkupd()
func checkupd()
global $main_u = GUICreate("Checking version...")
GUISetState(@SW_SHOW)
sleep(150)
toolTip("checking version...")
speaking("Checking version...")
checkversion()
GUIDelete($main_u)
sleep(100)
endfunc
func checkversion()
Local $yourexeversion = $program_ver
$newversion=" You have the version "
$newversion2=", And is available the "
$fileinfo = InetGet("https://www.dropbox.com/s/mxxplt275lmxt1r/EVCWeb.dat?dl=1", "EVCWeb.dat")
FileMove("EVCWeb.dat", @TempDir & "\EVCWeb.dat")
$latestver = iniRead (@TempDir & "\EVCWeb.dat", "updater", "LatestVersion", "")
select
Case $latestVer > $yourexeversion
speak("there is a new version.")
TTSDialog("update available! " &$newversion &$yourexeversion &$newversion2 &$latestver& ". Press enter to download.")
GUIDelete($main_u)
_Updater_Update("MC.exe", "none", "https://www.dropbox.com/s/e2y1nb0r449wxq4/MCExtract.exe?dl=1")
case else
GUIDelete($main_u)
main()
endselect
InetClose($fileinfo)
If @Compiled Then
FileDelete("MCWeb.dat")
FileDelete(@tempDir & "\MCWeb.dat")
EndIf
GUIDelete($main_u)
endfunc
Func Main()
if @compiled then
FileDelete("EVCWeb.dat")
EndIf
$Gui_main = guicreate("Espeak NG Voice Creator Version " &$program_ver)
speaking("Loading")
HotKeySet("{F1}", "playhelp")
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")
;$r_Label = GUICtrlCreateLabel("Runs: " &$rundata, 30, 100, 20, 20)
Local $idCreatebutton = GUICtrlCreateButton("Create voice", 65, 80, 20, 20)
GuiCtrlSetOnEvent($idCreatebutton, "crearvoz")
Local $idManualbutton = GUICtrlCreateButton("User Manual", 110, 80, 20, 20)
GuiCtrlSetOnEvent($idManualbutton, "playhelp")
Local $idExitbutton = GUICtrlCreateButton("&exit", 120, 80, 20, 20)
GuiCtrlSetOnEvent($idExitbutton, "_exit")
GUISetState(@SW_SHOW)
While 1
WEnd
EndFunc
Func Crearvoz()
Speaking("Preparing your Voice...")
CreateAudioProgress("0")
;Declarando variables:
global $voicename = "Voice" &Random(1, 1000, 1)
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
Local $sServer = 'ftpupload.net'
Local $sUsername = 'n260m_27330965'
Local $sPass = 'mrcp123'
Local $Err, $sFTP_Message
Local $hOpen = _FTP_Open('mateocedillo.260mb.net')
Local $hConn = _FTP_Connect($hOpen, $sServer, $sUsername, $sPass)
If @error Then
MsgBox($MB_SYSTEMMODAL, "Error", "Code: " &@error)
EndIf
Speaking("Creating Your Voice: Your Voice ID is: " &$voicename &". Please do not close this window until further notice.")
CreateAudioProgress("10")
Local $voicefile = FileOpen("voices\" &$voicename,$FC_OVERWRITE  + $FC_CREATEPATH)
	If $voicefile = -1 Then
		MsgBox($MB_SYSTEMMODAL, "error", "An error occurred while reading the file.")
	EndIf
FileWrite($VoiceFile, "##This voice has been created with Espeak NG Voice Creator##" &@crlf &"language variant" &@crlf &"name " &$voicename &@crlf &"##Properties##" &@crlf &"gender " &$gender &@crlf &"flutter " &$flutter &@crlf)
CreateAudioProgress("20")
FileWrite($VoiceFile, "##voice creation##" &@crlf &"formant 0 " &$f0param1 &" " &$f0param2 &" " &$f0param3 &@crlf &"formant 1 " &$f1param1 &" " &$f1param2 &" " &$f1param3 &@crlf &"formant 2 " &$f2param1 &" " &$f2param2 &" " &$f2param3 &@crlf &"formant 3 " &$f3param1 &" " &$f3param2 &" " &$f3param3 &@crlf &"formant 4 " &$f4param1 &" " &$f4param2 &" " &$f4param3 &@crlf)
CreateAudioProgress("30")
FileWrite($VoiceFile, "formant 5 " &$f5param1 &" " &$f5param2 &" " &$f5param3 &@crlf &"formant 6 " &$f6param1 &" " &$f6param2 &" " &$f6param3 &@crlf &"formant 7 " &$f7param1 &" " &$f7param2 &" " &$f7param3 &@crlf &"formant 8 " &$f8param1 &" " &$f8param2 &" " &$f8param3 &@crlf)
CreateAudioProgress("40")
FileWrite($VoiceFile, "##misceanellous##" &@crlf &"intonation " &$intonation &@crlf &"pitch " &$pitch1 &" " &$pitch2 &@crlf)
CreateAudioProgress("50")
If $isEcho = "1" then
FileWrite($VoiceFile, "echo " &$echo1 &" " &$echo2 &@crlf)
CreateAudioProgress("55")
EndIf
FileWrite($VoiceFile, "roughness " &$roughness &@crlf)
CreateAudioProgress("60")
If $isBreath = "1" then
FileWrite($VoiceFile, "breath " &$breath1 &" " &$breath2 &" " &$breath3 &" " &$breath4 &" " &$breath5 &" " &$breath6 &" " &$breath7 &" " &$breath8 &@crlf)
CreateAudioProgress("65")
EndIf
If $isConsonants = "1" then
FileWrite($VoiceFile, "consonants " &$consonants1 &" " &$consonants2 &@crlf)
CreateAudioProgress("70")
EndIf
If $isVoicing = "1" then
FileWrite($VoiceFile, "voicing " &$voicing &@crlf)
CreateAudioProgress("75")
EndIf
FileWrite($VoiceFile, "speed " &$speed &@crlf &"stressLength 0 1 2 3 4 5 6 7" &@crlf &"stressAdd " &$stressAdd1 &" " &$stressAdd2 &" " &$stressAdd3 &" " &$stressAdd4 &" " &$stressAdd5 &" " &$stressAdd6 &" " &$stressAdd7 &" " &$stressAdd8 &@crlf)
CreateAudioProgress("80")
sleep(10000)
FileClose($voicefile)
CreateAudioProgress("90")
Speaking("Voice created successfully!")
CreateAudioProgress("100")
MsgBox(64, "Voice created", "The voice has been created successfully!")
EndFunc
Func _Exit()
_nvdaControllerClient_free()
sleep(300)
Exit
EndFunc
func playhelp()
Local $manualdoc = "documentation\manual2.txt"
$editmessage1="User manual."
$editmessage2="The file cannot be found."
$editmessage3="opening..."
$editmessage4="An error occurred while reading the file."
$editmessage5="error"
Global $DocOpen = FileOpen($manualdoc, $FO_READ)
ToolTip($editmessage3)
speaking($editmessage3)
sleep(50)
If $DocOpen = -1 Then
MsgBox($MB_SYSTEMMODAL, $editmessage5, $editmessage4)
Return False
EndIf
Global $openned = FileRead($DocOpen)
global $manualw = GUICreate($manualdoc)
;GUISetOnEvent($GUI_EVENT_CLOSE, "closefile")
Local $idMyedit = GUICtrlCreateEdit($openned, 8, 50, 120, 50, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY, $WS_VSCROLL, $WS_VSCROLL, $WS_CLIPSIBLINGS))
$idExitGUI = GUICtrlCreateButton("close", 100, 50, 130, 75)
GuiCtrlSetOnEvent($idExitGUI, "closefile")
GUISetState(@SW_SHOW)
While 1
WEnd
GuiDelete($manualw)
EndFunc
func closefile()
FileClose($DocOpen)
GuiDelete($manualw)
Speaking("Window closed")
EndFunc