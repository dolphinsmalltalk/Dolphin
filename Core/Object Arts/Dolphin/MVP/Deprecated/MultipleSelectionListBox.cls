"Filed out from Dolphin Smalltalk"!

ListBox subclass: #MultipleSelectionListBox
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MultipleSelectionListBox guid: (GUID fromString: '{87b4c72d-026e-11d3-9fd7-00a0cc3e4a32}')!

MultipleSelectionListBox comment: 'MultipleSelectionListBox was deprecated in 6.0 - instances should be replaced by <ListBox> instances configured to operate in one of the multiple selection modes.  Note that ListBox corrects the historical design error in MultipleSelectionListBox in that the single selection protocols (#selection[:], #selectionByIndex[:], etc) always operate on a single item (this class redefines the single selection protocols to operate on collections). For multiple selections the multiple selection protocols (e.g. #selections[:], #selectionsByIndex[:], etc) must be used.'!

!MultipleSelectionListBox categoriesForClass!MVP-Views! !

!MultipleSelectionListBox methodsFor!

defaultWindowStyle
	"Private - Answer the default basic window creation style for a list box"

	^super defaultWindowStyle bitOr: LBS_EXTENDEDSEL
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

	^self getMultipleSelections!

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

!MultipleSelectionListBox categoriesForMethods!
defaultWindowStyle!constants!private! !
isMultiSelect:!public!testing! !
selection!public!selection! !
selection:ifAbsent:!public!selection! !
selectionByIndex!public!selection! !
selectionByIndex:ifAbsent:!public!selection! !
selectionIfNone:!public!selection! !
selectionOrNil!public!selection! !
!

!MultipleSelectionListBox class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Smalltalk developmentSystem deprecatedIcon! !

!MultipleSelectionListBox class categoriesForMethods!
icon!constants!public! !
!

