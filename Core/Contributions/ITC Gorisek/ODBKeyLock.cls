"Filed out from Dolphin Smalltalk X6.2"!

ODBLock subclass: #ODBKeyLock
	instanceVariableNames: 'key'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBKeyLock guid: (GUID fromString: '{8162EE26-0FB8-11D4-B091-000000000000}')!
ODBKeyLock comment: ''!
!ODBKeyLock categoriesForClass!No category! !
!ODBKeyLock methodsFor!

key
	^key!

key: aString 
	key := aString!

loadFromStream: aStream 
	objectID := ODBObjectID new loadFromStream: aStream.
	lockID := aStream getLong.
	key := aStream getString asByteArray!

storeOnStream: aStream 
	objectID storeOnStream: aStream.
	aStream putLong: lockID.
	aStream putString: key!

unlock
	self transactionObject dataBaseObject unlockKey: key with: lockID! !
!ODBKeyLock categoriesFor: #key!accessing!public! !
!ODBKeyLock categoriesFor: #key:!accessing!public! !
!ODBKeyLock categoriesFor: #loadFromStream:!public! !
!ODBKeyLock categoriesFor: #storeOnStream:!public! !
!ODBKeyLock categoriesFor: #unlock!public! !

!ODBKeyLock class methodsFor!

lockClassID
	"Answer unique class ID used for storing locks 
        or <nil> if lock does not need to be stored."

	^2! !
!ODBKeyLock class categoriesFor: #lockClassID!public! !

