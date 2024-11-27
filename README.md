# Dolphin

[![Build status](https://ci.appveyor.com/api/projects/status/scael64ohx3l6io9/branch/master?svg=true)](https://ci.appveyor.com/project/dolphinsmalltalk/dolphin-db22v/branch/master)

**Please note: The master branch is now the development branch for version 8.x. This adds support for namespaces and has numerous other improvements, but application code from 7.x will probably require changes when ported to it as it is a major version change. Dolphin 8 changes the package and class file formats when namespaces are used, and consequently code saved in the new format is not loadable directly into earlier versions of Dolphin. It is still possible to save packages in the old format from 8.x, but only if namespaces are not used or referenced. Please use the `release/7.2` branch if you need to keep working with code in release 7.2, or if you require a stable version. PRs for bug fixes, etc, will still be accepted against the `release/7.2` branch for the foreseeable future.**

This repository contains:
* A VS2022 solution to build the Virtual Machine (VM) elements of Dolphin Smalltalk.
* The necessary Smalltalk packages to build the Dolphin Smalltalk Core Images from a pre-built boot image.

## Building the Virtual Machine

It is not always necessary to build the VM, since pre-built binaries are available for download from github using the FetchVM script in the repo. You can skip straight to building the product image if you are happy to work from the latest tag in the repo. If you want to work at the tip of master, you may need to build the VM as incompatible changes may have been made that have not yet been tagged. Building the VM is straightforward and requires only freely available tools.

* First clone the [Dolphin](https://github.com/dolphinsmalltalk/Dolphin) repo to a `\Dolphin` directory on your machine. It can actually be any location but for convenience we'll call it `\Dolphin`.  Use a Git client tool to clone. Downloading the ZIP file won't work due to use of Git LFS.

* Install the free VS2022 Community Edition on your machine with the "Desktop development with C++" workload. The Dolphin VM is a set of C++ projects so make sure to install this option (it's not the default) or you'll end up only being able to compile C#. You can use the Pro or Enterprise edition if you have it. It is possible to compile the VM with earlier versions of VS (certainly VS2019) but you will need to downgrade the solution to the appropriate toolset and either retarget to the ealier Windows SDK that shipped with VS, or install the latest SDK standalone.

* Load the DolphinVM solution into Visual Studio. Choose the **Release** profile (**Debug** will compile but will run slowly and is not suitable for Smalltalk development work) and then _Build Solution_. A bunch of DLLs and `Dolphin8.exe` will have been copied to the `\Dolphin` root folder.

## Building the Dolphin 8 Product Image

Follow these instructions to create the product image and launch Dolphin Smalltalk for the first time.

* First clone the Dolphin repository (this one) into a suitable working directory on your machine, let's call it `\Dolphin`. Any supported version of Windows should be suitable, and at the moment that means _only_ Windows 10 or 11. Dolphin _may_ run on older Windows versions, but there should be no expectation that it will, or will continue to do so. 

* The master branch is on the bleeding edge and may be in a relatively unstable state, although the tests should always be passing. If you need a more stable build then you should use the `release/7.2` branch.

* Next you will need to build the binaries as described above, or fetch the VM binaries. For convenience a batch file, `FetchVM.CMD` is supplied that will determine the correct VM version and invoke the helper PowerShell script `FetchVM.ps1` to download it. If you want to download an alternative VM (which is not usually recommended) then this can be done by invoking `FetchVM.ps1` with a parameter..

* Before proceeding you will also need to pull the boot image from github large file storage. To do this execute `git lfs pull`.

* If you do not have a Visual Studio 2022 installed on your machine, then depending on what other software you have you may also need to install the [VC++ runtime distribution](https://support.microsoft.com/en-us/help/2977003/the-latest-supported-visual-c-downloads), specifically https://aka.ms/vs/17/release/vc_redist.x86.exe. This is required by the VM. If Dolphin fails to start, try installing this first.

* In the root folder of the repo you will find the `BootDPRO.cmd` script and a small boot image, `DBOOT.img8`. Double-click `BootDPRO.cmd` or run it from a console window. The boot process takes a minute or two to load all the Smalltalk code, and when completed you should see a `DPRO.img8` file in your directory. IMG8 is the image extension for Dolphin 8, and DPRO stands for _Dolphin Professional_.

* If the boot fails, this is likely because the VM needs to be rebuilt to be compatible with the Smalltalk code you are trying to boot. You may need to build it if pre-built binaries for the version are not available yet.

* Should you wish to test your booted image before proceeding with your own changes or work, you may want to run the standard regression test suite. This is recommended, and easy to do. Just run the `TestDPRO.cmd` script in the root folder. This will launch Dolphin, load the tests, and then execute them. As it runs you will see results being reported as console output. The complete test run should take no more than a couple of minutes. When complete a summary will state whether there were any failures. You should expect there to be none, but check the [AppVeyor build](https://ci.appveyor.com/project/dolphinsmalltalk/dolphin-db22v/branch/master) to see the current build status.

* To launch the image you can right click on `DPRO.img8` and choose _Open With_, selecting `Dolphin8.exe` as the executable to be permanently associated with this file type.

You should see Dolphin Professional 8 launch successfully.

![Dolphin System Folder](https://user-images.githubusercontent.com/15128107/44483893-33180800-a644-11e8-843b-ce731367e4cb.png)

## Contributing to Dolphin

If you want to submit changes, you will need to create your own fork and clone that instead. You will not be able to push directly to the main Dolphin repo.

If you wish to contribute to 8.x VM, please make and commit your VM changes in this Dolphin repo and submit a PR here. PRs can contain synchronized changes to both the VM and the image, and the PR validation build will exercise both.

Any contributions are welcome, but are expected to be of a very high standard. You are more likely to have your contribution accepted unchanged if you follow these rules:
- PRs should be associated with a pre-existing issue. In other words, create a github issue describing your bug or proposed improvement first. This allows the merits of the change to be discussed and should save wasted time preparing a PR that is rejected because the change is not agreed on principle.
- Source code should follow good Smalltalk style principles and designs should be simple and clear. The existing image is full of many examples of good practice.
- Source must be formatted using the standard in-image code formatter for consistency. Code that has obviously not been formatted with the auto-formatter will be rejected.
- Changes should be accompanied by tests that cover the mainstream scenario and boundary conditions. This applies even if there are no existing tests. Exceptions are unlikely to be made to this rule.

## Releasing a new version of Dolphin

If sufficient changes have been made to the VM or image such that a new release is warranted, you can push a new tag of the form _8.x.y_ (eg: **8.3.9**). When the tag is eventually pushed to the GitHub master branch (by a maintainer) this will trigger AppVeyor to build and generate a new [Release](https://github.com/dolphinsmalltalk/Dolphin/releases). Each release consists of the full set of VM binaries wrapped up as a zip called `DolphinVM.zip`, and associated PDBs (native debug information for the binaries). The `FetchVM` script will automatically download the correct set of binaries associated with the latest tag at which the repository is checked out. The release build does also build a setup .exe, but this is not maintained so it may not function correctly.


