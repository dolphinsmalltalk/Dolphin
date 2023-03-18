"Filed out from Dolphin Smalltalk"!

OS.BITMAP
	subclass: #'OS.DIBSECTION'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_DIBSECTION_Size' -> 16r54.
			'_OffsetOf_dsBitfields' -> 16r40.
			'_OffsetOf_dsBmih' -> 16r18.
			'_OffsetOf_dshSection' -> 16r4C.
			'_OffsetOf_dsOffset' -> 16r50
		}!
OS.DIBSECTION guid: (Core.GUID fromString: '{87b4c5e7-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.DIBSECTION comment: '<DIBSECTION> is an <ExternalStructure> class to wrap the struct ''Win.DIBSECTION'' from type information in the ''Windows API (ANSI)'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagDIBSECTION {
	BITMAP dsBm;
	BITMAPINFOHEADER dsBmih;
	long dsBitfields[3];
	long dshSection;
	long dsOffset;
} DIBSECTION;
'!
!OS.DIBSECTION categoriesForClass!Win32-Structs! !
!OS.DIBSECTION methodsFor!

biSizeImage
	"Answer the <Integer> value of the receiver's 'BITMAPINFOHEADER.biSizeImage' field."

	^bytes uint32AtOffset: _OffsetOf_dsBmih + BITMAPINFOHEADER._OffsetOf_biSizeImage!

dsBitfields
	"Answer the <UInt32Array> value of the receiver's 'dsBitfields' field."

	^UInt32Array fromAddress: bytes yourAddress + _OffsetOf_dsBitfields length: 3!

dsBmih
	"Answer the <BITMAPINFOHEADER> value of the receiver's 'dsBmih' field."

	^BITMAPINFOHEADER fromAddress: bytes yourAddress + _OffsetOf_dsBmih!

dsBmih: aBITMAPINFOHEADER
	"Set the receiver's 'dsBmih' field to the value of the argument, aBITMAPINFOHEADER"

	aBITMAPINFOHEADER
		replaceBytesOf: bytes
		from: ##(_OffsetOf_dsBmih + 1)
		to: ##(_OffsetOf_dsBmih + BITMAPINFOHEADER._BITMAPINFOHEADER_Size)
		startingAt: 1!

dshSection
	"Answer the <Handle> value of the receiver's 'dshSection' field."

	^(bytes uintPtrAtOffset: _OffsetOf_dshSection) asExternalHandle!

dshSection: aHandle
	"Set the receiver's 'dshSection' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_dshSection put: aHandle!

dsOffset
	"Answer the <Integer> value of the receiver's 'dsOffset' field."

	^bytes uint32AtOffset: _OffsetOf_dsOffset!

dsOffset: anInteger
	"Set the receiver's 'dsOffset' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dsOffset put: anInteger! !
!OS.DIBSECTION categoriesForMethods!
biSizeImage!accessing!public! !
dsBitfields!**compiled accessors**!public! !
dsBmih!**compiled accessors**!public! !
dsBmih:!**compiled accessors**!public! !
dshSection!**compiled accessors**!public! !
dshSection:!**compiled accessors**!public! !
dsOffset!**compiled accessors**!public! !
dsOffset:!**compiled accessors**!public! !
!

!OS.DIBSECTION class methodsFor!

byteSize
	^_DIBSECTION_Size!

defineFields
	"Define the fields of the DIBSECTION structure.
		DIBSECTION compileDefinition
	
		typedef [uuid(87B4C5E7-026E-11D3-9FD7-00A0CC3E4A32)]
		struct tagDIBSECTION {
			BITMAP dsBm;
			BITMAPINFOHEADER dsBmih;
			unsigned long dsBitfields[3];
			HANDLE dshSection;
			unsigned long dsOffset;
		} DIBSECTION;
"

	super defineFields.
	self
		defineField: #dsBmih type: (StructureField type: BITMAPINFOHEADER);
		defineField: #dsBitfields type: (ArrayField type: UInt32Array length: 3) beReadOnly;
		defineField: #dshSection type: HANDLEField new;
		defineField: #dsOffset type: UInt32Field new!

getFieldNames
	^#(#bmType #bmWidth #bmHeight #bmWidthBytes #bmPlanes #bmBitsPixel #bmBits #dsBmih #dsBitfields #dshSection #dsOffset)! !
!OS.DIBSECTION class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

