"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #LOGPALETTE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LOGPALETTE guid: (GUID fromString: '{87b4c5fa-026e-11d3-9fd7-00a0cc3e4a32}')!
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

	^bytes wordAtOffset: ##(self offsetOf: #palNumEntries)!

palNumEntries: anInteger
	"Set the receiver's 'palNumEntries' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #palNumEntries) put: anInteger!

palPalEntry
	"Answer the <StructureArray> value of the receiver's 'palPalEntry' field."

	^StructureArray
		fromAddress: bytes yourAddress + ##(self offsetOf: #palPalEntry)
		length: self palNumEntries
		elementClass: PALETTEENTRY!

palVersion
	"Answer the <Integer> value of the receiver's 'palVersion' field."

	^bytes wordAtOffset: 0!

palVersion: anInteger
	"Set the receiver's 'palVersion' field to the value of the argument, anInteger"

	bytes wordAtOffset: 0 put: anInteger! !
!LOGPALETTE categoriesFor: #palNumEntries!**compiled accessors**!public! !
!LOGPALETTE categoriesFor: #palNumEntries:!**compiled accessors**!public! !
!LOGPALETTE categoriesFor: #palPalEntry!**compiled accessors**!public! !
!LOGPALETTE categoriesFor: #palVersion!**compiled accessors**!public! !
!LOGPALETTE categoriesFor: #palVersion:!**compiled accessors**!public! !

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
!LOGPALETTE class categoriesFor: #defineFields!**auto generated**!initializing!public! !
!LOGPALETTE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!LOGPALETTE class categoriesFor: #new!instance creation!public! !

