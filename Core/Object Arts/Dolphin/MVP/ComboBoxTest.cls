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

testGeometry
	"Combobox's have an inconsistency with regards to placement because the dropped height must be included when the placement is set, but is not included in the placement when retrieved. Obviously we abstract this away so that the rectangle reported by the object is that part of the control that is always visible (edit box and drop-down), and likewise this is what is specified when the rectangle is set. This was incorrectly managed in a number of versions of Dolphin."

	| rect droppedHeight height rect2 |
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
	height := presenter getDroppedControlRect height.
	self assert: height equals: presenter height + 150.
	self assert: presenter actualHeight equals: height.
	"But changing the dropped height should have no effect on the reported view rectangle"
	self assert: presenter rectangle equals: rect! !
!ComboBoxTest categoriesForMethods!
classToTest!helpers!private! !
testGeometry!public!unit tests! !
!

