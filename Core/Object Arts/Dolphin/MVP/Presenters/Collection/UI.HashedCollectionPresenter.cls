"Filed out from Dolphin Smalltalk"!

UI.CollectionPresenter
	subclass: #'UI.HashedCollectionPresenter'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.HashedCollectionPresenter guid: (Core.GUID fromString: '{1a16cca4-5c91-49d9-9a87-4b4a340299d9}')!

UI.HashedCollectionPresenter comment: ''!

!UI.HashedCollectionPresenter categoriesForClass!MVP-Presenters! !

!UI.HashedCollectionPresenter methodsFor!

addElement: anObject
	self value: ((self value)
				add: anObject;
				yourself)!

addItem: anObject
	"Add anAssociation into the receiver's model"

	self addElement: anObject.
	self onValueChanged.
	listPresenter selection: anObject!

canAddOrRemoveItems
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

	<commandQuery: #canRemoveItem>
	| item |
	item := listPresenter selection.
	self removeElement: item.
	self onValueChanged! !

!UI.HashedCollectionPresenter categoriesForMethods!
addElement:!adding!private! !
addItem:!operations!public! !
canAddOrRemoveItems!commands-queries!private!testing! !
elements!accessing!public! !
onListChanged!event handling!public! !
onValueChanged!event handling!public! !
removeElement:!private!removing! !
removeItem!commands-actions!public!removing! !
!

