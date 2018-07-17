CALL BootDPRO
IF %ERRORLEVEL% NEQ 0 (
  echo Aborting.
  exit /b %ERRORLEVEL%
)
CALL TestDPRO
