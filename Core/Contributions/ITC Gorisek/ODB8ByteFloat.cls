"Filed out from Dolphin Smalltalk 7"!

ODBDeserializers subclass: #ODB8ByteFloat
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODB8ByteFloat guid: (GUID fromString: '{8162ee0a-0fb8-11d4-b091-000000000000}')!
ODB8ByteFloat comment: ''!
!ODB8ByteFloat categoriesForClass!No category! !
!ODB8ByteFloat class methodsFor!

odbDeserialize: deserializer 
	| float |
	float := Float basicNew: 8.
	deserializer stream getBytesFor: (ExternalAddress fromInteger: float yourAddress) len: 8.
	^float! !
!ODB8ByteFloat class categoriesFor: #odbDeserialize:!accessing!public! !

