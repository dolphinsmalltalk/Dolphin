"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #FORMATRANGE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cpMax _OffsetOf_cpMin _OffsetOf_hdc _OffsetOf_hdcTarget _OffsetOf_rc _OffsetOf_rcPage'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FORMATRANGE guid: (GUID fromString: '{9bdca5bb-f238-4744-a903-f02b32617822}')!
FORMATRANGE addClassConstant: '_OffsetOf_cpMax' value: 16r2C!
FORMATRANGE addClassConstant: '_OffsetOf_cpMin' value: 16r28!
FORMATRANGE addClassConstant: '_OffsetOf_hdc' value: 16r0!
FORMATRANGE addClassConstant: '_OffsetOf_hdcTarget' value: 16r4!
FORMATRANGE addClassConstant: '_OffsetOf_rc' value: 16r8!
FORMATRANGE addClassConstant: '_OffsetOf_rcPage' value: 16r18!
FORMATRANGE comment: 'FORMATRANGE is an <ExternalStructure> class to represent the Win32 structure of the same name.

FORMATRANGE is used in conjunction with the Rich Edit control''s EM_FORMATRANGE message. See the Win32 SDK documentation for further information.'!
!FORMATRANGE categoriesForClass!Unclassified! !
!FORMATRANGE methodsFor!

cpMax: anInteger
	"Set the receiver's 'cpMax' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cpMax put: anInteger!

cpMin: anInteger
	"Set the receiver's 'cpMin' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cpMin put: anInteger!

hdc: anExternalHandle
	"Set the receiver's 'hdc' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hdc put: anExternalHandle!

hdcTarget: anExternalHandle
	"Set the receiver's 'hdcTarget' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hdcTarget put: anExternalHandle!

rc
	"Answer the <RECT> value of the receiver's 'rc' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rc!

rc: aRECT
	"Set the receiver's 'rc' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rc + 1)
		to: ##(_OffsetOf_rc + RECT basicByteSize)
		startingAt: 1!

rcPage
	"Answer the <RECT> value of the receiver's 'rcPage' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rcPage!

rcPage: aRECT
	"Set the receiver's 'rcPage' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rcPage + 1)
		to: ##(_OffsetOf_rcPage + RECT basicByteSize)
		startingAt: 1! !
!FORMATRANGE categoriesForMethods!
cpMax:!**compiled accessors**!public! !
cpMin:!**compiled accessors**!public! !
hdc:!**compiled accessors**!public! !
hdcTarget:!**compiled accessors**!public! !
rc!**compiled accessors**!public! !
rc:!**compiled accessors**!public! !
rcPage!**compiled accessors**!public! !
rcPage:!**compiled accessors**!public! !
!

!FORMATRANGE class methodsFor!

defineFields
	"Define the fields of the Win32 FORMATRANGE structure.

		FORMATRANGE compileDefinition
	"

	self
		defineField: #hdc type: HANDLEField writeOnly;
		defineField: #hdcTarget type: HANDLEField writeOnly;
		defineField: #rc type: (StructureField type: RECT);
		defineField: #rcPage type: (StructureField type: RECT);

		"Expand CHARRANGE inline"
		defineField: #cpMin type: SDWORDField writeOnly;
		defineField: #cpMax type: SDWORDField writeOnly
!

getFieldNames
	^#(#hdc #hdcTarget #rc #rcPage #cpMin #cpMax)! !
!FORMATRANGE class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

