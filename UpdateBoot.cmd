@ECHO OFF
Dolphin7 DBOOT.img7 UpdateBoot
IF %ERRORLEVEL% NEQ 0 (
  ECHO Boot failed, Code=%ERRORLEVEL%
  PAUSE
) else (
  MOVE DBOOT.img DBOOT.img7 >nul
  DEL DBOOT.chg
)
