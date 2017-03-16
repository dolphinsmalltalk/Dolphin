"Filed out from Dolphin Smalltalk 7"!

ODBDBBTreeDictionary subclass: #ODBDBBTreeIdentityDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBDBBTreeIdentityDictionary guid: (GUID fromString: '{d6774546-5a08-49c3-b577-14b960a34efa}')!
ODBDBBTreeIdentityDictionary comment: ''!
!ODBDBBTreeIdentityDictionary categoriesForClass!No category! !
!ODBDBBTreeIdentityDictionary methodsFor!

makeTransactionObject: aTransaction 
	iterator version = aTransaction versionDescriptor 
		ifFalse: 
			[iterator
				clearSearchCache;
				version: aTransaction versionDescriptor].
	^(ODBBTreeIdentityDictionary new)
		setObjectHolder: objectHolder
			dataBaseObject: self
			transaction: aTransaction;
		keySize: iterator keyLength!

referencesDo: aBlock 
	"A key is a persistent object and a value is a persistent object.
	Therefore we need to iterate over both."

	| valueHolder association |
	iterator critical: [association := iterator getFirst].
	[association isNil] whileFalse: 
			[(valueHolder := ODBValueHolder createOn: association value) isRemoved 
				ifFalse: 
					[aBlock value: (ODBObjectID new fromBytes: association key at: 1).
					aBlock value: valueHolder objectID].
			iterator critical: 
					[association := iterator
								goTo: association key;
								getNext]]! !
!ODBDBBTreeIdentityDictionary categoriesFor: #makeTransactionObject:!public! !
!ODBDBBTreeIdentityDictionary categoriesFor: #referencesDo:!public! !

!ODBDBBTreeIdentityDictionary class methodsFor!

classID
	"Answer database object classID."

	^68! !
!ODBDBBTreeIdentityDictionary class categoriesFor: #classID!public! !

