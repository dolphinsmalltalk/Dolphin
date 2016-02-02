@ECHO OFF
ECHO Running regression tests
START /Wait Dolphin7 DPRO.img7 -f RegressionTestsRun.st -q
FINDSTR /L /C:" 0 errors" DPRO.testlog

IF %ERRORLEVEL% NEQ 0 (
  TYPE DPRO.testlog
  ECHO Tests failed
  EXIT -1
)

ECHO Finished regression tests