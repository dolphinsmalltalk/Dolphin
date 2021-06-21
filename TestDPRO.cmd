@ECHO OFF
echo. >DPRO.errors
Dolphin8 DPRO.img8 -u -f RegressionTestsRun.st -q
set errorCode=%ERRORLEVEL%
TYPE DPRO.errors
if NOT "%APPVEYOR%"=="" powershell.exe -file UploadTestResults.ps1
EXIT /b %errorCode%
