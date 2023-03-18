"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.SplitterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.SplitterTest guid: (Core.GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!
UI.Tests.SplitterTest comment: ''!
!UI.Tests.SplitterTest methodsFor!

classToTest
	^Splitter!

oldDolphinVersionsForStbUpgrade
	^1 to: 4!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view interactor isKindOf: DraggableViewInteractor.
	self assert: view hasFlatAppearance!

vuFile
	^'Splitter.Horizontal-vertical splitter.vu'! !
!UI.Tests.SplitterTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.SplitterTest class methodsFor!

resource_Horizontalvertical_splitter_D6
	"Answer the literal data from which the 'Horizontalvertical splitter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Horizontalvertical_splitter)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(Splitter) 98 12 0 0 98 2 8 1140850688 1 416 0 524550 ##(ColorRef) 8 4278190080 0 519 0 0 0 416 983302 ##(MessageSequence) 202 208 98 1 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 11 11 674 361 11 416 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 185 0 0 0 10 0 0 0] 98 0 674 193 193 0 27)!

resource_Horizontalvertical_splitter_D7
	"Answer the literal data from which the 'Horizontalvertical splitter' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Horizontalvertical_splitter)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.Splitter) 34 12 nil nil 34 2 8 1140850688 1 416 nil 327686 ##(Smalltalk.Color) #default nil 519 nil nil nil 1510470 1 ##(Smalltalk.DraggableViewInteractor) 416 nil 1 #left nil nil nil 328198 ##(Smalltalk.Point) 1 1 546 9 9 nil 560 nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 546 3839 21 546 951 11 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 90 9 0 0 15 0 0 0] 8 #() 546 193 193 nil 27)! !
!UI.Tests.SplitterTest class categoriesForMethods!
resource_Horizontalvertical_splitter_D6!public!resources-views! !
resource_Horizontalvertical_splitter_D7!public!resources-views! !
!

