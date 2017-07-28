@ECHO OFF
ECHO Running regression tests
echo. >DPRO.errors
Dolphin7 DPRO.img7 -u -f RegressionTestsRun.st -q
set errorCode=%ERRORLEVEL%
TYPE DPRO.errors
if NOT "%APPVEYOR%"=="" powershell.exe -file UploadTestResults.ps1
EXIT /b %errorCode%
