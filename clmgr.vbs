intJobNum = 10

Set objShell = CreateObject("WScript.Shell")
Const HKEY_LOCAL_MACHINE = &H80000002
strComputer = "."
Set objRegistry = GetObject("winmgmts:{impersonationLevel=Impersonate}!\\" & strComputer & "\root\default:StdRegProv")
strRegRoot = HKEY_LOCAL_MACHINE
strKey = "SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\VolumeCaches"
If objRegistry.EnumKey(strRegRoot, strKey, arrKeyNames) = 0 Then
	If IsNull(arrKeyNames) = False Then
		' Add the option for this job under every key
		For Each strKeyName In arrKeyNames
			If Right(strKey, 1) = "\" Then
				strFullPath = strKey & strKeyName
			Else
				strFullPath = strKey & "\" & strKeyName
			End If
			' objRegistry.GetDWORDValue strRegRoot, strFullPath, "StateFlags" & Right("0000" & intJobNum, 4), 2
			objRegistry.GetDWORDValue strRegRoot, strFullPath, "StateFlags" & Right("0000" & intJobNum, 4)

		Next
		' objShell.Run "CLEANMGR /sagerun:" & intJobNum, 1, True
		' Remove the option for this job under every key
		For Each strKeyName In arrKeyNames
			If Right(strKey, 1) = "\" Then
				strFullPath = strKey & strKeyName
			Else
				strFullPath = strKey & "\" & strKeyName
			End If
			' objRegistry.DeleteValue strRegRoot, strFullPath, "StateFlags" & Right("0000" & intJobNum, 4)
		Next
	Else
		WScript.Echo "No keys were found under " & strKey
	End If
Else
	WScript.Echo strKey & " was not found."
End If