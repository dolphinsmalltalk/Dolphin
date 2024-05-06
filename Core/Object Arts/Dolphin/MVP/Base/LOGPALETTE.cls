"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #LOGPALETTE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_palNumEntries _OffsetOf_palPalEntry _OffsetOf_palVersion'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

LOGPALETTE guid: (GUID fromString: '{87b4c5fa-026e-11d3-9fd7-00a0cc3e4a32}')!

LOGPALETTE addClassConstant: '_OffsetOf_palNumEntries' value: 16r2!
LOGPALETTE addClassConstant: '_OffsetOf_palPalEntry' value: 16r4!
LOGPALETTE addClassConstant: '_OffsetOf_palVersion' value: 16r0!

LOGPALETTE comment: '<LOGPALETTE> is an <ExternalStructure> class to wrap the struct ''Win32.LOGPALETTE'' from type information in the ''Win32 API'' library.

The type library contains the following helpstring for this struct
	"The LOGPALETTE structure defines a logical palette."

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(87b4c5fa-026e-11d3-9fd7-00a0cc3e4a32), helpstring("The LOGPALETTE structure defines a logical palette.")]
struct tagLOGPALETTE {
	[helpstring("The version number of the system.")] WORD palVersion;
	[helpstring("The number of entries in the logical palette.")] WORD palNumEntries;
	[readonly, helpstring("Specifies an array of PALETTEENTRY structures that define the color and usage of each entry in the logical palette."), size_is("palNumEntries")] PALETTEENTRY palPalEntry[256];
} LOGPALETTE;
'!

!LOGPALETTE categoriesForClass!Win32-Structs! !

!LOGPALETTE methodsFor!

palNumEntries
	"Answer the <Integer> value of the receiver's 'palNumEntries' field."

	^bytes wordAtOffset: _OffsetOf_palNumEntries!

palNumEntries: anInteger
	"Set the receiver's 'palNumEntries' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_palNumEntries put: anInteger!

palPalEntry
	"Answer the <StructureArray> value of the receiver's 'palPalEntry' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_palPalEntry
		length: self palNumEntries
		elementClass: PALETTEENTRY!

palVersion
	"Answer the <Integer> value of the receiver's 'palVersion' field."

	^bytes wordAtOffset: _OffsetOf_palVersion!

palVersion: anInteger
	"Set the receiver's 'palVersion' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_palVersion put: anInteger! !

!LOGPALETTE categoriesForMethods!
palNumEntries!**compiled accessors**!public! !
palNumEntries:!**compiled accessors**!public! !
palPalEntry!**compiled accessors**!public! !
palVersion!**compiled accessors**!public! !
palVersion:!**compiled accessors**!public! !
!

!LOGPALETTE class methodsFor!

defineFields
	"Define the fields of the LOGPALETTE structure.

	LOGPALETTE compileDefinition

		typedef [uuid(87b4c5fa-026e-11d3-9fd7-00a0cc3e4a32), helpstring('The LOGPALETTE structure defines a logical palette.')]
		struct tagLOGPALETTE {
			[helpstring('The version number of the system.')] WORD palVersion;
			[helpstring('The number of entries in the logical palette.')] WORD palNumEntries;
			[readonly, helpstring('Specifies an array of PALETTEENTRY structures that define the color and usage of each entry in the logical palette.'), size_is('palNumEntries')] PALETTEENTRY palPalEntry[256];
		} LOGPALETTE;
"

	self
		defineField: #palVersion
			type: WORDField new
			offset: 0;
		defineField: #palNumEntries
			type: WORDField new
			offset: 2;
		defineField: #palPalEntry
			type: (StructureArrayField type: PALETTEENTRY
					arrayLength: (ConformantArrayFieldLength lengthField: #palNumEntries)) beReadOnly
			offset: 4.
	self byteSize: 1028!

getFieldNames
	^#(#palVersion #palNumEntries #palPalEntry)!

new
	"Answer an instance of the receiver of sufficient size to hold 256 palette entries."

	^(super new)
		palNumEntries: 256;
		yourself! !

!LOGPALETTE class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
new!instance creation!public! !
!

