"Filed out from Dolphin Smalltalk X6.2"!

ODBDeserializers subclass: #ODBDoubleByteCharacter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBDoubleByteCharacter guid: (GUID fromString: '{8162EE0C-0FB8-11D4-B091-000000000000}')!
ODBDoubleByteCharacter comment: ''!
!ODBDoubleByteCharacter categoriesForClass!No category! !
!ODBDoubleByteCharacter class methodsFor!

odbDeserialize: deserializer 
	^Character value: deserializer stream getWord! !
!ODBDoubleByteCharacter class categoriesFor: #odbDeserialize:!public!serialization! !

