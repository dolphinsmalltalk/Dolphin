"Filed out from Dolphin Smalltalk"!

External.StringPointerArray
	subclass: #'External.AnsiStringArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.AnsiStringArray guid: (Core.GUID fromString: '{4e610671-5ba6-4acd-a055-ea74c749336d}')!

External.AnsiStringArray comment: '`AnsiStringArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of pointers to `AnsiString`s.  Both the body of the array and the strings themselves are allocated in the Smalltalk heap, and so the ownership of instances cannot be passed directly to external components. See also `LPSTRArray`, which differs in employing COM task heap memory for the strings and array body.'!

!External.AnsiStringArray methodsFor!

stringClass
	^AnsiString! !

!External.AnsiStringArray categoriesForMethods!
stringClass!constants!private! !
!

!External.AnsiStringArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^LPSTR! !

!External.AnsiStringArray class categoriesForMethods!
elementClass!constants!public! !
!

