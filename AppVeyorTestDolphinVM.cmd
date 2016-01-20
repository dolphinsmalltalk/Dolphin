@ECHO ON
git clone -q --branch=master https://github.com/dolphinsmalltalk/Dolphin.git Dolphin

copy ..\..\Dolphin7.exe Dolphin
copy ..\..\DolphinVM7.dll Dolphin
copy ..\..\DolphinCR7.dll Dolphin
copy ..\..\DolphinDR7.dll Dolphin
copy ..\..\DolphinSureCrypto.dll Dolphin

cd Dolphin
CALL BootDPRO
CALL TestDPRO