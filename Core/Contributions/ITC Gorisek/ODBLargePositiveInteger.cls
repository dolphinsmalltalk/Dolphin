"Filed out from Dolphin Smalltalk X6.2"!

ODBDeserializers subclass: #ODBLargePositiveInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBLargePositiveInteger guid: (GUID fromString: '{8162EE12-0FB8-11D4-B091-000000000000}')!
ODBLargePositiveInteger comment: ''!
!ODBLargePositiveInteger categoriesForClass!No category! !
!ODBLargePositiveInteger class methodsFor!

odbDeserialize: deserializer 
	^deserializer stream getPositiveInteger! !
!ODBLargePositiveInteger class categoriesFor: #odbDeserialize:!public! !

