echo Dolphin image built on %date% at %time% > boot.log
set git="%USERPROFILE%\AppData\Local\Atlassian\SourceTree\git_local\bin\git.exe"
if not exist %git% goto :eof
%git% log --pretty=format:"From GIT hash %%H%%n" -n 1 >> boot.log
%git% status >> boot.log
%git% remote -v | findstr fetch >> boot.log
:eof