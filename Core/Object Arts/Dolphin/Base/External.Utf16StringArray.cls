"Filed out from Dolphin Smalltalk"!

External.StringPointerArray
	subclass: #'External.Utf16StringArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Utf16StringArray guid: (Core.GUID fromString: '{50589481-d326-4a2f-9c9a-d109fa6070fe}')!

External.Utf16StringArray comment: '`Utf16StringArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of pointers to `Utf16String`s.  Both the body of the array and the strings themselves are allocated in the Smalltalk heap, and so the ownership of instances cannot be passed directly to external components. See also `LPWSTRArray`, which differs in employing COM task heap memory for the strings and array body.'!

!External.Utf16StringArray methodsFor!

stringClass
	^Utf16String! !

!External.Utf16StringArray categoriesForMethods!
stringClass!constants!private! !
!

!External.Utf16StringArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^LPWSTR! !

!External.Utf16StringArray class categoriesForMethods!
elementClass!constants!public! !
!

