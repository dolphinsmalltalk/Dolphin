"Filed out from Dolphin Smalltalk 7"!

ODBChange subclass: #ODBSizeChanged
	instanceVariableNames: 'deltaSize'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBSizeChanged guid: (GUID fromString: '{8162edff-0fb8-11d4-b091-000000000000}')!
ODBSizeChanged comment: ''!
!ODBSizeChanged categoriesForClass!No category! !
!ODBSizeChanged methodsFor!

commit
	transaction := transactionObject transaction.
	transactionObject dataBaseObject iterator 
		updateSizeAt: transaction versionNumber
		oldHolders: transaction oldHolders
		deltaSize: deltaSize!

deltaSize: anInteger 
	deltaSize := anInteger!

loadFromStream: aStream 
	objectID := ODBObjectID new loadFromStream: aStream.
	deltaSize := aStream getInteger!

rollback
	self transactionObject dataBaseObject iterator 
		updateSizeAt: transaction versionNumber
		oldHolders: transaction oldHolders
		deltaSize: 0 - deltaSize!

storeOnStream: aStream 
	objectID storeOnStream: aStream.
	aStream putInteger: deltaSize! !
!ODBSizeChanged categoriesFor: #commit!public! !
!ODBSizeChanged categoriesFor: #deltaSize:!public! !
!ODBSizeChanged categoriesFor: #loadFromStream:!public! !
!ODBSizeChanged categoriesFor: #rollback!public! !
!ODBSizeChanged categoriesFor: #storeOnStream:!public! !

!ODBSizeChanged class methodsFor!

changeClassID
        "Answer unique class ID used for storing changes into 
        transaction file or <nil> if change does not need to be stored."

    ^4! !
!ODBSizeChanged class categoriesFor: #changeClassID!public! !

