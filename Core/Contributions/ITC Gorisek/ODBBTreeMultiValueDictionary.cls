"Filed out from Dolphin Smalltalk 7"!

ODBBTreeIndexDictionary subclass: #ODBBTreeMultiValueDictionary
	instanceVariableNames: 'initialSize deltaSize newObjects'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBBTreeMultiValueDictionary guid: (GUID fromString: '{9c3a735f-1975-434c-b8c5-a8182c9cf1b6}')!
ODBBTreeMultiValueDictionary comment: ''!
!ODBBTreeMultiValueDictionary categoriesForClass!No category! !
!ODBBTreeMultiValueDictionary methodsFor!

add: anAssociation 
"
	self atKey: anAssociation key put: anAssociation value.
	^anAssociation"!

at: aKey 
	^self valuesAt: aKey!

at: aKey put: anObject 
	^self atKey: aKey add: anObject!

atKey: aKey add: anObject!

COMMENT
	"This class is not yet implemented."

	!

initialize
	"Private - Initialize receiver."

	super initialize.
	initialSize := 0.
	deltaSize := 0!

valuesAt: aKey
! !
!ODBBTreeMultiValueDictionary categoriesFor: #add:!public! !
!ODBBTreeMultiValueDictionary categoriesFor: #at:!public! !
!ODBBTreeMultiValueDictionary categoriesFor: #at:put:!public! !
!ODBBTreeMultiValueDictionary categoriesFor: #atKey:add:!public! !
!ODBBTreeMultiValueDictionary categoriesFor: #COMMENT!public! !
!ODBBTreeMultiValueDictionary categoriesFor: #initialize!private! !
!ODBBTreeMultiValueDictionary categoriesFor: #valuesAt:!public! !

