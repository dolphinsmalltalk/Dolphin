@ECHO OFF
Dolphin7 DBOOT.img7 DolphinProfessional

IF %ERRORLEVEL% NEQ 0 (
  ECHO Boot failed, Code=%ERRORLEVEL%
  EXIT %ERRORLEVEL%
)

ECHO Running regression tests
START /Wait Dolphin7 DPRO.img7 -f TestDPRO.st -q
TYPE DPRO.testlog

ECHO Finished regression tests
EXIT %ERRORLEVEL%

