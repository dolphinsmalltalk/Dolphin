"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD
	subclass: #'OS.EMRSELECTPALETTE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_EMRSELECTPALETTE_Size' -> 16rC. '_OffsetOf_ihPal' -> 16r8 }!

OS.EMRSELECTPALETTE guid: (Core.GUID fromString: '{2bd77a04-2b0c-4d93-b7b6-a55fbb1003ab}')!

OS.EMRSELECTPALETTE comment: '<EMRSELECTPALETTE> is an <ExternalStructure> class to wrap the struct ''Win32.EMRSELECTPALETTE'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(2BD77A04-2B0C-4D93-B7B6-A55FBB1003AB)]
struct tagEMRSELECTPALETTE {
	EMR EMR;
	[helpstring("Palette handle index, background mode only")] DWORD ihPal;
} EMRSELECTPALETTE;
'!

!OS.EMRSELECTPALETTE categoriesForClass!Win32-Structs! !

!OS.EMRSELECTPALETTE methodsFor!

ihPal
	"Answer the <Integer> value of the receiver's 'ihPal' field."

	^bytes uint32AtOffset: _OffsetOf_ihPal!

ihPal: anInteger
	"Set the receiver's 'ihPal' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_ihPal put: anInteger! !

!OS.EMRSELECTPALETTE categoriesForMethods!
ihPal!**compiled accessors**!public! !
ihPal:!**compiled accessors**!public! !
!

!OS.EMRSELECTPALETTE class methodsFor!

byteSize
	^_EMRSELECTPALETTE_Size!

defineFields
	"Define the fields of the EMRSELECTPALETTE structure.

	EMRSELECTPALETTE  compileDefinition

		typedef [uuid(2BD77A04-2B0C-4D93-B7B6-A55FBB1003AB)]
		struct tagEMRSELECTPALETTE {
			EMR EMR;
			[helpstring('Palette handle index, background mode only')] DWORD ihPal;
		} EMRSELECTPALETTE;
"

	super defineFields.
	self
		defineField: #ihPal
		type: UInt32Field new
		offset: 8.
	self byteSize: 12!

getFieldNames
	^#(#iType #nSize #ihPal)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_SELECTPALETTE}! !

!OS.EMRSELECTPALETTE class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

