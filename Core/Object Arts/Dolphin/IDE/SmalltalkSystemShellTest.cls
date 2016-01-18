"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SmalltalkSystemShellTest
	instanceVariableNames: 'systemShell'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SmalltalkSystemShellTest guid: (GUID fromString: '{6D373CD5-F02E-4ADB-BCE9-F0755886A74B}')!
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
	super tearDown!

testIconOrdering
	| initialContents sampleApps finalContents  |
	"1782"
	initialContents := self systemFolderPresenter contents asArray.
	sampleApps := initialContents detect: [:each | each description = 'Sample Applications'].
	self systemFolderPresenter selection: sampleApps.
	self systemFolderPresenter onActionPerformed.
	self systemFolderPresenter up.
	finalContents := self systemFolderPresenter contents asArray.
	self assert: finalContents = initialContents! !
!SmalltalkSystemShellTest categoriesFor: #setUp!private!unit tests! !
!SmalltalkSystemShellTest categoriesFor: #systemFolderPresenter!private!unit tests! !
!SmalltalkSystemShellTest categoriesFor: #tearDown!private!unit tests! !
!SmalltalkSystemShellTest categoriesFor: #testIconOrdering!public!unit tests! !

