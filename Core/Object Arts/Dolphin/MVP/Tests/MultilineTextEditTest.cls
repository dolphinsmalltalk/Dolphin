"Filed out from Dolphin Smalltalk"!

AbstractMultilineTextEditTest subclass: #MultilineTextEditTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MultilineTextEditTest guid: (GUID fromString: '{2eedba10-3618-4267-9a38-179fd63152c0}')!

MultilineTextEditTest comment: ''!

!MultilineTextEditTest categoriesForClass!Unclassified! !

!MultilineTextEditTest methodsFor!

classToTest
	^MultilineTextEdit!

margins
	^1 @ 1!

oldDolphinVersionsForStbUpgrade
	^1 to: 4!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assertIsNil: view contextMenu.
	self assert: (view instVarNamed: 'teFlags') equals: 4!

vuFile
	^'TextPresenter.Multiline text.vu'! !

!MultilineTextEditTest categoriesForMethods!
classToTest!constants!private! !
margins!constants!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

