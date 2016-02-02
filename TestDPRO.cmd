@ECHO OFF
ECHO Running regression tests
START /Wait Dolphin7 DPRO.img7 -f RegressionTestsRun.st -q
set errorCode=%ERRORLEVEL%
TYPE DPRO.testlog
EXIT errorCode
