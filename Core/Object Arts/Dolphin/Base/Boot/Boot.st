"Update the boot image
	The original Dolphin7 DBOOT image is in this directory and this file
	records the modifications to it. Completed steps are commented out
	or removed."

"SourceManager default fileIn: 'Core\Object Arts\Dolphin\Base\Boot\Boot001.st'.
SourceManager default fileIn: 'Core\Object Arts\Dolphin\Base\Boot\Boot002.st'."
!

Object owningPackage isChanged: false!
SourceManager default compressSources!
SessionManager current quit!
