@ECHO OFF
call BootLog.cmd
Dolphin7 DBOOT.img7 DolphinCommunityEdition
IF %ERRORLEVEL% NEQ 0 (
  ECHO Boot failed, Code=%ERRORLEVEL%
  PAUSE
)
