rem # Create boot.log file showing build date/time and git info if available
set savepath=%path%

rem # This line will exist in every build even if we can't find git
echo Dolphin image built on %date% at %time% > boot.log

rem # Check to see if git is already visible in the current path
git help 1> nul 2>&1
if %errorlevel% == 0 goto :git

rem # try Atlassian SourceTree
set newdir="%USERPROFILE%\AppData\Local\Atlassian\SourceTree\git_local\bin"
set path=%newdir%;%savepath%
git help 1> nul 2>&1
if %errorlevel% == 0 goto :git

rem # try other paths to git (following above pattern)

rem # git not found
goto :eof

:git
rem # check to see if current directory has a git checkout
git status 1> nul 2>&1
if not %errorlevel% == 0 goto :eof

rem # ready to add git information
git log --pretty=format:"From GIT hash %%H%%n" -n 1 >> boot.log
git status >> boot.log
git remote -v | findstr fetch >> boot.log
goto :eof

:eof
set path=%savepath%
