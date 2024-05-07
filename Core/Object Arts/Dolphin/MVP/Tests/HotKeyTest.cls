"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #HotKeyTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

HotKeyTest guid: (GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!

HotKeyTest comment: ''!

!HotKeyTest categoriesForClass!Unclassified! !

!HotKeyTest methodsFor!

classToTest
	^HotKey!

oldDolphinVersionsForStbUpgrade
	^#(1 3 4)!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view interactor identicalTo: view.
	self assert: view invalidCombinationsMask equals: 0.
	self assert: view defaultKeyMask equals: 0.
	anInteger < 3
		ifTrue: 
			["ComparisonPolicy should have been replaced"
			self assert: presenter model comparisonPolicy class equals: NeverSearchPolicy]!

vuFile
	"Up to D3 was actually AcceleratorPresenter.Hot key.vu"

	^'AcceleratorPresenter.Default view.vu'! !

!HotKeyTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!HotKeyTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.HotKey) 98 17 0 0 98 2 8 1409351680 1 416 721990 2 ##(Smalltalk.ValueHolder) 0 0 1114118 ##(Smalltalk.NeverSearchPolicy) 1 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294904951 852486 ##(Smalltalk.AccelToHotKey) 0 0 1 1 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 786 211 51 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 224 5 0 0 35 0 0 0] 98 0 786 193 193 0 27)!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.HotKey) 34 17 nil nil 34 2 8 1409351680 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 1 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1904328048 852486 ##(Smalltalk.AccelToHotKey) nil nil 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 738 211 51 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 232 7 0 0 35 0 0 0] 8 #() 738 193 193 nil 27)! !

!HotKeyTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
!

