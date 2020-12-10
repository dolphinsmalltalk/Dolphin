"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #SmalltalkSystemShellTest
	instanceVariableNames: 'systemShell'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
SmalltalkSystemShellTest guid: (Core.GUID fromString: '{6d373cd5-f02e-4adb-bce9-f0755886a74b}')!
SmalltalkSystemShellTest comment: ''!
!SmalltalkSystemShellTest categoriesForClass!Unclassified! !
!SmalltalkSystemShellTest methodsFor!

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
!SmalltalkSystemShellTest categoriesFor: #setUp!private!unit tests! !
!SmalltalkSystemShellTest categoriesFor: #systemFolderPresenter!private!unit tests! !
!SmalltalkSystemShellTest categoriesFor: #tearDown!private!unit tests! !
!SmalltalkSystemShellTest categoriesFor: #testIconOrdering!public!unit tests! !

