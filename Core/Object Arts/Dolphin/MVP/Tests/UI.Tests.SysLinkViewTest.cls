"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.SysLinkViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.Tests.SysLinkViewTest guid: (Core.GUID fromString: '{2af000e8-54bd-40b6-8dc6-d0014babc42c}')!

UI.Tests.SysLinkViewTest comment: ''!

!UI.Tests.SysLinkViewTest methodsFor!

classToTest
	^SysLinkView!

testItemFromPoint
	| ext |
	presenter displayValue: '<A HREF="http://www.foo.com">Foo</A> <A HREF="http://www.bar.com">Bar</A>'.
	"Disable visual style so the ambient font is used"
	presenter useVisualStyle: false.
	self waitForInputIdle.
	self assert: (presenter itemFromPoint: 0 @ 0) equals: 1.
	ext := presenter canvas
				font: presenter actualFont;
				textExtent: 'Foo '.
	self assert: (presenter itemFromPoint: ext + (0@-1)) equals: 2.
	self assertIsNil: (presenter itemFromPoint: 1000 @ 1000)!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assertIsNil: view backcolor.
	self assert: view text equals: '<A HREF="http://www.object-arts.com">Object Arts Home</A>'! !

!UI.Tests.SysLinkViewTest categoriesForMethods!
classToTest!helpers!private! !
testItemFromPoint!public! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.SysLinkViewTest class methodsFor!

resource_Link_text_D6
	"Answer the literal data from which the 'Link text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Link_text)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.SysLinkView) 98 16 0 0 98 2 8 1409286400 1 416 721990 2 ##(Smalltalk.ValueHolder) 0 32 1310726 ##(Smalltalk.EqualitySearchPolicy) 0 0 0 5 0 0 0 416 0 8 4294904867 852486 ##(Smalltalk.NullConverter) 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 738 181 31 416 674 8 #text: 98 1 8 '<A HREF="http://www.object-arts.com">Object Arts Home</A>' 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 209 5 0 0 25 0 0 0] 98 0 738 193 193 0 27)!

resource_Link_text_D7
	"Answer the literal data from which the 'Link text' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Link_text)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.SysLinkView) 34 16 nil nil 34 2 8 1409286400 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1310726 ##(Smalltalk.EqualitySearchPolicy) nil nil nil 5 nil nil nil 416 nil 8 1915775360 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 2799 21 706 181 31 416 658 #text: 34 1 8 '<A HREF="http://www.object-arts.com">Object Arts Home</A>' 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 209 5 0 0 25 0 0 0] 8 #() 706 193 193 nil 27 )! !

!UI.Tests.SysLinkViewTest class categoriesForMethods!
resource_Link_text_D6!public!resources-views! !
resource_Link_text_D7!public!resources-views! !
!

