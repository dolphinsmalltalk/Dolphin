"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest subclass: #'UI.Tests.ProgressBarTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ProgressBarTest guid: (Core.GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!
UI.Tests.ProgressBarTest comment: ''!
!UI.Tests.ProgressBarTest methodsFor!

classToTest
	^ProgressBar!

oldDolphinVersionsForStbUpgrade
	^1 to: 4!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view typeconverter isNullConverter!

vuFile
	^'NumberPresenter.Progress bar.vu'! !
!UI.Tests.ProgressBarTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.ProgressBarTest class methodsFor!

resource_Progress_bar_D6
	"Answer the literal data from which the 'Progress bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Progress_bar)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ProgressBar) 98 15 0 0 98 2 8 1409286144 1 416 721990 2 ##(Smalltalk.ValueHolder) 0 0 1114118 ##(Smalltalk.NeverSearchPolicy) 1 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294903757 852486 ##(Smalltalk.NullConverter) 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 786 411 51 416 722 8 #range: 98 1 525062 ##(Smalltalk.Interval) 1 201 3 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 68 6 0 0 35 0 0 0] 98 0 786 193 193 0 27)!

resource_Progress_bar_D7
	"Answer the literal data from which the 'Progress bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Progress_bar)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ProgressBar) 34 15 nil nil 34 2 8 1409286144 1 416 721990 2 ##(Smalltalk.ValueHolder) nil nil 1114118 ##(Smalltalk.NeverSearchPolicy) 1 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1903758288 852486 ##(Smalltalk.NullConverter) nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 738 411 51 416 690 #range: 34 1 525062 ##(Smalltalk.Interval) 1 201 3 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 76 8 0 0 35 0 0 0] 8 #() 738 193 193 nil 27)! !
!UI.Tests.ProgressBarTest class categoriesForMethods!
resource_Progress_bar_D6!public!resources-views! !
resource_Progress_bar_D7!public!resources-views! !
!

