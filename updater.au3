;Auto Actualizador (Auto updater)
;Created by Mateo Cedillo.
;Script:
;Including scripts
#include <AutoItConstants.au3>
#include <MsgBoxConstants.au3>
#include "include\sapi.au3"
func checkupdate($S_Program, $s_executable, $s_DatURL, $s_Window)
$main = GUICreate($s_window)
GUISetState(@SW_SHOW)
sleep(10)
$sLanguage = iniRead ("config\config.st", "General settings", "language", "")
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
Local $yourexeversion = FileGetVersion($s_executable)
select
case $sLanguage ="es"
$newversion=" Tienes la "
$newversion2=", y está disponible la "
case $sLanguage ="eng"
$newversion=" You have the version "
$newversion2=", And is available the "
endselect
$fileinfo = InetGet($s_DatURL, $S_Program &"Web.dat")
FileCopy($s_Program &"Web.dat", @TempDir & "\" &$S_Program &"Web.dat")
$latestver = iniRead (@TempDir & "\" &$S_program &"Web.dat", "updater", "LatestVersion", "")
if $sLanguage ="Es" then
if $ReadAccs ="Yes" then
select
Case $latestVer = 0
speak("no se ha podido comprovar versión.")
Case $latestVer < $yourexeversion
speak("la versión que hemos buscado es menor a la que tienes.")
Case $latestVer > $yourexeversion
speak("actualización disponible!" & $newversion & $yourexeversion & $newversion2 & $latestver & ". Haz el favor de actualizar o si  no, que te den.")
Case $latestVer >= $yourexeversion
speak("estás actualizado. Tienes la última versión.")
endselect
endif
endif
if $sLanguage ="Eng" then
select
Case $latestVer = 0
speak("version could not be checked.")
Case $latestVer < $yourexeversion
speak("the version we have looked for is lower than the one you have.")
Case $latestVer > $yourexeversion
speak("update available!" & $newversion & $yourexeversion & $newversion2 & $latestver & ". Please update.")
Case $latestVer >= $yourexeversion
speak("you are up to date.")
endselect
endif
if $ReadAccs ="No" then
if $sLanguage ="Es" then
select
Case $latestVer = 0
msgbox(0, "Error", "no se ha podido comprovar versión.")
Case $latestVer < $yourexeversion
msgbox(0, "Error", "la versión que hemos buscado es menor a la que tienes.")
Case $latestVer > $yourexeversion
$result= ($newversion &$yourexeversion &$newversion2 &$latestver)
msgbox(0, "actualización disponible!", $result)
Case $latestVer >= $yourexeversion
msgbox(0, "estás actualizado", "no hay actualización por el momento.")
endselect
endif
endif
if $sLanguage ="Eng" then
select
Case $latestVer = 0
msgbox(0, "Error", "version could not be checked.")
Case $latestVer < $yourexeversion
msgbox(0, "Error", "the version we have looked for is lower than the one you have.")
Case $latestVer > $yourexeversion
$result= ($newversion &$yourexeversion &$newversion2 &$latestver)
msgbox(0, "update available!", $result)
Case $latestVer >= $yourexeversion
msgbox(0, "you are up to date", "no update at the moment.")
endselect
endif
InetClose($fileinfo)
FileDelete(@tempDir & "\" &$S_Program &"Web.dat")
endfunc
func _exitpersonaliced()
$devmode="0"
select
case $devmode= "0"
;FileDelete("MCYWeb.dat")
FileDelete(@tempDir & "\MCWeb.dat")
sleep(10)
exit
case $devmode= "1"
exit
endselect
endfunc
Func _GetDisplaySize($iTotalDownloaded, Const $iPlaces)
Local Static $aSize[4] = ["Bytes", "KB", "MB", "GB"]
For $i = 0 to 3
$iTotalDownloaded /= 1024
If (Int($iTotalDownloaded) = 0) Then Return Round($iTotalDownloaded * 1024, $iPlaces) & " " & $aSize[$i]
Next
EndFunc
func _Updater_Update($S_executable, $S_URLinstallable, $S_URLPortable)
$sLanguage = iniRead ("config\config.st", "General settings", "language", "")
$ReadAccs = iniRead ("config\config.st", "Accessibility", "Enable enanced accessibility", "")
select
case $sLanguage ="Es"
ProgressOn("Descargando actualización.", "espera...", "0%", 100, 100, 16)
case $sLanguage ="Eng"
ProgressOn("Downloading update.", "Please wait...", "0%", 100, 100, 16)
endselect
$iPlaces = 2
$AppUrl = $S_URLPortable
$fldr = 'MCExtract.exe'
$hInet = InetGet($AppUrl, $fldr, 1, 1)
$URLSize = InetGetSize($AppUrl)
While Not InetGetInfo($hInet, 2)
Sleep(50)
$Size = InetGetInfo($hInet, 0)
$Percentage = Int($Size / $URLSize * 100)
$iSize = $URLSize - $Size
select
case $sLanguage ="Es"
$m2="Descargando..."
ProgressSet($Percentage, $m2, _GetDisplaySize($iSize, $iPlaces = 2) & " restante(s) " & $Percentage & " porciento completado")
case $sLanguage ="Eng"
ProgressSet($Percentage, _GetDisplaySize($iSize, $iPlaces = 2) & " remaining " & $Percentage & " percent completed.")
endselect
If _ispressed($I) Then
select
case $ReadAccs ="yes"
speaking("FileSize in bites:" & $URLSize & ". Downloaded: " & $Size& ". Progress: " & $Percentage & "%. Remaining: " & $iSize)
case $ReadAccs ="no"
msgbox (0, "Information", "FileSize in bites:" & $URLSize & ". Downloaded: " & $Size& ". Progress: " & $Percentage & "%. Remaining: " & $iSize)
endselect
endif
WEnd
select
case $sLanguage ="Es"
ProgressSet(90, "Acabando", "Acabando...")
case $sLanguage ="Eng"
ProgressSet(90, "ending up", "ending up... Please wait.")
endselect
select
case $sLanguage ="Es"
ProgressSet(99, "Instalando la actualización.", "Espera mientras el programa se actualiza.")
case $sLanguage ="Eng"
ProgressSet(99, "Installing update.", "Please wait while the program updates")
endselect
sleep(3000)
$process = ProcessExists($s_Executable)
If NOT $process = 0 Then
;ProcessClose($S_Executable)
sleep(50)
EndIf
run("MCExtract.exe")
sleep(500)
ProgressOff()
_exitpersonaliced()
endfunc
func DownloadEMK()
$sLanguage = iniRead ("config\config.st", "General settings", "language", "")
select
case $sLanguage ="Es"
ProgressOn("Descargando actualización.", "espera...", "0%", 100, 100, 16)
case $sLanguage ="Eng"
ProgressOn("Downloading update.", "Please wait...", "0%", 100, 100, 16)
endSelect
$iPlaces = 2
$AppUrl = 'https://www.dropbox.com/s/4wsca8huwjcltsg/EMK_extract.exe?dl=1'
$fldr = 'Extract.exe'
$hInet = InetGet($AppUrl, $fldr, 1, 1)
$URLSize = InetGetSize($AppUrl)
While Not InetGetInfo($hInet, 2)
;MsgBox($MB_SYSTEMMODAL + $MB_ICONERROR, "Error", "Failed to download. Please try again.")
Sleep(50)
$Size = InetGetInfo($hInet, 0)
$Percentage = Int($Size / $URLSize * 100)
$iSize = $URLSize - $Size
select
case $sLanguage ="Es"
$m2="Descargando..."
ProgressSet($Percentage, $m2, _GetDisplaySize($iSize, $iPlaces = 2) & " restante(s) " & $Percentage & " porciento completado")
case $sLanguage ="Eng"
ProgressSet($Percentage, _GetDisplaySize($iSize, $iPlaces = 2) & " remaining " & $Percentage & " percent completed.")
endselect
If _ispressed($I) Then
msgbox (0, "Information", "FileSize in bites:" & $URLSize & ". Downloaded: " & $Size& ". Progress: " & $Percentage & "%. Remaining: " & $iSize)
endif
WEnd
select
case $sLanguage ="Es"
ProgressSet(90, "Acabando", "Acabando...")
case $sLanguage ="Eng"
ProgressSet(90, "ending up", "ending up... Please wait.")
endselect
select
case $sLanguage ="Es"
ProgressSet(99, "Instalando la actualización.", "Emulate keys se está instalando.")
case $sLanguage ="Eng"
ProgressSet(99, "Installing update.", "Emulate keys is installing.")
endselect
sleep(3000)
$process = ProcessExists("EMK.exe")
If NOT $process = 0 Then
ProcessClose("EMK.exe")
EndIf
runWait("extract.exe")
sleep(1000)
FileDelete("extract.exe")
;run("EMK.exe")
ProgressOff()
_exitpersonaliced()
endfunc