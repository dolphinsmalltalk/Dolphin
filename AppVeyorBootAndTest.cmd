CALL BootDPRO
IF %ERRORLEVEL% NEQ 0 (
    echo Aborting.
    exit /b %ERRORLEVEL%
)
choco install psqlodbc --no-progress
powershell.exe -ExecutionPolicy RemoteSigned -file InstallMysqlOdbc.ps1
net start MySQL80
net start MSSQL$SQL2022
net start postgresql-x64-16
TZUTIL /s "Chatham Islands Standard Time"
CALL TestDPRO
set err=%ERRORLEVEL%
TZUTIL /s "UTC"
exit /b %err%