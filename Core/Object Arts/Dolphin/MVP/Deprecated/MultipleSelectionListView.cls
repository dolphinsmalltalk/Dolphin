"Filed out from Dolphin Smalltalk 7"!

ListView subclass: #MultipleSelectionListView
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
MultipleSelectionListView guid: (GUID fromString: '{87b4c733-026e-11d3-9fd7-00a0cc3e4a32}')!
MultipleSelectionListView comment: 'MultipleSelectionListView has now been deprecated - instances should be replaced by <ListView> instances configured to operate in multiple selection mode.  Note that ListView corrects the historical design error in MultipleSelectionListView in that the single selection protocols (#selection[:], #selectionByIndex[:], etc) always operate on a single item (this class redefines the single selection protocols to operate on collections). For multiple selections the multiple selection protocols (e.g. #selections[:], #selectionsByIndex[:], etc) must be used.'!
!MultipleSelectionListView categoriesForClass!MVP-Views! !
!MultipleSelectionListView methodsFor!

defaultWindowStyle
	"Private - Answer a base style to use when creating a ListView."

	^super defaultWindowStyle maskClear: LVS_SINGLESEL
!

isMultiSelect: aBoolean 
	aBoolean ifFalse: [self error: 'Cannot be switched out of multi-select mode.']!

selection
	"Legacy behaviour"

	^self selections!

selection: newSelection ifAbsent: exceptionHandler 
	"Legacy behaviour."

	^self selections: newSelection ifAbsent: exceptionHandler!

selectionByIndex
	"Legacy behaviour was to redefine the result to be a collection."

	^self selectionsByIndex!

selectionByIndex: anInteger ifAbsent: exceptionHandler 
	"Legacy behaviour for backwards compatibility."

	^self selectionsByIndex: anInteger ifAbsent: exceptionHandler!

selectionIfNone: aBlock 
	"Legacy behaviour"

	| selections |
	selections := self selections.
	^selections isEmpty ifTrue: [aBlock value] ifFalse: [selections]!

selectionOrNil
	"Legacy behaviour"

	^self selectionIfNone: [#()]! !
!MultipleSelectionListView categoriesFor: #defaultWindowStyle!constants!private! !
!MultipleSelectionListView categoriesFor: #isMultiSelect:!public!testing! !
!MultipleSelectionListView categoriesFor: #selection!public!selection! !
!MultipleSelectionListView categoriesFor: #selection:ifAbsent:!public!selection! !
!MultipleSelectionListView categoriesFor: #selectionByIndex!public!selection! !
!MultipleSelectionListView categoriesFor: #selectionByIndex:ifAbsent:!public!selection! !
!MultipleSelectionListView categoriesFor: #selectionIfNone:!public!selection! !
!MultipleSelectionListView categoriesFor: #selectionOrNil!public!selection! !

!MultipleSelectionListView class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Smalltalk developmentSystem deprecatedIcon!

publishedAspectsOfInstances
	"Answer a <LookupTable> of the <Aspect>s published by instances of the receiver."

	| aspects |
	aspects := super publishedAspectsOfInstances.
	(aspects at: #isMultiSelect) beReadOnly.
	^aspects! !
!MultipleSelectionListView class categoriesFor: #icon!constants!public! !
!MultipleSelectionListView class categoriesFor: #publishedAspectsOfInstances!constants!development!public! !

