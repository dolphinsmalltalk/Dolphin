"Filed out from Dolphin Smalltalk X6.1"!

CollectionPresenter subclass: #HashedCollectionPresenter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HashedCollectionPresenter guid: (GUID fromString: '{1A16CCA4-5C91-49D9-9A87-4B4A340299D9}')!
HashedCollectionPresenter comment: ''!
!HashedCollectionPresenter categoriesForClass!MVP-Presenters! !
!HashedCollectionPresenter methodsFor!

addElement: anObject
	self value: ((self value)
				add: anObject;
				yourself)!

addItem: anObject
	"Add anAssociation into the receiver's model"

	self addElement: anObject.
	self onValueChanged.
	listPresenter selection: anObject!

canGrow
	"Private - Answer true if it is valid to add and remove elements of the receiver's collection"

	^self isReadOnly not and: [self model canSet]!

elements
	^self value asSortedCollection: [:x :y | x displayString < y displayString]!

onListChanged
	"The list of keys has been changed so update the receiver's model."

	"Do nothing. Updates are handled by #addItem and #removeItem"
!

onValueChanged
	"Private - The value has been changed in the receiver's model.
	Transfer the value to the listModel"

	listPresenter model: ListModel newEquality.
	listPresenter list: self elements!

removeElement: anObject
	self value: ((self value)
				remove: anObject;
				yourself)!

removeItem
	"Removes the current selection from the receiver's list"

	| item |
	item := listPresenter selection.
	self removeElement: item.
	self onValueChanged! !
!HashedCollectionPresenter categoriesFor: #addElement:!adding!private! !
!HashedCollectionPresenter categoriesFor: #addItem:!operations!public! !
!HashedCollectionPresenter categoriesFor: #canGrow!private!testing! !
!HashedCollectionPresenter categoriesFor: #elements!accessing!public! !
!HashedCollectionPresenter categoriesFor: #onListChanged!event handling!public! !
!HashedCollectionPresenter categoriesFor: #onValueChanged!event handling!public! !
!HashedCollectionPresenter categoriesFor: #removeElement:!private!removing! !
!HashedCollectionPresenter categoriesFor: #removeItem!commands!public!removing! !

