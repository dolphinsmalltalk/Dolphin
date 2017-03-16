"Filed out from Dolphin Smalltalk 7"!

ODBTransactionObject subclass: #ODBBTreeIndexDictionary
	instanceVariableNames: 'changed keySize currentKey'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBBTreeIndexDictionary guid: (GUID fromString: '{8162ee2e-0fb8-11d4-b091-000000000000}')!
ODBBTreeIndexDictionary comment: ''!
!ODBBTreeIndexDictionary categoriesForClass!No category! !
!ODBBTreeIndexDictionary methodsFor!

at: aKey 
	^self at: aKey ifAbsent: []!

at: aKey ifAbsent: aBlock 
	| key value |
	key := self bytesFromKey: aKey.
	value := self valueAt: key ifAbsent: [^aBlock value].
	value isRemoved ifTrue: [^aBlock value].
	^value getObjectIn: transaction!

at: aKey ifAbsentPut: aBlock 
	^self at: aKey ifAbsent: [self at: aKey put: aBlock value]!

at: aKey put: anObject 
	"Associate aKey with anObject. Answer anObject."

	| key value |
	key := self bytesFromKey: aKey.
	value := self valueAt: key.
	value object: anObject.
	changed isNil ifTrue: [changed := self newChangedDictionary].
	changed at: key put: value.
	^anObject!

basicGoTo: aByteArray 
	currentKey := aByteArray.
	changed isNil ifFalse: [changed goTo: currentKey]!

bytesFromKey: anObject 
	^anObject asBtreeKeyOfSize: keySize!

commit: serializer 
	"Commit changes."

	dataBaseObject isNil ifTrue: [self commitNew] ifFalse: [self commitChanged]!

commitChanged
	"Private - Commit changes on an already existing dictionary."

	| changesPackage newValue vn oldHolders |
	changesPackage := transaction changesPackage.
	changesPackage add: (ODBDictionaryChanged new transactionObject: self).
	vn := transaction versionNumber.
	oldHolders := transaction oldHolders.
	changed isNil 
		ifFalse: 
			[changed keysAndValuesDo: 
					[:key :oldValue | 
					newValue := oldValue makeNewVersion: oldHolders.
					newValue versionNumber: vn.
					oldValue isRemoved 
						ifFalse: [newValue objectID: (transaction getObjectID: newValue object)].
					changesPackage add: ((ODBAssociationChanged new)
								key: key;
								setObjectID: holder objectID transactionObject: self;
								oldValue: oldValue;
								newValue: newValue)]]!

commitNew
	"Private - Commit changes when new database object needs to be created."

	| newHolder newDBObject vn |
	vn := transaction versionNumber.
	newHolder := (holder makeNewVersion: transaction oldHolders)
				persistentClassID: self databaseObjectClass classID;
				versionNumber: vn.
	newDBObject := self databaseObjectClass new createOn: newHolder keySize: keySize.
	changed notNil 
		ifTrue: 
			[changed keysAndValuesDo: 
					[:key :value | 
					value isRemoved 
						ifFalse: 
							[value
								objectID: (transaction getObjectID: value object);
								versionNumber: vn.
							newDBObject at: key put: value]]].
	(transaction changesPackage)
		add: ((ODBNewObjectVersion new)
					setObjectID: holder objectID transactionObject: self;
					oldVersion: holder;
					newVersion: newHolder);
		add: ((ODBDictionaryChanged new)
					transactionObject: self;
					dataBaseObject: newDBObject)!

databaseObjectClass
	^ODBDBBTreeIndexDictionary!

dbPeekNext
	| iterator assoc valueHolder |
	dataBaseObject isNil ifTrue: [^nil].
	iterator := dataBaseObject iterator.
	"critical section begin"
	iterator critical: 
			[iterator goTo: currentKey.
			
			[(assoc := iterator getNext) isNil ifTrue: [^nil].
			valueHolder := ODBValueHolder createOn: assoc value.
			[transaction versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved] 
					whileTrue: []].
	"critical section end"
	^ODBBTreeDictionaryAssociation new 
		setTransaction: transaction
		key: (self keyFromBytes: assoc key)
		value: valueHolder!

dbPeekPrevious
	| iterator assoc valueHolder |
	dataBaseObject isNil ifTrue: [^nil].
	iterator := dataBaseObject iterator.
	"critical section begin"
	iterator critical: 
			[iterator goTo: currentKey.
			
			[(assoc := iterator getPrevious) isNil ifTrue: [^nil].
			valueHolder := ODBValueHolder createOn: assoc value.
			[transaction versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved] 
					whileTrue: []].
	"critical section end"
	^ODBBTreeDictionaryAssociation new 
		setTransaction: transaction
		key: (self keyFromBytes: assoc key)
		value: valueHolder!

do: aBlock 
	"Evaluate aBlock for each object in the dictionary.
	NOTE: All objects will be loaded in one transaction at once.
	Do not use this method if there are a lot of objects in the dictionary since this could take some time."

	| assoc |
	assoc := self getFirst.
	[assoc isNil] whileFalse: 
			[aBlock value: assoc value.
			assoc := self getNext]!

forKeysStartingWith: aStringOrByteArray do: aBlock 
	"Evaluate aOneArgumentBlock for every key that starts with aStringOrByteArray."

	| fromKey toKey assoc |
	fromKey := self bytesFromKey: aStringOrByteArray.
	toKey := fromKey copy.
	aStringOrByteArray size + 1 to: keySize do: [:i | toKey at: i put: 255].
	self basicGoTo: fromKey.
	(assoc := self getCurrent) isNil ifTrue: [assoc := self getNext].
	[assoc isNil] whileFalse: 
			[(toKey odbIsLessThan: assoc key) ifTrue: [^self].
			aBlock value: assoc value.
			assoc := self getNext]!

getCurrent
	| a |
	changed isNil 
		ifFalse: 
			[(a := changed getCurrent) isNil 
				ifFalse: 
					[a valueHolder isRemoved ifTrue: [^nil].
					^a]].
	(dataBaseObject isNil 
		or: [(a := dataBaseObject iterator goToAndGetCurrentAt: currentKey) isNil]) ifTrue: [^nil].
	a := ODBValueHolder createOn: a value.
	[transaction versionDescriptor versionOK: a versionNumber] 
		whileFalse: [a loadPreviousVersionFrom: transaction oldHolders].
	a isRemoved ifTrue: [^nil].
	^ODBBTreeDictionaryAssociation new 
		setTransaction: transaction
		key: (self keyFromBytes: currentKey)
		value: a!

getFirst
	| assoc |
	self basicGoTo: (ByteArray new: keySize).
	(assoc := self getCurrent) isNil ifTrue: [^self getNext].
	^assoc!

getLast
	| assoc |
	self basicGoTo: ((ByteArray new: keySize) atAllPut: 255).
	(assoc := self getCurrent) isNil ifTrue: [^self getPrevious].
	^assoc!

getNext
	| a1 a2 |
	changed isNil 
		ifFalse: 
			[[(a1 := changed peekNext) isNil] whileFalse: 
					[((a2 := self dbPeekNext) notNil and: [a2 < a1]) 
						ifTrue: 
							[changed goTo: (currentKey := a2 key).
							^a2].
					currentKey := a1 key.
					changed goToNext.
					a1 valueHolder isRemoved ifFalse: [^a1]]].
	(a2 := self dbPeekNext) isNil ifTrue: [^nil].
	currentKey := self bytesFromKey: a2 key.
	^a2!

getPrevious
	| a1 a2 |
	changed isNil 
		ifFalse: 
			[[(a1 := changed peekPrevious) isNil] whileFalse: 
					[((a2 := self dbPeekPrevious) notNil and: [a1 < a2]) 
						ifTrue: 
							[changed goTo: (currentKey := a2 key).
							^a2].
					currentKey := a1 key.
					changed goToPrevious.
					a1 valueHolder isRemoved ifFalse: [^a1]]].
	(a2 := self dbPeekPrevious) isNil ifTrue: [^nil].
	currentKey := self bytesFromKey: a2 key.
	^a2!

goTo: aKey 
	self basicGoTo: (self bytesFromKey: aKey)!

includesKey: aKey 
	| value |
	value := self valueAt: (self bytesFromKey: aKey) ifAbsent: [^false].
	^value isRemoved not!

initialize
	"Private - Initialize receiver."

	super initialize.
	keySize := 32!

isChanged
	"Answer <true> if object has been changed."

	^changed notNil or: [dataBaseObject isNil]!

isEmpty
	^self size = 0!

keyFromBytes: aByteArray 
	^aByteArray!

keyLength
	^keySize!

keys
	"Answer collection of all keys in the dictionary."

	| assoc keysColl |
	keysColl := OrderedCollection new.
	assoc := self getFirst.
	[assoc isNil] whileFalse: 
			[keysColl add: (self keyFromBytes: assoc key).
			assoc := self getNext].
	^keysColl!

keysFrom: key1 to: key2 do: aBlock 
	"Evaluate aBlock for each key in the given key range."

	| toKey assoc |
	toKey := self bytesFromKey: key2.
	self goTo: key1.
	(assoc := self getCurrent) isNil ifTrue: [assoc := self getNext].
	[assoc isNil] whileFalse: 
			[(toKey odbIsLessThan: assoc key) ifTrue: [^self].
			aBlock value: assoc key.
			assoc := self getNext]!

keySize: anInteger 
	"Private - Set the key upon creation size."

	keySize := anInteger.
	(keySize < 300 and: [keySize > 1]) 
		ifFalse: [OmniBase signalError: 'Please choose key size between 2 and 300 bytes']!

newChangedDictionary
	^ODBSortedDictionary new!

objectCommitted
	"Private - Changes have been committed, update object."

	changed := nil!

removeKey: aKey 
	| key value |
	key := self bytesFromKey: aKey.
	value := self valueAt: key ifAbsent: [^nil].
	value isRemoved 
		ifFalse: 
			[value removed.
			changed isNil ifTrue: [changed := self newChangedDictionary].
			changed at: key put: value]!

selectKeysFrom: prefix1 to: prefix2 
	"Select all keys between prefix1 and prefix2."

	| toKey keys |
	keys := OrderedCollection new.
	prefix1 size > keySize ifTrue: [^keys].
	toKey := prefix2 , ((String new: keySize - prefix2 size) atAllPut: 255 asCharacter).
	self 
		keysFrom: prefix1
		to: toKey
		do: [:key | keys add: key].
	^keys!

selectKeysStartingWith: aString 
	"Select all keys that start with aString."

	| toKey keys |
	keys := OrderedCollection new.
	aString size > keySize ifTrue: [^keys].
	toKey := aString , ((String new: keySize - aString size) atAllPut: 255 asCharacter).
	self 
		keysFrom: aString
		to: toKey
		do: [:key | keys add: key].
	^keys!

transactionAssociationsDo: aBlock 
	"Evaluate a block for each association in dictionary.
        New transaction will be created for each key."

	| subTransaction valueHolder versionDescriptor client |
	dataBaseObject isNil ifTrue: [OmniBase signalError: 'Object has not been stored yet'].
	versionDescriptor := transaction versionDescriptor.
	client := transaction client.
	dataBaseObject associationsDo: 
			[:assoc | 
			valueHolder := assoc value.
			[versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved 
				ifFalse: 
					[subTransaction := client newTransactionFrom: transaction.
					aBlock value: subTransaction
						value: (Association key: assoc key
								value: (subTransaction referenceAt: valueHolder objectID)).
					subTransaction abort]]!

transactionDo: aBlock 
	"Evaluate a block for every object in dictionary.
        New transaction will be created for each key+value pair."

	| subTransaction client versionDescriptor |
	dataBaseObject isNil ifTrue: [OmniBase signalError: 'Object has not been stored yet'].
	versionDescriptor := transaction versionDescriptor.
	client := transaction client.
	dataBaseObject valuesDo: 
			[:valueHolder | 
			[versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved 
				ifFalse: 
					[subTransaction := client newTransaction.
					"take new version descriptor"
					versionDescriptor := subTransaction versionDescriptor.
					aBlock value: subTransaction value: (subTransaction objectAt: valueHolder objectID).
					subTransaction abort]]!

transactionReadOnlyDo: aBlock 
	"Evaluate a block for every object in dictionary.
	New transaction will be created for each key+value pair."

	| subTransaction versionDescriptor client |
	dataBaseObject isNil ifTrue: [OmniBase signalError: 'Object has not been stored yet'].
	versionDescriptor := transaction versionDescriptor.
	client := transaction client.
	dataBaseObject valuesDo: 
			[:valueHolder | 
			[versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved 
				ifFalse: 
					[subTransaction := client newTransactionFrom: transaction.
					aBlock value: subTransaction value: (subTransaction objectAt: valueHolder objectID).
					subTransaction abort]]!

transactionValueBlocksDo: aBlock 
	"Evaluate a block for every 100 objects in dictionary.
        New transaction is created each time aBlock is evaluated."

	| subTransaction objects count client versionDescriptor |
	dataBaseObject isNil ifTrue: [OmniBase signalError: 'Object has not been stored yet'].
	client := transaction client.
	count := 0.
	objects := OrderedCollection new: 40.
	subTransaction := client newTransaction.
	"take new version descriptor"
	versionDescriptor := subTransaction versionDescriptor.
	
	[dataBaseObject valuesDo: 
			[:valueHolder | 
			[versionDescriptor versionOK: valueHolder versionNumber] 
				whileFalse: [valueHolder loadPreviousVersionFrom: transaction oldHolders].
			valueHolder isRemoved 
				ifFalse: 
					[objects add: (subTransaction objectAt: valueHolder objectID).
					(count := count + 1) == 40 
						ifTrue: 
							[aBlock value: subTransaction value: objects.
							subTransaction abort.
							count := 0.
							objects := OrderedCollection new: 40.
							subTransaction := client newTransaction.
							"take new version descriptor"
							versionDescriptor := subTransaction versionDescriptor]]].
	count > 0 ifTrue: [aBlock value: subTransaction value: objects]] 
			ensure: [subTransaction abort]!

valueAt: key 
	"Private - Answer persistent object value at key  with right version loaded."

	^self valueAt: key ifAbsent: [ODBValueHolder new]!

valueAt: aKey ifAbsent: aBlock 
	"Private - Answer correct version of value holder at aKey, evaluate aBlock if absent."

	| value |
	changed isNil 
		ifFalse: 
			[value := changed at: aKey.
			value isNil ifFalse: [^value]].
	dataBaseObject isNil ifTrue: [^aBlock value].
	(value := dataBaseObject iterator goToAndGetCurrentAt: aKey) isNil 
		ifTrue: [^aBlock value].
	value := ODBValueHolder createOn: value value.
	[transaction versionDescriptor versionOK: value versionNumber] 
		whileFalse: [value loadPreviousVersionFrom: transaction oldHolders].
	^value!

values
	"Answer collection of all objects in the dictionary.
	NOTE: All objects will be loaded in one transaction at once.
	Do not use this method if there are a lot of objects in the dictionary since this could block your image for some time."

	| coll assoc |
	coll := OrderedCollection new.
	assoc := self getFirst.
	[assoc isNil] whileFalse: 
			[coll add: assoc value.
			assoc := self getNext].
	^coll! !
!ODBBTreeIndexDictionary categoriesFor: #at:!public! !
!ODBBTreeIndexDictionary categoriesFor: #at:ifAbsent:!public! !
!ODBBTreeIndexDictionary categoriesFor: #at:ifAbsentPut:!public! !
!ODBBTreeIndexDictionary categoriesFor: #at:put:!public! !
!ODBBTreeIndexDictionary categoriesFor: #basicGoTo:!private! !
!ODBBTreeIndexDictionary categoriesFor: #bytesFromKey:!private! !
!ODBBTreeIndexDictionary categoriesFor: #commit:!private! !
!ODBBTreeIndexDictionary categoriesFor: #commitChanged!private! !
!ODBBTreeIndexDictionary categoriesFor: #commitNew!private! !
!ODBBTreeIndexDictionary categoriesFor: #databaseObjectClass!private! !
!ODBBTreeIndexDictionary categoriesFor: #dbPeekNext!private! !
!ODBBTreeIndexDictionary categoriesFor: #dbPeekPrevious!private! !
!ODBBTreeIndexDictionary categoriesFor: #do:!public! !
!ODBBTreeIndexDictionary categoriesFor: #forKeysStartingWith:do:!public! !
!ODBBTreeIndexDictionary categoriesFor: #getCurrent!enumerating!public! !
!ODBBTreeIndexDictionary categoriesFor: #getFirst!enumerating!public! !
!ODBBTreeIndexDictionary categoriesFor: #getLast!enumerating!public! !
!ODBBTreeIndexDictionary categoriesFor: #getNext!enumerating!public! !
!ODBBTreeIndexDictionary categoriesFor: #getPrevious!enumerating!public! !
!ODBBTreeIndexDictionary categoriesFor: #goTo:!enumerating!public! !
!ODBBTreeIndexDictionary categoriesFor: #includesKey:!public! !
!ODBBTreeIndexDictionary categoriesFor: #initialize!private! !
!ODBBTreeIndexDictionary categoriesFor: #isChanged!public! !
!ODBBTreeIndexDictionary categoriesFor: #isEmpty!public! !
!ODBBTreeIndexDictionary categoriesFor: #keyFromBytes:!private! !
!ODBBTreeIndexDictionary categoriesFor: #keyLength!public! !
!ODBBTreeIndexDictionary categoriesFor: #keys!public! !
!ODBBTreeIndexDictionary categoriesFor: #keysFrom:to:do:!public! !
!ODBBTreeIndexDictionary categoriesFor: #keySize:!private! !
!ODBBTreeIndexDictionary categoriesFor: #newChangedDictionary!private! !
!ODBBTreeIndexDictionary categoriesFor: #objectCommitted!private! !
!ODBBTreeIndexDictionary categoriesFor: #removeKey:!public! !
!ODBBTreeIndexDictionary categoriesFor: #selectKeysFrom:to:!public! !
!ODBBTreeIndexDictionary categoriesFor: #selectKeysStartingWith:!public! !
!ODBBTreeIndexDictionary categoriesFor: #transactionAssociationsDo:!public! !
!ODBBTreeIndexDictionary categoriesFor: #transactionDo:!public! !
!ODBBTreeIndexDictionary categoriesFor: #transactionReadOnlyDo:!public! !
!ODBBTreeIndexDictionary categoriesFor: #transactionValueBlocksDo:!public! !
!ODBBTreeIndexDictionary categoriesFor: #valueAt:!private! !
!ODBBTreeIndexDictionary categoriesFor: #valueAt:ifAbsent:!private! !
!ODBBTreeIndexDictionary categoriesFor: #values!public! !

!ODBBTreeIndexDictionary class methodsFor!

createWithKeyLength: keyLength 
	"Answer new instance of dictionary with max keyLength characters for keys."

	^self new keySize: keyLength! !
!ODBBTreeIndexDictionary class categoriesFor: #createWithKeyLength:!public! !

