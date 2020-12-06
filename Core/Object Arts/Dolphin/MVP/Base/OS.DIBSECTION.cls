"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.DIBSECTION'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dsBitfields' -> 16r40.
		'_OffsetOf_dsBm' -> 16r0.
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

dsBitfields
	"Answer the <DWORDArray> value of the receiver's 'dsBitfields' field."

	^DWORDArray fromAddress: bytes yourAddress + _OffsetOf_dsBitfields length: 3!

dsBm
	"Answer the <BITMAP> value of the receiver's 'dsBm' field."

	^BITMAP fromAddress: bytes yourAddress!

dsBm: aBITMAP
	"Set the receiver's 'dsBm' field to the value of the argument, aBITMAP"

	aBITMAP
		replaceBytesOf: bytes
		from: ##(_OffsetOf_dsBm + 1)
		to: ##(_OffsetOf_dsBm + BITMAP basicByteSize)
		startingAt: 1!

dsBmih
	"Answer the <BITMAPINFOHEADER> value of the receiver's 'dsBmih' field."

	^BITMAPINFOHEADER fromAddress: bytes yourAddress + _OffsetOf_dsBmih!

dsBmih: aBITMAPINFOHEADER
	"Set the receiver's 'dsBmih' field to the value of the argument, aBITMAPINFOHEADER"

	aBITMAPINFOHEADER
		replaceBytesOf: bytes
		from: ##(_OffsetOf_dsBmih + 1)
		to: ##(_OffsetOf_dsBmih + BITMAPINFOHEADER basicByteSize)
		startingAt: 1!

dshSection
	"Answer the <ExternalHandle> value of the receiver's 'dshSection' field."

	^(bytes uintPtrAtOffset: _OffsetOf_dshSection) asExternalHandle!

dshSection: anExternalHandle
	"Set the receiver's 'dshSection' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_dshSection put: anExternalHandle!

dsOffset
	"Answer the <Integer> value of the receiver's 'dsOffset' field."

	^bytes dwordAtOffset: _OffsetOf_dsOffset!

dsOffset: anInteger
	"Set the receiver's 'dsOffset' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dsOffset put: anInteger! !
!OS.DIBSECTION categoriesFor: #dsBitfields!**compiled accessors**!public! !
!OS.DIBSECTION categoriesFor: #dsBm!**compiled accessors**!public! !
!OS.DIBSECTION categoriesFor: #dsBm:!**compiled accessors**!public! !
!OS.DIBSECTION categoriesFor: #dsBmih!**compiled accessors**!public! !
!OS.DIBSECTION categoriesFor: #dsBmih:!**compiled accessors**!public! !
!OS.DIBSECTION categoriesFor: #dshSection!**compiled accessors**!public! !
!OS.DIBSECTION categoriesFor: #dshSection:!**compiled accessors**!public! !
!OS.DIBSECTION categoriesFor: #dsOffset!**compiled accessors**!public! !
!OS.DIBSECTION categoriesFor: #dsOffset:!**compiled accessors**!public! !

!OS.DIBSECTION class methodsFor!

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

	self
		defineField: #dsBm type: (StructureField type: BITMAP);
		defineField: #dsBmih type: (StructureField type: BITMAPINFOHEADER);
		defineField: #dsBitfields type: (ArrayField type: DWORDArray length: 3) beReadOnly;
		defineField: #dshSection type: HANDLEField new;
		defineField: #dsOffset type: DWORDField new!

getFieldNames
	^#(#dsBm #dsBmih #dsBitfields #dshSection #dsOffset)! !
!OS.DIBSECTION class categoriesFor: #defineFields!public!template definition! !
!OS.DIBSECTION class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

