"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBChange
	instanceVariableNames: 'objectID transactionObject transaction'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBChange guid: (GUID fromString: '{8162EDCE-0FB8-11D4-B091-000000000000}')!
ODBChange comment: ''!
!ODBChange categoriesForClass!No category! !
!ODBChange methodsFor!

commit
        "Commit changes."!

committed!

initialize
	!

loadFromStream: aStream 
	"Load receiver from aStream.  Implemented by subclasses."

	!

objectID
	^objectID!

rollback
	!

setObjectID: anObjectID transactionObject: aTransactionObject 
	objectID := anObjectID.
	transactionObject := aTransactionObject!

storeOnStream: aStream 
	"Store receiver on aStream. 
        Implemented by subclasses."

	!

transaction: aTransaction 
	transaction := aTransaction!

transactionObject
	^transactionObject isNil 
		ifFalse: [transactionObject]
		ifTrue: [transactionObject := transaction transactionObjectAt: objectID]!

transactionObject: aTransactionObject 
	transactionObject := aTransactionObject! !
!ODBChange categoriesFor: #commit!public! !
!ODBChange categoriesFor: #committed!public! !
!ODBChange categoriesFor: #initialize!private! !
!ODBChange categoriesFor: #loadFromStream:!public! !
!ODBChange categoriesFor: #objectID!accessing!public! !
!ODBChange categoriesFor: #rollback!public! !
!ODBChange categoriesFor: #setObjectID:transactionObject:!public! !
!ODBChange categoriesFor: #storeOnStream:!public! !
!ODBChange categoriesFor: #transaction:!accessing!public! !
!ODBChange categoriesFor: #transactionObject!accessing!public! !
!ODBChange categoriesFor: #transactionObject:!accessing!public! !

!ODBChange class methodsFor!

changeClassID
	"Answer unique class ID used for storing changes into 
	transaction file or <nil> if change does not need to be stored."

	^nil!

new
	^super new initialize! !
!ODBChange class categoriesFor: #changeClassID!public! !
!ODBChange class categoriesFor: #new!public! !

