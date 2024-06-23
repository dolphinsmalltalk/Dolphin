"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRGRADIENTFILL'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_EMRGRADIENTFILL_Size' -> 16r34.
			'_OffsetOf_nTri' -> 16r1C.
			'_OffsetOf_nVer' -> 16r18.
			'_OffsetOf_rclBounds' -> 16r8.
			'_OffsetOf_ulMode' -> 16r20.
			'_OffsetOf_Ver' -> 16r24
		}!

OS.EMRGRADIENTFILL guid: (Core.GUID fromString: '{1302823f-242e-4301-b5eb-ee7a20a4b787}')!

OS.EMRGRADIENTFILL comment: '<EMRGRADIENTFILL> is an <ExternalStructure> class to wrap the struct ''Win32.EMRGRADIENTFILL'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(1302823F-242E-4301-B5EB-EE7A20A4B787)]
struct tagEMRGRADIENTFILL {
	EMR EMR;
	[helpstring("Inclusive-inclusive bounds in device units")] RECTL rclBounds;
	DWORD nVer;
	DWORD nTri;
	ULONG ulMode;
	TRIVERTEX Ver[1];
} EMRGRADIENTFILL;
'!

!OS.EMRGRADIENTFILL categoriesForClass!Win32-Structs! !

!OS.EMRGRADIENTFILL methodsFor!

nTri
	"Answer the <Integer> value of the receiver's 'nTri' field."

	^bytes uint32AtOffset: _OffsetOf_nTri!

nTri: anInteger
	"Set the receiver's 'nTri' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nTri put: anInteger!

nVer
	"Answer the <Integer> value of the receiver's 'nVer' field."

	^bytes uint32AtOffset: _OffsetOf_nVer!

nVer: anInteger
	"Set the receiver's 'nVer' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_nVer put: anInteger!

rclBounds
	"Answer the <RECTL> value of the receiver's 'rclBounds' field."

	^RECTL fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECTL
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECTL"

	aRECTL
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECTL._RECTL_Size)
		startingAt: 1!

ulMode
	"Answer the <Integer> value of the receiver's 'ulMode' field."

	^bytes uint32AtOffset: _OffsetOf_ulMode!

ulMode: anInteger
	"Set the receiver's 'ulMode' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ulMode put: anInteger!

Ver
	"Answer the <StructureArray> value of the receiver's 'Ver' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_Ver
		length: self nVer
		elementClass: TRIVERTEX!

Ver: aStructureArrayOfTRIVERTEX
	"Set the receiver's 'Ver' field to the value of the argument, aStructureArrayOfTRIVERTEX"

	| size |
	size := aStructureArrayOfTRIVERTEX byteSize.
	aStructureArrayOfTRIVERTEX
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Ver + 1)
		to: _OffsetOf_Ver + size
		startingAt: 1.
	self nVer: aStructureArrayOfTRIVERTEX size! !

!OS.EMRGRADIENTFILL categoriesForMethods!
nTri!**compiled accessors**!public! !
nTri:!**compiled accessors**!public! !
nVer!**compiled accessors**!public! !
nVer:!**compiled accessors**!public! !
rclBounds!**compiled accessors**!public! !
rclBounds:!**compiled accessors**!public! !
ulMode!**compiled accessors**!public! !
ulMode:!**compiled accessors**!public! !
Ver!**compiled accessors**!public! !
Ver:!**compiled accessors**!public! !
!

!OS.EMRGRADIENTFILL class methodsFor!

byteSize
	^_EMRGRADIENTFILL_Size!

defineFields
	"Define the fields of the EMRGRADIENTFILL structure.

	EMRGRADIENTFILL  compileDefinition

		typedef [uuid(1302823F-242E-4301-B5EB-EE7A20A4B787)]
		struct tagEMRGRADIENTFILL {
			EMR EMR;
			[helpstring('Inclusive-inclusive bounds in device units')] RECTL rclBounds;
			DWORD nVer;
			DWORD nTri;
			ULONG ulMode;
			[size_is(nVer)]TRIVERTEX Ver[];
		} EMRGRADIENTFILL;
"

	super defineFields.
	self
		defineField: #rclBounds
			type: (StructureField type: RECTL)
			offset: 8;
		defineField: #nVer
			type: UInt32Field new
			offset: 24;
		defineField: #nTri
			type: UInt32Field new
			offset: 28;
		defineField: #ulMode
			type: UInt32Field new
			offset: 32;
		defineField: #Ver
			type: (StructureArrayField type: TRIVERTEX lengthField: #nVer)
			offset: 36!

getFieldNames
	^#(#iType #nSize #rclBounds #nVer #nTri #ulMode #Ver)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_GRADIENTFILL}! !

!OS.EMRGRADIENTFILL class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

