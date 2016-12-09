@ECHO OFF
ECHO Running regression tests
echo. >DPRO.errors
echo Fatal error terminated run: >DPRO.testlog
START /B /Wait Dolphin7 DPRO.img7 -u -f RegressionTestsRun.st -q
FINDSTR /L /C:"PASSED" DPRO.testlog >nul
set errorCode=%ERRORLEVEL%
TYPE DPRO.testlog
TYPE DPRO.errors
EXIT /b %errorCode%
