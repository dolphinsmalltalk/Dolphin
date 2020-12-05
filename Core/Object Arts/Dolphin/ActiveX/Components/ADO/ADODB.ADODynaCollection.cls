"Filed out from Dolphin Smalltalk 7"!

ADODB.ADOCollection subclass: #'ADODB.ADODynaCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
ADODB.ADODynaCollection guid: (Core.GUID fromString: '{cf1fb266-a204-4f8e-b6bb-bcb2806ef724}')!
ADODB.ADODynaCollection comment: ''!
!ADODB.ADODynaCollection categoriesForClass!Unclassified! !
!ADODB.ADODynaCollection methodsFor!

add: newElement
	"Append a new element to the receiver."

	^interface Append: newElement!

removeAtIndex: index
	"Remove, and answer, the element of the receiver at the specified 
	<integer> index, by shuffling elements which succeed it down one slot.
	Raise a <BoundsError> if there is no element with that index."

	^interface Delete: (index-1) asVariant! !
!ADODB.ADODynaCollection categoriesFor: #add:!adding!public! !
!ADODB.ADODynaCollection categoriesFor: #removeAtIndex:!public!removing! !

