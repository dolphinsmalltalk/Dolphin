"Filed out from Dolphin Smalltalk 7"!

ODBTransaction subclass: #ODBLocalTransaction
	instanceVariableNames: 'changesPackage inconsistent newObjects application'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBLocalTransaction guid: (GUID fromString: '{8162ee2b-0fb8-11d4-b091-000000000000}')!
ODBLocalTransaction comment: ''!
!ODBLocalTransaction categoriesForClass!No category! !
!ODBLocalTransaction methodsFor!

addLock: aLock 
	"Private - Add aLock to receiver."

	locks add: aLock!

addLoggedLock: aLock 
	"Private - Add aLock to receiver and store it to transaction file."

	locks add: aLock.
	transactionFile lockAdd: aLock!

application
	^application!

application: anObject 
	"Set application object for the transaction.
	This is just a value holder that can be used by the end user.
	Setting application has no effect in OmniBase."

	application := anObject!

becomeInconsistent
	"Mark that transaction changes are inconsistent. 
	If transaction is inconsistent, it can not be committed!! "

	inconsistent := true!

changesPackage
	^changesPackage!

checkpoint
	"Checkpoint transaction i.e. write all persistent objects that are marked as dirty or new into database.
	Only changes are written into the database. This is an atomic operation which will either complete successfully
	or fail completely with no changes whatsoever written into the database. After writing changes all locks on already
	existing object will still be set. Objects that were new, had no locks set and are thus not locked. Transaction can
	be checkpointed more than once. As seen below the whole process of writing changes into the database (files)
	is executed using a semaphore therefore only one transaction per database session can write its changes at a time."

	self isInconsistent ifTrue: [OmniBase signalError: 'Transaction is inconsistent'].
	transactionManager critical: 
			[[self prepare] ifCurtailed: 
					[self becomeInconsistent.
					transactionManager transactionCommitEnd: self].
			[changesPackage commit] ifCurtailed: 
					[self
						becomeInconsistent;
						basicAbort]].
	self committed!

commit
	self
		checkpoint;
		abort!

committed
	"Private - Transaction has just been committed."

	"End of transaction"

	transactionFile recovery: nil.
	transactionManager transactionCommitEnd: self.
	"Update transaction objects"
	changesPackage committed.
	changesPackage := nil!

initialize
	"Private - Initialize receiver."

	super initialize.
	newObjects := Array new: 16!

isChanged
	"Answer true if changes were made to objects in this transaction."

	objectIndex do: [:transactionObject | transactionObject isChanged ifTrue: [^true]].
	^false!

isInconsistent
	"Answer true if transaction changes are inconsistent. 
	If transaction is inconsistent, it can not be committed."

	^inconsistent == true!

lock: anObject 
	"Lock anObject."

	| transactionObject |
	transactionObject := self getTransactionObject: anObject ifAbsent: [^true].
	transactionObject objectID index == 0 ifTrue: [^true].
	^transactionObject lock!

lockID
	"Private - Answer unique lock ID. Create transaction 
	file, if no locks have been set before. Answer <nil> 
	if database is globally locked by another user and no 
	locks can currently be set."

	locks isNil 
		ifTrue: 
			[(transactionFile := client newTransactionFileFor: self) isNil ifTrue: [^nil].
			locks := OrderedCollection new].
	^transactionFile transactionID!

makePersistent: anObject 
	^self makePersistent: anObject in: dbConnection objectManager defaultContainer!

makePersistent: anObject in: aContainerOrContainerName 
	"Store anObject into specified container if it is not stored yet, else do nothing.
	Answer anObject."

	| container |
	anObject odbObjectID isNil ifFalse: [^anObject].
	self getTransactionObject: anObject
		ifAbsent: 
			[aContainerOrContainerName class == ODBContainer 
				ifFalse: 
					[container := dbConnection objectManager containerNamed: aContainerOrContainerName
								ifAbsent: [OmniBase signalError: 'Container does not exist']]
				ifTrue: [container := aContainerOrContainerName].
			self storeNewObject: anObject inContainer: container].
	^anObject!

markDirty: anObject 
	"Mark anObject as dirty so that it will be written to the 
	database when message #commit is sent.
	Note: if an object is not loaded yet i.e. the message #markDirty is sent to an unresolved ODBReference the object will not be marked as dirty.
	Therefore send #markDirty after you've loaded and changed the object, not before, else use #odbResolve before sending #markDirty."

	| objectToStore transactionObject |
	cacheMutex isNil 
		ifTrue: 
			["transaction is already aborted"
			OmniBase signalError: 'Transaction is already aborted.'].
	(objectToStore := anObject) odbObjectID isNil 
		ifFalse: 
			[anObject isODBReference ifFalse: [^self].
			anObject odbNotLoaded ifTrue: [^self].
			anObject odbTransaction == self ifFalse: [objectToStore := anObject odbResolve]].
	transactionObject := self getTransactionObject: objectToStore
				ifAbsent: 
					[OmniBase 
						signalError: 'Object is not persistent or is a part of composite persistent object'].
	transactionObject objectID index = 0 ifTrue: [^true].
	transactionObject lock ifFalse: [^self signalLockingConflictAt: anObject].
	transactionObject objectChanged!

peekTransactionObjectAt: objectID 
	"Answer transaction object at objectID but do not cache it in transaction."

	| holder transactionObject |
	(transactionObject := self cachedTransactionObjectAt: objectID) isNil 
		ifFalse: [^transactionObject].
	(holder := dbConnection objectManager holderAt: objectID) == nil 
		ifTrue: [OmniBase signalError: 'Invalid object ID'].
	[versionDescriptor versionOK: holder versionNumber] 
		whileFalse: [holder loadPreviousVersionFrom: self oldHolders].
	transactionObject := holder getObject makeTransactionObject: self.
	^transactionObject objectLoaded!

prepare
	"Private - Prepare for commit."

	| serializer coll holder array index allObjects lastSize notFirstPass |
	allObjects := OmniBase newIdentitySet: objectIndex size.
	notFirstPass := false.
	"send #odbAboutToCommitIn: to every persistent object in cache"
	"if any object stores additional objects do it again for new objects"
	
	[lastSize := objectIndex size.
	objectIndex values do: 
			[:each | 
			(notFirstPass and: [allObjects includes: each]) 
				ifFalse: 
					[each odbAboutToCommitIn: self.
					allObjects add: each]].
	lastSize = objectIndex size] 
			whileFalse: [notFirstPass := true].
	cacheMutex critical: 
			["initialize object ID indexes for new objects & lock & store them"
			1 to: newObjects size
				do: 
					[:i | 
					(coll := newObjects at: i) isNil 
						ifFalse: 
							[array := Array new: coll size.
							index := 0.
							coll do: 
									[:each | 
									index := index + 1.
									holder := each objectHolder.
									array at: index put: holder].
							holder container initHolders: array.
							coll do: [:each | objects at: each objectHolder objectID put: each].
							newObjects at: i put: nil]].
			self lockID isNil ifTrue: [OmniBase signalError: 'Database is globaly locked by another user'].
			"make reference map"
			serializer := ODBSerializer new.
			self transactionReferences 
				do: [:each | serializer addExternalReference: each key objectId: each value].
			objectIndex 
				keysAndValuesDo: [:key :value | serializer addExternalReference: key objectId: value objectID]].
	"get new version number"
	transactionManager transactionCommitBegin: self.
	transactionFile versionNumber: versionDescriptor versionNumber.
	"collect changes on transaction objects"
	changesPackage := ODBChangesPackage new.
	allObjects do: [:transactionObject | transactionObject commit: serializer].
	dbConnection objectManager flushContainers.
	self oldHolders flush.
	transactionFile recovery: changesPackage!

removeCachedObjectID: objectID 
	"Remove transaction object associated with objectID."

	objects isNil ifFalse: [cacheMutex critical: [objects removeKey: objectID]]!

removeLock: aLock 
	"Private - Remove aLock from collection of set locks."

	locks remove: aLock ifAbsent: []!

removeLoggedLock: aODBLock 
	"Private - Remove anODBLock from receiver and remove it from transaction file."

	locks remove: aODBLock ifAbsent: [].
	transactionFile lockRemove: aODBLock!

root: anObject 
	"Set the root object of the database."

	| rootObjectHolder rootOID |
	rootOID := ODBObjectID containerID: 1 index: 1.
	(rootObjectHolder := self objectAt: rootOID) isNil 
		ifTrue: 
			[rootObjectHolder := ODBRootObjectHolder new.
			self store: rootObjectHolder.
			cacheMutex critical: [objects at: rootOID put: rootObjectHolder]].
	rootObjectHolder rootObject: anObject!

signalLockingConflictAt: anObject 
	"Private - anObject could not have been locked. 
	Signal an error."

	| transactionObject |
	transactionObject := self getTransactionObject: anObject
				ifAbsent: [OmniBase signalError: 'Internal locking error'].
	transactionObject objectHolder oldVersion 
		ifTrue: [OmniBase signalObjectAlreadyChangedInAnotherTransactionError]
		ifFalse: [OmniBase signalObjectAlreadyLockedInAnotherTransactionError]!

start
	"Start transaction. Transaction is read-only 
	until no objects are locked."

	transactionManager transactionStart: self!

startFrom: aTransaction 
	"Start transaction.
	Transaction is read-only until no objects are locked.
	Version descriptor from aTransaction is valid at start."

	versionDescriptor := aTransaction versionDescriptor copy!

startInVersion: aVersionDescriptor 
	versionDescriptor := aVersionDescriptor!

store: anObject 
	^self 
		store: anObject
		in: dbConnection objectManager defaultContainer
		ifLocked: [self signalLockingConflictAt: anObject]!

store: anObject ifLocked: aBlock 
	^self 
		store: anObject
		in: dbConnection objectManager defaultContainer
		ifLocked: aBlock!

store: anObject in: aContainerOrContainerName 
	^self 
		store: anObject
		in: aContainerOrContainerName
		ifLocked: [self signalLockingConflictAt: anObject]!

store: anObject in: anODBContainerOrString ifLocked: aBlock 
	"Store anObject into given container anODBContainerOrString which can be either a String (container name) or an ODBContainer.
	Evaluate aBlock if anObject can not be locked."

	| objectToStore transactionObject container |
	(objectToStore := anObject) odbObjectID isNil 
		ifFalse: 
			[anObject isODBReference ifFalse: [^self].
			anObject odbNotLoaded ifTrue: [^self].
			anObject odbTransaction == self ifFalse: [objectToStore := anObject odbResolve]].
	transactionObject := self getTransactionObject: objectToStore
				ifAbsent: 
					[anODBContainerOrString class == ODBContainer 
						ifFalse: 
							[container := dbConnection objectManager containerNamed: anODBContainerOrString
										ifAbsent: [OmniBase signalError: 'Invalid container name']]
						ifTrue: [container := anODBContainerOrString].
					^self storeNewObject: objectToStore inContainer: container].
	"* namesto: (self lock: anObject) ifFalse: [ ^aBlock value ]."
	transactionObject objectID index == 0 ifTrue: [^true].	"*"
	transactionObject lock ifFalse: [^aBlock value].	"*"
	transactionObject objectChanged!

storeNewObject: anObject inContainer: aContainer 
	"Store anObject into specified container."

	| transactionObject holder coll id |
	holder := aContainer newObjectHolder.
	anObject isODBTransactionObject 
		ifFalse: [transactionObject := ODBSerializedObject new value: anObject]
		ifTrue: [transactionObject := anObject].
	transactionObject setObjectHolder: holder transaction: self.
	cacheMutex critical: 
			[(id := aContainer id) > newObjects size 
				ifTrue: 
					[(coll := Array new: id) 
						replaceFrom: 1
						to: newObjects size
						with: newObjects
						startingAt: 1.
					newObjects := coll].
			(coll := newObjects at: id) isNil 
				ifTrue: 
					[coll := OrderedCollection new: 32.
					newObjects at: id put: coll].
			coll add: transactionObject.
			objectIndex at: anObject put: transactionObject].
	transactionObject objectStored!

unlock: anObject 
	"Unlock anObject."

	| transactionObject |
	transactionObject := self getTransactionObject: anObject ifAbsent: [^true].
	transactionObject isChanged ifTrue: [^false].	"Changed objects can not be unlocked."
	^transactionObject unlock! !
!ODBLocalTransaction categoriesFor: #addLock:!private! !
!ODBLocalTransaction categoriesFor: #addLoggedLock:!private! !
!ODBLocalTransaction categoriesFor: #application!public! !
!ODBLocalTransaction categoriesFor: #application:!public! !
!ODBLocalTransaction categoriesFor: #becomeInconsistent!public! !
!ODBLocalTransaction categoriesFor: #changesPackage!private! !
!ODBLocalTransaction categoriesFor: #checkpoint!public! !
!ODBLocalTransaction categoriesFor: #commit!public! !
!ODBLocalTransaction categoriesFor: #committed!private! !
!ODBLocalTransaction categoriesFor: #initialize!private! !
!ODBLocalTransaction categoriesFor: #isChanged!public! !
!ODBLocalTransaction categoriesFor: #isInconsistent!public! !
!ODBLocalTransaction categoriesFor: #lock:!public! !
!ODBLocalTransaction categoriesFor: #lockID!private! !
!ODBLocalTransaction categoriesFor: #makePersistent:!public! !
!ODBLocalTransaction categoriesFor: #makePersistent:in:!public! !
!ODBLocalTransaction categoriesFor: #markDirty:!public! !
!ODBLocalTransaction categoriesFor: #peekTransactionObjectAt:!private! !
!ODBLocalTransaction categoriesFor: #prepare!private! !
!ODBLocalTransaction categoriesFor: #removeCachedObjectID:!private! !
!ODBLocalTransaction categoriesFor: #removeLock:!private! !
!ODBLocalTransaction categoriesFor: #removeLoggedLock:!private! !
!ODBLocalTransaction categoriesFor: #root:!public! !
!ODBLocalTransaction categoriesFor: #signalLockingConflictAt:!private! !
!ODBLocalTransaction categoriesFor: #start!public! !
!ODBLocalTransaction categoriesFor: #startFrom:!public! !
!ODBLocalTransaction categoriesFor: #startInVersion:!public! !
!ODBLocalTransaction categoriesFor: #store:!public! !
!ODBLocalTransaction categoriesFor: #store:ifLocked:!public! !
!ODBLocalTransaction categoriesFor: #store:in:!public! !
!ODBLocalTransaction categoriesFor: #store:in:ifLocked:!public! !
!ODBLocalTransaction categoriesFor: #storeNewObject:inContainer:!private! !
!ODBLocalTransaction categoriesFor: #unlock:!public! !

