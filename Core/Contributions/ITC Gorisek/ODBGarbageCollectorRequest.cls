"Filed out from Dolphin Smalltalk 7"!

ODBByteStorageRequest subclass: #ODBGarbageCollectorRequest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBGarbageCollectorRequest guid: (GUID fromString: '{8162edfb-0fb8-11d4-b091-000000000000}')!
ODBGarbageCollectorRequest comment: ''!
!ODBGarbageCollectorRequest categoriesForClass!No category! !
!ODBGarbageCollectorRequest methodsFor!

bytesStored
	objectHolder container indexFile at: objectHolder objectID index
		put: objectHolder contents! !
!ODBGarbageCollectorRequest categoriesFor: #bytesStored!public! !

