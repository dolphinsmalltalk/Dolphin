"Update the boot image
	The original Dolphin7 DBOOT image is in this directory and this file
	applies modifications to it based on scripts in this directory."

| path version |
version := Object owningPackage packageVersion.		"find last update"
Notification signal: 'Starting at version = ' , version printString.
version isEmpty ifTrue: [version := '7.0'].
version := (version subStrings: $.) last asNumber.
[
	version := (1001 + version) printString copyFrom: 2.
	path := 'Core\Object Arts\Dolphin\Base\Boot\Boot' , version , '.st'.
	File exists: path.	"Is there a new update?"
] whileTrue: [
	Notification signal: 'Installing update ' , version printString.
	SourceManager default fileIn: path.
	Object owningPackage packageVersion: '7.' , version.
	version := version asNumber.
].

Object owningPackage isChanged: false!
SourceManager default compressSources!
(Delay forSeconds: 5) wait!
SessionManager current quit!
