"Filed out from Dolphin Smalltalk X6.2"!

ODBDatabaseObject subclass: #ODBDBBTreeIndexDictionary
	instanceVariableNames: 'iterator'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBDBBTreeIndexDictionary guid: (GUID fromString: '{8162EE03-0FB8-11D4-B091-000000000000}')!
ODBDBBTreeIndexDictionary comment: ''!
!ODBDBBTreeIndexDictionary categoriesForClass!No category! !
!ODBDBBTreeIndexDictionary methodsFor!

associationsDo: aBlock 
	| association |
	iterator critical: [association := iterator getFirst].
	[association isNil] whileFalse: 
			[aBlock value: (Association key: association key
						value: (ODBValueHolder createOn: association value)).
			iterator critical: 
					[association := iterator
								goTo: association key;
								getNext]]!

at: aKey ifAbsent: aBlock 
	| association |
	^(association := iterator goToAndGetCurrentAt: ((ByteArray new: iterator keyLength) 
						replaceFrom: 1
						to: (aKey size min: iterator keyLength)
						with: aKey
						startingAt: 1)) 
		isNil ifTrue: [aBlock value] ifFalse: [ODBValueHolder createOn: association value]!

at: aKey put: value 
	iterator goTo: aKey put: value contents!

close
	iterator notNil 
		ifTrue: 
			[objectHolder container closeObjectFile: objectHolder fileID.
			iterator := nil]!

createBackupCopyIn: newContainer versionDescriptor: versionDescriptor oldHolders: oldHolders versionNumber: versionNumber 
	"Create a backup copy of receiver in a newContainer."

	| newIterator assoc size realSize valueHolder |
	newContainer onNewObjectFileDo: 
			[:index :fileName | 
			objectHolder fileID: index.
			newIterator := (ODBGcBTreeIterator new)
						keyLength: iterator keyLength;
						valueLength: ODBValueHolder sizeInBytes;
						createOn: fileName.
			size := iterator getSizeAt: versionDescriptor oldHolders: oldHolders.
			realSize := 0.
			
			[assoc := iterator getFirst.
			[assoc isNil] whileFalse: 
					[valueHolder := ODBValueHolder createOn: assoc value.
					[versionDescriptor versionOK: valueHolder versionNumber] 
						whileFalse: [valueHolder loadPreviousVersionFrom: oldHolders].
					valueHolder isRemoved 
						ifFalse: 
							[realSize := realSize + 1.
							valueHolder versionNumber: versionNumber.
							newIterator goTo: assoc key put: valueHolder contents].
					assoc := iterator getNext].
			"realSize = size ifFalse: [OmniBase warningMessage: 'Cached dictionary size does not match real size']."
			newIterator putSizeHolder: ((ODBSizeHolder new)
						dictionarySize: realSize;
						previousVersionPosition: 0;
						versionNumber: versionNumber;
						yourself).
			newIterator close] 
					ifCurtailed: [newIterator remove].
			iterator := nil]!

createOn: anObjectHolder keySize: anInteger 
	objectHolder := anObjectHolder.
	objectHolder container onNewObjectFileDo: 
			[:index :fileName | 
			objectHolder fileID: index.
			iterator := (ODBBTreeIterator new)
						keyLength: anInteger;
						valueLength: ODBValueHolder sizeInBytes;
						createOn: fileName]!

garbageCollectOn: anODBGarbageCollector 
	anODBGarbageCollector reorganizeIndexSets ifTrue: [self reorganizeBTree]!

iterator
	^iterator!

makeTransactionObject: aTransaction 
	iterator version = aTransaction versionDescriptor 
		ifFalse: 
			[iterator
				clearSearchCache;
				version: aTransaction versionDescriptor].
	^(ODBBTreeIndexDictionary new)
		setObjectHolder: objectHolder
			dataBaseObject: self
			transaction: aTransaction;
		keySize: iterator keyLength!

openOn: anObjectHolder 
	objectHolder := anObjectHolder.
	iterator := objectHolder container openObjectFile: objectHolder fileID
				ifAbsentPut: [:fileName | ODBBTreeIterator openOn: fileName]!

remove
	iterator isNil 
		ifFalse: 
			[objectHolder container removeObjectFile: objectHolder fileID.
			iterator := nil]!

reorganizeBTree
	"Reorganize B-Tree dictionary."

	| newIterator assoc oldIndex |
	objectHolder container onNewObjectFileDo: 
			[:index :fileName | 
			oldIndex := objectHolder fileID.
			objectHolder fileID: index.
			newIterator := (ODBGcBTreeIterator new)
						keyLength: iterator keyLength;
						valueLength: ODBValueHolder sizeInBytes;
						createOn: fileName.
			
			[newIterator putSizeHolder: iterator getSizeHolder.
			assoc := iterator getFirst.
			[assoc isNil] whileFalse: 
					[(ODBValueHolder createOn: assoc value) isRemoved 
						ifFalse: [newIterator goTo: assoc key put: assoc value].
					assoc := iterator getNext].
			newIterator close] 
					ifCurtailed: [newIterator remove].
			objectHolder store.
			iterator := nil].
	objectHolder container removeObjectFile: oldIndex!

valuesDo: aBlock 
	| association |
	iterator critical: [association := iterator getFirst].
	[association isNil] whileFalse: 
			[aBlock value: (ODBValueHolder createOn: association value).
			iterator critical: 
					[association := iterator
								goTo: association key;
								getNext]]! !
!ODBDBBTreeIndexDictionary categoriesFor: #associationsDo:!public! !
!ODBDBBTreeIndexDictionary categoriesFor: #at:ifAbsent:!public! !
!ODBDBBTreeIndexDictionary categoriesFor: #at:put:!public! !
!ODBDBBTreeIndexDictionary categoriesFor: #close!public! !
!ODBDBBTreeIndexDictionary categoriesFor: #createBackupCopyIn:versionDescriptor:oldHolders:versionNumber:!public! !
!ODBDBBTreeIndexDictionary categoriesFor: #createOn:keySize:!public! !
!ODBDBBTreeIndexDictionary categoriesFor: #garbageCollectOn:!public! !
!ODBDBBTreeIndexDictionary categoriesFor: #iterator!public! !
!ODBDBBTreeIndexDictionary categoriesFor: #makeTransactionObject:!public! !
!ODBDBBTreeIndexDictionary categoriesFor: #openOn:!public! !
!ODBDBBTreeIndexDictionary categoriesFor: #remove!public! !
!ODBDBBTreeIndexDictionary categoriesFor: #reorganizeBTree!public! !
!ODBDBBTreeIndexDictionary categoriesFor: #valuesDo:!public! !

!ODBDBBTreeIndexDictionary class methodsFor!

classID
	"Answer database object classID."

	^67!

hasExternalFiles
	"Answer <true> if the object stores its contents into external files."

	^true! !
!ODBDBBTreeIndexDictionary class categoriesFor: #classID!public! !
!ODBDBBTreeIndexDictionary class categoriesFor: #hasExternalFiles!accessing!public! !

