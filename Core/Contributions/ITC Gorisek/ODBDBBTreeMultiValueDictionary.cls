"Filed out from Dolphin Smalltalk 7"!

ODBDBBTreeIndexDictionary subclass: #ODBDBBTreeMultiValueDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBDBBTreeMultiValueDictionary guid: (GUID fromString: '{cccaa6eb-a9e7-4c14-b43b-53237f14b6a9}')!
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

