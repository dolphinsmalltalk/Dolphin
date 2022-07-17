"Filed out from Dolphin Smalltalk"!

MultipleSelectionListControlTest subclass: #MultipleSelectionListBoxTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MultipleSelectionListBoxTest guid: (GUID fromString: '{29849786-386a-43f0-a24e-f1970727a83b}')!

MultipleSelectionListBoxTest comment: 'Test that the behaviour of the deprecated MultipleSelectionListBox class retains its legacy features in the refactored ListControlView hierarchy.'!

!MultipleSelectionListBoxTest categoriesForClass!Unclassified! !

!MultipleSelectionListBoxTest methodsFor!

classToTest
	^MultipleSelectionListBox!

oldDolphinVersionsForStbUpgrade
	^1 to: 4!

vuFile
	^'ListPresenter.Multi-selection list box.vu'! !

!MultipleSelectionListBoxTest categoriesForMethods!
classToTest!constants!private! !
oldDolphinVersionsForStbUpgrade!constants!private! !
vuFile!constants!private! !
!

!MultipleSelectionListBoxTest class methodsFor!

resource_Multiselection_list_box_D6
	"Answer the literal data from which the 'Multiselection list box' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Multiselection_list_box)
	"

	^#(#'!!STL' 3 788558 10 ##(STBViewProxy) 8 ##(MultipleSelectionListBox) 98 17 0 0 98 2 8 1144064257 1025 416 590662 2 ##(ListModel) 202 208 98 0 0 1114638 ##(STBSingletonProxy) 8 ##(SearchPolicy) 8 #identity 524550 ##(ColorRef) 8 4278190080 0 7 0 0 0 416 0 8 4294903705 459270 ##(Message) 8 #displayString 98 0 544 32 983302 ##(MessageSequence) 202 208 98 2 721670 ##(MessageSend) 8 #createAt:extent: 98 2 328198 ##(Point) 11 11 882 251 351 416 818 8 #horizontalExtent: 98 1 1 416 983302 ##(WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 0 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 5 0 0 0 5 0 0 0 130 0 0 0 180 0 0 0] 98 0 882 193 193 0 27)! !

!MultipleSelectionListBoxTest class categoriesForMethods!
resource_Multiselection_list_box_D6!public!resources-views! !
!

