@ECHO OFF
move Boot.st BootMain.st 1> nul 2>&1
move BootBoot.st Boot.st 1> nul 2>&1
Dolphin7 DBOOT.img7
IF %ERRORLEVEL% NEQ 0 (
  ECHO Boot failed, Code=%ERRORLEVEL%
  PAUSE
) else (
  del DBOOT.chg
  move DBOOT.img DBOOT.img7 1> nul 2>&1
)
move Boot.st BootBoot.st 1> nul 2>&1
move BootMain.st Boot.st 1> nul 2>&1
