"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ODBTransaction
	instanceVariableNames: 'client objects versionDescriptor dbConnection transactionFile objectIndex transactionManager locks cacheMutex'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBTransaction guid: (GUID fromString: '{8162ede5-0fb8-11d4-b091-000000000000}')!
ODBTransaction comment: ''!
!ODBTransaction categoriesForClass!No category! !
!ODBTransaction methodsFor!

abort
	"Abort transaction. After aborting it, it can not be used anymore."

	transactionManager isNil ifFalse: [transactionManager critical: [self basicAbort]]!

basicAbort
	"Private - Abort transaction. After aborting it, it can not be used anymore."

	| changes |
	dbConnection isNil 
		ifFalse: 
			[locks isNil 
				ifFalse: 
					[(changes := transactionFile recovery) isNil 
						ifFalse: 
							[changes
								transaction: self;
								rollback.
							transactionFile recovery: nil].
					locks do: 
							[:each | 
							each
								transaction: self;
								unlock]].
			transactionManager transactionAborted: self.
			client transactionRemove: self].
	objectIndex := nil.
	objects := nil.
	client := nil.
	dbConnection := nil.
	transactionManager := nil.
	cacheMutex isNil 
		ifFalse: 
			[cacheMutex odbTerminateWaitingProcesses.
			cacheMutex := nil]!

cachedObjectAt: objectID 
	"Answer object identified by the given objectID.
	Answer <nil> if the object is not found in the local transaction cache.
	This method will not load the object from the disk drive."

	| transactionObject |
	^(objects isNil 
		or: [(transactionObject := self cachedTransactionObjectAt: objectID) isNil]) 
			ifFalse: [transactionObject value]!

cachedTransactionObjectAt: objectID 
	"Private - Answer cached transaction object at objectID."

	| obj |
	cacheMutex critical: [obj := objects at: objectID].
	^obj!

canReconnectConnectionOnClosedDatabase
	^false!

client
	^client!

environment
	^dbConnection!

getLoadedObjects
	"Answer collection of associations of all objects loaded in current transaction."

	| coll |
	coll := OrderedCollection new.
	objectIndex do: [:each | each objectID containerID > 0 ifTrue: [coll add: each value]].
	^coll!

getObjectID: anObject 
	"Answer <objectID> coresponding to anObject."

	| transactionObject oid |
	anObject odbObjectID isNil ifFalse: [^anObject odbObjectID].
	cacheMutex critical: [transactionObject := objectIndex at: anObject].
	transactionObject isNil 
		ifTrue: 
			[OmniBase 
				signalError: 'Object is not persistent or is contained in another persistent object'].
	(oid := transactionObject objectID) index == 0 
		ifTrue: 
			[OmniBase 
				signalError: 'Object ID is not allocated yet. Object ID will be allocated after transaction checkpoint or commit.'].
	^oid!

getObjectIDOrNil: anObject 
	"Private - Answer <objectID> coresponding to anObject 
        or <nil> if not allready stored."

	| transactionObject oid |
	anObject odbObjectID isNil ifFalse: [^anObject odbObjectID].
	cacheMutex critical: [transactionObject := objectIndex at: anObject].
	^transactionObject isNil 
		ifFalse: [(oid := transactionObject objectID) index == 0 ifFalse: [oid]]!

getTransactionObject: anObject ifAbsent: aBlock 
	"Private - Answer transaction object corresponding to anObject.
	Evaluate aBlock if none."

	| transactionObject |
	anObject isODBReference 
		ifTrue: 
			[anObject odbTransaction == self 
				ifFalse: [OmniBase signalError: 'Reference from another transaction'].
			^anObject odbTransactionObject].
	cacheMutex critical: [transactionObject := objectIndex at: anObject].
	^transactionObject isNil ifTrue: [aBlock value] ifFalse: [transactionObject]!

getVersionNumberOfCurrentObjectVersionFor: anObject 
	"Answer version number of the newest i.e. the current version of anObject in the database.
	This version number can be used if an old version of the whole database has to be recreated (see OmniBaseArchiver)."

	| holder objectID |
	(objectID := self getObjectIDOrNil: anObject) isNil ifTrue: [^nil].
	(holder := dbConnection objectManager holderAt: objectID) isNil ifTrue: [^nil].
	^holder versionNumber!

getVersionNumberOfFirstObjectVersionFor: anObject 
	"Answer version number of the oldest version of anObject in the database.
	This version number can be used if an old version of the whole database has to be recreated (see OmniBaseArchiver)."

	| holder objectID |
	(objectID := self getObjectIDOrNil: anObject) isNil ifTrue: [^nil].
	(holder := dbConnection objectManager holderAt: objectID) isNil ifTrue: [^nil].
	[holder loadPreviousVersionOrNilFrom: self oldHolders] whileTrue: [].
	^holder versionNumber!

initialize
	cacheMutex := Semaphore forMutualExclusion.
	objects := ODBObjectIDDictionary new.
	objectIndex := OmniBase newFastIdentityDictionary: 1000!

isChanged
	"Answer <true> if changes were made to the database."

	^false!

isGlobalLocked
	"Answer <true> if transaction was started in 
	a global locked database session."

	^false!

isReadOnly
	"Answer <true> if this is a read-only transaction."

	^false!

objectAt: objectID 
	"Answer object at objectID, <nil> if it does not exist."

	| transactionObject |
	objects isNil ifTrue: [OmniBase signalError: 'Transaction was already aborted'].
	objectID containerID == 0 ifTrue: [^self transactionReferenceAt: objectID index].
	^(transactionObject := self transactionObjectAt: objectID) isNil 
		ifFalse: [transactionObject value]!

objectHolderAt: objectID 
	"Private - Answer object holder at objectID."

	| trObj |
	^(trObj := self cachedTransactionObjectAt: objectID) isNil 
		ifFalse: [trObj objectHolder]
		ifTrue: [dbConnection objectManager holderAt: objectID]!

odbBasicSerialize: serializer 
	serializer stream putByte: 84!

odbObjectID
	^ODBObjectID containerID: 0 index: 1000!

odbSerialize: serializer 
	serializer stream putByte: 84!

oldHolders
	"Private - Answer file used to store old holder versions."

	^transactionManager oldHolders!

referenceAt: objectID 
	"Private - Answer reference at objectID. If object is already loaded, answer its value."

	| refObj |
	objectID containerID == 0 ifTrue: [^self transactionReferenceAt: objectID index].
	(refObj := self cachedTransactionObjectAt: objectID) isNil ifFalse: [^refObj value].
	refObj := ODBReference new.
	^refObj odbSetLoader: (ODBDemandLoader new 
				setTransaction: self
				objectID: objectID
				proxyObject: refObj)!

root
	"Answer the database root object. Root object represents an entry point into the database.
	Only objects that are being referenced from the root object will remain after the garbage
	collection on the database."

	| rootObjectHolder |
	^(rootObjectHolder := self objectAt: (ODBObjectID containerID: 1 index: 1)) isNil 
		ifFalse: [rootObjectHolder rootObject]!

setClient: aClient environment: anOmniBase 
	client := aClient.
	dbConnection := anOmniBase.
	transactionManager := dbConnection transactionManager!

transactionFile
	^transactionFile!

transactionObjectAt: objectID 
	"Private - Answer transaction object at objectID."

	| holder transactionObject t2 |
	cacheMutex isNil ifTrue: [^ODBExpiredProxyObject on: objectID].
	cacheMutex critical: [transactionObject := objects at: objectID].
	transactionObject isNil ifFalse: [^transactionObject].
	dbConnection objectManager isNil 
		ifTrue: 
			[self canReconnectConnectionOnClosedDatabase 
				ifTrue: 
					["long read only transactions are allowed to go on after database is closed so that proxy objects can still be used after the image is restarted"
					dbConnection := dbConnection class allSessions 
								detect: [:each | each dirName = dbConnection dirName]
								ifNone: [OmniBase openOn: dbConnection dirName]]
				ifFalse: [^ODBExpiredProxyObject on: objectID]].
	(holder := dbConnection objectManager holderAt: objectID) isNil 
		ifTrue: 
			["OID (1:1) = nil"
			^transactionObject := (objectID index = 1 and: [objectID containerID = 1]) 
						ifFalse: [OmniBase signalError: 'Invalid object ID']].
	[versionDescriptor versionOK: holder versionNumber] 
		whileFalse: [holder loadPreviousVersionFrom: self oldHolders].
	[transactionObject := holder getObject makeTransactionObject: self] 
		ifCurtailed: [self becomeInconsistent].
	cacheMutex critical: 
			[(t2 := objects at: objectID) isNil 
				ifTrue: 
					[objects at: objectID put: transactionObject.
					objectIndex at: transactionObject value put: transactionObject]].
	^t2 isNil ifTrue: [transactionObject objectLoaded] ifFalse: [t2]!

transactionReferenceAt: objectIDindex 
	"Private - Answer object at objectID index."

	objectIDindex == 1000 ifTrue: [^self].
	^transactionManager transactionReferenceAt: objectIDindex!

transactionReferences
	"Private - Answer collection of transaction dependent 
	objects and their object IDs (starting with 1000)."

	^(OrderedCollection new: 512)
		add: (Association key: self value: self odbObjectID);
		add: (Association key: dbConnection value: dbConnection odbObjectID);
		yourself!

versionDescriptor
	^versionDescriptor!

versionDescriptor: aVersionDescriptor 
	versionDescriptor := aVersionDescriptor!

versionNumber
	^versionDescriptor versionNumber! !
!ODBTransaction categoriesFor: #abort!public! !
!ODBTransaction categoriesFor: #basicAbort!private! !
!ODBTransaction categoriesFor: #cachedObjectAt:!public! !
!ODBTransaction categoriesFor: #cachedTransactionObjectAt:!private! !
!ODBTransaction categoriesFor: #canReconnectConnectionOnClosedDatabase!private! !
!ODBTransaction categoriesFor: #client!public! !
!ODBTransaction categoriesFor: #environment!public! !
!ODBTransaction categoriesFor: #getLoadedObjects!public! !
!ODBTransaction categoriesFor: #getObjectID:!public! !
!ODBTransaction categoriesFor: #getObjectIDOrNil:!private! !
!ODBTransaction categoriesFor: #getTransactionObject:ifAbsent:!private! !
!ODBTransaction categoriesFor: #getVersionNumberOfCurrentObjectVersionFor:!public! !
!ODBTransaction categoriesFor: #getVersionNumberOfFirstObjectVersionFor:!public! !
!ODBTransaction categoriesFor: #initialize!private! !
!ODBTransaction categoriesFor: #isChanged!public! !
!ODBTransaction categoriesFor: #isGlobalLocked!public! !
!ODBTransaction categoriesFor: #isReadOnly!public! !
!ODBTransaction categoriesFor: #objectAt:!public! !
!ODBTransaction categoriesFor: #objectHolderAt:!private! !
!ODBTransaction categoriesFor: #odbBasicSerialize:!private! !
!ODBTransaction categoriesFor: #odbObjectID!private! !
!ODBTransaction categoriesFor: #odbSerialize:!private! !
!ODBTransaction categoriesFor: #oldHolders!private! !
!ODBTransaction categoriesFor: #referenceAt:!private! !
!ODBTransaction categoriesFor: #root!public! !
!ODBTransaction categoriesFor: #setClient:environment:!private! !
!ODBTransaction categoriesFor: #transactionFile!private! !
!ODBTransaction categoriesFor: #transactionObjectAt:!private! !
!ODBTransaction categoriesFor: #transactionReferenceAt:!private! !
!ODBTransaction categoriesFor: #transactionReferences!private! !
!ODBTransaction categoriesFor: #versionDescriptor!public! !
!ODBTransaction categoriesFor: #versionDescriptor:!private! !
!ODBTransaction categoriesFor: #versionNumber!public! !

!ODBTransaction class methodsFor!

new
	^super new initialize!

odbDeserialize: deserializer 
	^deserializer transaction! !
!ODBTransaction class categoriesFor: #new!private! !
!ODBTransaction class categoriesFor: #odbDeserialize:!private! !

