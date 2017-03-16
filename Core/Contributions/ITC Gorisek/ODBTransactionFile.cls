"Filed out from Dolphin Smalltalk 7"!

ODBFile subclass: #ODBTransactionFile
	instanceVariableNames: 'locks transactionID lockPositions recovery newLockPosition'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBTransactionFile guid: (GUID fromString: '{8162ee20-0fb8-11d4-b091-000000000000}')!
ODBTransactionFile comment: ''!
!ODBTransactionFile categoriesForClass!No category! !
!ODBTransactionFile methodsFor!

collectLockClassIDsFrom: rootClass to: aDictionary 
	"Private - Collect all lock classIDs and store them to aDictionary."

	rootClass lockClassID notNil 
		ifTrue: [aDictionary at: rootClass lockClassID put: rootClass].
	rootClass subclasses do: [:each | self collectLockClassIDsFrom: each to: aDictionary]!

created
	stream
		putBytesFrom: (ByteArray new: 11);
		flush.
	newLockPosition := self headerLength + 10!

createOn: aString 
	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeCreateAlways
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareRead
				cacheMode: ODBFileStream cacheModeAtomicWrite.
	^self writeHeader!

descriptionString
	^'OmniBase Transaction Log File
OmniBase 1.0, David Gorisek (c) 1998

'!

initialize
	locks := OrderedCollection new.
	lockPositions := OrderedCollection new!

lockAdd: anODBLock 
	"Add lock to transaction file."

	| mStream bytes |
	recovery isNil ifFalse: [OmniBase signalError: 'Can not lock in the middle of commit'].
	anODBLock lockIndex isNil ifFalse: [OmniBase signalError: 'Lock is allready stored'].
	locks add: anODBLock.
	lockPositions add: newLockPosition.
	anODBLock lockIndex: locks size.
	(mStream := ODBMemoryWriteStream new) putByte: 0.
	anODBLock storeOnStream: mStream.
	mStream putByte: 0.
	stream
		position: newLockPosition;
		putBytesFrom: (bytes := mStream asByteArray);
		position: newLockPosition;
		putByte: anODBLock class lockClassID.
	stream flush.
	newLockPosition := newLockPosition + bytes size - 1!

lockRemove: anODBLock 
	"Remove lock from transaction file."

	| i |
	(i := anODBLock lockIndex) isNil 
		ifTrue: [OmniBase signalError: 'Lock has not been stored yet'].
	locks at: i put: nil.
	stream position: (lockPositions at: i).
	stream putByte: 100 + anODBLock class lockClassID.
	anODBLock lockIndex: nil.
	stream flush!

locks
	"Answer all locks stored in transaction file."

	^locks select: [:each | each notNil]!

opened
	"Private - Load all stored locks and recovery information."

	"collect lock classes class IDs"

	| classes storedID classID obj startingPosition |
	classes := IdentityDictionary new.
	self collectLockClassIDsFrom: ODBLock to: classes.
	"load locks first"
	locks := OrderedCollection new.
	lockPositions := OrderedCollection new.
	stream position: self headerLength + 10.
	
	[startingPosition := stream position.
	(storedID := stream getByte) == 0] whileFalse: 
				[storedID > 100 ifTrue: [classID := storedID - 100] ifFalse: [classID := storedID].	"removed locks have classID > 100"
				obj := (classes at: classID ifAbsent: [OmniBase signalError: 'Unknown lock classID']) new 
							loadFromStream: stream.
				storedID > 100 
					ifFalse: 
						["if lock is still active"
						locks add: obj.
						obj lockIndex: locks size.
						lockPositions add: startingPosition]].
	"load recovery information next"
	stream position: self headerLength + 4.
	(startingPosition := stream getLong) == 0 
		ifFalse: 
			[stream position: startingPosition.
			recovery := ODBChangesPackage new loadFromStream: stream]!

openOn: aString 
	"Open transaction file. Signal an error if failed."

	stream := ODBFileStream 
				createOn: aString
				createMode: ODBFileStream createModeOpenExisting
				accessMode: ODBFileStream accessModeReadWrite
				shareMode: ODBFileStream shareModeShareRead
				cacheMode: ODBFileStream cacheModeAtomicWrite.
	^self compareHeader!

recovery
	^recovery!

recovery: anODBChangesPackage 
	"Set recovery instance variable and save recovery information."

	| recoveryPosition |
	anODBChangesPackage isNil 
		ifTrue: [recoveryPosition := 0]
		ifFalse: 
			[recoveryPosition := newLockPosition + 1.
			stream position: recoveryPosition.
			anODBChangesPackage storeOnStream: stream].
	stream
		atPosition: self headerLength + 4 putLong: recoveryPosition;
		flush.
	recovery := anODBChangesPackage!

reinitialize
	"Reinitialize an opened transaction file."

	| bytes |
	newLockPosition := self headerLength + 10.
	bytes := ByteArray new: 11.
	bytes odbShortAt: 9 put: transactionID.
	stream
		position: newLockPosition - 10;
		putBytesFrom: bytes.
	recovery := nil.
	self initialize!

transactionID
	transactionID isNil 
		ifTrue: 
			[transactionID := stream
						position: self headerLength + 8;
						getWord].
	^transactionID!

transactionID: anInteger 
	transactionID := anInteger.
	stream
		position: self headerLength + 8;
		putWord: anInteger!

versionNumber
	^stream
		position: self headerLength;
		getLong!

versionNumber: anInteger 
	stream
		position: self headerLength;
		putLong: anInteger! !
!ODBTransactionFile categoriesFor: #collectLockClassIDsFrom:to:!public! !
!ODBTransactionFile categoriesFor: #created!public! !
!ODBTransactionFile categoriesFor: #createOn:!public! !
!ODBTransactionFile categoriesFor: #descriptionString!public! !
!ODBTransactionFile categoriesFor: #initialize!public! !
!ODBTransactionFile categoriesFor: #lockAdd:!public! !
!ODBTransactionFile categoriesFor: #lockRemove:!public! !
!ODBTransactionFile categoriesFor: #locks!public! !
!ODBTransactionFile categoriesFor: #opened!public! !
!ODBTransactionFile categoriesFor: #openOn:!public! !
!ODBTransactionFile categoriesFor: #recovery!public! !
!ODBTransactionFile categoriesFor: #recovery:!public! !
!ODBTransactionFile categoriesFor: #reinitialize!public! !
!ODBTransactionFile categoriesFor: #transactionID!public! !
!ODBTransactionFile categoriesFor: #transactionID:!public! !
!ODBTransactionFile categoriesFor: #versionNumber!public! !
!ODBTransactionFile categoriesFor: #versionNumber:!public! !

