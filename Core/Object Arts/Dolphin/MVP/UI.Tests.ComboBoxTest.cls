"Filed out from Dolphin Smalltalk"!

UI.Tests.PresenterTest subclass: #'UI.Tests.ComboBoxTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.ComboBoxTest guid: (Core.GUID fromString: '{beb204cd-8c17-44a4-8305-c23345382e1e}')!
UI.Tests.ComboBoxTest comment: ''!
!UI.Tests.ComboBoxTest methodsFor!

classToTest
	^ComboBox!

oldDolphinVersionsForStbUpgrade
	^1 to: 4!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assertIsNil: view forecolor.
	self assert: view droppedHeight equals: 200.
	self assert: view interactor identicalTo: view.
	self assert: view mode identicalTo: #dropDown!

vuFile
	^'ListPresenter.Combo box.vu'! !
!UI.Tests.ComboBoxTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.ComboBoxTest class methodsFor!

resource_Combo_box_D6
	"Answer the literal data from which the 'Combo box' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Combo_box_D6)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ComboBox) 98 17 0 0 98 2 8 1412498946 1025 416 590662 2 ##(Smalltalk.ListModel) 202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294903803 459270 ##(Smalltalk.Message) 8 #displayString 98 0 544 401 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 850 251 43 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 244 5 0 0 31 0 0 0] 98 0 850 193 193 0 27)!

resource_Combo_box_D7
	"Answer the literal data from which the 'Combo box' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Combo_box_D7)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ComboBox) 34 17 nil nil 34 2 8 1412498946 1025 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1903738896 459270 ##(Smalltalk.Message) #displayString 8 #() 528 401 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 786 251 51 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 252 7 0 0 35 0 0 0] 8 #() 786 193 193 nil 27)! !
!UI.Tests.ComboBoxTest class categoriesForMethods!
resource_Combo_box_D6!public!resources-views! !
resource_Combo_box_D7!public!resources-views! !
!

