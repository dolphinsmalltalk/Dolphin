@ECHO OFF
for %%I in (..\Boot.st ..\DBOOT.img7 ..\DBOOT.sml) do (copy %%I .)
for %%* in (.) do set CurrDirName=%%~nx*
..\Dolphin7 DBOOT.img7 Project "%CurrDirName%\Project Development.pax"
IF %ERRORLEVEL% NEQ 0 (
  ECHO Boot failed, Code=%ERRORLEVEL%
)
del Boot.st DBOOT.*
