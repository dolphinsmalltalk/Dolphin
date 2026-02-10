"Filed out from Dolphin Smalltalk"!

External.Int64Array
	subclass: #'OS.FILETIMEArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.FILETIMEArray guid: (Core.GUID fromString: '{c4af3bc3-8a67-43c1-94bd-d3347335baa1}')!

OS.FILETIMEArray comment: '`OS.FILETIMEArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of `FILETIME`s.

The values of `FILETIMEArray`s are marshalled to/from `Core.DateAndTime`s.'!

!OS.FILETIMEArray methodsFor!

initializeVariant: anOleVariant
	"Private - Initialize the variant argument to be a vector type holding a copy of the receiver's values. This will be a (VT_ARRAY|VT_DATE), or a (VT_VECTOR|VT_FILETIME)."

	anOleVariant filetimeVector: self!

isSelfEvaluating
	"Could be, but would be very verbose, so eschew for now."

	^false!

uncheckedAt: anInteger
	"Private - Answer a <DateAndTime> equivalent to the <FILETIME> element of the receiver at the specified <integer> index. No bounds checks are performed on the subscript."

	"We can inline the conversion between DateAndTime representation and FILETIME to avoid creating an intermediate FILETIME object."

	^DateAndTime utcSeconds: ((self basicUncheckedAt: anInteger) - FILETIME.SmalltalkEpoch) / 1e7!

uncheckedAt: anInteger put: aDateAndTime
	"Private - Replace the <FILETIME> value at the index specified by the `<integer>` 1st argument with a FILETIME equivalent to the 2nd, <DateAndTime>, argument. No bounds checks are performed on the subscript. "

	"We can inline the conversion between DateAndTime representation and FILETIME to avoid creating an intermediate FILETIME object."

	| filetime |
	filetime := (FILETIME.SmalltalkEpoch + (aDateAndTime asSeconds * 1e7)) truncated.
	(filetime < 0 or: [filetime > Int64.MaxValue])
		ifTrue: 
			[InvalidArgumentError signal: '<1p> is outside the permitted range [0, 2**63-1]' << filetime
				with: 'aDateAndTime'].
	self basicUncheckedAt: anInteger put: filetime.
	^aDateAndTime! !

!OS.FILETIMEArray categoriesForMethods!
initializeVariant:!converting!private! !
isSelfEvaluating!public! !
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!OS.FILETIMEArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^FILETIME! !

!OS.FILETIMEArray class categoriesForMethods!
elementClass!constants!public! !
!

