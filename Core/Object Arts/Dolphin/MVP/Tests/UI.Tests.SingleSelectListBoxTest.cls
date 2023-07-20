"Filed out from Dolphin Smalltalk"!

UI.Tests.ListBoxTest
	subclass: #'UI.Tests.SingleSelectListBoxTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.SingleSelectListBoxTest guid: (Core.GUID fromString: '{8e5a59a5-f500-4d07-9ea2-b1019c9302b2}')!
UI.Tests.SingleSelectListBoxTest comment: ''!
!UI.Tests.SingleSelectListBoxTest methodsFor!

testSelectionModeChange
	| objects |
	self deny: self isMultiSelect.
	objects := self objectsToTest.
	presenter model addAll: objects.
	self assert: presenter hasSelection not.
	self assertIsNil: presenter selectionOrNil.
	"Must trigger a selection change when switching to multi-select, as otherwise observers do not know the mode change has occurred."
	self
		should: [presenter view isMultiSelect: true]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter hasSelection not.
	self assertIsNil: presenter selectionOrNil.
	self assert: presenter view selectionMode identicalTo: #multi.
	self
		shouldnt: [presenter view selectionMode: #toggle]
		trigger: #selectionChanged
		against: presenter.
	self
		shouldnt: [presenter view selectionMode: #multi]
		trigger: #selectionChanged
		against: presenter.
	self
		should: [presenter view isMultiSelect: false]
		trigger: #selectionChanged
		against: presenter.
	presenter selection: objects second.
	self assert: presenter view selectionsByIndex equals: #(2).
	self should: [presenter view getMultipleSelections] raise: Error.
	self
		should: [presenter view isMultiSelect: true]
		trigger: #selectionChanged
		against: presenter.
	"#115: Changing list box selection mode fails if there are selections"
	self assert: presenter view selectionsByIndex equals: #(2)!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: view isMultiSelect
		equals: aResourceIdentifier selector == #resource_Multiselection_list_box! !
!UI.Tests.SingleSelectListBoxTest categoriesForMethods!
testSelectionModeChange!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
!

!UI.Tests.SingleSelectListBoxTest class methodsFor!

classToTest
	^ListPresenter!

resource_Default_view_D6
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ListBox) 98 17 0 0 98 2 8 1412497665 1025 416 590662 2 ##(Smalltalk.ListModel) 202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294903955 459270 ##(Smalltalk.Message) 8 #displayString 98 0 544 32 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 850 251 351 416 786 8 #horizontalExtent: 98 1 1 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 244 5 0 0 185 0 0 0] 98 0 850 193 193 0 27)!

resource_Default_view_D7
	"Answer the literal data from which the 'Default view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Default_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ListBox) 34 17 nil nil 34 2 8 1412497665 1025 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1903732064 459270 ##(Smalltalk.Message) #displayString 8 #() 528 false 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 3839 21 786 251 351 416 738 #horizontalExtent: 8 #(0) 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 252 7 0 0 185 0 0 0] 8 #() 786 193 193 nil 27 )! !
!UI.Tests.SingleSelectListBoxTest class categoriesForMethods!
classToTest!helpers!private! !
resource_Default_view_D6!public!resources-views! !
resource_Default_view_D7!public!resources-views! !
!

