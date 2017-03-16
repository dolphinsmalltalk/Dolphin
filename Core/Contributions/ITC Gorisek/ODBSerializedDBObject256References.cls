"Filed out from Dolphin Smalltalk 7"!

ODBSerializedDBObjectWithoutReferences subclass: #ODBSerializedDBObject256References
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBSerializedDBObject256References guid: (GUID fromString: '{8162ee07-0fb8-11d4-b091-000000000000}')!
ODBSerializedDBObject256References comment: ''!
!ODBSerializedDBObject256References categoriesForClass!No category! !
!ODBSerializedDBObject256References methodsFor!

makeTransactionObject: aTransaction

	| mStream bytes referenceManager |
	bytes := objectHolder loadBytes.
	mStream := ODBMemoryReadStream new
				createOn: bytes;
				position: ((referenceManager := ODBReferenceManager new) createMax256From: bytes).
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
		createMax256From: objectHolder loadBytes;
		referencesDo: aBlock! !
!ODBSerializedDBObject256References categoriesFor: #makeTransactionObject:!public! !
!ODBSerializedDBObject256References categoriesFor: #referencesDo:!public!public/transaction processing! !

!ODBSerializedDBObject256References class methodsFor!

classID
	"Answer database object classID."

	^5! !
!ODBSerializedDBObject256References class categoriesFor: #classID!public! !

