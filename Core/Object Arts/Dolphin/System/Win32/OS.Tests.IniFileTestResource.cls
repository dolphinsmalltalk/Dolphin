"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestResource
	subclass: #'OS.Tests.IniFileTestResource'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.IniFileTestResource guid: (Core.GUID fromString: '{8e42730b-5040-4528-ae15-41e9f153c025}')!
OS.Tests.IniFileTestResource comment: ''!
!OS.Tests.IniFileTestResource methodsFor!

emptyFile
	^self fileLocator localFileSpecFor: 'empty.ini'!

fileLocator
	^FileLocator imageFolderRelative: 'Resources\Tests\IniFiles\'!

iniFile1
	^self fileLocator localFileSpecFor: '1.ini'!

setUp
	super setUp.
	File createDirectory: self fileLocator basePath.
	"Note that it appears that a UTF-8 BOM causes problems with the underlying API. Perhaps not surprising it is a left over from 16-bit Windows."
	(FileStream write: self iniFile1 type: #ansi)
		nextPutAll: '[Section1]
S1Key1=S1Value1
S1Key2=S1Value2
S1Key3=

[S2]

[3]
S3Key1=123

[]
=NoSectionNoKeyValue
';
		close.
	(FileStream write: self emptyFile) close!

tearDown
	super tearDown.
	(File exists: self fileLocator basePath) ifTrue: [[File deleteDirectory: self fileLocator basePath] on: Error do: [:ex | ]]! !
!OS.Tests.IniFileTestResource categoriesForMethods!
emptyFile!public! !
fileLocator!accessing!public! !
iniFile1!accessing!public! !
setUp!public!setup! !
tearDown!public!setup! !
!

