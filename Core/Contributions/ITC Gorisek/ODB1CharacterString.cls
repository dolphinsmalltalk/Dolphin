"Filed out from Dolphin Smalltalk X6.2"!

ODBDeserializers subclass: #ODB1CharacterString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODB1CharacterString guid: (GUID fromString: '{8162EE09-0FB8-11D4-B091-000000000000}')!
ODB1CharacterString comment: ''!
!ODB1CharacterString categoriesForClass!No category! !
!ODB1CharacterString class methodsFor!

odbDeserialize: deserializer 
	| str |
	(str := String new: 1) at: 1 put: deserializer stream getChar.
	^deserializer register: str! !
!ODB1CharacterString class categoriesFor: #odbDeserialize:!accessing!public! !

