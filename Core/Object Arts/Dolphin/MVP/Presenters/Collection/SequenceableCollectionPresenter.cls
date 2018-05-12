"Filed out from Dolphin Smalltalk 7"!

CollectionPresenter subclass: #SequenceableCollectionPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequenceableCollectionPresenter guid: (GUID fromString: '{87b4c68c-026e-11d3-9fd7-00a0cc3e4a32}')!
SequenceableCollectionPresenter comment: 'SequenceableCollectionPresenter is a <valuePresenter> that presents a <sequencedCollection> accessed via its <valueModel>. It provides a number of [operations]for editing the list. As changes are made to the list it is applied back to the presenter''s <valueModel>.

'!
!SequenceableCollectionPresenter categoriesForClass!MVP-Presenters! !
!SequenceableCollectionPresenter methodsFor!

canReorder
	"Private - Answer true if it is valid to reorder the receiver's collection"

	^self isReadOnly not 
		and: [self model canSet and: [self model value class conformsToProtocol: #sequencedCollection]]!

moveDown
	"Moves the current selection closer to the end of the receiver's list"

	| index list |
	index := listPresenter selectionByIndex.
	list := self listModel.
	list swap: index with: index + 1.
	listPresenter selectionByIndex: index + 1!

moveFirst
	"Moves the current selection to be the first item in the receiver's list"

	| list index |
	index := listPresenter selectionByIndex.
	list := self listModel.
	list noEventsDo: 
			[| item |
			item := list at: index.
			list replaceFrom: 2 to: index with: list startingAt: 1.
			list at: 1 put: item].
	list notifyListChanged.
	listPresenter selectionByIndex: 1!

moveLast
	"Moves the current selection to be the last  item in the receiver's list"

	| list index last |
	index := listPresenter selectionByIndex.
	list := self listModel.
	last := list size.
	list noEventsDo: 
			[| item |
			item := list at: index.
			list 
				replaceFrom: index
				to: last - 1
				with: list
				startingAt: index + 1.
			list at: last put: item].
	list notifyListChanged.
	listPresenter selectionByIndex: last!

moveUp
	"Moves the current selection closer to the head of the receiver's list"

	| index list |
	index := listPresenter selectionByIndex.
	list := self listModel.
	list swap: index with: index - 1.
	listPresenter selectionByIndex: index - 1!

onValueChanged
	"Private - The value has been changed in the receiver's model.
	Transfer the value to the listModel"

	listPresenter list: self value!

queryCommand: query
	"Private - Enters details about a potential command for the receiver into 
	the <CommandQuery>, query"

	| command |
	command := query commandSymbol.
	(#(#moveUp #moveFirst) identityIncludes: command) 
		ifTrue: 
			[query isEnabled: (self canReorder and: [listPresenter selectionByIndex > 1]).
			^true].
	(#(#moveDown #moveLast) identityIncludes: command) 
		ifTrue: 
			[query 
				isEnabled: (self canReorder and: 
							[| selected |
							selected := listPresenter selectionByIndex.
							selected > 0 and: [selected < self listModel size]]).
			^true].
	^super queryCommand: query! !
!SequenceableCollectionPresenter categoriesFor: #canReorder!private!testing! !
!SequenceableCollectionPresenter categoriesFor: #moveDown!commands!operations!public! !
!SequenceableCollectionPresenter categoriesFor: #moveFirst!commands!operations!public! !
!SequenceableCollectionPresenter categoriesFor: #moveLast!commands!operations!public! !
!SequenceableCollectionPresenter categoriesFor: #moveUp!commands!operations!public! !
!SequenceableCollectionPresenter categoriesFor: #onValueChanged!event handling!private! !
!SequenceableCollectionPresenter categoriesFor: #queryCommand:!commands!private! !

