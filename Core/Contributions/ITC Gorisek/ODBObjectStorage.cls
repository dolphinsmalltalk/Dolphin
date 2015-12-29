"Filed out from Dolphin Smalltalk X6.2"!

ODBFile subclass: #ODBObjectStorage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBObjectStorage guid: (GUID fromString: '{8162EE1E-0FB8-11D4-B091-000000000000}')!
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

