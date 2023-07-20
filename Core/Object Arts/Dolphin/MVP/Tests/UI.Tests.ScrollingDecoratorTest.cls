"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.ScrollingDecoratorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ScrollingDecoratorTest guid: (Core.GUID fromString: '{67f9d5dd-3f9b-4f9f-9d72-207bdf40d661}')!
UI.Tests.ScrollingDecoratorTest comment: ''!
!UI.Tests.ScrollingDecoratorTest methodsFor!

classToTest
	^ScrollingDecorator!

initializePresenter
	super initializePresenter.
	presenter backcolor: Color dialog.
	presenter addSubView: (ContainerView new
				backcolor: Color blue;
				yourself).
	presenter layoutManager shouldStretchToFit: false!

testMultipleSubViews
	self should: [presenter addSubView: ContainerView new] raise: Error!

testResizeLargeAndSmall
	"cdemers - 3/10/2004 Resize the subview to be smaller than the parent."

	"#1511"

	| origExtent |
	origExtent := presenter subViews first extent.
	presenter extent: 800 @ 800.
	presenter layout.
	presenter extent: origExtent + 20.
	presenter layout.
	self assert: presenter subViews first extent equals: origExtent!

testResizeToNothing
	"Will give an 'Index out of bounds' error in D5.1.3"

	presenter topShell extent: 0 @ 0!

testSubViewResizeLargerThanParent
	"cdemers - 3/10/2004 Resize the subview to be larger than the parent."

	presenter subViews first extent: 500 @ 500.
	presenter layout.
	self assert: presenter subViews first extent equals: 500 @ 500!

testSubViewResizeSmallerThanParent
	"#1511"

	"cdemers - 3/10/2004 Resize the subview to be smaller than the parent."

	presenter subViews first extent: 50 @ 50.
	presenter layout.
	self assert: presenter subViews first extent equals: 50 @ 50! !
!UI.Tests.ScrollingDecoratorTest categoriesForMethods!
classToTest!helpers!private! !
initializePresenter!public!Running! !
testMultipleSubViews!public!unit tests! !
testResizeLargeAndSmall!public!unit tests! !
testResizeToNothing!public!unit tests! !
testSubViewResizeLargerThanParent!public!unit tests! !
testSubViewResizeSmallerThanParent!public!unit tests! !
!

!UI.Tests.ScrollingDecoratorTest class methodsFor!

resource_Scrolling_container_D6
	"Answer the literal data from which the 'Scrolling container' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scrolling_container)
	"


	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(ScrollingDecorator)  98 18 0 0 98 2 8 1143996416 131073 416 0 0 0 5 0 0 0 416 1573190 1 ##(ScrollingDecoratorLayout)  16 234 256 98 0 0 328198 ##(Point)  1 1 16 562 17 17 983302 ##(MessageSequence)  202 208 98 1 721670 ##(MessageSend)  8 #createAt:extent: 98 2 562 11 11 562 701 501 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 99 1 0 0 255 0 0 0] 98 0 562 193 193 0 27 )!

resource_Scrolling_container_D7
	"Answer the literal data from which the 'Scrolling container' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Scrolling_container)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScrollingDecorator) 34 18 nil nil 34 2 8 1143996416 131073 416 nil nil nil 5 nil nil nil 416 1573190 1 ##(Smalltalk.ScrollingDecoratorLayout) true 170 192 8 #() nil 328198 ##(Smalltalk.Point) 1 1 true 546 17 17 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 546 11 11 546 701 501 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 99 1 0 0 255 0 0 0] 8 #() 546 193 193 nil 27)! !
!UI.Tests.ScrollingDecoratorTest class categoriesForMethods!
resource_Scrolling_container_D6!public!resources-views! !
resource_Scrolling_container_D7!public!resources-views! !
!

