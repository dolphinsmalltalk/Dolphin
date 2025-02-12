﻿"Filed out from Dolphin Smalltalk"!

External.LPVOID
	subclass: #'OS.COM.LPBSTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.LPBSTR guid: (Core.GUID fromString: '{8ed55b71-d72d-4df1-a211-434db718fef0}')!

OS.COM.LPBSTR comment: 'LPBSTR is a class to represent pointers to BSTRs (Basic Strings). It is useful where an IDispatch method requires that a BSTR argument be passed by references, or when implement such a method as a means of returning a BSTR reference.

LPBSTR implicitly converts to the referenced string when asked for its value, rather than answering the pointer value itself.

For example:

	bstr := ''abc'' asBSTR.				"Ctrl+E"
	(LPBSTR fromAddress: bstr basicYourAddress) 	"Ctrl+D"

Note that because BSTR is an indirection class (BSTRs are pointers to strings), it is necessary to send its instances #basicYourAddress to get the address of the object, rather than #yourAddress which will return the contained address.
'!

!OS.COM.LPBSTR categoriesForClass!External-Data-Unstructured! !

!OS.COM.LPBSTR methodsFor!

asString
	"Answer a `String` composed of the characters of the receiver, or the empty string if the receiver is a null pointer."

	^self asUtf16String!

asUtf16String
	"Answer a `Utf16String` composed of the characters of the BSTR pointed at by the receiver (assumed itself to be UTF-16 encoded), or the empty string if the referenced BSTR is a null pointer (by convention a null BSTR is treated the same as an empty string)."

	| bstr |
	bstr := bytes uintPtrAtOffset: 0.
	^bstr == 0
		ifTrue: [Utf16String empty]
		ifFalse: [Utf16String fromAddress: bstr length: (OleAut32 sysStringLen: bstr)]!

asUtf8String
	"Answer a `Utf8String` containing the same code points as the UTF-16 encoded BSTR pointed at by the receiver, or the empty string if the referenced BSTR is a null pointer (by convention a null BSTR is treated the same as an empty string)."

	^self asUtf16String asUtf8String!

value
	"Answer the <String> pointed at by the receiver (N.B. it is copied into Smalltalk space)"

	^self asString!

value: aString
	"Replace the <BSTR> at which the receiver points with the <BSTR> representation of the <readableString>
	argument.
	Note that unless the original owner of the BSTR frees the new BSTR, a memory leak will result, since
	this object assumes it does not own the BSTR at which it points, even if it has overwritten it."

	| bstr |
	bstr := bytes uintPtrAtOffset: 0.
	bstr == 0 ifFalse: [OleAut32 sysFreeString: bstr].
	bstr := aString asBSTR.
	"Avoid side effect on argument if it is already a <BSTR>"
	bstr == aString ifTrue: [bstr := bstr copy].
	super value: bstr detach! !

!OS.COM.LPBSTR categoriesForMethods!
asString!converting!public! !
asUtf16String!converting!public! !
asUtf8String!converting!public! !
value!accessing!public! !
value:!accessing!public! !
!

!OS.COM.LPBSTR class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VM registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil! !

!OS.COM.LPBSTR class categoriesForMethods!
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
!

