"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest subclass: #'UI.Tests.ScrollBarTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ScrollBarTest guid: (Core.GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!
UI.Tests.ScrollBarTest comment: ''!
!UI.Tests.ScrollBarTest methodsFor!

classToTest
	^ScrollBar!

oldDolphinVersionsForStbUpgrade
	^1 to: 5!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view isTrackingContinuous.
	self assert: view typeconverter isNullConverter!

vuFile
	^'NumberPresenter.Vertical scroll bar.vu'! !
!UI.Tests.ScrollBarTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.ScrollBarTest class methodsFor!

resource_Vertical_scroll_bar_D6
	"Answer the literal data from which the 'Vertical scroll bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_scroll_bar)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(ScrollBar) 98 16 0 0 98 2 8 1409351681 1 416 721990 2 ##(ValueHolder) 0 0 1114118 ##(NeverSearchPolicy) 1 524550 ##(ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294904997 852486 ##(NullConverter) 0 0 16 983302 ##(MessageSequence) 202 208 98 3 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 2799 21 786 35 291 416 722 8 #range: 98 1 525062 ##(Interval) 1 201 3 416 722 8 #pageSize: 98 1 1 416 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 136 5 0 0 155 0 0 0] 98 0 786 193 193 0 27)!

resource_Vertical_scroll_bar_D7
	"Answer the literal data from which the 'Vertical scroll bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Vertical_scroll_bar)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ScrollBar) 34 16 nil nil 34 2 8 1409351681 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 1 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1904029216 852486 ##(Smalltalk.NullConverter) nil nil true 983302 ##(Smalltalk.MessageSequence) 138 144 34 3 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 738 35 291 416 690 #range: 34 1 525062 ##(Smalltalk.Interval) 1 201 3 416 690 #pageSize: 8 #(0) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 144 7 0 0 155 0 0 0] 8 #() 738 193 193 nil 27)! !
!UI.Tests.ScrollBarTest class categoriesForMethods!
resource_Vertical_scroll_bar_D6!public!resources-views! !
resource_Vertical_scroll_bar_D7!public!resources-views! !
!

