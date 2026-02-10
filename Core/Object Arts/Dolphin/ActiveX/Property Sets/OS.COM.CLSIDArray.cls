"Filed out from Dolphin Smalltalk"!

External.GUIDArray
	subclass: #'OS.COM.CLSIDArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.CLSIDArray guid: (Core.GUID fromString: '{13765b0a-4851-44ad-8c51-a04c650310cd}')!

OS.COM.CLSIDArray comment: '`OS.COM.CLSIDArray` is a specialized `GUIDArray` to represent contiguous single-dimensioned arrays of `OS.COM.CLSID` values.'!

!OS.COM.CLSIDArray methodsFor!

asSAFEARRAY
	"Answer the <SAFEARRAY> representation of the receiver."

	^COM.SAFEARRAY withAll: self recordClass: self elementClass!

initializeVariant: aVariant
	"Private - Initialize the variant argument to be a vector type holding a copy of the receiver's values. This will be either a (VT_ARRAY|VT_RECORD) of CLSID records, or a (VT_VECTOR|VT_CLSID)."

	aVariant clsidVector: self! !

!OS.COM.CLSIDArray categoriesForMethods!
asSAFEARRAY!converting!public! !
initializeVariant:!converting!private! !
!

!OS.COM.CLSIDArray class methodsFor!

elementClass
	^CLSID! !

!OS.COM.CLSIDArray class categoriesForMethods!
elementClass!constants!public! !
!

