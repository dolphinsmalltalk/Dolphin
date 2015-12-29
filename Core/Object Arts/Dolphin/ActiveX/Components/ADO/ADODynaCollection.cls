"Filed out from Dolphin Smalltalk X6"!

ADOCollection subclass: #ADODynaCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ADODynaCollection guid: (GUID fromString: '{CF1FB266-A204-4F8E-B6BB-BCB2806EF724}')!
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

