var wshShell = new ActiveXObject("WScript.Shell");
var ps1 = WScript.Arguments.Item(0);
var ret = wshShell.Run('%SystemRoot%\\system32\\WindowsPowerShell\\v1.0\\powershell.exe -ExecutionPolicy Bypass -File "' + ps1 + '"', 0, false);
WScript.Quit(ret);