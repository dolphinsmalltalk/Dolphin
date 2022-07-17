"Filed out from Dolphin Smalltalk"!

UI.Tests.StaticViewTest subclass: #'UI.Tests.ColorViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ColorViewTest guid: (Core.GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!
UI.Tests.ColorViewTest comment: ''!
!UI.Tests.ColorViewTest methodsFor!

classToTest
	^ColorView!

oldDolphinVersionsForStbUpgrade
	^1 to: 4!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view displayValue equals: (anInteger < 13 ifTrue: [Color black] ifFalse: [Color blue])!

vuFile
	^'ColorPresenter.Color view.vu'! !
!UI.Tests.ColorViewTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.ColorViewTest class methodsFor!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ColorView) 98 16 0 0 98 2 8 1409286400 1 416 721990 2 ##(Smalltalk.ValueHolder) 0 32 1114118 ##(Smalltalk.NeverSearchPolicy) 786694 ##(Smalltalk.IndexedColor) 33554465 576 0 5 0 0 0 416 0 8 4294903625 852486 ##(Smalltalk.NullConverter) 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 770 251 81 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 244 5 0 0 50 0 0 0] 98 0 770 193 193 0 27)!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ColorView) 34 16 nil nil 34 2 8 1409286400 1 416 721990 2 ##(Smalltalk.ValueHolder) nil false 1114118 ##(Smalltalk.NeverSearchPolicy) 327686 ##(Smalltalk.Color) #blue 560 nil 5 nil nil nil 416 nil 8 1903849936 852486 ##(Smalltalk.NullConverter) nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 738 251 81 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 252 7 0 0 50 0 0 0] 8 #() 738 193 193 nil 27 )! !
!UI.Tests.ColorViewTest class categoriesForMethods!
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
!

