"Filed out from Dolphin Smalltalk 7"!

ODBDeserializers subclass: #ODBnCharacterString
	instanceVariableNames: 'n'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBnCharacterString guid: (GUID fromString: '{8162ee13-0fb8-11d4-b091-000000000000}')!
ODBnCharacterString comment: ''!
!ODBnCharacterString categoriesForClass!No category! !
!ODBnCharacterString methodsFor!

n: anInteger

    n := anInteger.!

odbDeserialize: deserializer

    | str |
    deserializer stream getBytesFor: (str := String new: n) len: n.
    ^deserializer register: str! !
!ODBnCharacterString categoriesFor: #n:!private! !
!ODBnCharacterString categoriesFor: #odbDeserialize:!accessing!public! !

!ODBnCharacterString class methodsFor!

length: anInteger 
	^self new n: anInteger! !
!ODBnCharacterString class categoriesFor: #length:!creation!public! !

