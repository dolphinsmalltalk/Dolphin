"Update the boot image by applying the modifications from the scripts in this directory."

| path currentVersion patchVersion nextPatch stdout |
stdout := SessionManager current stdout.
currentVersion := Object owningPackage packageVersion.		"find last update"
currentVersion isEmpty ifTrue: [currentVersion := '7.1.000'].
stdout nextPutAll: 'Updating boot image from version '; print: currentVersion; cr.
patchVersion := Integer fromString: (currentVersion subStrings: $.) last.
[
	nextPatch := patchVersion + 1 printStringBase: 10 nDigits: 3.
	path := 'Core\Object Arts\Dolphin\Base\Boot\Boot' , nextPatch , '.st'.
	stdout nextPutAll: 'Looking for update file '; print: path; cr.
	File exists: path.	"Is there a new update?"
] whileTrue: [
	stdout nextPutAll: 'Installing update '; print: nextPatch; cr.
	SourceManager default fileIn: path.
	Object owningPackage packageVersion: '7.1.' , nextPatch.
	patchVersion := Integer fromString: nextPatch.
].

patchVersion := Object owningPackage packageVersion.
patchVersion = currentVersion 
	ifTrue: [stdout nextPutAll: 'No updates found'; cr]
	ifFalse: [
		stdout nextPutAll: 'Updated boot image to version '; print: patchVersion; cr.
		Object owningPackage isChanged: false.
		SourceManager default compressSources]!
SessionManager current quit!
