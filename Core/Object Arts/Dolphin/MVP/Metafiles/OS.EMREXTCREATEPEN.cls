"Filed out from Dolphin Smalltalk 7"!

OS.ENHMETARECORD subclass: #'OS.EMREXTCREATEPEN'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cbBits' -> 16r18.
		'_OffsetOf_cbBmi' -> 16r10.
		'_OffsetOf_elp' -> 16r1C.
		'_OffsetOf_ihPen' -> 16r8.
		'_OffsetOf_offBits' -> 16r14.
		'_OffsetOf_offBmi' -> 16rC
	}!
OS.EMREXTCREATEPEN guid: (Core.GUID fromString: '{797b4380-74af-4163-8248-87bca7b9a3f4}')!
OS.EMREXTCREATEPEN comment: '<EMREXTCREATEPEN> is an <ExternalStructure> class to wrap the struct ''Win32.EMREXTCREATEPEN'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(797B4380-74AF-4163-8248-87BCA7B9A3F4)]
struct tagEMREXTCREATEPEN {
	EMR EMR;
	[helpstring("Pen handle index")] DWORD ihPen;
	[helpstring("Offset to the BITMAPINFO structure if any")] DWORD offBmi;
	[helpstring("Size of the BITMAPINFO structure if any. The bitmap info is followed by the bitmap bits to form a packed DIB.")] DWORD cbBmi;
	[helpstring("Offset to the brush bitmap bits if any")] DWORD offBits;
	[helpstring("Size of the brush bitmap bits if any")] DWORD cbBits;
	[helpstring("The extended pen with the style array.")] EXTLOGPEN elp;
} EMREXTCREATEPEN;
'!
!OS.EMREXTCREATEPEN categoriesForClass!Win32-Structs! !
!OS.EMREXTCREATEPEN methodsFor!

cbBits
	"Answer the <Integer> value of the receiver's 'cbBits' field."

	^bytes dwordAtOffset: _OffsetOf_cbBits!

cbBits: anInteger
	"Set the receiver's 'cbBits' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBits put: anInteger!

cbBmi
	"Answer the <Integer> value of the receiver's 'cbBmi' field."

	^bytes dwordAtOffset: _OffsetOf_cbBmi!

cbBmi: anInteger
	"Set the receiver's 'cbBmi' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_cbBmi put: anInteger!

elp
	"Answer the <EXTLOGPEN> value of the receiver's 'elp' field."

	^EXTLOGPEN fromAddress: bytes yourAddress + _OffsetOf_elp!

elp: anEXTLOGPEN
	"Set the receiver's 'elp' field to the value of the argument, anEXTLOGPEN"

	anEXTLOGPEN
		replaceBytesOf: bytes
		from: ##(_OffsetOf_elp + 1)
		to: ##(_OffsetOf_elp + EXTLOGPEN basicByteSize)
		startingAt: 1!

ihPen
	"Answer the <Integer> value of the receiver's 'ihPen' field."

	^bytes dwordAtOffset: _OffsetOf_ihPen!

ihPen: anInteger
	"Set the receiver's 'ihPen' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ihPen put: anInteger!

offBits
	"Answer the <Integer> value of the receiver's 'offBits' field."

	^bytes dwordAtOffset: _OffsetOf_offBits!

offBits: anInteger
	"Set the receiver's 'offBits' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBits put: anInteger!

offBmi
	"Answer the <Integer> value of the receiver's 'offBmi' field."

	^bytes dwordAtOffset: _OffsetOf_offBmi!

offBmi: anInteger
	"Set the receiver's 'offBmi' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_offBmi put: anInteger! !
!OS.EMREXTCREATEPEN categoriesFor: #cbBits!**compiled accessors**!public! !
!OS.EMREXTCREATEPEN categoriesFor: #cbBits:!**compiled accessors**!public! !
!OS.EMREXTCREATEPEN categoriesFor: #cbBmi!**compiled accessors**!public! !
!OS.EMREXTCREATEPEN categoriesFor: #cbBmi:!**compiled accessors**!public! !
!OS.EMREXTCREATEPEN categoriesFor: #elp!**compiled accessors**!public! !
!OS.EMREXTCREATEPEN categoriesFor: #elp:!**compiled accessors**!public! !
!OS.EMREXTCREATEPEN categoriesFor: #ihPen!**compiled accessors**!public! !
!OS.EMREXTCREATEPEN categoriesFor: #ihPen:!**compiled accessors**!public! !
!OS.EMREXTCREATEPEN categoriesFor: #offBits!**compiled accessors**!public! !
!OS.EMREXTCREATEPEN categoriesFor: #offBits:!**compiled accessors**!public! !
!OS.EMREXTCREATEPEN categoriesFor: #offBmi!**compiled accessors**!public! !
!OS.EMREXTCREATEPEN categoriesFor: #offBmi:!**compiled accessors**!public! !

!OS.EMREXTCREATEPEN class methodsFor!

defineFields
	"Define the fields of the EMREXTCREATEPEN structure.

	EMREXTCREATEPEN  compileDefinition

		typedef [uuid(797B4380-74AF-4163-8248-87BCA7B9A3F4)]
		struct tagEMREXTCREATEPEN {
			EMR EMR;
			[helpstring('Pen handle index')] DWORD ihPen;
			[helpstring('Offset to the BITMAPINFO structure if any')] DWORD offBmi;
			[helpstring('Size of the BITMAPINFO structure if any. The bitmap info is followed by the bitmap bits to form a packed DIB.')] DWORD cbBmi;
			[helpstring('Offset to the brush bitmap bits if any')] DWORD offBits;
			[helpstring('Size of the brush bitmap bits if any')] DWORD cbBits;
			[helpstring('The extended pen with the style array.')] EXTLOGPEN elp;
		} EMREXTCREATEPEN;
"

	super defineFields.
	self
		defineField: #ihPen
			type: DWORDField new
			offset: 8;
		defineField: #offBmi
			type: DWORDField new
			offset: 12;
		defineField: #cbBmi
			type: DWORDField new
			offset: 16;
		defineField: #offBits
			type: DWORDField new
			offset: 20;
		defineField: #cbBits
			type: DWORDField new
			offset: 24;
		defineField: #elp
			type: (StructureField type: EXTLOGPEN)
			offset: 28.
	self byteSize: 56!

getFieldNames
	^#(#iType #nSize #ihPen #offBmi #cbBmi #offBits #cbBits #elp)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_EXTCREATEPEN}! !
!OS.EMREXTCREATEPEN class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.EMREXTCREATEPEN class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.EMREXTCREATEPEN class categoriesFor: #iTypes!constants!public! !

