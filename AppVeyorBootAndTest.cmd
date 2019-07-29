CALL BootDPRO
IF %ERRORLEVEL% NEQ 0 (
    echo Aborting.
    exit /b %ERRORLEVEL%
)
TZUTIL /s "Chatham Islands Standard Time"
CALL TestDPRO
set err=%ERRORLEVEL%
TZUTIL /s "UTC"
exit /b %err%