@ECHO OFF
rem - This creates a directory for use in Wine
rem - See http://www.object-arts.com/blog/files/904294e27cec4b8dff96422f3197f603-5.html
Dolphin7 DPRO.img7 -q -i Dolphin -f winefix.st -x
IF %ERRORLEVEL% NEQ 0 (
 ECHO Boot failed, Code=%ERRORLEVEL%
 PAUSE
)
mkdir wine
rem - pretty sure not all of this is needed!
copy ConsoleStub.exe wine
copy ConsoleToGo.exe wine
move Dolphin.chg wine
move Dolphin.img7 wine
move Dolphin.sml wine
copy Dolphin7.exe wine
copy DolphinCR7.dll wine
copy DolphinDR7.dll wine
copy DolphinSureCrypto.dll wine
copy DolphinVM7.dll wine
copy EducationCentre6.chm wine
copy EducationCentrePopups6.hlp wine
copy GUIStub.exe wine
copy GUIToGo.exe wine
robocopy Help wine\Help
copy IPDolphin.dll wine
copy IPDolphinToGo.dll wine
copy LICENSE wine
copy README.md wine
robocopy Resources wine\Resources
copy SciLexer.dll wine
copy Welcome.st wine
