@ECHO OFF
ECHO Running regression tests
echo. >DPRO.errors
Dolphin7 DPRO.img7 -u -f RegressionTestsRun.st -q
set errorCode=%ERRORLEVEL%
TYPE DPRO.errors
EXIT /b %errorCode%
