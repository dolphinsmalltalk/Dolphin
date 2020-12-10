"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'OS.Tests.VersionResourceTest'
	instanceVariableNames: 'updatePath sourceModule sourceSize sourceBytes'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.VersionResourceTest guid: (Core.GUID fromString: '{a475b032-cef9-4aa6-affe-32b7dc1c4640}')!
OS.Tests.VersionResourceTest comment: ''!
!OS.Tests.VersionResourceTest categoriesForClass!Unclassified! !
!OS.Tests.VersionResourceTest methodsFor!

assertResource: res atVersion: newVersion
	self assert: res fileVersion equals: newVersion.
	self assert: res fixedInfo fileVersionString equals: newVersion.
	self assert: res productVersion equals: newVersion.
	self assert: res fixedInfo productVersionString equals: newVersion.
	res stringTables do: 
			[:each |
			self assert: (each at: 'FileVersion') equals: newVersion.
			self assert: (each at: 'ProductVersion') equals: newVersion]!

assertVersionResource: versionResource equalTo: versionResource2
	| newStrings |
	self assert: versionResource languageId equals: versionResource2 languageId.
	newStrings := versionResource2 stringTables.
	self assert: (newStrings keys noDifference: versionResource stringTables keys).
	newStrings values with: versionResource stringTables values
		do: [:eachTable1 :eachTable2 | self assert: (eachTable1 associations noDifference: eachTable2 associations)].
	self assert: versionResource pack equals: versionResource2 pack!

modifyVersionResource: versionResource
	(versionResource stringTables values first)
		at: 'FileDescription' put: 'A test version resource file description';
		at: 'Product Name' put: 'Dolphin SUnit Tests'!

setUp
	| pVer header |
	updatePath := File temporaryFilename.
	File copy: self sourcePath to: updatePath.
	sourceModule := DynamicLinkLibrary open: self sourcePath.
	pVer := VersionResource getVersionResourceOfModule: sourceModule.
	header := VS_VERSION_INFO_HEADER fromAddress: pVer.
	sourceSize := header wLength.
	sourceBytes := pVer copyFrom: 1 to: sourceSize!

sourcePath
	^(FolderRelativeFileLocator basePath: SessionManager current installationDirectory)
		localFileSpecFor: 'GUIToGo.exe'!

tearDown
	sourceModule close.
	File delete: updatePath!

testRoundTripUnpackPack
	| packedBytes repackedBytes versionResource versionResource2 |
	versionResource := VersionResource new unpack: sourceBytes yourAddress.
	packedBytes := versionResource pack.
	self assert: sourceBytes equals: packedBytes.
	self modifyVersionResource: versionResource.
	packedBytes := versionResource pack.
	versionResource2 := VersionResource new unpack: packedBytes yourAddress.
	repackedBytes := versionResource2 pack.
	self assert: packedBytes equals: repackedBytes.
	self assertVersionResource: versionResource equalTo: versionResource2!

testRoundTripUpdate
	| versionResource versionResource2 |
	versionResource := VersionResource new unpack: sourceBytes yourAddress.
	versionResource updateFile: updatePath.
	versionResource2 := VersionResource forPath: updatePath.
	self assert: sourceBytes equals: versionResource2 pack.
	self assertVersionResource: versionResource2 equalTo: versionResource.
	self modifyVersionResource: versionResource.
	versionResource updateFile: updatePath.
	versionResource2 := VersionResource forPath: updatePath.
	self assertVersionResource: versionResource2 equalTo: versionResource!

testVersionStrings
	"Test minor version incrementer"

	| res originalVersion newVersion |
	#'1598'.
	res := VersionResource forPath: updatePath.
	originalVersion := '1.0.0.1'.
	self assert: res fileVersion equals: originalVersion.
	newVersion := '101.202.303.404'.
	res fileVersion: newVersion.
	self assert: res fileVersion equals: newVersion.
	self assert: res fixedInfo fileVersionString equals: newVersion.
	self assert: res productVersion equals: originalVersion.
	res productVersion: newVersion.
	self assertResource: res atVersion: newVersion.
	res bumpProductVersion.
	self assertResource: res atVersion: '101.202.304.404'! !
!OS.Tests.VersionResourceTest categoriesFor: #assertResource:atVersion:!public!unit tests! !
!OS.Tests.VersionResourceTest categoriesFor: #assertVersionResource:equalTo:!private!unit tests! !
!OS.Tests.VersionResourceTest categoriesFor: #modifyVersionResource:!public!unit tests! !
!OS.Tests.VersionResourceTest categoriesFor: #setUp!private!Running! !
!OS.Tests.VersionResourceTest categoriesFor: #sourcePath!constants!private! !
!OS.Tests.VersionResourceTest categoriesFor: #tearDown!private!Running! !
!OS.Tests.VersionResourceTest categoriesFor: #testRoundTripUnpackPack!public!unit tests! !
!OS.Tests.VersionResourceTest categoriesFor: #testRoundTripUpdate!public!unit tests! !
!OS.Tests.VersionResourceTest categoriesFor: #testVersionStrings!public!unit tests! !

