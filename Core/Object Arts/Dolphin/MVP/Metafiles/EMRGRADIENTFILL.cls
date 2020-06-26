"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMRGRADIENTFILL
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_nTri' -> 16r1C.
		'_OffsetOf_nVer' -> 16r18.
		'_OffsetOf_rclBounds' -> 16r8.
		'_OffsetOf_ulMode' -> 16r20.
		'_OffsetOf_Ver' -> 16r24
	}!
EMRGRADIENTFILL guid: (GUID fromString: '{1302823f-242e-4301-b5eb-ee7a20a4b787}')!
EMRGRADIENTFILL comment: '<EMRGRADIENTFILL> is an <ExternalStructure> class to wrap the struct ''Win32.EMRGRADIENTFILL'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!EMRGRADIENTFILL categoriesForClass!Win32-Structs! !
!EMRGRADIENTFILL methodsFor!

nTri
	"Answer the <Integer> value of the receiver's 'nTri' field."

	^bytes dwordAtOffset: _OffsetOf_nTri!

nTri: anInteger
	"Set the receiver's 'nTri' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nTri put: anInteger!

nVer
	"Answer the <Integer> value of the receiver's 'nVer' field."

	^bytes dwordAtOffset: _OffsetOf_nVer!

nVer: anInteger
	"Set the receiver's 'nVer' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_nVer put: anInteger!

rclBounds
	"Answer the <RECT> value of the receiver's 'rclBounds' field."

	^RECT fromAddress: bytes yourAddress + _OffsetOf_rclBounds!

rclBounds: aRECT
	"Set the receiver's 'rclBounds' field to the value of the argument, aRECT"

	aRECT
		replaceBytesOf: bytes
		from: ##(_OffsetOf_rclBounds + 1)
		to: ##(_OffsetOf_rclBounds + RECT basicByteSize)
		startingAt: 1!

ulMode
	"Answer the <Integer> value of the receiver's 'ulMode' field."

	^bytes dwordAtOffset: _OffsetOf_ulMode!

ulMode: anInteger
	"Set the receiver's 'ulMode' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ulMode put: anInteger!

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
!EMRGRADIENTFILL categoriesFor: #nTri!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #nTri:!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #nVer!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #nVer:!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #rclBounds!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #rclBounds:!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #ulMode!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #ulMode:!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #Ver!**compiled accessors**!public! !
!EMRGRADIENTFILL categoriesFor: #Ver:!**compiled accessors**!public! !

!EMRGRADIENTFILL class methodsFor!

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
			type: (StructureField type: RECT)
			offset: 8;
		defineField: #nVer
			type: DWORDField new
			offset: 24;
		defineField: #nTri
			type: DWORDField new
			offset: 28;
		defineField: #ulMode
			type: DWORDField new
			offset: 32;
		defineField: #Ver
			type: (StructureArrayField type: TRIVERTEX lengthField: #nVer)
			offset: 36!

getFieldNames
	^#(#iType #nSize #rclBounds #nVer #nTri #ulMode #Ver)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_GRADIENTFILL}! !
!EMRGRADIENTFILL class categoriesFor: #defineFields!public!template definition! !
!EMRGRADIENTFILL class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMRGRADIENTFILL class categoriesFor: #iTypes!constants!public! !

