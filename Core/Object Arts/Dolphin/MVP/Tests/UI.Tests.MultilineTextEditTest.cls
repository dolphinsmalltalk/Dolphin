"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractMultilineTextEditTest
	subclass: #'UI.Tests.MultilineTextEditTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.MultilineTextEditTest guid: (Core.GUID fromString: '{2eedba10-3618-4267-9a38-179fd63152c0}')!

UI.Tests.MultilineTextEditTest comment: ''!

!UI.Tests.MultilineTextEditTest methodsFor!

classToTest
	^MultilineTextEdit!

margins
	^1 @ 1!

testClearing
	"Multiline-edit control will delete text restored through undo if it exceeds the display height and/or width and horizontal/vertical scrolling styles are not set."

	presenter
		canVScroll: true;
		canHScroll: true.
	super testClearing!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assertIsNil: view contextMenu.
	self assert: (view instVarNamed: 'teFlags') equals: 4! !

!UI.Tests.MultilineTextEditTest categoriesForMethods!
classToTest!constants!private! !
margins!constants!private! !
testClearing!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.MultilineTextEditTest class methodsFor!

resource_Multiline_text_D6
	"Answer the literal data from which the 'Multiline text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Multiline_text)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.MultilineTextEdit) 98 16 0 0 98 2 8 1143017796 1025 416 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 7 0 0 0 416 0 8 4294904635 852486 ##(Smalltalk.NullConverter) 0 0 9 983302 ##(Smalltalk.MessageSequence) 202 208 98 3 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 722 401 161 416 658 8 #selectionRange: 98 1 525062 ##(Smalltalk.Interval) 3 1 3 416 658 8 #isTextModified: 98 1 32 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 63 6 0 0 90 0 0 0] 98 0 722 193 193 0 27)!

resource_Multiline_text_D7
	"Answer the literal data from which the 'Multiline text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Multiline_text)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.MultilineTextEdit) 34 16 nil nil 34 2 8 1143017796 1025 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1903872368 852486 ##(Smalltalk.NullConverter) nil nil 9 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 674 401 161 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 71 8 0 0 90 0 0 0] 8 #() 674 193 193 nil 27 )! !

!UI.Tests.MultilineTextEditTest class categoriesForMethods!
resource_Multiline_text_D6!public!resources-views! !
resource_Multiline_text_D7!public!resources-views! !
!

