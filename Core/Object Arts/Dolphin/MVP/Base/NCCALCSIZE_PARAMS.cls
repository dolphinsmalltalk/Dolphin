"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #NCCALCSIZE_PARAMS
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_lppos _OffsetOf_rgrc'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NCCALCSIZE_PARAMS guid: (GUID fromString: '{dbc3695f-4c20-411c-8110-539ce4be4b4a}')!
NCCALCSIZE_PARAMS addClassConstant: '_OffsetOf_lppos' value: 16r30!
NCCALCSIZE_PARAMS addClassConstant: '_OffsetOf_rgrc' value: 16r0!
NCCALCSIZE_PARAMS comment: '<NCCALCSIZE_PARAMS> is an <ExternalStructure> class to wrap the struct ''Win32.NCCALCSIZE_PARAMS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(DBC3695F-4C20-411C-8110-539CE4BE4B4A)]
struct tagNCCALCSIZE_PARAMS {
	RECT rgrc[3];
	WINDOWPOS* lppos;
} NCCALCSIZE_PARAMS;
'!
!NCCALCSIZE_PARAMS categoriesForClass!Win32-Structs! !
!NCCALCSIZE_PARAMS methodsFor!

lppos
	"Answer the <WINDOWPOS> value of the receiver's 'lppos' field."

	^WINDOWPOS fromAddress: (bytes intPtrAtOffset: _OffsetOf_lppos)!

lppos: aWINDOWPOS
	"Set the receiver's 'lppos' field to the value of the argument, aWINDOWPOS"

	bytes uintPtrAtOffset: _OffsetOf_lppos put: aWINDOWPOS yourAddress!

rgrc
	"Answer the <StructureArray> value of the receiver's 'rgrc' field."

	^StructureArray
		fromAddress: bytes yourAddress
		length: 3
		elementClass: RECT!

rgrc: aStructureArrayOfRECT
	"Set the receiver's 'rgrc' field to the value of the argument, aStructureArrayOfRECT"

	| size |
	size := aStructureArrayOfRECT byteSize min: ##(3 * RECT basicByteSize).
	aStructureArrayOfRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rgrc + 1)
		to: size
		startingAt: 1! !
!NCCALCSIZE_PARAMS categoriesForMethods!
lppos!**compiled accessors**!public! !
lppos:!**compiled accessors**!public! !
rgrc!**compiled accessors**!public! !
rgrc:!**compiled accessors**!public! !
!

!NCCALCSIZE_PARAMS class methodsFor!

defineFields
	"Define the fields of the NCCALCSIZE_PARAMS structure.

	NCCALCSIZE_PARAMS  compileDefinition

		typedef [uuid(DBC3695F-4C20-411C-8110-539CE4BE4B4A)]
		struct tagNCCALCSIZE_PARAMS {
			RECT rgrc[3];
			WINDOWPOS* lppos;
		} NCCALCSIZE_PARAMS;
"

	self
		defineField: #rgrc type: (StructureArrayField type: RECT length: 3);
		defineField: #lppos type: (PointerField type: WINDOWPOS)!

getFieldNames
	^#(#rgrc #lppos)! !
!NCCALCSIZE_PARAMS class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

