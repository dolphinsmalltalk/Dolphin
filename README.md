# DolphinVM

[![Build status](https://ci.appveyor.com/api/projects/status/6ru55e8y9huog899/branch/master?svg=true)](https://ci.appveyor.com/project/dolphinsmalltalk/dolphinvm-nf68c/branch/master)

The [Dolphin Smalltalk](http://object-arts.com/) virtual machine. 

This is a VS2017 solution to build the Virtual Machine (VM) elements of Dolphin Smalltalk. It is not necessary to build the VM to run the Dolphin IDE, which is available in the [Dolphin](https://github.com/objectarts/Dolphin) GitHub repository, since you can download these in pre-built form, either directly or by running the FetchVM script in the root of the Dolphin repository. You'll only need to build DolphinVM if you need to explicitly change the VM itself, or if you want to debug a low-level issue.

Note: if you are just looking to install Dolphin and get going as quickly as possible you may prefer to start with the release build and and follow the directions [here](http://www.object-arts.com/gettingstarted.html). That way you won't have to sully yourself with either the Dolphin or the DolphinVM repositories. However, if you really want to build the Dolphin VM from scratch, read on.

## Building the Virtual Machine

* First clone the [Dolphin](https://github.com/dolphinsmalltalk/Dolphin) repo to a `\Dolphin` directory on your machine. It can actually be any location but for convenience we'll call it `\Dolphin`. If you want to submit changes, however, you will first need to create your own fork and clone that instead. You will not be able to push directly to the main Dolphin repo.

* _Versions prior to 7.1:_ You should clone this repository (DolphinVM) into a `DolphinVM\` subdirectory of `\Dolphin\Core\`. The same comment applies regarding the need to fork this repo if you want to be able to contribute changes.

* _Version 7.1 and later:_ The Dolphin repository includes this repository as a submodule synchronised to the correct version. Depending on your git client and how you cloned the repository you  may need to run ``git submodule update --init`` to clone the VM.

* Install VS2017 Community Edition on your machine with the "Desktop development with C++" workload. You can use the Pro or Enterprise edition if you have it. It is possible to compile the VM with VS2015, but you will need to downgrade the solution to the v140 toolset and either retarget to the ealier Windows SDK that shipped with VS2015, or install the latest SDK standalone. Later VS versions (when they appear) may work too but we no longer support VS2013, sorry. The Dolphin VM is a set of C++ projects so make sure to install this option (it's not the default) or you'll end up only being able to compile C#.

* Load the DolphinVM solution into Visual Studio. Choose the **Release** profile (**Debug** will compile but will run slowly) and then _Build Solution_. A bunch of DLLs and `Dolphin7.exe` will have been copied to the `\Dolphin` root folder.

Now go to the Dolphin [Getting Started](http://www.object-arts.com/gettingstarted.html) page and follow the instructions there to build the image file with your new VM. You can then launch Dolphin and continue with the tutorials.

## Releasing the VM

If sufficient changes have been made to the VM such that a new release is warranted, you should push a new tag of the form _v.7.x.y_ (eg: **v7.0.42**). When the tag is eventually pushed to the GitHub master branch (by a maintainer) this will cause AppVeyor to build and generate a new [Release](https://github.com/dolphinsmalltalk/DolphinVM/releases). Each release consists of the full set of VM binaries wrapped up as a zip called `DolphinVM.zip`. The VM binaries are not (now) included in the Dolphin repository but can be fetched by executing the `FetchVM.CMD` script from the image directory. Whenever, a new VM is released the version tag should be edited into `FetchVM.ps1` so that those who do not want to build it can easily download the correct version to boot and run Dolphin image from the Dolphin repository.
