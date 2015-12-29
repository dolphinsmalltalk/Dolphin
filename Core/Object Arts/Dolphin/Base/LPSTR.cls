"Filed out from Dolphin Smalltalk X6"!

LPVOID subclass: #LPSTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LPSTR guid: (GUID fromString: '{2B2B03B9-FA4A-4273-BD43-8616625EE779}')!
LPSTR comment: 'LPSTR is a class to represent pointers to single-byte strings. It is useful where an external function returns a pointer to a character string through a pointer argument, or where a callback function passes in a pointer to a string as an output parameter to be populated.

LPSTR implicitly converts to the referenced string when asked for its value, rather than answering the pointer value itself.'!
!LPSTR categoriesForClass!Unclassified! !
!LPSTR methodsFor!

asString
	"Answer a String composed of the characters of the receiver, or
	the empty string if the receiver is a null pointer."
	
	^self value!

value
	"Answer the UnicodeString pointed at by the receiver (N.B. it is copied into Smalltalk space)"

	^String fromAddress: super value! !
!LPSTR categoriesFor: #asString!converting!public! !
!LPSTR categoriesFor: #value!accessing!public! !

