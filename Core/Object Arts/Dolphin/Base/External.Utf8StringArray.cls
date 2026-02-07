"Filed out from Dolphin Smalltalk"!

External.StringPointerArray
	subclass: #'External.Utf8StringArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.Utf8StringArray guid: (Core.GUID fromString: '{276ea702-2303-4e11-8d13-a8288de69b78}')!

External.Utf8StringArray comment: '`Utf8StringArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of pointers to `Utf8String`s.  Both the body of the array and the strings themselves are allocated in the Smalltalk heap, and so the ownership of instances cannot be passed directly to external components.'!

!External.Utf8StringArray methodsFor!

stringClass
	^Utf8String! !

!External.Utf8StringArray categoriesForMethods!
stringClass!constants!private! !
!

