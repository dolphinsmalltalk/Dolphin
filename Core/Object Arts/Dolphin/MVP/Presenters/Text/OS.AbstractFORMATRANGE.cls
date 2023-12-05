"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.AbstractFORMATRANGE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_hdc' -> 16r0.
			'_OffsetOf_hdcTarget' -> 16r4.
			'_OffsetOf_rc' -> 16r8.
			'_OffsetOf_rcPage' -> 16r18
		}!
OS.AbstractFORMATRANGE guid: (Core.GUID fromString: '{d3259bb1-8876-4dde-b997-5e49c79e4368}')!
OS.AbstractFORMATRANGE isNonInstantiable: true!
OS.AbstractFORMATRANGE comment: ''!
!OS.AbstractFORMATRANGE methodsFor!

cpMax: anInteger
	self subclassResponsibility!

cpMin: anInteger
	self subclassResponsibility!

hdc: aHandle
	"Set the receiver's 'hdc' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hdc put: aHandle!

hdcTarget: aHandle
	"Set the receiver's 'hdcTarget' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hdcTarget put: aHandle!

rc
	"Answer the <RECTL> value of the receiver's 'rc' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rc!

rc: aRECTL
	"Set the receiver's 'rc' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rc + 1)
		to: ##(_OffsetOf_rc + RECTL._RECTL_Size)
		startingAt: 1!

rcPage
	"Answer the <RECTL> value of the receiver's 'rcPage' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rcPage!

rcPage: aRECTL
	"Set the receiver's 'rcPage' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcPage + 1)
		to: ##(_OffsetOf_rcPage + RECTL._RECTL_Size)
		startingAt: 1! !
!OS.AbstractFORMATRANGE categoriesForMethods!
cpMax:!public! !
cpMin:!public! !
hdc:!**compiled accessors**!public! !
hdcTarget:!**compiled accessors**!public! !
rc!**compiled accessors**!public! !
rc:!**compiled accessors**!public! !
rcPage!**compiled accessors**!public! !
rcPage:!**compiled accessors**!public! !
!

!OS.AbstractFORMATRANGE class methodsFor!

defineFields
	"Define the common fields of the FORMATRANGE and similar structures.

		AbstractFORMATRANGE compileDefinition
	"

	self
		defineField: #hdc type: HANDLEField writeOnly;
		defineField: #hdcTarget type: HANDLEField writeOnly;
		defineField: #rc type: (StructureField type: RECTL);
		defineField: #rcPage type: (StructureField type: RECTL)! !
!OS.AbstractFORMATRANGE class categoriesForMethods!
defineFields!public!template definition! !
!

