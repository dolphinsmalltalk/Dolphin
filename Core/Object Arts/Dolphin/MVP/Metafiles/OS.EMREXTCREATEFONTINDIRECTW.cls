"Filed out from Dolphin Smalltalk"!

OS.ENHMETARECORD subclass: #'OS.EMREXTCREATEFONTINDIRECTW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EMREXTCREATEFONTINDIRECTW_Size' -> 16r14C.
		'_OffsetOf_elfw' -> 16rC.
		'_OffsetOf_ihFont' -> 16r8
	}!
OS.EMREXTCREATEFONTINDIRECTW guid: (Core.GUID fromString: '{29743add-8da1-4573-9b6b-8a3d2c5ac799}')!
OS.EMREXTCREATEFONTINDIRECTW comment: '<EMREXTCREATEFONTINDIRECT> is an <ExternalStructure> class to wrap the struct ''Win32.EMREXTCREATEFONTINDIRECT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(29743ADD-8DA1-4573-9B6B-8A3D2C5AC799)]
struct tagEMREXTCREATEFONTINDIRECT {
	EMR EMR;
	[helpstring("Font handle index")] DWORD ihFont;
	EXTLOGFONT elfw;
} EMREXTCREATEFONTINDIRECT;
'!
!OS.EMREXTCREATEFONTINDIRECTW categoriesForClass!Win32-Structs! !
!OS.EMREXTCREATEFONTINDIRECTW methodsFor!

elfw
	"Answer the <EXTLOGFONTW> value of the receiver's 'elfw' field."

	^EXTLOGFONTW fromAddress: bytes yourAddress + _OffsetOf_elfw!

elfw: anEXTLOGFONTW
	"Set the receiver's 'elfw' field to the value of the argument, anEXTLOGFONTW"

	anEXTLOGFONTW
		replaceBytesOf: bytes
		from: ##(_OffsetOf_elfw + 1)
		to: ##(_OffsetOf_elfw + EXTLOGFONTW._EXTLOGFONTW_Size)
		startingAt: 1!

ihFont
	"Answer the <Integer> value of the receiver's 'ihFont' field."

	^bytes dwordAtOffset: _OffsetOf_ihFont!

ihFont: anInteger
	"Set the receiver's 'ihFont' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ihFont put: anInteger! !
!OS.EMREXTCREATEFONTINDIRECTW categoriesForMethods!
elfw!**compiled accessors**!public! !
elfw:!**compiled accessors**!public! !
ihFont!**compiled accessors**!public! !
ihFont:!**compiled accessors**!public! !
!

!OS.EMREXTCREATEFONTINDIRECTW class methodsFor!

byteSize
	^_EMREXTCREATEFONTINDIRECTW_Size!

defineFields
	"Define the fields of the EMREXTCREATEFONTINDIRECTW structure.

	EMREXTCREATEFONTINDIRECTW  compileDefinition

		typedef [uuid(29743ADD-8DA1-4573-9B6B-8A3D2C5AC799)]
		struct tagEMREXTCREATEFONTINDIRECTW {
			EMR EMR;
			[helpstring('Font handle index')] DWORD ihFont;
			EXTLOGFONTW elfw;
		} EMREXTCREATEFONTINDIRECTW;
"

	super defineFields.
	self
		defineField: #ihFont
			type: DWORDField new
			offset: 8;
		defineField: #elfw
			type: (StructureField type: EXTLOGFONTW)
			offset: 12.
	self byteSize: 332!

getFieldNames
	^#(#iType #nSize #ihFont #elfw)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_EXTCREATEFONTINDIRECTW}! !
!OS.EMREXTCREATEFONTINDIRECTW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
iTypes!constants!public! !
!

