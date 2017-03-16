"Filed out from Dolphin Smalltalk 7"!

ODBBTreeIndexDictionary subclass: #ODBBTreeIntegerIndexDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBBTreeIntegerIndexDictionary guid: (GUID fromString: '{3227223a-72d0-4869-9ff1-781c849c1b2c}')!
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

