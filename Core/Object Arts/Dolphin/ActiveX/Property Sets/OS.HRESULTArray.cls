"Filed out from Dolphin Smalltalk"!

External.Int32Array
	subclass: #'OS.HRESULTArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.HRESULTArray guid: (Core.GUID fromString: '{7a3460f8-2199-467c-b647-fe301c38b5b3}')!

OS.HRESULTArray comment: '`HRESULArray` is a specialized `ExternalArray` to represent contiguous single-dimensioned arrays of `HRESULT` codes, which are 32-bit integer status or error codes with values and meanings defined by the OS or some external component or subsystem.'!

!OS.HRESULTArray methodsFor!

initializeVariant: anOleVariant
	"Private - Initialize the variant argument to be a vector type holding a copy of the receiver's values. This will be a (VT_ARRAY|VT_ERROR), or a (VT_VECTOR|VT_ERROR)."

	anOleVariant hresultVector: self!

isSelfEvaluating
	"Could be, but would be very verbose, so eschew for now."

	^false!

uncheckedAt: anInteger
	^HRESULT fromInteger: (self basicUncheckedAt: anInteger)! !

!OS.HRESULTArray categoriesForMethods!
initializeVariant:!converting!private! !
isSelfEvaluating!public!testing! !
uncheckedAt:!accessing!private! !
!

!OS.HRESULTArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^HRESULT! !

!OS.HRESULTArray class categoriesForMethods!
elementClass!constants!public! !
!

