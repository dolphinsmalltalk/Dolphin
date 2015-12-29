"Filed out from Dolphin Smalltalk X6.2"!

ODBDeserializers subclass: #ODBFloatAs100Integer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBFloatAs100Integer guid: (GUID fromString: '{8162EE0F-0FB8-11D4-B091-000000000000}')!
ODBFloatAs100Integer comment: ''!
!ODBFloatAs100Integer categoriesForClass!No category! !
!ODBFloatAs100Integer class methodsFor!

odbDeserialize: deserializer 
	^deserializer stream getInteger / 100.0! !
!ODBFloatAs100Integer class categoriesFor: #odbDeserialize:!accessing!public! !

