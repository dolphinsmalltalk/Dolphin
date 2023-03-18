"Filed out from Dolphin Smalltalk"!

External.ExternalArray subclass: #'External.FLOATArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.FLOATArray guid: (Core.GUID fromString: '{87b4c5a3-026e-11d3-9fd7-00a0cc3e4a32}')!
External.FLOATArray comment: 'Specialized `ExternalArray` to represent contiguous single-dimensioned arrays of single-precision (32-bit) floating point numbers.'!
!External.FLOATArray categoriesForClass!External-Data-Structured! !
!External.FLOATArray methodsFor!

closeTo: aNumber
	^self closeTo: aNumber precision: 0.0000001!

closeTo: aSequenceOfNumbers precision: precisionFloat
	aSequenceOfNumbers size = length ifFalse: [^false].
	1 to: length
		do: 
			[:i |
			((self uncheckedAt: i) closeTo: (aSequenceOfNumbers at: i) precision: precisionFloat)
				ifFalse: [^false]].
	^true!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see.
	There are only 6 guaranteed digits of precision in a single-precision float, so we limit output to that so that the string representation would round trip."

	aPuttableStream nextPut: $(.
	self isNull
		ifFalse: 
			[| listSep |
			listSep := aPuttableStream locale listSeparator.
			self do: [:float | float printOn: aPuttableStream significantFigures: 6]
				separatedBy: 
					[aPuttableStream
						nextPutAll: listSep;
						space]].
	aPuttableStream nextPut: $)!

uncheckedAt: anInteger 
	"Private - Answer a <Float> representing the 32-bit single-precision 
	IEEE float at the specified <integer> index in the receiver. No bounds 
	checks are performed on the subscript."

	^bytes floatAtOffset: (anInteger - 1) * VMConstants.FloatSize!

uncheckedAt: anInteger put: aFloat 
	"Private - Replace the single-precision floating point value at the specified index in the receiver
	with the Float argument."

	^bytes floatAtOffset: (anInteger - 1) * VMConstants.FloatSize put: aFloat! !
!External.FLOATArray categoriesForMethods!
closeTo:!comparing!public! !
closeTo:precision:!comparing!public! !
displayOn:!printing!private! !
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.FLOATArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^FLOAT! !
!External.FLOATArray class categoriesForMethods!
elementClass!constants!public! !
!

