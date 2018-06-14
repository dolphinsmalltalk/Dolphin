ECHO Zip Dolphin VM Binaries
7z a DolphinVM.zip %APPVEYOR_BUILD_FOLDER%\Release\*.dll %APPVEYOR_BUILD_FOLDER%\Release\*.exe
