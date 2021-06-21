@ECHO OFF
Dolphin8 DBOOT.img8 UpdateBoot
IF %ERRORLEVEL% NEQ 0 (
  ECHO Boot failed, Code=%ERRORLEVEL%
  PAUSE
) else (
  MOVE DBOOT.img DBOOT.img8 >nul 2>nul
  DEL DBOOT.chg
)
