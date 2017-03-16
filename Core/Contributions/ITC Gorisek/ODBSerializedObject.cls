"Filed out from Dolphin Smalltalk 7"!

ODBTransactionObject subclass: #ODBSerializedObject
	instanceVariableNames: 'changed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBSerializedObject guid: (GUID fromString: '{8162ee30-0fb8-11d4-b091-000000000000}')!
ODBSerializedObject comment: ''!
!ODBSerializedObject categoriesForClass!No category! !
!ODBSerializedObject methodsFor!

commit: serializer 
	"Commit changes."

	| change bytes referenceManager newHolder classID |
	changed == true ifFalse: [^self].
	referenceManager := ODBReferenceManager new.
	bytes := ODBMemoryWriteStream new.
	serializer 
		serialize: dataBaseObject odbObject
		onStream: bytes
		referenceManager: referenceManager
		classManager: transaction environment classManager.
	bytes := referenceManager asBytesWith: bytes asByteArray.
	classID := referenceManager databaseObjectClassID.
	newHolder := (holder makeNewVersion: transaction oldHolders)
				persistentClassID: classID;
				versionNumber: transaction versionNumber.
	newHolder storeBytes: bytes.
	change := (ODBNewObjectVersion new)
				setObjectID: holder objectID transactionObject: self;
				oldVersion: holder;
				newVersion: newHolder.
	transaction changesPackage add: change!

isChanged
	"Answer <true> if object has been changed."

	^changed == true!

objectChanged
	"This message is sent from transaction the first time it is marked as dirty."

	changed := true!

objectCommitted
	"Sent from change after it has committed."

	changed := false!

objectLoaded
	"Sent to transaction object when it is loaded into transaction."

	dataBaseObject odbLoadedIn: transaction!

objectStored
	"Sent to transaction object when object was made persistent."

	changed := true.
	dataBaseObject odbMadePersistentIn: transaction!

value
	"Answer object represented by receiver."

	^dataBaseObject!

value: anObject 
	"Set the object represented by the receiver."

	dataBaseObject := anObject.
	changed := true! !
!ODBSerializedObject categoriesFor: #commit:!public! !
!ODBSerializedObject categoriesFor: #isChanged!public! !
!ODBSerializedObject categoriesFor: #objectChanged!public! !
!ODBSerializedObject categoriesFor: #objectCommitted!public! !
!ODBSerializedObject categoriesFor: #objectLoaded!public! !
!ODBSerializedObject categoriesFor: #objectStored!public! !
!ODBSerializedObject categoriesFor: #value!acessing!public! !
!ODBSerializedObject categoriesFor: #value:!acessing!public! !

