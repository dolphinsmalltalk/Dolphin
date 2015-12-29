"Filed out from Dolphin Smalltalk X6.2"!

ODBDeserializers subclass: #ODBFloatAsInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBFloatAsInteger guid: (GUID fromString: '{8162EE10-0FB8-11D4-B091-000000000000}')!
ODBFloatAsInteger comment: '"""ODBFloatAsIntegerNo comment available "" "'!
!ODBFloatAsInteger categoriesForClass!No category! !
!ODBFloatAsInteger class methodsFor!

odbDeserialize: deserializer 
	^deserializer stream getInteger asFloat! !
!ODBFloatAsInteger class categoriesFor: #odbDeserialize:!accessing!public! !

