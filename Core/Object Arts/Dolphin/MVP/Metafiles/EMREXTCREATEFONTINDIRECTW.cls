"Filed out from Dolphin Smalltalk 7"!

ENHMETARECORD subclass: #EMREXTCREATEFONTINDIRECTW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_elfw _OffsetOf_ihFont'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EMREXTCREATEFONTINDIRECTW guid: (GUID fromString: '{29743add-8da1-4573-9b6b-8a3d2c5ac799}')!
EMREXTCREATEFONTINDIRECTW addClassConstant: '_OffsetOf_elfw' value: 16rC!
EMREXTCREATEFONTINDIRECTW addClassConstant: '_OffsetOf_ihFont' value: 16r8!
EMREXTCREATEFONTINDIRECTW comment: '<EMREXTCREATEFONTINDIRECT> is an <ExternalStructure> class to wrap the struct ''Win32.EMREXTCREATEFONTINDIRECT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!EMREXTCREATEFONTINDIRECTW categoriesForClass!Win32-Structs! !
!EMREXTCREATEFONTINDIRECTW methodsFor!

elfw
	"Answer the <EXTLOGFONTW> value of the receiver's 'elfw' field."

	^EXTLOGFONTW fromAddress: bytes yourAddress + _OffsetOf_elfw!

elfw: anEXTLOGFONTW
	"Set the receiver's 'elfw' field to the value of the argument, anEXTLOGFONTW"

	anEXTLOGFONTW
		replaceBytesOf: bytes
		from: ##(_OffsetOf_elfw + 1)
		to: ##(_OffsetOf_elfw + EXTLOGFONTW basicByteSize)
		startingAt: 1!

ihFont
	"Answer the <Integer> value of the receiver's 'ihFont' field."

	^bytes dwordAtOffset: _OffsetOf_ihFont!

ihFont: anInteger
	"Set the receiver's 'ihFont' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_ihFont put: anInteger! !
!EMREXTCREATEFONTINDIRECTW categoriesFor: #elfw!**compiled accessors**!public! !
!EMREXTCREATEFONTINDIRECTW categoriesFor: #elfw:!**compiled accessors**!public! !
!EMREXTCREATEFONTINDIRECTW categoriesFor: #ihFont!**compiled accessors**!public! !
!EMREXTCREATEFONTINDIRECTW categoriesFor: #ihFont:!**compiled accessors**!public! !

!EMREXTCREATEFONTINDIRECTW class methodsFor!

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
		defineField: #ihFont type: DWORDField new offset: 8;
		defineField: #elfw type: (StructureField type: EXTLOGFONTW) offset: 12.
	self byteSize: 332!

getFieldNames
	^#(#iType #nSize #ihFont #elfw)!

iTypes
	"Answer the integer enhanced metafile record type id for this record class."

	^{EMR_EXTCREATEFONTINDIRECTW}! !
!EMREXTCREATEFONTINDIRECTW class categoriesFor: #defineFields!public!template definition! !
!EMREXTCREATEFONTINDIRECTW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!EMREXTCREATEFONTINDIRECTW class categoriesFor: #iTypes!constants!public! !

