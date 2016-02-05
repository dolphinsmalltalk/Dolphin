# Dolphin

This repository contains the necessary files to build the [Dolphin Smalltalk](object-arts.com) Core Images from a pre-built boot image. 

Note: if you are just looking to install Dolphin and get going as quickly as possible you may prefer to start with the release build and [Setup Installer](http://object-arts.com/downloads.html) and follow the directions [here](http://object-arts.com/gettingstarted.html). However, if you’d really like to know how Dolphin is put together then the sources are available here on GitHub in two repositories:

* **Dolphin** - This repository. This the Dolphin image and the means to build the various product incarnations from a prebuilt boot image. Executables for the various virtual machine components are included, so it is not necessary to compile these from source unless you really need to. If you do want to build the VM, you'll want the repo below in addition to this one.

* **[DolphinVM](https://github.com/dolphinsmalltalk/DolphinVM)** - This is repository for the Dolphin Smalltalk virtual machine and the helper DLLs for deploying to the different Windows target formats.

## Building the Dolphin 7 Product Images

Follow these instructions to create the product images and launch Dolphin Smalltalk for the first time.

* First clone the Dolphin repository (this one) into a suitable working directory on your machine, let's call it `\Dolphin`. Any version of Windows from XP onwards should be suitable but most validation has been done under Windows 10.

* In the new directory you will find a number of CMD files used boot the images for the various products. Three such products are available, DCORE, DCE and DPRO. Normally, you will want to use DPRO only, since this is a superset of all the others. However, it is worthwhile booting all of the products after each change to make sure that nothing in the boot sequence has been broken. This can be done with the `BootAll` CMD file. _Note: DPRO stands for Dolphin Professional_.

* Double-click `BootAll.cmd`. A console window will open and sequentially spawn the individual boot jobs. Depending on the heritage of your Windows environment, you may see a failure message saying that `MSVCRT140.DLL` cannot be found. If this is the case on your system, you will need to download and install the [Visual Studio 2015 Redistributable](https://www.microsoft.com/en-us/download/details.aspx?id=48145) components. Since Dolphin is a 32 bit application you’ll only need `vcredist_x86.exe`. If you need to do this then, once installed, try the `BootAll` again.

* When the boot processes have completed, you should see a number of `.img7` files in your directory. IMG7 is the new image extension for Dolphin 7. You should right click on `DPRO.img7` and choose _Open With_, selecting `Dolphin7.exe` as the executable to be permanently associated with this file type.

You should see Dolphin Professional 7 launch successfully. We’ll leave it as an exercise for the reader to work out how to dismiss the splash screen. You can now continue with the Dolphin [Getting Started](http://object-arts.com/gettingstarted.html) introduction if you wish.

![Dolphin System Folder](https://raw.githubusercontent.com/dolphinsmalltalk/Dolphin/master/Help/Images/SystemFolder.png)

[![Build status](https://ci.appveyor.com/api/projects/status/scael64ohx3l6io9/branch/master?svg=true)](https://ci.appveyor.com/project/dolphinsmalltalk/dolphin-db22v/branch/master)

