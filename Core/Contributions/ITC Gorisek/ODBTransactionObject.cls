"Filed out from Dolphin Smalltalk 7"!

Object subclass: #ODBTransactionObject
	instanceVariableNames: 'transaction lockObject holder dataBaseObject'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBTransactionObject guid: (GUID fromString: '{8162ede7-0fb8-11d4-b091-000000000000}')!
ODBTransactionObject comment: ''!
!ODBTransactionObject categoriesForClass!No category! !
!ODBTransactionObject methodsFor!

dataBaseObject
	^dataBaseObject!

initialize!

isLocked
	"Answer <true> if the receiver is localy locked."

	^lockObject notNil!

isODBTransactionObject
	^true!

lock
	"Lock receiver."

	| lockID lockObj |
	lockObject isNil 
		ifTrue: 
			[(lockID := transaction lockID) isNil ifTrue: [^false].
			transaction isGlobalLocked ifTrue: [^true].
			lockObj := ODBObjectLock new.
			lockObj
				objectID: holder objectID;
				lockID: lockID.
			transaction addLock: lockObj.
			(holder lockWith: lockID) 
				ifFalse: 
					[transaction removeLock: lockObj.
					^false].
			lockObject := lockObj].
	^true!

objectChanged
	"This message is sent from transaction the first time it is marked as dirty."

	!

objectHolder
	^holder!

objectID
	^holder objectID!

objectLoaded
	"Sent to transaction object when it is loaded into transaction."

	!

objectStored
	"Sent to transaction object when it is stored for the first time."

	!

setDataBaseObject: anObject 
	dataBaseObject := anObject!

setObjectHolder: anObjectHolder 
	holder := anObjectHolder!

setObjectHolder: anObjectHolder dataBaseObject: aDatabaseObject transaction: aTransaction 
	holder := anObjectHolder.
	dataBaseObject := aDatabaseObject.
	transaction := aTransaction!

setObjectHolder: anObjectHolder transaction: aTransaction 
	holder := anObjectHolder.
	transaction := aTransaction!

transaction
	^transaction!

unlock
	"Unlock receiver."

	lockObject isNil 
		ifFalse: 
			[(holder unlockWith: lockObject lockID) ifFalse: [^false].
			transaction removeLock: lockObject.
			lockObject := nil].
	^true!

value
	"Answer object represented by receiver. Default <self>."

	! !
!ODBTransactionObject categoriesFor: #dataBaseObject!public! !
!ODBTransactionObject categoriesFor: #initialize!initialization!public! !
!ODBTransactionObject categoriesFor: #isLocked!public! !
!ODBTransactionObject categoriesFor: #isODBTransactionObject!public! !
!ODBTransactionObject categoriesFor: #lock!public! !
!ODBTransactionObject categoriesFor: #objectChanged!public! !
!ODBTransactionObject categoriesFor: #objectHolder!public! !
!ODBTransactionObject categoriesFor: #objectID!public! !
!ODBTransactionObject categoriesFor: #objectLoaded!public! !
!ODBTransactionObject categoriesFor: #objectStored!public! !
!ODBTransactionObject categoriesFor: #setDataBaseObject:!public! !
!ODBTransactionObject categoriesFor: #setObjectHolder:!public! !
!ODBTransactionObject categoriesFor: #setObjectHolder:dataBaseObject:transaction:!public! !
!ODBTransactionObject categoriesFor: #setObjectHolder:transaction:!public! !
!ODBTransactionObject categoriesFor: #transaction!public! !
!ODBTransactionObject categoriesFor: #unlock!public! !
!ODBTransactionObject categoriesFor: #value!public! !

!ODBTransactionObject class methodsFor!

new
	^super new initialize! !
!ODBTransactionObject class categoriesFor: #new!public! !

