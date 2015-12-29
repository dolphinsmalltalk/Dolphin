"Filed out from Dolphin Smalltalk X6.2"!

ODBChange subclass: #ODBAssociationChanged
	instanceVariableNames: 'key oldValue newValue'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBAssociationChanged guid: (GUID fromString: '{8162EDFC-0FB8-11D4-B091-000000000000}')!
ODBAssociationChanged comment: ''!
!ODBAssociationChanged categoriesForClass!No category! !
!ODBAssociationChanged methodsFor!

commit
	transactionObject dataBaseObject at: key put: newValue!

key: aString 
	key := aString!

loadFromStream: aStream 
	objectID := ODBObjectID new loadFromStream: aStream.
	key := aStream getString asByteArray.
	oldValue := ODBValueHolder new loadFromStream: aStream.
	newValue := ODBValueHolder new loadFromStream: aStream!

newValue: aValue 
	newValue := aValue!

oldValue: aValue 
	oldValue := aValue!

rollback
	self transactionObject dataBaseObject at: key put: oldValue!

storeOnStream: aStream 
	objectID storeOnStream: aStream.
	aStream putString: key.
	oldValue storeOnStream: aStream.
	newValue storeOnStream: aStream! !
!ODBAssociationChanged categoriesFor: #commit!public! !
!ODBAssociationChanged categoriesFor: #key:!public! !
!ODBAssociationChanged categoriesFor: #loadFromStream:!public! !
!ODBAssociationChanged categoriesFor: #newValue:!public! !
!ODBAssociationChanged categoriesFor: #oldValue:!public! !
!ODBAssociationChanged categoriesFor: #rollback!public! !
!ODBAssociationChanged categoriesFor: #storeOnStream:!public! !

!ODBAssociationChanged class methodsFor!

changeClassID
        "Answer unique class ID used for storing changes into 
        transaction file or <nil> if change does not need to be stored."

    ^2! !
!ODBAssociationChanged class categoriesFor: #changeClassID!public! !

