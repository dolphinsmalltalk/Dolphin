"Filed out from Dolphin Smalltalk"!

External.LPVOID
	subclass: #'External.LPSZ'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.LPSZ guid: (Core.GUID fromString: '{f77fb715-c75e-464d-945d-599f48694006}')!

External.LPSZ isNonInstantiable: true!

External.LPSZ comment: ''!

!External.LPSZ methodsFor!

asString
	"Answer a `String` composed of the characters of the receiver."

	^self value!

asUtf16String
	"Answer a `Utf16String` containing the same code points as the string pointed at by the receiver."

	^self value asUtf16String!

asUtf8String
	"Answer a `Utf8String` containing the same code points as the string pointed at by the receiver."

	^self value asUtf8String!

copy
	"Answer an <Object> which is a copy of the receiver. For string pointers we dereference to a copy of the underlying string."

	^self deepCopy!

deepCopy
	"Answer a 'deep copy' of the receiver. For copies of string pointers, we return a copy of the string value."

	^self value!

value
	"Answer the <String> pointed at by the receiver (N.B. it is copied into Smalltalk space)"

	^self subclassResponsibility!

value: aString
	"Set the receiver's 'value' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_value put: aString yourAddress! !

!External.LPSZ categoriesForMethods!
asString!converting!public! !
asUtf16String!converting!public! !
asUtf8String!converting!public! !
copy!copying!public! !
deepCopy!copying!public! !
value!accessing!public! !
value:!**compiled accessors**!public! !
!

