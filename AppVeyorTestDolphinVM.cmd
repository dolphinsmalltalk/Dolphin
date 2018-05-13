ECHO Clone Dolphin image environment
git clone -q --branch=master https://github.com/dolphinsmalltalk/Dolphin.git Dolphin

ECHO Copy executables
copy ..\..\*.exe Dolphin
copy ..\..\*.dll Dolphin

ECHO Boot and test image
cd Dolphin
CALL BootDPRO
CALL TestDPRO