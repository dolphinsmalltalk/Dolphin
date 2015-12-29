"Filed out from Dolphin Smalltalk X6.2"!

ODBBTreeIndexDictionary subclass: #ODBBTreeDictionary
	instanceVariableNames: 'locks initialSize deltaSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBBTreeDictionary guid: (GUID fromString: '{8162EE31-0FB8-11D4-B091-000000000000}')!
ODBBTreeDictionary comment: ''!
!ODBBTreeDictionary categoriesForClass!No category! !
!ODBBTreeDictionary methodsFor!

addKey: key value: anObject 
	"Private - Add association to dictionary of changed associations."

	| value |
	(value := self valueAt: key) isRemoved 
		ifTrue: [deltaSize := deltaSize + 1]
		ifFalse: 
			[transaction isNil 
				ifFalse: 
					["ce je objekt identicen ga ne shranjuj znova"
					(transaction getObjectIDOrNil: anObject) = value objectID ifTrue: [^anObject]]].
	value object: anObject.
	changed isNil ifTrue: [changed := self newChangedDictionary].
	changed at: key put: value.
	^anObject!

at: aKey put: anObject 
	"Associate aKey with anObject.
	aKey can be any object which implements method #asBtreeKeyOfSize:
	Trigger an exception if aKey has already been locked or changed in a concurrently running transaction."

	^self 
		at: aKey
		put: anObject
		ifLocked: [OmniBase signalCannotLockBTreeDictionaryKey]!

at: aKey put: anObject ifLocked: aBlock 
	"Associate aKey with anObject.
	Evaluate aBlock if aKey has been locked before in some other transaction."

	| key |
	key := self bytesFromKey: aKey.
	(self basicLockKey: key) ifFalse: [^aBlock value].
	transaction isNil ifFalse: [transaction makePersistent: anObject in: holder container].
	^self addKey: key value: anObject!

basicLockKey: key 
	"Private - Lock key so that other transactions wont be able
	to change it. Answer <true> if successfull."

	| lock lockID value |
	dataBaseObject isNil ifTrue: [^true].
	(lockID := transaction lockID) isNil ifTrue: [^false].
	transaction isGlobalLocked ifTrue: [^true].
	locks isNil 
		ifTrue: [locks := LookupTable new]
		ifFalse: [(locks includesKey: key) ifTrue: [^true]].
	lock := (ODBKeyLock new)
				objectID: holder objectID;
				lockID: lockID;
				key: key.
	value := self valueAt: key.
	dataBaseObject iterator critical: 
			[transaction addLoggedLock: lock.
			((dataBaseObject iterator)
				goTo: key;
				lockCurrentValue: value contents with: lockID) 
					ifFalse: 
						[transaction removeLoggedLock: lock.
						^false]].
	locks at: key put: lock.
	^true!

commitChanged
	"Private - Commit changes on an already existing dictionary."

	| changesPackage newValue vn oldHolders |
	changesPackage := transaction changesPackage.
	changesPackage add: (ODBDictionaryChanged new transactionObject: self).
	deltaSize = 0 
		ifFalse: 
			[changesPackage add: ((ODBSizeChanged new)
						setObjectID: holder objectID transactionObject: self;
						deltaSize: deltaSize)].
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
	newDBObject iterator 
		updateSizeAt: vn
		oldHolders: nil
		deltaSize: deltaSize.
	(transaction changesPackage)
		add: ((ODBNewObjectVersion new)
					setObjectID: holder objectID transactionObject: self;
					oldVersion: holder;
					newVersion: newHolder);
		add: ((ODBDictionaryChanged new)
					transactionObject: self;
					dataBaseObject: newDBObject)!

databaseObjectClass
	^ODBDBBTreeDictionary!

initialize
	"Private - Initialize receiver."

	super initialize.
	initialSize := 0.
	deltaSize := 0!

isKeyLocked: aKey 
	"Answer <true> if aKey is locked."

	| key result |
	dataBaseObject isNil ifTrue: [^false].
	transaction isGlobalLocked ifTrue: [^false].
	key := self bytesFromKey: aKey.
	dataBaseObject iterator critical: 
			[result := (locks notNil and: [locks includesKey: key]) or: 
							[(dataBaseObject iterator)
								goTo: key;
								isLocked]].
	^result!

lockKey: aKey 
	"Lock key aKey so that other transactions wont be able
	to change it. Answer <true> if successfull."

	^self basicLockKey: (self bytesFromKey: aKey)!

objectCommitted
	"Changes have been committed, update object."

	changed := nil.
	initialSize := initialSize + deltaSize.
	deltaSize := 0!

objectLoaded
	"Sent to transaction object when it is loaded into transaction."

	initialSize := dataBaseObject iterator getSizeAt: transaction versionDescriptor
				oldHolders: transaction oldHolders!

objectStored
	"Sent to transaction object when it is stored for the first time."

	| container |
	changed notNil 
		ifTrue: 
			[container := holder container.
			changed do: 
					[:eachValue | 
					eachValue isRemoved ifFalse: [transaction makePersistent: eachValue object in: container]]]!

removeKey: aKey 
	^self removeKey: aKey ifLocked: [OmniBase signalCannotLockBTreeDictionaryKey]!

removeKey: aKey ifLocked: aBlock 
	| key value |
	key := self bytesFromKey: aKey.
	(self basicLockKey: key) ifFalse: [^aBlock value].
	value := self valueAt: key ifAbsent: [^nil].
	value isRemoved 
		ifFalse: 
			[value removed.
			changed isNil ifTrue: [changed := self newChangedDictionary].
			changed at: key put: value.
			deltaSize := deltaSize - 1]!

size
	"Answer number of keys in receiver.
	(metodo je treba spremeniti, ce so reference na objekte iz 
	transakcije weak -> sizeHolder mora biti iz verzije pred startom transakcije)"

	^initialSize + deltaSize!

unlockKey: aKey 
	"Unlocks key aKey. Answer <true> if successfull."

	| lock key |
	dataBaseObject isNil ifTrue: [^true].
	key := self bytesFromKey: aKey.
	changed isNil ifFalse: [(changed includes: key) ifTrue: [^false]].
	locks isNil ifTrue: [^transaction isGlobalLocked].
	lock := locks at: key ifAbsent: [^false].
	(dataBaseObject unlockKey: key with: lock lockID) ifFalse: [^false].
	transaction removeLoggedLock: lock.
	locks removeKey: key.
	^true! !
!ODBBTreeDictionary categoriesFor: #addKey:value:!private! !
!ODBBTreeDictionary categoriesFor: #at:put:!public! !
!ODBBTreeDictionary categoriesFor: #at:put:ifLocked:!public! !
!ODBBTreeDictionary categoriesFor: #basicLockKey:!private! !
!ODBBTreeDictionary categoriesFor: #commitChanged!private! !
!ODBBTreeDictionary categoriesFor: #commitNew!private! !
!ODBBTreeDictionary categoriesFor: #databaseObjectClass!private! !
!ODBBTreeDictionary categoriesFor: #initialize!private! !
!ODBBTreeDictionary categoriesFor: #isKeyLocked:!public! !
!ODBBTreeDictionary categoriesFor: #lockKey:!public! !
!ODBBTreeDictionary categoriesFor: #objectCommitted!private! !
!ODBBTreeDictionary categoriesFor: #objectLoaded!private! !
!ODBBTreeDictionary categoriesFor: #objectStored!private! !
!ODBBTreeDictionary categoriesFor: #removeKey:!public! !
!ODBBTreeDictionary categoriesFor: #removeKey:ifLocked:!public! !
!ODBBTreeDictionary categoriesFor: #size!public! !
!ODBBTreeDictionary categoriesFor: #unlockKey:!public! !

