"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Tools.Tests.SmalltalkSystemShellTest'
	instanceVariableNames: 'systemShell'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.SmalltalkSystemShellTest guid: (Core.GUID fromString: '{6d373cd5-f02e-4adb-bce9-f0755886a74b}')!
Tools.Tests.SmalltalkSystemShellTest comment: ''!
!Tools.Tests.SmalltalkSystemShellTest methodsFor!

setUp
	super setUp.
	systemShell := SmalltalkSystemShell show.!

systemFolderPresenter
	^systemShell instVarNamed: 'systemFolderPresenter'!

tearDown
	systemShell topShell view destroy.
	systemShell := nil.
	super tearDown!

testIconOrdering
	| initialContents sampleApps finalContents |
	"1782"
	initialContents := self systemFolderPresenter contents asArray.
	sampleApps := initialContents detect: [:each | each description = 'Sample Applications'].
	self systemFolderPresenter selection: sampleApps.
	self systemFolderPresenter onActionPerformed.
	self systemFolderPresenter up.
	finalContents := self systemFolderPresenter contents asArray.
	self assert: finalContents equals: initialContents! !
!Tools.Tests.SmalltalkSystemShellTest categoriesForMethods!
setUp!private!unit tests! !
systemFolderPresenter!private!unit tests! !
tearDown!private!unit tests! !
testIconOrdering!public!unit tests! !
!

