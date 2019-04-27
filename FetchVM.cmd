@ECHO OFF
REM Fetch the DolphinVM binaries from GitHub into the current directory.
REM Specify a parameter to fetch a specific version or leave blank to
REM get the recommended VM version for this release of the image.

FOR /F "usebackq delims=" %%A in (`"git describe --abbrev=0"`) do SET tag=%%A
powershell.exe -ExecutionPolicy RemoteSigned -file FetchVM.ps1 %tag% %*