"Filed out from Dolphin Smalltalk X6.2"!

ODBDeserializers subclass: #ODB8ByteFloat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODB8ByteFloat guid: (GUID fromString: '{8162EE0A-0FB8-11D4-B091-000000000000}')!
ODB8ByteFloat comment: ''!
!ODB8ByteFloat categoriesForClass!No category! !
!ODB8ByteFloat class methodsFor!

odbDeserialize: deserializer 
	| float |
	float := Float basicNew: 8.
	deserializer stream getBytesFor: (ExternalAddress fromInteger: float yourAddress) len: 8.
	^float! !
!ODB8ByteFloat class categoriesFor: #odbDeserialize:!accessing!public! !

