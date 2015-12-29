"Filed out from Dolphin Smalltalk X6.2"!

ODBClient subclass: #ODBLocalClient
	instanceVariableNames: 'hasGlobalLock freeTransactionFile'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBLocalClient guid: (GUID fromString: '{8162EE01-0FB8-11D4-B091-000000000000}')!
ODBLocalClient comment: '"Local clients are active. Only local clients can change objects in the database. "'!
!ODBLocalClient categoriesForClass!No category! !
!ODBLocalClient methodsFor!

createOn: aClientManager clientID: anInteger 
	| userName machineName |
	
	[userName := SessionManager current userName asLowercase.
	machineName := SessionManager current computerName asLowercase] 
			on: Error
			do: [:ex | ].
	(userName isNil or: [userName isEmpty]) ifTrue: [userName := 'unknown-user'].
	(machineName isNil or: [machineName isEmpty]) ifTrue: [machineName := 'unknown-host'].
	id := anInteger.
	clientManager := aClientManager.
	clientFile := ODBClientFile createOn: (clientManager clientFileName: id).
	clientManager addOpenedClient: self.
	self description: 'OmniBase 2.1 [clientID=' , id printString , '] ' , userName , '@' 
				, machineName!

currentGlobalLockedTransaction

    transactions do: [:each | each transactionFile == nil ifFalse: [ ^each ]].
    ^nil!

description: aString
        "Set client description string."

    clientFile clientDescription: aString!

globalLock
        "Set global write lock to all objects in the database.
        No other client will be able to write to the database
        until the lock is released by globalUnlock. Answer <true>
        if sucessfull or <false> if failed. Global lock will fail if
        any client (including local client) allready has read-write
        transactions running. When database is globaly locked only one
        read-write transaction can run at that time."

    | count |
    count := transactionFiles size.
    freeTransactionFile isNil ifFalse: [ count := count - 1 ].
    (hasGlobalLock not and: [ count == 0 ])
        ifTrue: [ hasGlobalLock := clientManager setGlobalLockFor: id ].
    ^hasGlobalLock!

globalUnlock
        "Release global lock on database.
        Answer <true> if successfull."

    hasGlobalLock ifFalse: [ ^false ].
    transactions do: [:each | each isGlobalLocked ifTrue: [ ^false ]].
    clientManager globalUnlock.
    hasGlobalLock := false.
    ^true
!

initialize
	"Private - Initialize receiver."

	transactions := OmniBase newIdentitySet: 20.
	transactionFiles := OrderedCollection new.
	hasGlobalLock := false!

isGlobalLocked

    ^hasGlobalLock!

isLocal

    ^true!

makeRootObject
	"Private - Initialize root object."

	(self newTransaction)
		root: OmniBase newPersistentDictionary;
		commit!

newLongReadOnlyTransaction
	"Answer new long read-only transaction for receiver."

	^(ODBLongReadOnlyTransaction new)
		setClient: self environment: clientManager environment;
		start!

newReadOnlyTransaction
	"Answer new read-only transaction for receiver."

	^(ODBReadOnlyTransaction new)
		setClient: self environment: clientManager environment;
		start!

newTransaction
	"Answer new transaction for receiver."

	| transaction |
	hasGlobalLock 
		ifFalse: [transaction := ODBLocalTransaction new]
		ifTrue: [transaction := ODBGlobalLockedTransaction new].
	^transaction
		setClient: self environment: clientManager environment;
		start!

newTransactionFileFor: aTransaction 
	| transactionFile transactionID count |
	count := transactionFiles size.
	freeTransactionFile isNil ifFalse: [count := count - 1].
	hasGlobalLock 
		ifTrue: 
			[aTransaction isGlobalLocked ifFalse: [^nil].
			count == 0 ifFalse: [^nil]]
		ifFalse: 
			[aTransaction isGlobalLocked ifTrue: [^nil].
			count == 0 ifTrue: [(clientManager requestLocksFor: id) ifFalse: [^nil]]].
	freeTransactionFile isNil 
		ifFalse: 
			[transactionFile := freeTransactionFile.
			freeTransactionFile := nil.
			transactions add: aTransaction.
			^transactionFile].
	transactionID := id bitShift: 8.
	256 timesRepeat: 
			[(transactionFiles includes: transactionID) 
				ifFalse: 
					[transactionFiles add: transactionID.
					clientFile transactionIDs: transactionFiles.
					[transactionFile := ODBTransactionFile createOn: (self trnFileName: transactionID)] 
						on: Error
						do: [:er | transactionFile := nil].
					transactionFile isNil 
						ifTrue: [transactionFiles remove: transactionID]
						ifFalse: 
							[transactions add: aTransaction.
							^transactionFile transactionID: transactionID]].
			transactionID := transactionID + 1].
	OmniBase signalError: 'Maximum number of active read-write transactions reached'!

newTransactionFrom: aTransaction
        "Answer new transaction for receiver from aTransaction. 
        Objects accessible in aTransaction will also be accessible 
        in new transaction."

    | transaction |
    transaction := aTransaction class new.
    ^transaction setClient: self environment: clientManager environment; startFrom: aTransaction!

newTransactionInVersion: aVersionDescriptor
        "Answer new transaction with given version descriptor."

    | transaction |
    hasGlobalLock
        ifFalse: [ transaction := ODBLocalTransaction new ]
        ifTrue: [ transaction := ODBGlobalLockedTransaction new ].
    ^transaction setClient: self environment: clientManager environment; startInVersion: aVersionDescriptor!

remove

    freeTransactionFile isNil ifFalse: [ freeTransactionFile remove ].
    freeTransactionFile := true. "do not cache transaction files anymore"
    ^super remove!

transactionRemove: aTransaction
        "Private - Remove aTransaction."

    | trnFile trID |
    (trnFile := aTransaction transactionFile) == nil ifTrue: [ ^self ].
    freeTransactionFile == nil
        ifTrue: [ freeTransactionFile := trnFile reinitialize ]
        ifFalse: [
            trID := trnFile transactionID.
            trnFile remove
                ifTrue: [
                    transactionFiles remove: trID ifAbsent: [].
                    clientFile transactionIDs: transactionFiles.
                ]
        ].
    transactionFiles size > 1 ifFalse: [ clientManager removeLocksFor: id ].
    transactions remove: aTransaction ifAbsent: []! !
!ODBLocalClient categoriesFor: #createOn:clientID:!public! !
!ODBLocalClient categoriesFor: #currentGlobalLockedTransaction!private! !
!ODBLocalClient categoriesFor: #description:!public! !
!ODBLocalClient categoriesFor: #globalLock!public! !
!ODBLocalClient categoriesFor: #globalUnlock!public! !
!ODBLocalClient categoriesFor: #initialize!private! !
!ODBLocalClient categoriesFor: #isGlobalLocked!public! !
!ODBLocalClient categoriesFor: #isLocal!public! !
!ODBLocalClient categoriesFor: #makeRootObject!private! !
!ODBLocalClient categoriesFor: #newLongReadOnlyTransaction!public! !
!ODBLocalClient categoriesFor: #newReadOnlyTransaction!public! !
!ODBLocalClient categoriesFor: #newTransaction!public! !
!ODBLocalClient categoriesFor: #newTransactionFileFor:!private! !
!ODBLocalClient categoriesFor: #newTransactionFrom:!public! !
!ODBLocalClient categoriesFor: #newTransactionInVersion:!public! !
!ODBLocalClient categoriesFor: #remove!public! !
!ODBLocalClient categoriesFor: #transactionRemove:!private! !

