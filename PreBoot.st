"This file contains patches to base system classes that are required in order to be able to reload the base class library, but which are not yet consolidated into the boot image. Note that the BCL is reloaded anyway (see Boot.st), so most BCL changes do not require pre-patching; try without first"!

ClassLocator.ImportedClasses := nil!