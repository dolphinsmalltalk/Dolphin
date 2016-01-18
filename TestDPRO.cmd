@ECHO OFF
ECHO Running regression tests
START /Wait Dolphin7 DPRO.img7 -f TestDPRO.st -q

IF %ERRORLEVEL% NEQ 0 (
  TYPE DPRO.testlog
  ECHO Tests failed=%ERRORLEVEL%
  EXIT -1
)

TYPE DPRO.testlog
ECHO Finished regression tests
EXIT -1

