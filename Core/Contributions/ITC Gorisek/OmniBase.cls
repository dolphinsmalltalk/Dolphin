"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #OmniBase
	instanceVariableNames: 'rootDir objectManager classManager clientManager transactionManager'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: 'sessions currentTransaction processToTransactionDict processToTransactionMutex'!
OmniBase guid: (GUID fromString: '{8162EDEB-0FB8-11D4-B091-000000000000}')!
OmniBase comment: ''!
!OmniBase categoriesForClass!No category! !
!OmniBase methodsFor!

classManager
	^classManager!

clientManager
	^clientManager!

close
	clientManager notNil 
		ifTrue: 
			[clientManager close.
			clientManager := nil].
	classManager notNil 
		ifTrue: 
			[classManager close.
			classManager := nil].
	objectManager notNil 
		ifTrue: 
			[objectManager close.
			objectManager := nil].
	transactionManager notNil 
		ifTrue: 
			[transactionManager close.
			transactionManager := nil].
	self class remove: self!

compactContainerNamed: containerName 
	"Reorganize container object storage file.
	This will do the following:
		- compact all container files and remove old object versions
		- reorganize all b-trees
	"

	(ODBGarbageCollector new)
		openOn: self;
		reorganizeDictionaries: true;
		reorganizeIndexSets: true;
		compactContainerNamed: containerName silentMode: false!

createBackupOn: newDirectoryName 
	"Starts an on-line backup process and creates a backup copy
	of the receiver database.
	The database will be copied based on the current version of the data.
	The copy of the database will have its containers compacted with no old versions.
	The version counter will be reset to zero and b-trees will be reorganized to be up to 1 node full."

	OmniBaseArchiver new onlineBackup: self to: newDirectoryName!

createOn: dirName 
	"Create new database. If a database already exists signal error."

	
	[rootDir := dirName.
	(ODBFileStream directoryExists: rootDir) 
		ifFalse: [ODBFileStream directoryCreate: rootDir].
	classManager := ODBClassManager new createOn: self.
	objectManager := ODBObjectManager new createOn: self.
	transactionManager := ODBTransactionManager new createOn: self.
	clientManager := ODBClientManager new createOn: self.
	self opened.
	clientManager localClient makeRootObject] 
			ifCurtailed: [self close]!

dirName
	^rootDir!

existsContainerNamed: aString 
	"Answer <true> if container named aString exists."

	objectManager containerNamed: aString ifAbsent: [^false].
	^true!

freeDiskSpace
	^(DiskVolumeInformation forPath: rootDir) totalFreeBytes!

garbageCollect
	"Garbage collect the database.
	This will do the following:
		- remove all objects which are not referenced from the database root
		- compact all container files and remove old object versions
	B-tree dictionaries will not be compacted."

	(ODBGarbageCollector new)
		reorganizeDictionaries: false;
		reorganizeIndexSets: false;
		runOn: self!

globalLock
	"Lock database so that only one user can change objects in
	it. No locks will be made to objects stored in the database
	files while the database is globaly locked. Answer <true>
	if successfull or <false> if failed. Global write lock will
	fail if there are read-write transactions already running."

	clientManager removeDisconnectedClients.
	^clientManager localClient globalLock!

globalUnlock
	"Release global write lock set by the local client."

	^clientManager localClient globalUnlock!

initialize
	ODBDatabaseObject initialize!

isGlobalLocked
	^self localClient isGlobalLocked!

localClient
	^clientManager localClient!

newBTreeDictionary: keySize 
	^self class newBTreeDictionary: keySize!

newBTreeIdentityDictionary
	"Factory method - create a new instance of a persistent B-tree identity dictionary.
	This kind of persistent dictionary is using a file system b-tree below to store dictionary associations for quick access.
	A b-tree persistent identity dictionary can store only persistent objects or nil as keys and persistent objects or nil as value."

	^self class newBTreeIdentityDictionary!

newBTreeIndexDictionary: keySize 
	^self class newBTreeIndexDictionary: keySize!

newContainer: aString 
	"Create new container named aString."

	^objectManager containerNew: aString!

newLongReadOnlyTransaction
	"Answer new long read-only transaction. Read only transactions
	are here only to prevent user code from writing into the database.
	Read-only transaction are not meant to improve concurrency since
	multi-version concurrency control is used in OmniBase and therefore
	all transactions run as read-only transactions up to the point when the
	first object is locked.

	Long transactions allow database restart without disrupting proxy objects."

	^clientManager localClient newLongReadOnlyTransaction!

newPersistentDictionary
	^self class newPersistentDictionary!

newReadOnlyTransaction
	"Answer new read-only transaction. Read only transactions
	are here only to prevent user code from writing into the database.
	Read-only transaction are not meant to improve concurrency since
	multi-version concurrency control is used in OmniBase and therefore
	all transactions run as read-only transactions up to the point when the
	first object is locked."

	^clientManager localClient newReadOnlyTransaction!

newTransaction
	^clientManager localClient newTransaction!

numberOfClients
	"Answer total number of client connections currently working with database.
	(this will answer how many times a database on a given directory has been opened)"

	| clients count |
	count := 0.
	clients := clientManager
				removeDisconnectedClients;
				clients.
	clients do: [:eachClient | eachClient isTerminated ifFalse: [count := count + 1]].
	clientManager closeForeignClients.
	^count!

objectManager
	^objectManager!

odbObjectID
	"Private - answer an object ID of the database connection instance.
	This is used when a persistent object is referencing current database connection.
	When deserialized it will set reference to the current database connection."

	^ODBObjectID containerID: 0 index: 4!

opened
	"Private - Receiver has just been opened."

	self class add: self.
	
	[clientManager
		removeDisconnectedClients;
		closeForeignClients] on: Error
			do: [:er | #odbTODO]!

openOn: dirName 
	"Open an already existing database environment. 
	Trigger an exception if failed."

	
	[rootDir := dirName.
	classManager := ODBClassManager new openOn: self.
	objectManager := ODBObjectManager new openOn: self.
	transactionManager := ODBTransactionManager new openOn: self.
	clientManager := ODBClientManager new openOn: self.
	self opened] 
			ifCurtailed: [self close].
	self freeDiskSpace < 5242880 ifTrue: [OmniBase warningMessage: 'Low disk space !!']!

reorganize
	"Reorganize database files.
	This will do the following:
		- remove all objects which are not referenced from the database root
		- compact all container files and remove old object versions
		- compact b-tree index files"

	(ODBGarbageCollector new)
		reorganizeDictionaries: true;
		reorganizeIndexSets: true;
		runOn: self!

setUserDescription: aString 
	"Set user description.
	This string can be read by other database connections to identify who has opened a database."

	self localClient description: aString!

transactionManager
	^transactionManager! !
!OmniBase categoriesFor: #classManager!private! !
!OmniBase categoriesFor: #clientManager!private! !
!OmniBase categoriesFor: #close!public! !
!OmniBase categoriesFor: #compactContainerNamed:!public! !
!OmniBase categoriesFor: #createBackupOn:!public! !
!OmniBase categoriesFor: #createOn:!public! !
!OmniBase categoriesFor: #dirName!private! !
!OmniBase categoriesFor: #existsContainerNamed:!public! !
!OmniBase categoriesFor: #freeDiskSpace!public! !
!OmniBase categoriesFor: #garbageCollect!public! !
!OmniBase categoriesFor: #globalLock!public! !
!OmniBase categoriesFor: #globalUnlock!public! !
!OmniBase categoriesFor: #initialize!private! !
!OmniBase categoriesFor: #isGlobalLocked!public! !
!OmniBase categoriesFor: #localClient!public! !
!OmniBase categoriesFor: #newBTreeDictionary:!public! !
!OmniBase categoriesFor: #newBTreeIdentityDictionary!public! !
!OmniBase categoriesFor: #newBTreeIndexDictionary:!public! !
!OmniBase categoriesFor: #newContainer:!public! !
!OmniBase categoriesFor: #newLongReadOnlyTransaction!public! !
!OmniBase categoriesFor: #newPersistentDictionary!public! !
!OmniBase categoriesFor: #newReadOnlyTransaction!public! !
!OmniBase categoriesFor: #newTransaction!public! !
!OmniBase categoriesFor: #numberOfClients!public! !
!OmniBase categoriesFor: #objectManager!private! !
!OmniBase categoriesFor: #odbObjectID!private! !
!OmniBase categoriesFor: #opened!private! !
!OmniBase categoriesFor: #openOn:!public! !
!OmniBase categoriesFor: #reorganize!public! !
!OmniBase categoriesFor: #setUserDescription:!public! !
!OmniBase categoriesFor: #transactionManager!private! !

!OmniBase class methodsFor!

add: anOmniBase 
	"Private - Registers an opened database session."

	sessions isNil ifTrue: [sessions := OrderedCollection new].
	sessions add: anOmniBase!

allSessions
	"Answers a collection of all opened database sessions."

	^sessions!

checkpoint
	"Commit all changes in persistent objects to the database
	and leave all locks set. Current transaction can still be used
	to change more objects."

	self currentTransaction checkpoint!

closeAll
	"Closes all opened database sessions. Do not use this method if you're using
	the Source Tracking System for development since it will also close its connection
	to the source code repository."

	sessions isNil ifTrue: [^false].
	sessions copy 
		do: [:each | [each close] on: Error do: [:er | sessions remove: each ifAbsent: []]]!

commit
	"Commit all changes in persistent objects to the database
	and release all locks. Current transaction can not be used
	anymore."

	self currentTransaction commit!

confirmationMessage: aString 
	^MessageBox confirm: aString!

createOn: dirName 
	"Creates new database on a given directory pathname."

	^self new createOn: dirName!

current
	"Answers the database session of the current active transaction."

	^self currentTransaction environment!

currentTransaction
	| transaction |
	transaction := currentTransaction.
	processToTransactionMutex critical: 
			[transaction := processToTransactionDict at: Processor activeProcess
						ifAbsent: [transaction]].
	transaction isNil ifFalse: [^transaction].
	self signalError: 'No transaction is active'!

currentTransaction: anODBLocalTransaction 
	currentTransaction := anODBLocalTransaction!

currentTransactionOrNil
	| transaction |
	transaction := currentTransaction.
	processToTransactionMutex critical: 
			[transaction := processToTransactionDict at: Processor activeProcess
						ifAbsent: [transaction]].
	^transaction!

getCurrentAndSet: anOmniBaseTransaction for: aProcess 
	"Private - Associaties anOmniBaseTransaction with aProcess.
	Answer previous active transaction in case transactions are nested."

	| previousTxn |
	processToTransactionMutex critical: 
			[previousTxn := processToTransactionDict at: aProcess ifAbsent: [].
			processToTransactionDict at: aProcess put: anOmniBaseTransaction].
	^previousTxn!

initialize
	processToTransactionMutex isNil 
		ifTrue: 
			[processToTransactionDict := IdentityDictionary new.
			processToTransactionMutex := Semaphore forMutualExclusion]!

logWarning: aString 
	(Transcript isNil or: [aString isNil]) 
		ifFalse: 
			[Transcript
				nextPutAll: aString;
				cr]!

new
	self initialize.
	^super new initialize!

newBTreeDictionary: keySize 
	"Factory method - create a new instance of a persistent B-tree dictionary.
	This kind of persistent dictionary is using a file system b-tree below to store dictionary associations for quick access.
	A b-tree persistent dictionary can store any object that implements #asBtreeKeyOfSize: as key, and any persistent object as its value."

	^ODBBTreeDictionary createWithKeyLength: keySize!

newBTreeIdentityDictionary
	"Factory method - create a new instance of a persistent B-tree identity dictionary.
	This kind of persistent dictionary is using a file system b-tree below to store dictionary associations for quick access.
	A b-tree persistent identity dictionary can store only persistent objects or nil as keys and persistent objects or nil as value."

	^ODBBTreeIdentityDictionary new!

newBTreeIndexDictionary: keySize 
	^ODBBTreeIndexDictionary createWithKeyLength: keySize!

newFastIdentityDictionary: initialSize 
	^ODBIdentityDictionary new: initialSize!

newIdentitySet: initialSize 
	^IdentitySet new: initialSize!

newPersistentDictionary
	"Create new persistent dictionary. All dictionary keys will be 
	stored together with the dictionary if not already persistent. All
	dictionary values will be stored separately and will be made
	persistent each with its own object ID."

	| dict |
	dict := ODBPersistentDictionary new.
	self currentTransactionOrNil notNil ifTrue: [dict makePersistent].
	^dict!

objectAt: anODBObjectID 
	"Answer a persistent object with a given object id. The object will be fetched right away 
	without instantiating a proxy object first. Answer <nil> if object id is nonexistent i.e. 
	there is no persistent object with such oid."

	^self currentTransaction objectAt: anODBObjectID!

openOn: dirName 
	^self new openOn: dirName!

remove: anOmniBase 
	"Private - Deregisters an opened database session."

	sessions isNil ifTrue: [^self].
	sessions remove: anOmniBase ifAbsent: []!

removeFor: aProcess 
	"Private - Disassociaties a transaction from aProcess."

	processToTransactionMutex 
		critical: [processToTransactionDict removeKey: aProcess ifAbsent: []]!

rollback
	"Release all locks set in the current transaction and forget 
	all changes done on persistent objects."

	self currentTransaction abort!

root
	"Answer the database root object. Root object represents an entry point into the database.
	Only objects referenced from the root object will remain after the garbage collection is 
	performed on the database. By default the root object is a dictionary with persistent objects
	as its values. This can be changed if needed using message #root: on transaction."

	^self currentTransaction root!

setTransaction: aTransaction for: aProcess 
	"Private - Associaties a transaction to aProcess."

	processToTransactionMutex 
		critical: [processToTransactionDict at: aProcess put: aTransaction]!

signalCannotLockBTreeDictionaryKey
	^ODBCannotLockKey signal!

signalCannotSetFileLockError
	^ODBCannotLock signal!

signalError: errorMessage 
	ODBError signal: errorMessage!

signalFileLockWaitNotification
	^ODBLockNotification signal!

signalObjectAlreadyChangedInAnotherTransactionError
	^ODBCannotLockObject signal: 'Object has already been changed in another transaction'!

signalObjectAlreadyLockedInAnotherTransactionError
	^ODBCannotLockObject signal: 'Object is already locked in another transaction'!

warningMessage: aString 
	MessageBox warning: aString caption: 'OmniBase warning'! !
!OmniBase class categoriesFor: #add:!private! !
!OmniBase class categoriesFor: #allSessions!public! !
!OmniBase class categoriesFor: #checkpoint!public! !
!OmniBase class categoriesFor: #closeAll!public! !
!OmniBase class categoriesFor: #commit!public! !
!OmniBase class categoriesFor: #confirmationMessage:!public! !
!OmniBase class categoriesFor: #createOn:!public! !
!OmniBase class categoriesFor: #current!public! !
!OmniBase class categoriesFor: #currentTransaction!public! !
!OmniBase class categoriesFor: #currentTransaction:!public! !
!OmniBase class categoriesFor: #currentTransactionOrNil!public!transaction management! !
!OmniBase class categoriesFor: #getCurrentAndSet:for:!handling!private! !
!OmniBase class categoriesFor: #initialize!public! !
!OmniBase class categoriesFor: #logWarning:!public! !
!OmniBase class categoriesFor: #new!private! !
!OmniBase class categoriesFor: #newBTreeDictionary:!public! !
!OmniBase class categoriesFor: #newBTreeIdentityDictionary!public! !
!OmniBase class categoriesFor: #newBTreeIndexDictionary:!public! !
!OmniBase class categoriesFor: #newFastIdentityDictionary:!creating!public! !
!OmniBase class categoriesFor: #newIdentitySet:!creating!public! !
!OmniBase class categoriesFor: #newPersistentDictionary!creating!public! !
!OmniBase class categoriesFor: #objectAt:!public! !
!OmniBase class categoriesFor: #openOn:!public! !
!OmniBase class categoriesFor: #remove:!private! !
!OmniBase class categoriesFor: #removeFor:!handling!private! !
!OmniBase class categoriesFor: #rollback!public! !
!OmniBase class categoriesFor: #root!public! !
!OmniBase class categoriesFor: #setTransaction:for:!handling!private! !
!OmniBase class categoriesFor: #signalCannotLockBTreeDictionaryKey!exceptions!private! !
!OmniBase class categoriesFor: #signalCannotSetFileLockError!exceptions!private! !
!OmniBase class categoriesFor: #signalError:!exceptions!private! !
!OmniBase class categoriesFor: #signalFileLockWaitNotification!exceptions!private! !
!OmniBase class categoriesFor: #signalObjectAlreadyChangedInAnotherTransactionError!exceptions!private! !
!OmniBase class categoriesFor: #signalObjectAlreadyLockedInAnotherTransactionError!exceptions!private! !
!OmniBase class categoriesFor: #warningMessage:!public! !

