"Filed out from Dolphin Smalltalk 7"!

ODBFile subclass: #ODBObjectStorage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBObjectStorage guid: (GUID fromString: '{8162ee1e-0fb8-11d4-b091-000000000000}')!
ODBObjectStorage comment: ''!
!ODBObjectStorage categoriesForClass!No category! !
!ODBObjectStorage methodsFor!

descriptionString
	^'OmniBase Object Storage
OmniBase 1.0, David Gorisek (c) 1998

'!

isEmpty
	^stream size == self headerLength!

removeAll
	stream truncate: self headerLength! !
!ODBObjectStorage categoriesFor: #descriptionString!public! !
!ODBObjectStorage categoriesFor: #isEmpty!public! !
!ODBObjectStorage categoriesFor: #removeAll!public! !

