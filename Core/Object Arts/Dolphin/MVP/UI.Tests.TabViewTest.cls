"Filed out from Dolphin Smalltalk"!

UI.Tests.AbstractTabViewTest subclass: #'UI.Tests.TabViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.TabViewTest guid: (Core.GUID fromString: '{3fd7f1ae-aff6-4a24-b35e-d6e810433b8c}')!
UI.Tests.TabViewTest comment: ''!
!UI.Tests.TabViewTest methodsFor!

classToTest
	^TabView!

oldDolphinVersionsForStbUpgrade
	^1 to: 4!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view backcolor identicalTo: Color face3d!

vuFile
	^'ListPresenter.Tab view.vu'! !
!UI.Tests.TabViewTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.TabViewTest class methodsFor!

resource_Tab_view_D6
	"Answer the literal data from which the 'Tab view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Tab_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.TabView) 98 23 0 0 98 2 8 1409352192 1 416 590662 2 ##(Smalltalk.ListModel) 202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 721158 ##(Smalltalk.SystemColor) 31 0 5 0 0 0 416 0 8 4294903589 459270 ##(Smalltalk.Message) 8 #displayString 98 0 8 ##(Smalltalk.IconicListAbstract) 1049670 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 8 #noIcons 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 898 701 61 416 834 8 #tcmSetExtendedStyle:dwExStyle: 98 2 -1 1 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 213 6 0 0 40 0 0 0] 98 0 898 193 193 0 27)! !
!UI.Tests.TabViewTest class categoriesForMethods!
resource_Tab_view_D6!public!resources-views! !
!

