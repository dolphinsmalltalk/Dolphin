@ECHO OFF
del dboot.errors 2>nul
Dolphin8 DBOOT.img8 DolphinProfessional
IF %ERRORLEVEL% NEQ 0 (
  ECHO Boot failed, Code=%ERRORLEVEL%
  if "%AppVeyor%"=="" PAUSE
  exit /b %ERRORLEVEL%
)
