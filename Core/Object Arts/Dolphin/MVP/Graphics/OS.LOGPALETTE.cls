"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.LOGPALETTE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_LOGPALETTE_Size' -> 16r404.
			'_OffsetOf_palNumEntries' -> 16r2.
			'_OffsetOf_palPalEntry' -> 16r4.
			'_OffsetOf_palVersion' -> 16r0
		}!

OS.LOGPALETTE guid: (Core.GUID fromString: '{87b4c5fa-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.LOGPALETTE comment: '<LOGPALETTE> is an <ExternalStructure> class to wrap the struct ''Win32.LOGPALETTE'' from type information in the ''Win32 API'' library.

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

!OS.LOGPALETTE categoriesForClass!Win32-Structs! !

!OS.LOGPALETTE methodsFor!

palNumEntries
	"Answer the <Integer> value of the receiver's 'palNumEntries' field."

	^bytes uint16AtOffset: _OffsetOf_palNumEntries!

palNumEntries: anInteger
	"Set the receiver's 'palNumEntries' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_palNumEntries put: anInteger!

palPalEntry
	"Answer the <StructureArray> value of the receiver's 'palPalEntry' field."

	^StructureArray
		fromAddress: bytes yourAddress + _OffsetOf_palPalEntry
		length: self palNumEntries
		elementClass: PALETTEENTRY!

palVersion
	"Answer the <Integer> value of the receiver's 'palVersion' field."

	^bytes uint16AtOffset: _OffsetOf_palVersion!

palVersion: anInteger
	"Set the receiver's 'palVersion' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_palVersion put: anInteger! !

!OS.LOGPALETTE categoriesForMethods!
palNumEntries!**compiled accessors**!public! !
palNumEntries:!**compiled accessors**!public! !
palPalEntry!**compiled accessors**!public! !
palVersion!**compiled accessors**!public! !
palVersion:!**compiled accessors**!public! !
!

!OS.LOGPALETTE class methodsFor!

byteSize
	^_LOGPALETTE_Size!

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
			type: UInt16Field new
			offset: 0;
		defineField: #palNumEntries
			type: UInt16Field new
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

!OS.LOGPALETTE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
new!instance creation!public! !
!

