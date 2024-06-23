"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.NCCALCSIZE_PARAMS'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_NCCALCSIZE_PARAMS_Size' -> 16r34.
			'_OffsetOf_lppos' -> 16r30.
			'_OffsetOf_rgrc' -> 16r0
		}!

OS.NCCALCSIZE_PARAMS guid: (Core.GUID fromString: '{dbc3695f-4c20-411c-8110-539ce4be4b4a}')!

OS.NCCALCSIZE_PARAMS comment: '<NCCALCSIZE_PARAMS> is an <ExternalStructure> class to wrap the struct ''Win32.NCCALCSIZE_PARAMS'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(DBC3695F-4C20-411C-8110-539CE4BE4B4A)]
struct tagNCCALCSIZE_PARAMS {
	RECT rgrc[3];
	WINDOWPOS* lppos;
} NCCALCSIZE_PARAMS;
'!

!OS.NCCALCSIZE_PARAMS categoriesForClass!Win32-Structs! !

!OS.NCCALCSIZE_PARAMS methodsFor!

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
		elementClass: RECTL!

rgrc: aStructureArrayOfRECTL
	"Set the receiver's 'rgrc' field to the value of the argument, aStructureArrayOfRECTL"

	| size |
	size := aStructureArrayOfRECTL byteSize min: ##(3 * RECTL._RECTL_Size).
	aStructureArrayOfRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rgrc + 1)
		to: size
		startingAt: 1! !

!OS.NCCALCSIZE_PARAMS categoriesForMethods!
lppos!**compiled accessors**!public! !
lppos:!**compiled accessors**!public! !
rgrc!**compiled accessors**!public! !
rgrc:!**compiled accessors**!public! !
!

!OS.NCCALCSIZE_PARAMS class methodsFor!

byteSize
	^_NCCALCSIZE_PARAMS_Size!

defineFields
	"Define the fields of the NCCALCSIZE_PARAMS structure.

	NCCALCSIZE_PARAMS  compileDefinition

		typedef [uuid(DBC3695F-4C20-411C-8110-539CE4BE4B4A)]
		struct tagNCCALCSIZE_PARAMS {
			RECTL rgrc[3];
			WINDOWPOS* lppos;
		} NCCALCSIZE_PARAMS;
"

	self
		defineField: #rgrc type: (StructureArrayField type: RECTL length: 3);
		defineField: #lppos type: (PointerField type: WINDOWPOS)!

getFieldNames
	^#(#rgrc #lppos)! !

!OS.NCCALCSIZE_PARAMS class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

