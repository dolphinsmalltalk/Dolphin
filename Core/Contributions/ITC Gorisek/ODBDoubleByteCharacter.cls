"Filed out from Dolphin Smalltalk 7"!

ODBDeserializers subclass: #ODBDoubleByteCharacter
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBDoubleByteCharacter guid: (GUID fromString: '{8162ee0c-0fb8-11d4-b091-000000000000}')!
ODBDoubleByteCharacter comment: ''!
!ODBDoubleByteCharacter categoriesForClass!No category! !
!ODBDoubleByteCharacter class methodsFor!

odbDeserialize: deserializer 
	^Character value: deserializer stream getWord! !
!ODBDoubleByteCharacter class categoriesFor: #odbDeserialize:!public!serialization! !

