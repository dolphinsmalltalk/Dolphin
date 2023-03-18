"Filed out from Dolphin Smalltalk"!

External.LPVOID
	subclass: #'External.LPSTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.LPSTR guid: (Core.GUID fromString: '{2b2b03b9-fa4a-4273-bd43-8616625ee779}')!
External.LPSTR comment: 'LPSTR is a class to represent pointers to single-byte strings. It is useful where an external function returns a pointer to a character string through a pointer argument, or where a callback function passes in a pointer to a string as an output parameter to be populated.

LPSTR implicitly converts to the referenced string when asked for its value, rather than answering the pointer value itself.'!
!External.LPSTR categoriesForClass!External-Data-Unstructured! !
!External.LPSTR methodsFor!

asString
	"Answer a String composed of the characters of the receiver, or
	the empty string if the receiver is a null pointer."
	
	^self value!

value
	"Answer the String pointed at by the receiver (N.B. it is copied into Smalltalk space)"

	^AnsiString fromAddress: super value! !
!External.LPSTR categoriesForMethods!
asString!converting!public! !
value!accessing!public! !
!

