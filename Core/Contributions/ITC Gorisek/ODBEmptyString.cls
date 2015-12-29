"Filed out from Dolphin Smalltalk X6.2"!

ODBDeserializers subclass: #ODBEmptyString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBEmptyString guid: (GUID fromString: '{8162EE0D-0FB8-11D4-B091-000000000000}')!
ODBEmptyString comment: ''!
!ODBEmptyString categoriesForClass!No category! !
!ODBEmptyString class methodsFor!

odbDeserialize: deserializer 
	^deserializer register: String new! !
!ODBEmptyString class categoriesFor: #odbDeserialize:!accessing!public! !

