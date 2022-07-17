"Filed out from Dolphin Smalltalk"!

PresenterTest subclass: #ComboBoxTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ComboBoxTest guid: (GUID fromString: '{86cee8f7-40c2-4ed5-b4e6-a0107e7f15f8}')!

ComboBoxTest comment: ''!

!ComboBoxTest categoriesForClass!Unclassified! !

!ComboBoxTest methodsFor!

classToTest
	^ComboBox!

oldDolphinVersionsForStbUpgrade
	^1 to: 4!

testGeometry
	"Combobox's have an inconsistency with regards to placement because the dropped height must be included when the placement is set, but is not included in the placement when retrieved. Obviously we abstract this away so that the rectangle reported by the object is that part of the control that is always visible (edit box and drop-down), and likewise this is what is specified when the rectangle is set. This was incorrectly managed in a number of versions of Dolphin."

	| rect droppedHeight height |
	rect := presenter rectangle.
	"Note that the change in width will apply, but the height not as the height of the text box is determined by the font. However, we need to perturb the height to cause the control to attempt to adjust its height."
	droppedHeight := presenter droppedHeight.
	presenter rectangle: (presenter rectangle translatedBy: (0 @ 0 corner: -10 @ 2)).
	"Actual rectangle height should not have changed as the height is fixed"
	rect := rect translatedBy: (0 @ 0 corner: -10 @ 0).
	self assert: presenter rectangle equals: rect.
	"Likewise the dropped height should not have changed."
	self assert: presenter droppedHeight equals: droppedHeight.
	"If we explicitly set the dropped height, then it should change"
	presenter droppedHeight: 150.
	presenter validateLayout.
	height := presenter getDroppedControlRect height.
	self assert: height equals: presenter height + 150.
	self assert: presenter actualHeight equals: height.
	"But changing the dropped height should have no effect on the reported view rectangle"
	self assert: presenter rectangle equals: rect.
	"Reset placement should maintain dropped height"
	rect := presenter getDroppedControlRect.
	rect moveBy: 200 @ 100.
	presenter placement: (presenter placement position: presenter placement origin + (200 @ 100)).
	self assert: presenter getDroppedControlRect equals: rect.
	self assert: presenter actualHeight equals: height.
	presenter recreate.
	SessionManager inputState pumpMessages.
	self assert: presenter getDroppedControlRect height equals: rect height!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assertIsNil: view forecolor.
	self assert: view droppedHeight equals: 200 * view dpi // USER_DEFAULT_SCREEN_DPI.
	self assert: view interactor identicalTo: view.
	self assert: view mode identicalTo: #dropDown!

vuFile
	^'ListPresenter.Combo box.vu'! !

!ComboBoxTest categoriesForMethods!
classToTest!helpers!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
testGeometry!public!unit tests! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!ComboBoxTest class methodsFor!

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

!ComboBoxTest class categoriesForMethods!
resource_Combo_box_D6!public!resources-views! !
resource_Combo_box_D7!public!resources-views! !
!

