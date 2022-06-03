#include "include\progress.au3"
Example()
Func Example()
Local $iSavPos = 0
For $i = $iSavPos To 100
$iSavPos = $i
CreateBeepProgress($i)
Sleep(50)
			Next
			If $i > 100 Then
msgbox(0, "done", "done")
			EndIf
EndFunc