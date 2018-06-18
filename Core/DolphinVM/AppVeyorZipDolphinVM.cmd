ECHO Zip Dolphin VM Binaries
7z a DolphinVM.zip %~dp0%CONFIGURATION%\*.dll %~dp0%CONFIGURATION%\*.exe
7z a DolphinPdbs.zip %~dp0%CONFIGURATION%\Dolphin*.pdb
