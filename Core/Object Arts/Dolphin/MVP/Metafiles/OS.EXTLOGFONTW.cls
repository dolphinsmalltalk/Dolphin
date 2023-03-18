"Filed out from Dolphin Smalltalk"!

External.Structure subclass: #'OS.EXTLOGFONTW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_EXTLOGFONTW_Size' -> 16r140.
		'_OffsetOf_elfCulture' -> 16r130.
		'_OffsetOf_elfFullName' -> 16r5C.
		'_OffsetOf_elfLogFont' -> 16r0.
		'_OffsetOf_elfMatch' -> 16r124.
		'_OffsetOf_elfPanose' -> 16r134.
		'_OffsetOf_elfReserved' -> 16r128.
		'_OffsetOf_elfStyle' -> 16rDC.
		'_OffsetOf_elfStyleSize' -> 16r120.
		'_OffsetOf_elfVendorId' -> 16r12C.
		'_OffsetOf_elfVersion' -> 16r11C
	}!
OS.EXTLOGFONTW guid: (Core.GUID fromString: '{2cdcae37-591a-42a5-a44a-b92e4c362921}')!
OS.EXTLOGFONTW comment: '<EXTLOGFONT> is an <ExternalStructure> class to wrap the struct ''Win32.EXTLOGFONT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(2CDCAE37-591A-42A5-A44A-B92E4C362921)]
struct tagEXTLOGFONT {
	LOGFONT elfLogFont;
	BYTE elfFullName[64];
	BYTE elfStyle[64];
	[helpstring("0 for the first release of NT ")] DWORD elfVersion;
	DWORD elfStyleSize;
	DWORD elfMatch;
	DWORD elfReserved;
	BYTE elfVendorId[4];
	[helpstring("0 for Latin")] DWORD elfCulture;
	PANOSE elfPanose;
} EXTLOGFONT;
'!
!OS.EXTLOGFONTW categoriesForClass!Win32-Structs! !
!OS.EXTLOGFONTW methodsFor!

elfFullName
	"Answer the <Utf16String> value of the receiver's 'elfFullName' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_elfFullName!

elfFullName: anUtf16String
	"Set the receiver's 'elfFullName' field to the value of the argument, anUtf16String"

	| size |
	size := anUtf16String byteSize - 2 min: ##(63 * 2).
	anUtf16String
		replaceBytesOf: bytes
		from: ##(_OffsetOf_elfFullName + 1)
		to: _OffsetOf_elfFullName + size
		startingAt: 1.
	bytes uint16AtOffset: _OffsetOf_elfFullName + size put: 0!

elfLogFont
	"Answer the <LOGFONTW> value of the receiver's 'elfLogFont' field."

	^LOGFONTW fromAddress: bytes yourAddress!

elfLogFont: aLOGFONTW
	"Set the receiver's 'elfLogFont' field to the value of the argument, aLOGFONTW"

	aLOGFONTW
		replaceBytesOf: bytes
		from: ##(_OffsetOf_elfLogFont + 1)
		to: ##(_OffsetOf_elfLogFont + LOGFONTW._LOGFONTW_Size)
		startingAt: 1!

elfMatch
	"Answer the <Integer> value of the receiver's 'elfMatch' field."

	^bytes uint32AtOffset: _OffsetOf_elfMatch!

elfMatch: anInteger
	"Set the receiver's 'elfMatch' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_elfMatch put: anInteger!

elfPanose
	"Answer the <PANOSE> value of the receiver's 'elfPanose' field."

	^PANOSE fromAddress: bytes yourAddress + _OffsetOf_elfPanose!

elfPanose: aPANOSE
	"Set the receiver's 'elfPanose' field to the value of the argument, aPANOSE"

	aPANOSE
		replaceBytesOf: bytes
		from: ##(_OffsetOf_elfPanose + 1)
		to: ##(_OffsetOf_elfPanose + PANOSE._PANOSE_Size)
		startingAt: 1!

elfStyle
	"Answer the <Utf16String> value of the receiver's 'elfStyle' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_elfStyle!

elfStyle: anUtf16String
	"Set the receiver's 'elfStyle' field to the value of the argument, anUtf16String"

	| size |
	size := anUtf16String byteSize - 2 min: ##(31 * 2).
	anUtf16String
		replaceBytesOf: bytes
		from: ##(_OffsetOf_elfStyle + 1)
		to: _OffsetOf_elfStyle + size
		startingAt: 1.
	bytes uint16AtOffset: _OffsetOf_elfStyle + size put: 0!

elfStyleSize
	"Answer the <Integer> value of the receiver's 'elfStyleSize' field."

	^bytes uint32AtOffset: _OffsetOf_elfStyleSize!

elfStyleSize: anInteger
	"Set the receiver's 'elfStyleSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_elfStyleSize put: anInteger!

elfVendorId
	"Answer the <ExternalArray> value of the receiver's 'elfVendorId' field."

	^ExternalArray fromAddress: bytes yourAddress + _OffsetOf_elfVendorId length: 4!

elfVendorId: anExternalArray
	"Set the receiver's 'elfVendorId' field to the value of the argument, anExternalArray"

	| size |
	size := anExternalArray byteSize min: ##(4 * ExternalArray elementSize).
	anExternalArray
		replaceBytesOf: bytes
		from: ##(_OffsetOf_elfVendorId + 1)
		to: _OffsetOf_elfVendorId + size
		startingAt: 1! !
!OS.EXTLOGFONTW categoriesForMethods!
elfFullName!**compiled accessors**!public! !
elfFullName:!**compiled accessors**!public! !
elfLogFont!**compiled accessors**!public! !
elfLogFont:!**compiled accessors**!public! !
elfMatch!**compiled accessors**!public! !
elfMatch:!**compiled accessors**!public! !
elfPanose!**compiled accessors**!public! !
elfPanose:!**compiled accessors**!public! !
elfStyle!**compiled accessors**!public! !
elfStyle:!**compiled accessors**!public! !
elfStyleSize!**compiled accessors**!public! !
elfStyleSize:!**compiled accessors**!public! !
elfVendorId!**compiled accessors**!public! !
elfVendorId:!**compiled accessors**!public! !
!

!OS.EXTLOGFONTW class methodsFor!

byteSize
	^_EXTLOGFONTW_Size!

defineFields
	"Define the fields of the EXTLOGFONTW structure.

	EXTLOGFONTW compileDefinition

		typedef [uuid(2cdcae37-591a-42a5-a44a-b92e4c362921)]
		struct tagEXTLOGFONTW {
			LOGFONTW elfLogFont;
			[string] unsigned short elfFullName[64];
			[string] unsigned short elfStyle[32];
			[hidden, helpstring('0 for the first release of NT ')] DWORD elfVersion;
			DWORD elfStyleSize;
			DWORD elfMatch;
			[hidden] DWORD elfReserved;
			BYTE elfVendorId[4];
			[hidden, helpstring('0 for Latin')] DWORD elfCulture;
			PANOSE elfPanose;
		} EXTLOGFONTW;
"

	self
		defineField: #elfLogFont
			type: (StructureField type: LOGFONTW)
			offset: 0;
		defineField: #elfFullName
			type: (StringField type: Utf16String length: 64)
			offset: 92;
		defineField: #elfStyle
			type: (StringField type: Utf16String length: 32)
			offset: 220;
		defineField: #elfVersion
			type: UInt32Field new beFiller
			offset: 284;
		defineField: #elfStyleSize
			type: UInt32Field new
			offset: 288;
		defineField: #elfMatch
			type: UInt32Field new
			offset: 292;
		defineField: #elfReserved
			type: UInt32Field new beFiller
			offset: 296;
		defineField: #elfVendorId
			type: (ArrayField type: ExternalArray length: 4)
			offset: 300;
		defineField: #elfCulture
			type: UInt32Field new beFiller
			offset: 304;
		defineField: #elfPanose
			type: (StructureField type: PANOSE)
			offset: 308.
	self byteSize: 320!

getFieldNames
	^#(#elfLogFont #elfFullName #elfStyle #elfStyleSize #elfMatch #elfVendorId #elfPanose)! !
!OS.EXTLOGFONTW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

