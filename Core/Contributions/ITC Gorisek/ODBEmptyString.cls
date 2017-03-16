"Filed out from Dolphin Smalltalk 7"!

ODBDeserializers subclass: #ODBEmptyString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBEmptyString guid: (GUID fromString: '{8162ee0d-0fb8-11d4-b091-000000000000}')!
ODBEmptyString comment: ''!
!ODBEmptyString categoriesForClass!No category! !
!ODBEmptyString class methodsFor!

odbDeserialize: deserializer 
	^deserializer register: String new! !
!ODBEmptyString class categoriesFor: #odbDeserialize:!accessing!public! !

