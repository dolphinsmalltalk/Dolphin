"Filed out from Dolphin Smalltalk X6.2"!

ODBTransactionObject subclass: #ODBRootObjectHolder
	instanceVariableNames: 'changed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBRootObjectHolder guid: (GUID fromString: '{8162EE2F-0FB8-11D4-B091-000000000000}')!
ODBRootObjectHolder comment: ''!
!ODBRootObjectHolder categoriesForClass!No category! !
!ODBRootObjectHolder methodsFor!

commit: serializer 
	"Commit changes."

	| change newHolder |
	changed == true 
		ifTrue: 
			[newHolder := (holder makeNewVersion: transaction oldHolders)
						persistentClassID: ODBRootObjectDBHolder classID;
						versionNumber: transaction versionNumber;
						rootObjectID: (transaction getObjectID: dataBaseObject).
			change := (ODBNewObjectVersion new)
						setObjectID: holder objectID transactionObject: self;
						oldVersion: holder;
						newVersion: newHolder.
			transaction changesPackage add: change]!

isChanged
	"Answer <true> if object has been changed."

	^changed == true!

objectCommitted
	"Sent from change after it has committed."

	changed := false!

objectLoaded
	"Sent to transaction object when it has been loaded into transaction."

	dataBaseObject := transaction objectAt: dataBaseObject!

rootObject
	"Answer object represented by receiver."

	^dataBaseObject!

rootObject: anObject 
	"Set object represented by the receiver."

	changed := true.
	transaction makePersistent: anObject.
	dataBaseObject := anObject! !
!ODBRootObjectHolder categoriesFor: #commit:!public! !
!ODBRootObjectHolder categoriesFor: #isChanged!public! !
!ODBRootObjectHolder categoriesFor: #objectCommitted!public! !
!ODBRootObjectHolder categoriesFor: #objectLoaded!public! !
!ODBRootObjectHolder categoriesFor: #rootObject!public! !
!ODBRootObjectHolder categoriesFor: #rootObject:!public! !

