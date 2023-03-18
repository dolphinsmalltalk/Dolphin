"Filed out from Dolphin Smalltalk"!

External.LPVOID
	subclass: #'External.LPWSTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.LPWSTR guid: (Core.GUID fromString: '{87b4c5b1-026e-11d3-9fd7-00a0cc3e4a32}')!
External.LPWSTR comment: 'LPWSTR is a class to represent pointers to Unicode strings. It is useful where an external function (or COM method call) returns a pointer to a wide character string through a pointer argument. An example being the IEnumString interface.

LPWSTR implicitly converts to the referenced Unicode string when asked for its value, rather than answering the pointer value itself.

'!
!External.LPWSTR categoriesForClass!External-Data-Unstructured! !
!External.LPWSTR methodsFor!

asString
	"Answer a String composed of the characters of the receiver, or
	the empty string if the receiver is a null pointer."
	
	^self value asString!

value
	"Answer the <Utf16String> pointed at by the receiver (N.B. it is copied into Smalltalk space)"

	^Utf16String fromAddress: super value! !
!External.LPWSTR categoriesForMethods!
asString!converting!public! !
value!accessing!public! !
!

