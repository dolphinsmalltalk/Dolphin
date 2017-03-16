"Filed out from Dolphin Smalltalk 7"!

ODBSerializedDBObjectWithoutReferences subclass: #ODBSerializedDBObject65536References
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBSerializedDBObject65536References guid: (GUID fromString: '{8162ee08-0fb8-11d4-b091-000000000000}')!
ODBSerializedDBObject65536References comment: ''!
!ODBSerializedDBObject65536References categoriesForClass!No category! !
!ODBSerializedDBObject65536References methodsFor!

makeTransactionObject: aTransaction 
	| mStream bytes referenceManager |
	bytes := objectHolder loadBytes.
	mStream := (ODBMemoryReadStream new)
				createOn: bytes;
				position: ((referenceManager := ODBReferenceManager new) createMax65536From: bytes).
	referenceManager transaction: aTransaction.
	^ODBSerializedObject new 
		setObjectHolder: objectHolder
		dataBaseObject: (ODBDeserializer new 
				deserializeFrom: mStream
				referenceManager: referenceManager
				transaction: aTransaction)
		transaction: aTransaction!

referencesDo: aBlock 
	(ODBReferenceManager new)
		createMax65536From: objectHolder loadBytes;
		referencesDo: aBlock! !
!ODBSerializedDBObject65536References categoriesFor: #makeTransactionObject:!public! !
!ODBSerializedDBObject65536References categoriesFor: #referencesDo:!public!public/transaction processing! !

!ODBSerializedDBObject65536References class methodsFor!

classID
	"Answer database object classID."

	^6! !
!ODBSerializedDBObject65536References class categoriesFor: #classID!public! !

