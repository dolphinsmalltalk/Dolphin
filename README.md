# DolphinVM
Dolphin Smalltalk virtual machine. 

MSVC solution to build the Virtual Machine (VM) elements of Dolphin Smalltalk. This is not required to run the Dolphin IDE, which is available in the [Dolphin](https://github.com/objectarts/Dolphin) GitHub repository, since the latter comes with the executables already pre-built. You'll only need to build DolphinVM if you need to explicitly change the VM itself.

You should clone this repo into a DolphinVM\ subdirectory of Dolphin\Core\.

Load the DolphinVM solution into MSVC 2013 Community Edition or later. This is a C++ set of projects so make sure you install this version of MSVC. Choose the Release profile (Debug will **not** compile) and then Build Solution. The first time you'll get errors but these should disappear after a second Build. A bunch of DLLs and Dolphin.exe will have been copied to the Dolphin\ root folder.

[![Build status](https://ci.appveyor.com/api/projects/status/6ru55e8y9huog899/branch/master?svg=true)](https://ci.appveyor.com/project/dolphinsmalltalk/dolphinvm-nf68c/branch/master)
