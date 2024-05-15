"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #SmalltalkSystemShellTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SmalltalkSystemShellTest guid: (GUID fromString: '{6d373cd5-f02e-4adb-bce9-f0755886a74b}')!

SmalltalkSystemShellTest comment: ''!

!SmalltalkSystemShellTest categoriesForClass!Unclassified! !

!SmalltalkSystemShellTest methodsFor!

classToTest
	^SmalltalkSystemShell!

systemFolderPresenter
	^presenter instVarNamed: 'systemFolderPresenter'!

testIconOrdering
	| initialContents sampleApps finalContents |
	"1782"
	initialContents := self systemFolderPresenter contents asArray.
	sampleApps := initialContents detect: [:each | each description = 'Sample Applications'].
	self systemFolderPresenter selection: sampleApps.
	self systemFolderPresenter onActionPerformed.
	self systemFolderPresenter up.
	finalContents := self systemFolderPresenter contents asArray.
	self assert: finalContents equals: initialContents!

viewClass
	^ShellView! !

!SmalltalkSystemShellTest categoriesForMethods!
classToTest!helpers!private! !
systemFolderPresenter!private!unit tests! !
testIconOrdering!public!unit tests! !
viewClass!constants!private! !
!

