"Filed out from Dolphin Smalltalk"!

External.UIntPtrArray
	subclass: #'External.StringPointerArray'
	instanceVariableNames: 'strings'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.StringPointerArray guid: (Core.GUID fromString: '{73470ba4-9a74-4b8c-b703-96514c60d9d0}')!

External.StringPointerArray isNonInstantiable: true!

External.StringPointerArray comment: '`StringPointerArray` is a abstract class of `ExternalArray`s to represent contiguous single-dimensioned arrays of pointers to `String`s.  Both the body of the array and the strings themselves are allocated in the Smalltalk heap, and so the ownership of instances cannot be passed directly to external components. There are concrete subclasses to represent strings with all the supported encodings.'!

!External.StringPointerArray methodsFor!

basicLength: anInteger
	super basicLength: anInteger.
	strings ifNil: [strings := Array new: anInteger] ifNotNil: [strings resize: anInteger].
	^self!

postCopy
	super postCopy.
	strings := strings copy.
	^self!

stringClass
	^self subclassResponsibility!

uncheckedAt: anInteger
	"Private - Answer a <String> representing the element of the receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	^self stringClass fromAddress: (self basicUncheckedAt: anInteger)!

uncheckedAt: indexInteger put: aString
	| string |
	string := self stringClass coerceString: aString.
	self basicUncheckedAt: indexInteger put: (strings at: indexInteger put: string) yourAddress.
	^string! !

!External.StringPointerArray categoriesForMethods!
basicLength:!public! !
postCopy!copying!public! !
stringClass!constants!private! !
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

