"Filed out from Dolphin Smalltalk X6"!

LPVOID subclass: #LPWSTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LPWSTR guid: (GUID fromString: '{87B4C5B1-026E-11D3-9FD7-00A0CC3E4A32}')!
LPWSTR comment: 'LPWSTR is a class to represent pointers to Unicode strings. It is useful where an external function (or COM method call) returns a pointer to a wide character string through a pointer argument. An example being the IEnumString interface.

LPWSTR implicitly converts to the referenced Unicode string when asked for its value, rather than answering the pointer value itself.

'!
!LPWSTR categoriesForClass!External-Data-Structured! !
!LPWSTR methodsFor!

asString
	"Answer a String composed of the characters of the receiver, or
	the empty string if the receiver is a null pointer."
	
	^self value asString!

value
	"Answer the UnicodeString pointed at by the receiver (N.B. it is copied into Smalltalk space)"

	^UnicodeString fromAddress: super value! !
!LPWSTR categoriesFor: #asString!converting!public! !
!LPWSTR categoriesFor: #value!accessing!public! !

