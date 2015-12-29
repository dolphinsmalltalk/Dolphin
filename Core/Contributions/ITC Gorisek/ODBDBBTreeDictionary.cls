"Filed out from Dolphin Smalltalk X6.2"!

ODBDBBTreeIndexDictionary subclass: #ODBDBBTreeDictionary
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBDBBTreeDictionary guid: (GUID fromString: '{8162EE06-0FB8-11D4-B091-000000000000}')!
ODBDBBTreeDictionary comment: ''!
!ODBDBBTreeDictionary categoriesForClass!No category! !
!ODBDBBTreeDictionary methodsFor!

garbageCollectOn: anODBGarbageCollector 
	anODBGarbageCollector reorganizeDictionaries ifTrue: [self reorganizeBTree]!

makeTransactionObject: aTransaction 
	iterator version = aTransaction versionDescriptor 
		ifFalse: 
			[iterator
				clearSearchCache;
				version: aTransaction versionDescriptor].
	^(ODBBTreeDictionary new)
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
								getNext]]!

unlockKey: aKey with: lockID 
	| result |
	iterator critical: 
			[result := iterator
						goTo: aKey;
						unlockCurrentWith: lockID].
	^result! !
!ODBDBBTreeDictionary categoriesFor: #garbageCollectOn:!public! !
!ODBDBBTreeDictionary categoriesFor: #makeTransactionObject:!public! !
!ODBDBBTreeDictionary categoriesFor: #referencesDo:!public! !
!ODBDBBTreeDictionary categoriesFor: #unlockKey:with:!public! !

!ODBDBBTreeDictionary class methodsFor!

classID
	"Answer database object classID."

	^65! !
!ODBDBBTreeDictionary class categoriesFor: #classID!public! !

