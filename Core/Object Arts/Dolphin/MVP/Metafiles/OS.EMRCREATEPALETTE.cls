"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMRCREATEPALETTE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMRCREATEPALETTE_Size' -> 16r14.
		'_OffsetOf_ihPal' -> 16r8.
		'_OffsetOf_lgpl' -> 16rC
	}!
OS.EMRCREATEPALETTE guid: (Core.GUID fromString: '{b8739ed2-de47-467f-aa8d-3a62f4c00509}')!
OS.EMRCREATEPALETTE comment: '<EMRCREATEPALETTE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRCREATEPALETTE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(B8739ED2-DE47-467F-AA8D-3A62F4C00509)]
struct tagEMRCREATEPALETTE {
	EMR EMR;
	[helpstring("Palette handle index")] DWORD ihPal;
	[helpstring("The peFlags fields in the palette entries do not contain any flags")] LOGPALETTE lgpl;
} EMRCREATEPALETTE;
'!
!OS.EMRCREATEPALETTE categoriesForClass!Win32-Structs! !
!OS.EMRCREATEPALETTE methodsFor!

ihPal
	"Answer the <Integer> value of the receiver's 'ihPal' field."

	^bytes uint32AtOffset: _OffsetOf_ihPal!

ihPal: anInteger
	"Set the receiver's 'ihPal' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ihPal put: anInteger!

lgpl
	"Answer the <LOGPALETTE> value of the receiver's 'lgpl' field."

	^LOGPALETTE fromAddress: bytes yourAddress + _OffsetOf_lgpl!

lgpl: aLOGPALETTE
	"Set the receiver's 'lgpl' field to the value of the argument, aLOGPALETTE"

	aLOGPALETTE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_lgpl + 1)
		to: ##(_OffsetOf_lgpl + LOGPALETTE._LOGPALETTE_Size)
		startingAt: 1! !
!OS.EMRCREATEPALETTE categoriesForMethods!
ihPal!**compiled accessors**!public! !
ihPal:!**compiled accessors**!public! !
lgpl!**compiled accessors**!public! !
lgpl:!**compiled accessors**!public! !
!

!OS.EMRCREATEPALETTE class methodsFor!

byteSize
	^_EMRCREATEPALETTE_Size!

defineFields
	"Define the fields of the EMRCREATEPALETTE structure.

	EMRCREATEPALETTE  compileDefinition

		typedef [uuid(B8739ED2-DE47-467F-AA8D-3A62F4C00509)]
		struct tagEMRCREATEPALETTE {
			EMR EMR;
			[helpstring('Palette handle index')] DWORD ihPal;
			[helpstring('The peFlags fields in the palette entries do not contain any flags')] LOGPALETTE lgpl;
		} EMRCREATEPALETTE;
"

	super defineFields.
	self
		defineField: #ihPal
			type: UInt32Field new
			offset: 8;
		defineField: #lgpl
			type: (StructureField type: LOGPALETTE)
			offset: 12.
	self byteSize: 20!

getFieldNames
	^#(#iType #nSize #ihPal #lgpl)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_CREATEPALETTE}! !
!OS.EMRCREATEPALETTE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

