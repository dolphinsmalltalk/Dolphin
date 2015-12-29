"Filed out from Dolphin Smalltalk X6.2"!

ODBDatabaseObject subclass: #ODBSerializedDBObjectWithoutReferences
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBSerializedDBObjectWithoutReferences guid: (GUID fromString: '{8162EE05-0FB8-11D4-B091-000000000000}')!
ODBSerializedDBObjectWithoutReferences comment: ''!
!ODBSerializedDBObjectWithoutReferences categoriesForClass!No category! !
!ODBSerializedDBObjectWithoutReferences methodsFor!

garbageCollectOn: anODBGarbageCollector 
	objectHolder container 
		addByteStorageRequest: (ODBGarbageCollectorRequest new objectHolder: objectHolder
				bytes: objectHolder loadBytes)!

makeTransactionObject: aTransaction

	| mStream bytes |
	bytes := objectHolder loadBytes.
	mStream := ODBMemoryReadStream new createOn: bytes.
	^ODBSerializedObject new
		setObjectHolder: objectHolder
		dataBaseObject: (ODBDeserializer new
						deserializeFrom: mStream
						referenceManager: nil
						transaction: aTransaction)
		transaction: aTransaction! !
!ODBSerializedDBObjectWithoutReferences categoriesFor: #garbageCollectOn:!public! !
!ODBSerializedDBObjectWithoutReferences categoriesFor: #makeTransactionObject:!public! !

!ODBSerializedDBObjectWithoutReferences class methodsFor!

classID
	"Answer database object classID."

	^3!

hasBytes
	"Answer <true> if the object stores its contents as bytes."

	^true! !
!ODBSerializedDBObjectWithoutReferences class categoriesFor: #classID!public! !
!ODBSerializedDBObjectWithoutReferences class categoriesFor: #hasBytes!accessing!public! !

