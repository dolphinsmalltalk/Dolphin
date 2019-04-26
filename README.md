# Dolphin

[![Build status](https://ci.appveyor.com/api/projects/status/scael64ohx3l6io9/branch/master?svg=true)](https://ci.appveyor.com/project/dolphinsmalltalk/dolphin-db22v/branch/master)

This repository contains:
* A VS2017 solution to build the Virtual Machine (VM) elements of Dolphin Smalltalk.
* The necessary Smalltalk packages to build the [Dolphin Smalltalk](https://object-arts.com) Core Images from a pre-built boot image.

Note: if you are just looking to install Dolphin and get going as quickly as possible you may prefer to start with the release build and [Setup Installer](https://object-arts.com/downloads.html) and follow the directions [here](https://object-arts.com/gettingstarted.html). However, if you’d really like to know how Dolphin is put together then the complete sources are available here on GitHub in this repository. 


## Building the Virtual Machine

* First clone the [Dolphin](https://github.com/dolphinsmalltalk/Dolphin) repo to a `\Dolphin` directory on your machine. It can actually be any location but for convenience we'll call it `\Dolphin`.  Use a Git client tool to clone. Downloading the ZIP file won't work due to use of Git LFS.

* _Versions prior to 7.1:_ You should also clone the separate VM repository (DolphinVM) into a `DolphinVM\` subdirectory of `\Dolphin\Core\`.

* _Version 7.1 and later:_ The DolphinVM repository has been merged into the main Dolphin repository and can be found in the `Core\DolphinVM` folder. The history from the original repository has been retained. 

* Install VS2017 Community Edition on your machine with the "Desktop development with C++" workload. You can use the Pro or Enterprise edition if you have it. It is possible to compile the VM with VS2015, but you will need to downgrade the solution to the v140 toolset and either retarget to the ealier Windows SDK that shipped with VS2015, or install the latest SDK standalone. Later VS versions (when they appear) may work too but we no longer support VS2013, sorry. The Dolphin VM is a set of C++ projects so make sure to install this option (it's not the default) or you'll end up only being able to compile C#.

* Load the DolphinVM solution into Visual Studio. Choose the **Release** profile (**Debug** will compile but will run slowly) and then _Build Solution_. A bunch of DLLs and `Dolphin7.exe` will have been copied to the `\Dolphin` root folder.

## Building the Dolphin 7 Product Image

Follow these instructions to create the product image and launch Dolphin Smalltalk for the first time.

* First clone the Dolphin repository (this one) into a suitable working directory on your machine, let's call it `\Dolphin`. Any version of Windows from Vista onwards should be suitable but most validation has been done under Windows 10.

* The master branch is on the bleeding edge and may represent an unstable state, although the tests should always be passing. If you want a stable build then you should check out the 7.0 branch instead of master.

* Next you will need to build the binaries as described above, or fetch the VM binaries. For convenience a batch file, `FetchVM.CMD` is supplied and, providing you have PowerShell scripting enabled, you can just double-click this to pull the correct version of the VM down from GitHub. Alternatively, you can right click on the `FetchVM.ps1` file and choose _Run with PowerShell_, which does not require scripting to be explicitly enabled in Windows. If you supply a parameter to either of these script files you can choose to fetch an alternative VM version to the default (not usually recommended). 

* Before proceeding you will also need to pull the boot image from github large file storage. To do this execute `git lfs pull`.

* In the root folder of the repo you will find the `BootDPRO.cmd` script and a small boot image, `DBOOT.img7`. Double-click `BootDPRO.cmd` or run it from a console window. When the boot process has completed, you should see a `DPRO.img7` file in your directory. IMG7 is the new image extension for Dolphin 7, and DPRO stands for _Dolphin Professional_.

* Should you wish to test your booted image before proceeding with your own changes or work, you may want to run the standard regression test suite. This is recommended, and easy to do. Just run the `TestDPRO.cmd` script in the root folder. This will launch Dolphin, load the tests, and then execute them. As it runs you will see results being reported as console output. When complete a summary will state whether there were any failures. You should expect there to be none, but check the [AppVeyor build](https://ci.appveyor.com/project/dolphinsmalltalk/dolphin-db22v/branch/master) to see the current build status.

* To launch the image you can right click on `DPRO.img7` and choose _Open With_, selecting `Dolphin7.exe` as the executable to be permanently associated with this file type.

You should see Dolphin Professional 7 launch successfully. We’ll leave it as an exercise for the reader to work out how to dismiss the splash screen. You can now continue with the Dolphin [Getting Started](http://object-arts.com/gettingstarted.html) introduction if you wish.

![Dolphin System Folder](https://user-images.githubusercontent.com/15128107/44483893-33180800-a644-11e8-843b-ce731367e4cb.png)

## Contributing to Dolphin

If you want to submit changes, you will need to create your own fork and clone that instead. You will not be able to push directly to the main Dolphin repo.

No further changes will (normally) be accepted into the DolphinVM repo for versions of Dolphin from 7.1, although it remains open for bug fixes to 7.0. If you wish to contribute to the 7.1 VM, please make and commit your VM changes in this main Dolphin repo and submit a PR here. PRs can contain synchronized changes to both the VM and the image, and the PR validation build will exercise both.

## Releasing a new version of Dolphin

If sufficient changes have been made to the VM or image such that a new release is warranted, you can push a new tag of the form _v.7.x.y_ (eg: **v7.0.42**). When the tag is eventually pushed to the GitHub master branch (by a maintainer) this will trigger an AppVeyor to build and generate a new [Release](https://github.com/dolphinsmalltalk/Dolphin/releases). Each release consists of the full set of VM binaries wrapped up as a zip called `DolphinVM.zip`, associated PDBs, and a setup for installing Dolphin along with a pro image. Whenever, a new version is released the version tag should be edited into `FetchVM.ps1` so that those who do not want to build it can easily download the correct version to boot and run Dolphin image from the Dolphin repository.


