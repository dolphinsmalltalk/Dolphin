"Filed out from Dolphin Smalltalk X6.2"!

ODBBTreeIndexDictionary subclass: #ODBBTreeIntegerIndexDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBBTreeIntegerIndexDictionary guid: (GUID fromString: '{3227223A-72D0-4869-9FF1-781C849C1B2C}')!
ODBBTreeIntegerIndexDictionary comment: ''!
!ODBBTreeIntegerIndexDictionary categoriesForClass!No category! !
!ODBBTreeIntegerIndexDictionary methodsFor!

bytesFromKey: anInteger 
	^((ByteArray new: 4) odbLongAt: 1 put: anInteger) reverse!

databaseObjectClass
	^ODBDBBTreeIntegerIndexDictionary!

initialize
	"Private - Initialize receiver."

	super initialize.
	keySize := 4!

keyFromBytes: aByteArray 
	^aByteArray reverse odbLongAt: 1! !
!ODBBTreeIntegerIndexDictionary categoriesFor: #bytesFromKey:!private! !
!ODBBTreeIntegerIndexDictionary categoriesFor: #databaseObjectClass!private! !
!ODBBTreeIntegerIndexDictionary categoriesFor: #initialize!private! !
!ODBBTreeIntegerIndexDictionary categoriesFor: #keyFromBytes:!private! !

!ODBBTreeIntegerIndexDictionary class methodsFor!

new
	^super new keySize: 4! !
!ODBBTreeIntegerIndexDictionary class categoriesFor: #new!public! !

