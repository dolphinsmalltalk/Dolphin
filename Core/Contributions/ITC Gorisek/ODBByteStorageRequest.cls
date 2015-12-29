"Filed out from Dolphin Smalltalk X6.2"!

Object subclass: #ODBByteStorageRequest
	instanceVariableNames: 'objectHolder byteArray'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBByteStorageRequest guid: (GUID fromString: '{8162EDCD-0FB8-11D4-B091-000000000000}')!
ODBByteStorageRequest comment: ''!
!ODBByteStorageRequest categoriesForClass!No category! !
!ODBByteStorageRequest methodsFor!

bytes
	^byteArray!

bytesStored
	!

objectHolder
	^objectHolder!

objectHolder: anObjectHolder bytes: aByteArray 
	objectHolder := anObjectHolder.
	byteArray := aByteArray!

objectPosition: anInteger 
	objectHolder objectPosition: anInteger! !
!ODBByteStorageRequest categoriesFor: #bytes!public! !
!ODBByteStorageRequest categoriesFor: #bytesStored!public! !
!ODBByteStorageRequest categoriesFor: #objectHolder!public! !
!ODBByteStorageRequest categoriesFor: #objectHolder:bytes:!public! !
!ODBByteStorageRequest categoriesFor: #objectPosition:!public! !

