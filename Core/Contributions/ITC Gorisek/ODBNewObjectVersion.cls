"Filed out from Dolphin Smalltalk X6.2"!

ODBChange subclass: #ODBNewObjectVersion
	instanceVariableNames: 'newVersion oldVersion'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBNewObjectVersion guid: (GUID fromString: '{8162EDFE-0FB8-11D4-B091-000000000000}')!
ODBNewObjectVersion comment: ''!
!ODBNewObjectVersion categoriesForClass!No category! !
!ODBNewObjectVersion methodsFor!

commit
	"Commit changes."

	newVersion store!

committed
	"Changes have been committed, update transaction object."

	transactionObject
		setObjectHolder: newVersion;
		objectCommitted!

loadFromStream: aStream 
	objectID := ODBObjectID new loadFromStream: aStream.
	oldVersion := ODBObjectHolder new loadFromStream: aStream.
	newVersion := ODBObjectHolder new loadFromStream: aStream!

newVersion
	^newVersion!

newVersion: anObjectHolder 
	newVersion := anObjectHolder!

oldVersion
	^oldVersion!

oldVersion: anObjectHolder 
	oldVersion := anObjectHolder!

rollback
	"Rollback changes."

	| currentHolder |
	(currentHolder := transaction objectHolderAt: objectID) isNil ifTrue: [^self].
	currentHolder versionNumber > newVersion versionNumber 
		ifFalse: 
			[currentHolder
				contents: oldVersion contents;
				store]!

storeOnStream: aStream 
	objectID storeOnStream: aStream.
	oldVersion storeOnStream: aStream.
	newVersion storeOnStream: aStream! !
!ODBNewObjectVersion categoriesFor: #commit!public! !
!ODBNewObjectVersion categoriesFor: #committed!public! !
!ODBNewObjectVersion categoriesFor: #loadFromStream:!public! !
!ODBNewObjectVersion categoriesFor: #newVersion!public! !
!ODBNewObjectVersion categoriesFor: #newVersion:!public! !
!ODBNewObjectVersion categoriesFor: #oldVersion!public! !
!ODBNewObjectVersion categoriesFor: #oldVersion:!public! !
!ODBNewObjectVersion categoriesFor: #rollback!public! !
!ODBNewObjectVersion categoriesFor: #storeOnStream:!public! !

!ODBNewObjectVersion class methodsFor!

changeClassID
        "Answer unique class ID used for storing changes into 
        transaction file or <nil> if change does not need to be stored."

    ^1! !
!ODBNewObjectVersion class categoriesFor: #changeClassID!public! !

