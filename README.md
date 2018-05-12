# Dolphin

_N.B. master is now the 7.1 beta which is incomplete, may have significant unresolved issues, and is not compatible with older Dolphin 7 builds. Use the 7.0 branch if you want a stable build._

[![Build status](https://ci.appveyor.com/api/projects/status/scael64ohx3l6io9/branch/master?svg=true)](https://ci.appveyor.com/project/dolphinsmalltalk/dolphin-db22v/branch/master)

This repository contains the necessary files to build the [Dolphin Smalltalk](http://object-arts.com) Core Images from a pre-built boot image.

Note: if you are just looking to install Dolphin and get going as quickly as possible you may prefer to start with the release build and [Setup Installer](http://object-arts.com/downloads.html) and follow the directions [here](http://object-arts.com/gettingstarted.html). However, if you’d really like to know how Dolphin is put together then the sources are available here on GitHub in two repositories:

* **Dolphin** - This repository. This the Dolphin image and the means to build the various product incarnations from a prebuilt boot image. Executables for the various virtual machine components can either be built from the DolphinVM repository (included as a git submodule), or fetched in pre-built form  the [DolphinVM Releases](https://github.com/dolphinsmalltalk/DolphinVM/releases).

* **[DolphinVM](https://github.com/dolphinsmalltalk/DolphinVM)** - This is repository for the Dolphin Smalltalk virtual machine and the helper DLLs for deploying to the different Windows target formats. It is included as a sub-module of the Dolphin repository in the core\DolphinVM folder.

## Building the Dolphin 7 Product Images

Follow these instructions to create the product images and launch Dolphin Smalltalk for the first time.

* First clone the Dolphin repository (this one) into a suitable working directory on your machine, let's call it `\Dolphin`. Any version of Windows from Vista onwards should be suitable but most validation has been done under Windows 10.

* The master branch is on the bleeding and may represent an unstable state, although the tests should always be passing. If you want a stable build then you should check out the 7.0 branch instead of master.

* Next you will need to build or fetch the VM binaries. For convenience a batch file, `FetchVM.CMD` is supplied and, providing you have PowerShell scripting enabled, you can just double-click this to pull the correct version of the VM down from GitHub. Alternatively, you can right click on the `FetchVM.ps1` file and choose _Run with PowerShell_, which does not require scripting to be explicitly enabled in Windows. If you supply a parameter to either of these script files you can choose to fetch an alternative VM version to the default (not usually recommended). 

* Remember, you can also choose to build the VM from source if you wish. To do so first clone the DolphinVM submodule by running the following command in a console window open in the root folder of the Dolphin repository you just cloned: `git submodule update --init`. You should then open the core\DolphinVM\Dolphin.sln file using VS2017 and build the Release configuration.

* Before proceeding you will also need to pull the boot image from github large file storage. To do this execute `git lfs pull`.

* In the root folder of the repo you will find a number of CMD files used boot the images for the various products. Two such products are available, DCORE and DPRO. Normally, you will want to use DPRO only, since this is a superset of DCORE. Sometimes it worthwhile booting both products after a change to make sure that nothing in the boot sequence has been broken. This can be done with the `BootAll` CMD file, but let's assume you just want to boot DPRO. _Note: DPRO stands for Dolphin Professional_.

* Double-click `BootDPRO.cmd` or run it from a console window. When the boot process has completed, you should see a `DPRO.img7` file in your directory. IMG7 is the new image extension for Dolphin 7.

* Should you wish to test your booted image before proceeding with your own changes or work, you may want to run the standard regression test suite. This is recommended, and easy to do. Just run the `TestDPRO.cmd` script in the root folder. This will launch Dolphin, load the tests, and then execute them. As it runs you will see results being reported as console output. When complete a summary will state whether there were any failures. You should expect there to be none, but check the [AppVeyor build]((https://ci.appveyor.com/project/dolphinsmalltalk/dolphin-db22v/branch/master) to see the current build status.

* To launch the image you can right click on `DPRO.img7` and choose _Open With_, selecting `Dolphin7.exe` as the executable to be permanently associated with this file type.

You should see Dolphin Professional 7 launch successfully. We’ll leave it as an exercise for the reader to work out how to dismiss the splash screen. You can now continue with the Dolphin [Getting Started](http://object-arts.com/gettingstarted.html) introduction if you wish.

![Dolphin System Folder](https://raw.githubusercontent.com/dolphinsmalltalk/Dolphin/master/Help/Images/SystemFolder.png)

