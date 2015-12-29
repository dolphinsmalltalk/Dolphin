"Filed out from Dolphin Smalltalk X6.2"!

ODBDeserializers subclass: #ODBLargeNegativeInteger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBLargeNegativeInteger guid: (GUID fromString: '{8162EE11-0FB8-11D4-B091-000000000000}')!
ODBLargeNegativeInteger comment: ''!
!ODBLargeNegativeInteger categoriesForClass!No category! !
!ODBLargeNegativeInteger class methodsFor!

odbDeserialize: deserializer 
	^0 - deserializer stream getPositiveInteger! !
!ODBLargeNegativeInteger class categoriesFor: #odbDeserialize:!public! !

