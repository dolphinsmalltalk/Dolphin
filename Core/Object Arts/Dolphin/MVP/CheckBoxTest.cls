"Filed out from Dolphin Smalltalk"!

CheckButtonTest subclass: #CheckBoxTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CheckBoxTest guid: (GUID fromString: '{ecae6a15-f793-4253-9052-e9c562fe2e48}')!

CheckBoxTest comment: ''!

!CheckBoxTest categoriesForClass!Unclassified! !

!CheckBoxTest methodsFor!

classToTest
	^CheckBox!

oldDolphinVersionsForStbUpgrade
	^1 to: 4!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view alignment identicalTo: #leftCenter.
	self assertIsNil: view image.
	self assert: view text equals: ''.
	anInteger < 8
		ifTrue: 
			["ComparisonPolicy should have been replaced"
			self assert: presenter model comparisonPolicy class equals: NeverSearchPolicy]!

vuFile
	"Originally BooleanPresenter.Check box"

	^'BooleanPresenter.Default view.vu'! !

!CheckBoxTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!CheckBoxTest class methodsFor!

resource_CheckBox_view_D6
	"Answer the literal data from which the 'CheckBox view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_CheckBox_view_D6)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.CheckBox) 98 16 0 0 98 2 8 1409363203 1 416 721990 2 ##(Smalltalk.ValueHolder) 0 0 1114118 ##(Smalltalk.NeverSearchPolicy) 32 0 0 5 0 0 0 416 0 8 4294903631 852486 ##(Smalltalk.NullConverter) 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 738 227 43 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 232 5 0 0 31 0 0 0] 98 0 738 193 193 0 27)!

resource_CheckBox_view_D7
	"Answer the literal data from which the 'CheckBox view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_CheckBox_view_D7)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.CheckBox) 34 16 nil nil 34 2 8 1409363203 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) false nil nil 5 nil nil nil 416 nil 8 1915188384 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 2799 21 706 227 43 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 232 5 0 0 31 0 0 0] 8 #() 706 193 193 nil 27 )! !

!CheckBoxTest class categoriesForMethods!
resource_CheckBox_view_D6!public!resources-views! !
resource_CheckBox_view_D7!public!resources-views! !
!

