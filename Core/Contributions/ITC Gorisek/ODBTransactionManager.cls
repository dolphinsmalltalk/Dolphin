"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ODBTransactionManager
	instanceVariableNames: 'dbConnection versionControl oldHolders committingTransaction transactionReferences mutex serializingTransactionsMutex serializingTransactionsSemaphore'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBTransactionManager guid: (GUID fromString: '{8162ede6-0fb8-11d4-b091-000000000000}')!
ODBTransactionManager comment: ''!
!ODBTransactionManager categoriesForClass!No category! !
!ODBTransactionManager methodsFor!

close
	versionControl notNil 
		ifTrue: 
			[versionControl close.
			versionControl := nil].
	oldHolders notNil 
		ifTrue: 
			[oldHolders close.
			oldHolders := nil].
	dbConnection := nil!

createOn: aDatabase 
	self initializeOn: aDatabase.
	
	[versionControl := ODBVersionControlFile createOn: self vcFileName.
	oldHolders := ODBOldHoldersFile createOn: self oldHoldersFileName.
	self initializeReferences] 
			ifCurtailed: [self close]!

critical: aBlock 
	mutex critical: aBlock!

currentVersionDescriptor
	^versionControl versionDescriptor copy!

initializeOn: aDatabase 
	dbConnection := aDatabase.
	mutex := Semaphore forMutualExclusion.
	serializingTransactionsSemaphore := Semaphore new.
	serializingTransactionsSemaphore signal!

initializeReferences
	"Private - Initialize dictionary of transaction references."

	transactionReferences := Array new: 4.
	transactionReferences
		at: 1 put: nil;
		at: 2 put: true;
		at: 3 put: false;
		at: 4 put: dbConnection!

oldHolders
	^oldHolders!

oldHoldersFileName
	^dbConnection dirName , ODBFileStream pathSeparatorString , 'omnibase.log'!

openOn: anOmniBase 
	self initializeOn: anOmniBase.
	
	[versionControl := ODBVersionControlFile openOn: self vcFileName.
	[oldHolders := ODBOldHoldersFile openOn: self oldHoldersFileName] on: Error
		do: [:er | oldHolders := ODBOldHoldersFile createOn: self oldHoldersFileName].
	self initializeReferences] 
			ifCurtailed: [self close]!

transactionAborted: aTransaction 
	"Discard version descriptor. Default do nothing."

	committingTransaction == aTransaction 
		ifTrue: 
			[versionControl removeCommittingFor: aTransaction client clientID.
			committingTransaction := nil.
			serializingTransactionsSemaphore signal]!

transactionCommitBegin: aTransaction 
	| versionNumber |
	serializingTransactionsSemaphore wait.
	committingTransaction notNil 
		ifTrue: [OmniBase signalError: 'Concurrent commit is not allowed'].
	committingTransaction := aTransaction.
	versionNumber := versionControl getNewVersionNumberFor: aTransaction client clientID.
	aTransaction versionDescriptor versionNumber: versionNumber!

transactionCommitEnd: aTransaction 
	committingTransaction == aTransaction 
		ifTrue: 
			[versionControl removeCommittingFor: aTransaction client clientID.
			committingTransaction := nil.
			serializingTransactionsSemaphore signal]!

transactionReferenceAt: index 
	^(index > transactionReferences size or: [index = 0]) 
		ifFalse: [transactionReferences at: index]!

transactionStart: aTransaction 
	"Set transaction version descriptor upon transaction start."

	aTransaction versionDescriptor: versionControl versionDescriptor copy!

vcFileName
	^dbConnection dirName , ODBFileStream pathSeparatorString , 'omnibase.vcf'!

versionControl
	^versionControl! !
!ODBTransactionManager categoriesFor: #close!public! !
!ODBTransactionManager categoriesFor: #createOn:!public! !
!ODBTransactionManager categoriesFor: #critical:!public! !
!ODBTransactionManager categoriesFor: #currentVersionDescriptor!public! !
!ODBTransactionManager categoriesFor: #initializeOn:!private! !
!ODBTransactionManager categoriesFor: #initializeReferences!private! !
!ODBTransactionManager categoriesFor: #oldHolders!public! !
!ODBTransactionManager categoriesFor: #oldHoldersFileName!private! !
!ODBTransactionManager categoriesFor: #openOn:!public! !
!ODBTransactionManager categoriesFor: #transactionAborted:!public! !
!ODBTransactionManager categoriesFor: #transactionCommitBegin:!public! !
!ODBTransactionManager categoriesFor: #transactionCommitEnd:!public! !
!ODBTransactionManager categoriesFor: #transactionReferenceAt:!public! !
!ODBTransactionManager categoriesFor: #transactionStart:!public! !
!ODBTransactionManager categoriesFor: #vcFileName!private! !
!ODBTransactionManager categoriesFor: #versionControl!private! !

