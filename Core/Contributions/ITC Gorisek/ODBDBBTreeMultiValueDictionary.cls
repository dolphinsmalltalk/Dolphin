"Filed out from Dolphin Smalltalk X6.2"!

ODBDBBTreeIndexDictionary subclass: #ODBDBBTreeMultiValueDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBDBBTreeMultiValueDictionary guid: (GUID fromString: '{CCCAA6EB-A9E7-4C14-B43B-53237F14B6A9}')!
ODBDBBTreeMultiValueDictionary comment: ''!
!ODBDBBTreeMultiValueDictionary categoriesForClass!No category! !
!ODBDBBTreeMultiValueDictionary methodsFor!

makeTransactionObject: aTransaction 
	iterator version = aTransaction versionDescriptor 
		ifFalse: 
			[iterator
				clearSearchCache;
				version: aTransaction versionDescriptor].
	^(ODBBTreeMultiValueDictionary new)
		setObjectHolder: objectHolder
			dataBaseObject: self
			transaction: aTransaction;
		keySize: iterator keyLength!

referencesDo: aBlock 
	| valueHolder association |
	iterator critical: [association := iterator getFirst].
	[association isNil] whileFalse: 
			[(valueHolder := ODBValueHolder createOn: association value) isRemoved 
				ifFalse: [aBlock value: valueHolder objectID].
			iterator critical: 
					[association := iterator
								goTo: association key;
								getNext]]! !
!ODBDBBTreeMultiValueDictionary categoriesFor: #makeTransactionObject:!public! !
!ODBDBBTreeMultiValueDictionary categoriesFor: #referencesDo:!public! !

!ODBDBBTreeMultiValueDictionary class methodsFor!

classID
	"Answer database object classID."

	^69! !
!ODBDBBTreeMultiValueDictionary class categoriesFor: #classID!public! !

