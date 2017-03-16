"Filed out from Dolphin Smalltalk 7"!

ODBDeserializers subclass: #ODBLargePositiveInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBLargePositiveInteger guid: (GUID fromString: '{8162ee12-0fb8-11d4-b091-000000000000}')!
ODBLargePositiveInteger comment: ''!
!ODBLargePositiveInteger categoriesForClass!No category! !
!ODBLargePositiveInteger class methodsFor!

odbDeserialize: deserializer 
	^deserializer stream getPositiveInteger! !
!ODBLargePositiveInteger class categoriesFor: #odbDeserialize:!public! !

