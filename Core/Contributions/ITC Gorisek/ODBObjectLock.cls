"Filed out from Dolphin Smalltalk X6.2"!

ODBLock subclass: #ODBObjectLock
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBObjectLock guid: (GUID fromString: '{8162EE27-0FB8-11D4-B091-000000000000}')!
ODBObjectLock comment: ''!
!ODBObjectLock categoriesForClass!No category! !
!ODBObjectLock methodsFor!

loadFromStream: aStream 
	objectID := ODBObjectID new loadFromStream: aStream.
	lockID := aStream getLong!

storeOnStream: aStream 
	objectID storeOnStream: aStream.
	aStream putLong: lockID!

unlock
	^(transaction objectHolderAt: objectID) unlockWith: lockID! !
!ODBObjectLock categoriesFor: #loadFromStream:!public! !
!ODBObjectLock categoriesFor: #storeOnStream:!public! !
!ODBObjectLock categoriesFor: #unlock!public! !

!ODBObjectLock class methodsFor!

lockClassID
	"Answer unique class ID used for storing locks 
        or <nil> if lock does not need to be stored."

	^1! !
!ODBObjectLock class categoriesFor: #lockClassID!public! !

