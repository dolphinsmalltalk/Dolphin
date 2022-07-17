"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest subclass: #'UI.Tests.StaticRectangleTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.StaticRectangleTest guid: (Core.GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!
UI.Tests.StaticRectangleTest comment: ''!
!UI.Tests.StaticRectangleTest methodsFor!

classToTest
	^StaticRectangle!

oldDolphinVersionsForStbUpgrade
	^#(4 5)!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view style identicalTo: #blackFrame!

vuFile
	^'StaticRectangle.Default view.vu'! !
!UI.Tests.StaticRectangleTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.StaticRectangleTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy)  8 ##(StaticRectangle)  98 14 0 0 98 2 8 1140850951 1 416 0 524550 ##(ColorRef)  8 4278190080 0 7 0 0 0 416 0 8 4294906439 983302 ##(MessageSequence)  202 208 98 2 721670 ##(MessageSend)  8 #createAt:extent: 98 2 328198 ##(Point)  11 11 690 211 51 416 626 8 #isEnabled: 98 1 32 416 983302 ##(WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 110 0 0 0 30 0 0 0] 98 0 690 193 193 0 27 )
!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.StaticRectangle) 34 14 nil nil 34 2 8 1140850951 1 416 nil 327686 ##(Smalltalk.Color) #default nil 7 nil nil nil 416 nil 8 1903849936 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 642 211 51 416 594 #isEnabled: 8 #(false) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 232 7 0 0 35 0 0 0] 8 #() 642 193 193 nil 27 )! !
!UI.Tests.StaticRectangleTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
!

