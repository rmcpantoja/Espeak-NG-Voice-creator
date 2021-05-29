#include-once

Func NVDAController_BrailleMessage($message)
Local $aRet = DllCall("nvdaControllerClient32.dll", "ulong", "nvdaController_brailleMessage", "wstr", $message)
If @error Then Return SetError(@error, @extended, Null)
Return SetError(0, 0, $aRet[0])
EndFunc

Func NVDAController_CancelSpeech()
Local $aRet = DllCall("nvdaControllerClient32.dll", "ulong", "nvdaController_cancelSpeech")
If @error Then Return SetError(@error, @extended, Null)
Return SetError(0, 0, $aRet[0])
EndFunc

Func NVDAController_SpeakText($text)
Local $aRet = DllCall("nvdaControllerClient32.dll", "ulong", "nvdaController_speakText", "wstr", $text)
If @error Then Return SetError(@error, @extended, Null)
Return SetError(0, 0, $aRet[0])
EndFunc

Func NVDAController_TestIfRunning()
Local $aRet = DllCall("nvdaControllerClient32.dll", "ulong", "nvdaController_testIfRunning")
If @error Then Return SetError(@error, @extended, Null)
Return SetError(0, 0, $aRet[0])
EndFunc
