"Filed out from Dolphin Smalltalk X6.2"!

ODBDBBTreeIndexDictionary subclass: #ODBDBBTreeIntegerIndexDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBDBBTreeIntegerIndexDictionary guid: (GUID fromString: '{DB775EF8-2475-481D-9B26-CE21F5164DAF}')!
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

