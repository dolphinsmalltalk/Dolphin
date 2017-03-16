"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ODBLock
	instanceVariableNames: 'transaction lockIndex objectID lockID'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBLock guid: (GUID fromString: '{8162eddd-0fb8-11d4-b091-000000000000}')!
ODBLock comment: ''!
!ODBLock categoriesForClass!No category! !
!ODBLock methodsFor!

lockID
	^lockID!

lockID: anInteger 
	lockID := anInteger!

lockIndex
	^lockIndex!

lockIndex: anInteger 
	lockIndex := anInteger!

objectID
	^objectID!

objectID: anObjectID 
	objectID := anObjectID!

transaction: aTransaction 
	transaction := aTransaction!

transactionObject
	"Private - Get transaction object corresponding to objectID."

	^transaction transactionObjectAt: objectID! !
!ODBLock categoriesFor: #lockID!accessing!public! !
!ODBLock categoriesFor: #lockID:!accessing!public! !
!ODBLock categoriesFor: #lockIndex!accessing!public! !
!ODBLock categoriesFor: #lockIndex:!accessing!public! !
!ODBLock categoriesFor: #objectID!accessing!public! !
!ODBLock categoriesFor: #objectID:!accessing!public! !
!ODBLock categoriesFor: #transaction:!accessing!public! !
!ODBLock categoriesFor: #transactionObject!private! !

!ODBLock class methodsFor!

lockClassID
	"Answer unique class ID used for storing locks 
        or <nil> if lock does not need to be stored."

	self subclassResponsibility! !
!ODBLock class categoriesFor: #lockClassID!public! !

