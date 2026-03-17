"Filed out from Dolphin Smalltalk"!

External.LPSZ
	subclass: #'OS.COM.LPBSTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.COM.OleVariant private})
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

deepCopy
	"Answer a 'deep copy' of the receiver, in this case a copy of the dereferenced <BSTR>."

	| bstr copy |
	bstr := bytes uintPtrAtOffset: 0.
	^bstr == 0
		ifTrue: [BSTR new]
		ifFalse: 
			[
			"We use `SysAllocStringLen` as the BSTR may contain null characters"
			copy := OleAut32 sysAllocStringLen: bstr len: (OleAut32 sysStringLen: bstr).
			copy
				beFinalizable;
				yourself]!

value
	"Answer the <String> pointed at by the receiver (N.B. it is copied into Smalltalk space)"

	| bstr |
	bstr := bytes uintPtrAtOffset: 0.
	^bstr == 0
		ifTrue: [Utf16String.Empty]
		ifFalse: [Utf16String fromAddress: bstr length: (OleAut32 sysStringLen: bstr)]!

value: aString
	"Replace the <BSTR> at which the receiver points with the <BSTR> representation of the <readableString> argument.
	Note that unless the original owner of the BSTR frees the new BSTR, a memory leak will result, since this object assumes it does not own the BSTR at which it points, even if it has overwritten it."

	| bstr |
	bstr := bytes uintPtrAtOffset: 0.
	bstr == 0 ifFalse: [OleAut32 sysFreeString: bstr].
	bstr := aString asBSTR.
	"Avoid side effect on argument if it is already a <BSTR>"
	bstr == aString ifTrue: [bstr := bstr copy].
	super value: bstr detach! !

!OS.COM.LPBSTR categoriesForMethods!
deepCopy!copying!public! !
value!accessing!public! !
value:!accessing!public! !
!

!OS.COM.LPBSTR class methodsFor!

allocHeapObject: aString
	"Private - Allocate and initialize an external representation (in this case a BSTR) of the characters of the <String> argument."

	| bstr |
	bstr := aString asBSTR.
	^bstr == aString ifTrue: [bstr copy] ifFalse: [bstr]!

freeHeapObject: aBSTR
	aBSTR isNull ifFalse: [OleAut32 sysFreeString: aBSTR]!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VM registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VM registryAt: self name put: nil!

variantVectorName
	"Private - Answer the symbolic name of the accessor for a variant holding a vector of the receiver's element type."

	^#bstrVector!

vt
	^VT_BSTR! !

!OS.COM.LPBSTR class categoriesForMethods!
allocHeapObject:!instance creation!private! !
freeHeapObject:!initialize/release!private! !
initialize!development!initializing!private! !
uninitialize!class hierarchy-removing!private! !
variantVectorName!constants!private! !
vt!public! !
!

