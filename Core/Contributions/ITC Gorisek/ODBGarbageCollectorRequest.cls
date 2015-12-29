"Filed out from Dolphin Smalltalk X6.2"!

ODBByteStorageRequest subclass: #ODBGarbageCollectorRequest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBGarbageCollectorRequest guid: (GUID fromString: '{8162EDFB-0FB8-11D4-B091-000000000000}')!
ODBGarbageCollectorRequest comment: ''!
!ODBGarbageCollectorRequest categoriesForClass!No category! !
!ODBGarbageCollectorRequest methodsFor!

bytesStored
	objectHolder container indexFile at: objectHolder objectID index
		put: objectHolder contents! !
!ODBGarbageCollectorRequest categoriesFor: #bytesStored!public! !

