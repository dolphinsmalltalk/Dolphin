"Filed out from Dolphin Smalltalk"!

UI.Tests.ListViewTest subclass: #'UI.Tests.SingleSelectListViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.ListViewConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.SingleSelectListViewTest guid: (Core.GUID fromString: '{176c59b9-4286-4753-8320-c9b5da469d9e}')!
UI.Tests.SingleSelectListViewTest comment: ''!
!UI.Tests.SingleSelectListViewTest methodsFor!

oldDolphinVersionsForStbUpgrade
	^1 to: 5!

sortSelections
	^#(50)!

testSelectionModeChange
	| objects caret |
	self deny: self isMultiSelect.
	objects := self objectsToTest.
	presenter model addAll: objects.
	presenter selectionByIndex: 1.
	self
		shouldnt: [presenter view isMultiSelect: true]
		trigger: #selectionChanged
		against: presenter.
	self assert: self isMultiSelect.
	self assert: presenter selectionsByIndex equals: #(1).
	presenter selectionsByIndex: #(2 3).
	caret := presenter view caretIndex.
	self assert: caret equals: 3.
	self
		should: [presenter view isMultiSelect: false]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selectionByIndex equals: caret.
	presenter view selectionsByIndex: #(1 2).
	self assert: presenter selectionsByIndex equals: #(1)!

verifyUpgradedView: anInteger
	| view |
	super verifyUpgradedView: anInteger.
	view := self view.
	self deny: view isMultiSelect.
	anInteger > 3 ifTrue: [self assert: self view primaryColumn text equals: 'Column 1']!

vuFile
	^'ListPresenter.Enhanced list view.vu'! !
!UI.Tests.SingleSelectListViewTest categoriesForMethods!
oldDolphinVersionsForStbUpgrade!constants!private! !
sortSelections!private!unit tests! !
testSelectionModeChange!public!unit tests! !
verifyUpgradedView:!helpers!private! !
vuFile!constants!private! !
!

!UI.Tests.SingleSelectListViewTest class methodsFor!

resource_Enhanced_list_view_D6
	"Answer the literal data from which the 'Enhanced list view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Enhanced_list_view)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.ListView) 98 30 0 0 98 2 8 1409355853 1025 416 590662 2 ##(Smalltalk.ListModel) 202 208 98 0 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 5 0 0 0 416 0 8 4294903801 459270 ##(Smalltalk.Message) 8 #displayString 98 0 8 ##(Smalltalk.IconicListAbstract) 1049670 1 ##(Smalltalk.IconImageManager) 0 0 0 0 0 0 202 208 98 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 8 #left 658 688 704 8 ##(Smalltalk.SortedCollection) 0 0 416 0 1 0 0 8 #report 544 0 131169 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 2 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 328198 ##(Smalltalk.Point) 2799 21 1042 491 311 416 978 8 #text: 98 1 8 'Column 1' 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 108 6 0 0 165 0 0 0] 98 0 1042 193 193 0 27)!

resource_Enhanced_list_view_D7
	"Answer the literal data from which the 'Enhanced list view' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Enhanced_list_view)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.ListView) 34 45 nil nil 34 2 8 1409355853 1025 416 590662 2 ##(Smalltalk.ListModel) 138 144 8 #() nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 327686 ##(Smalltalk.Color) #default nil 5 nil nil nil 416 nil 8 1883852064 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.IconicListAbstract) 1049926 1 ##(Smalltalk.IconImageManager) nil nil nil nil nil nil 138 144 34 1 920646 5 ##(Smalltalk.ListViewColumn) 8 'Column 1' 201 #left 626 #displayString 656 626 #<= 8 #() nil nil 416 nil 1 nil nil #report 528 nil 131169 nil 1 nil nil nil nil nil nil nil nil nil nil nil nil nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 2 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 328198 ##(Smalltalk.Point) 7039 21 946 491 311 416 898 #text: 34 1 8 'Column 1' 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 191 13 0 0 10 0 0 0 180 14 0 0 165 0 0 0] 8 #() 946 193 193 nil 35)! !
!UI.Tests.SingleSelectListViewTest class categoriesForMethods!
resource_Enhanced_list_view_D6!public!resources-views! !
resource_Enhanced_list_view_D7!public!resources-views! !
!

