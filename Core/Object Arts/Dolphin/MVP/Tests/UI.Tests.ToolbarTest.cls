"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest
	subclass: #'UI.Tests.ToolbarTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ToolbarTest guid: (Core.GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!
UI.Tests.ToolbarTest comment: ''!
!UI.Tests.ToolbarTest methodsFor!

classToTest
	^Toolbar!

oldDolphinVersionsForStbUpgrade
	^1 to: 5!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: (view items allSatisfy: [:each | each isKindOf: ToolbarItem]).
	self assert: view interactor identicalTo: view.
	self assert: view buttonSize y equals: 22.
	self assert: view indent equals: 0.
	"12->13 conversion"
	self assert: view backcolor identicalTo: Color default.
	self assert: view forecolor identicalTo: Color default.
	self assert: view isTransparent.
	self deny: view hasLabels.
	self assert: (view baseStyleAllMask: OS.CommCtrlConstants.CCS_NOPARENTALIGN)!

vuFile
	^'Toolbar.List tools.vu'! !
!UI.Tests.ToolbarTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.ToolbarTest class methodsFor!

resource_Tool_bar_D6
	"Answer the literal data from which the 'Tool bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Tool_bar)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy)  8 ##(Smalltalk.Toolbar)  98 25 0 0 98 2 8 1409288972 131137 416 0 524550 ##(Smalltalk.ColorRef)  8 4278190080 0 517 0 263174 ##(Smalltalk.Font)  0 16 459014 ##(Smalltalk.LOGFONT)  8 #[243 255 255 255 0 0 0 0 0 0 0 0 0 0 0 0 144 1 0 0 0 0 0 0 3 2 1 34 65 114 105 97 108 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0] 328198 ##(Smalltalk.Point)  193 193 0 416 498 528 8 4294903295 234 256 98 0 234 256 704 202 208 704 234 240 704 0 1 0 626 33 33 626 45 45 0 656198 1 ##(Smalltalk.FlowLayout)  1 1 1 983302 ##(Smalltalk.MessageSequence)  202 208 98 2 721670 ##(Smalltalk.MessageSend)  8 #createAt:extent: 98 2 626 2799 21 626 701 51 416 898 8 #updateSize 704 416 983302 ##(Smalltalk.WINDOWPLACEMENT)  8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 213 6 0 0 35 0 0 0] 98 0 626 193 193 0 27 )!

resource_Tool_bar_D7
	"Answer the literal data from which the 'Tool bar' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Tool_bar)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.Toolbar) 34 25 nil nil 34 2 8 1409288972 131137 416 nil 327686 ##(Smalltalk.Color) #default nil 517 nil nil nil 416 496 8 1867527152 170 192 8 #() 170 192 544 138 144 544 nil nil 1 nil nil nil nil 656198 1 ##(Smalltalk.FlowLayout) 1 1 1 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 7039 21 738 701 51 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 29 15 0 0 35 0 0 0] 8 #() 738 193 193 nil 27 )! !
!UI.Tests.ToolbarTest class categoriesForMethods!
resource_Tool_bar_D6!public!resources-views! !
resource_Tool_bar_D7!public!resources-views! !
!

