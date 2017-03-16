"Filed out from Dolphin Smalltalk 7"!

ODBDeserializers subclass: #ODBFloatAsInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBFloatAsInteger guid: (GUID fromString: '{8162ee10-0fb8-11d4-b091-000000000000}')!
ODBFloatAsInteger comment: '"""ODBFloatAsIntegerNo comment available "" "'!
!ODBFloatAsInteger categoriesForClass!No category! !
!ODBFloatAsInteger class methodsFor!

odbDeserialize: deserializer 
	^deserializer stream getInteger asFloat! !
!ODBFloatAsInteger class categoriesFor: #odbDeserialize:!accessing!public! !

