"Filed out from Dolphin Smalltalk 7"!

PresenterTest subclass: #ScrollingDecoratorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ScrollingDecoratorTest guid: (GUID fromString: '{67f9d5dd-3f9b-4f9f-9d72-207bdf40d661}')!
ScrollingDecoratorTest comment: ''!
!ScrollingDecoratorTest categoriesForClass!Unclassified! !
!ScrollingDecoratorTest methodsFor!

classToTest
	^ScrollingDecorator!

initializePresenter
	super initializePresenter.
	presenter backcolor: Color dialog.
	presenter addSubView: ((ContainerView new)
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
!ScrollingDecoratorTest categoriesFor: #classToTest!helpers!private! !
!ScrollingDecoratorTest categoriesFor: #initializePresenter!public!Running! !
!ScrollingDecoratorTest categoriesFor: #testMultipleSubViews!public!unit tests! !
!ScrollingDecoratorTest categoriesFor: #testResizeLargeAndSmall!public!unit tests! !
!ScrollingDecoratorTest categoriesFor: #testResizeToNothing!public!unit tests! !
!ScrollingDecoratorTest categoriesFor: #testSubViewResizeLargerThanParent!public!unit tests! !
!ScrollingDecoratorTest categoriesFor: #testSubViewResizeSmallerThanParent!public!unit tests! !

