"Filed out from Dolphin Smalltalk"!

UI.Tests.StaticViewTest
	subclass: #'UI.Tests.FontViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.FontViewTest guid: (Core.GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!
UI.Tests.FontViewTest comment: ''!
!UI.Tests.FontViewTest methodsFor!

classToTest
	^FontView!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assertIsNil: view backcolor.
	self assertIsNil: view previewText.
	self assertIsNil: view font! !
!UI.Tests.FontViewTest categoriesForMethods!
classToTest!helpers!private! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.FontViewTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.FontView) 98 17 0 0 98 2 8 1409286400 1 416 721990 2 ##(Smalltalk.ValueHolder) 0 0 1114118 ##(Smalltalk.NeverSearchPolicy) 0 0 0 5 0 0 0 416 0 8 4294903625 852486 ##(Smalltalk.NullConverter) 0 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 738 571 51 416 674 8 #text: 98 1 8 'Default' 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 148 6 0 0 35 0 0 0] 98 0 738 193 193 0 27)!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.FontView) 34 17 nil nil 34 2 8 1409286400 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) nil nil nil 5 nil nil nil 416 nil 8 1915124368 852486 ##(Smalltalk.NullConverter) nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 2799 21 706 571 51 416 658 #text: 34 1 8 'Default' 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 148 6 0 0 35 0 0 0] 8 #() 706 193 193 nil 27 )! !
!UI.Tests.FontViewTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
!

