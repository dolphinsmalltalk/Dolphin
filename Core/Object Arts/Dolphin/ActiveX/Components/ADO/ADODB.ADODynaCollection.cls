"Filed out from Dolphin Smalltalk 7"!

ADOCollection subclass: #ADODynaCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ADODynaCollection guid: (GUID fromString: '{cf1fb266-a204-4f8e-b6bb-bcb2806ef724}')!
ADODynaCollection comment: ''!
!ADODynaCollection categoriesForClass!Unclassified! !
!ADODynaCollection methodsFor!

add: newElement
	"Append a new element to the receiver."

	^interface Append: newElement!

removeAtIndex: index
	"Remove, and answer, the element of the receiver at the specified 
	<integer> index, by shuffling elements which succeed it down one slot.
	Raise a <BoundsError> if there is no element with that index."

	^interface Delete: (index-1) asVariant! !
!ADODynaCollection categoriesFor: #add:!adding!public! !
!ADODynaCollection categoriesFor: #removeAtIndex:!public!removing! !

