"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.FORMATRANGE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_FORMATRANGE_Size' -> 16r30.
		'_OffsetOf_cpMax' -> 16r2C.
		'_OffsetOf_cpMin' -> 16r28.
		'_OffsetOf_hdc' -> 16r0.
		'_OffsetOf_hdcTarget' -> 16r4.
		'_OffsetOf_rc' -> 16r8.
		'_OffsetOf_rcPage' -> 16r18
	}!
OS.FORMATRANGE guid: (Core.GUID fromString: '{9bdca5bb-f238-4744-a903-f02b32617822}')!
OS.FORMATRANGE comment: 'FORMATRANGE is an <ExternalStructure> class to represent the Win32 structure of the same name.

FORMATRANGE is used in conjunction with the Rich Edit control''s EM_FORMATRANGE message. See the Win32 SDK documentation for further information.'!
!OS.FORMATRANGE categoriesForClass!Unclassified! !
!OS.FORMATRANGE methodsFor!

cpMax: anInteger
	"Set the receiver's 'cpMax' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cpMax put: anInteger!

cpMin: anInteger
	"Set the receiver's 'cpMin' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cpMin put: anInteger!

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
!OS.FORMATRANGE categoriesForMethods!
cpMax:!**compiled accessors**!public! !
cpMin:!**compiled accessors**!public! !
hdc:!**compiled accessors**!public! !
hdcTarget:!**compiled accessors**!public! !
rc!**compiled accessors**!public! !
rc:!**compiled accessors**!public! !
rcPage!**compiled accessors**!public! !
rcPage:!**compiled accessors**!public! !
!

!OS.FORMATRANGE class methodsFor!

byteSize
	^_FORMATRANGE_Size!

defineFields
	"Define the fields of the Win32 FORMATRANGE structure.

		FORMATRANGE compileDefinition
	"

	self
		defineField: #hdc type: HANDLEField writeOnly;
		defineField: #hdcTarget type: HANDLEField writeOnly;
		defineField: #rc type: (StructureField type: RECTL);
		defineField: #rcPage type: (StructureField type: RECTL);
		defineField: #cpMin type: SDWORDField writeOnly;
		defineField: #cpMax type: SDWORDField writeOnly

	"Expand CHARRANGE inline"!

getFieldNames
	^#(#hdc #hdcTarget #rc #rcPage #cpMin #cpMax)! !
!OS.FORMATRANGE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

