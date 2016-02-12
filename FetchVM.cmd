@ECHO OFF
REM Fetch the DolphinVM binaries from GitHub into the current directory.
REM Specify a parameter to fetch a specific version or leave blank to
REM get the recommended VM version for this release of the image.

powershell.exe -file FetchVM.ps1 %*