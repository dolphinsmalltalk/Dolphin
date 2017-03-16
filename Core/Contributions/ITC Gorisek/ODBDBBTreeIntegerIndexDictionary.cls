"Filed out from Dolphin Smalltalk 7"!

ODBDBBTreeIndexDictionary subclass: #ODBDBBTreeIntegerIndexDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBDBBTreeIntegerIndexDictionary guid: (GUID fromString: '{db775ef8-2475-481d-9b26-ce21f5164daf}')!
ODBDBBTreeIntegerIndexDictionary comment: ''!
!ODBDBBTreeIntegerIndexDictionary categoriesForClass!No category! !
!ODBDBBTreeIntegerIndexDictionary methodsFor!

makeTransactionObject: aTransaction 
	iterator version = aTransaction versionDescriptor 
		ifFalse: 
			[iterator
				clearSearchCache;
				version: aTransaction versionDescriptor].
	^(ODBBTreeIntegerIndexDictionary new)
		setObjectHolder: objectHolder
			dataBaseObject: self
			transaction: aTransaction;
		keySize: iterator keyLength! !
!ODBDBBTreeIntegerIndexDictionary categoriesFor: #makeTransactionObject:!public! !

!ODBDBBTreeIntegerIndexDictionary class methodsFor!

classID
	"Answer database object classID."

	^70! !
!ODBDBBTreeIntegerIndexDictionary class categoriesFor: #classID!public! !

