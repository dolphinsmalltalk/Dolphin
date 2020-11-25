"Filed out from Dolphin Smalltalk 7"!

LPVOID subclass: #LPBSTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LPBSTR guid: (GUID fromString: '{8ed55b71-d72d-4df1-a211-434db718fef0}')!
LPBSTR comment: 'LPBSTR is a class to represent pointers to BSTRs (Basic Strings). It is useful where an IDispatch method requires that a BSTR argument be passed by references, or when implement such a method as a means of returning a BSTR reference.

LPBSTR implicitly converts to the referenced string when asked for its value, rather than answering the pointer value itself.

For example:

	bstr := ''abc'' asBSTR.				"Ctrl+E"
	(LPBSTR fromAddress: bstr basicYourAddress) 	"Ctrl+D"

Note that because BSTR is an indirection class (BSTRs are pointers to strings), it is necessary to send its instances #basicYourAddress to get the address of the object, rather than #yourAddress which will return the contained address.
'!
!LPBSTR categoriesForClass!External-Data-Unstructured! !
!LPBSTR methodsFor!

asString
	"Answer a `String` composed of the characters of the receiver, or the empty string if the receiver is a null pointer."

	^self asUtf16String!

asUtf16String
	"Answer a `Utf16String` composed of the characters of the BSTR pointed at by the receiver (assumed itself to be UTF-16 encoded), or the empty string if the referenced BSTR is a null pointer (by convention a null BSTR is treated the same as an empty string)."

	| bstr |
	bstr := bytes uintPtrAtOffset: 0.
	^bstr == 0
		ifTrue: [Utf16String empty]
		ifFalse: [Utf16String fromAddress: bstr length: (OLEAutLibrary default sysStringLen: bstr)]!

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
	bstr == 0 ifFalse: [OLEAutLibrary default sysFreeString: bstr].
	bstr := aString asBSTR.
	"Avoid side effect on argument if it is already a <BSTR>"
	bstr == aString ifTrue: [bstr := bstr copy].
	super value: bstr detach! !
!LPBSTR categoriesFor: #asString!converting!public! !
!LPBSTR categoriesFor: #asUtf16String!converting!public! !
!LPBSTR categoriesFor: #asUtf8String!converting!public! !
!LPBSTR categoriesFor: #value!accessing!public! !
!LPBSTR categoriesFor: #value:!accessing!public! !

!LPBSTR class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!LPBSTR class categoriesFor: #initialize!development!initializing!private! !
!LPBSTR class categoriesFor: #uninitialize!class hierarchy-removing!private! !

