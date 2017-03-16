"Filed out from Dolphin Smalltalk 7"!

ODBDeserializers subclass: #ODBLargeNegativeInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBLargeNegativeInteger guid: (GUID fromString: '{8162ee11-0fb8-11d4-b091-000000000000}')!
ODBLargeNegativeInteger comment: ''!
!ODBLargeNegativeInteger categoriesForClass!No category! !
!ODBLargeNegativeInteger class methodsFor!

odbDeserialize: deserializer 
	^0 - deserializer stream getPositiveInteger! !
!ODBLargeNegativeInteger class categoriesFor: #odbDeserialize:!public! !

