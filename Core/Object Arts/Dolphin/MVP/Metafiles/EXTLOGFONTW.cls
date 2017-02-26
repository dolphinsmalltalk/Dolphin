"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #EXTLOGFONTW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EXTLOGFONTW guid: (GUID fromString: '{2cdcae37-591a-42a5-a44a-b92e4c362921}')!
EXTLOGFONTW comment: '<EXTLOGFONT> is an <ExternalStructure> class to wrap the struct ''Win32.EXTLOGFONT'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!EXTLOGFONTW categoriesForClass!Win32-Structs! !
!EXTLOGFONTW methodsFor!

elfFullName
	"Answer the <UnicodeString> value of the receiver's 'elfFullName' field."

	^UnicodeString fromAddress: bytes yourAddress + ##(self offsetOf: #elfFullName)!

elfFullName: anUnicodeString
	"Set the receiver's 'elfFullName' field to the value of the argument, anUnicodeString"

	| size |
	size := anUnicodeString byteSize - 2 min: ##(63 * 2).
	anUnicodeString
		replaceBytesOf: bytes
		from: ##((self offsetOf: #elfFullName) + 1)
		to: ##(self offsetOf: #elfFullName) + size
		startingAt: 1.
	bytes wordAtOffset: ##(self offsetOf: #elfFullName) + size put: 0!

elfLogFont
	"Answer the <LOGFONTW> value of the receiver's 'elfLogFont' field."

	^LOGFONTW fromAddress: bytes yourAddress!

elfLogFont: aLOGFONTW
	"Set the receiver's 'elfLogFont' field to the value of the argument, aLOGFONTW"

	aLOGFONTW
		replaceBytesOf: bytes
		from: 1
		to: ##(LOGFONTW basicByteSize)
		startingAt: 1!

elfMatch
	"Answer the <Integer> value of the receiver's 'elfMatch' field."

	^bytes dwordAtOffset: ##(self offsetOf: #elfMatch)!

elfMatch: anInteger
	"Set the receiver's 'elfMatch' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #elfMatch) put: anInteger!

elfPanose
	"Answer the <PANOSE> value of the receiver's 'elfPanose' field."

	^PANOSE fromAddress: bytes yourAddress + ##(self offsetOf: #elfPanose)!

elfPanose: aPANOSE
	"Set the receiver's 'elfPanose' field to the value of the argument, aPANOSE"

	aPANOSE
		replaceBytesOf: bytes
		from: ##((self offsetOf: #elfPanose) + 1)
		to: ##((self offsetOf: #elfPanose) + PANOSE basicByteSize)
		startingAt: 1!

elfStyle
	"Answer the <UnicodeString> value of the receiver's 'elfStyle' field."

	^UnicodeString fromAddress: bytes yourAddress + ##(self offsetOf: #elfStyle)!

elfStyle: anUnicodeString
	"Set the receiver's 'elfStyle' field to the value of the argument, anUnicodeString"

	| size |
	size := anUnicodeString byteSize - 2 min: ##(31 * 2).
	anUnicodeString
		replaceBytesOf: bytes
		from: ##((self offsetOf: #elfStyle) + 1)
		to: ##(self offsetOf: #elfStyle) + size
		startingAt: 1.
	bytes wordAtOffset: ##(self offsetOf: #elfStyle) + size put: 0!

elfStyleSize
	"Answer the <Integer> value of the receiver's 'elfStyleSize' field."

	^bytes dwordAtOffset: ##(self offsetOf: #elfStyleSize)!

elfStyleSize: anInteger
	"Set the receiver's 'elfStyleSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #elfStyleSize) put: anInteger!

elfVendorId
	"Answer the <ExternalArray> value of the receiver's 'elfVendorId' field."

	^ExternalArray fromAddress: bytes yourAddress + ##(self offsetOf: #elfVendorId) length: 4!

elfVendorId: anExternalArray
	"Set the receiver's 'elfVendorId' field to the value of the argument, anExternalArray"

	| size |
	size := anExternalArray byteSize min: ##(4 * ExternalArray elementSize).
	anExternalArray
		replaceBytesOf: bytes
		from: ##((self offsetOf: #elfVendorId) + 1)
		to: ##(self offsetOf: #elfVendorId) + size
		startingAt: 1! !
!EXTLOGFONTW categoriesFor: #elfFullName!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfFullName:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfLogFont!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfLogFont:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfMatch!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfMatch:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfPanose!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfPanose:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfStyle!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfStyle:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfStyleSize!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfStyleSize:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfVendorId!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfVendorId:!**compiled accessors**!public! !

!EXTLOGFONTW class methodsFor!

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
		defineField: #elfLogFont type: (StructureField type: LOGFONTW) offset: 0;
		defineField: #elfFullName type: (StringField type: UnicodeString length: 64) offset: 92;
		defineField: #elfStyle type: (StringField type: UnicodeString length: 32) offset: 220;
		defineField: #elfVersion type: DWORDField new beFiller offset: 284;
		defineField: #elfStyleSize type: DWORDField new offset: 288;
		defineField: #elfMatch type: DWORDField new offset: 292;
		defineField: #elfReserved type: DWORDField new beFiller offset: 296;
		defineField: #elfVendorId type: (ArrayField type: ExternalArray length: 4) offset: 300;
		defineField: #elfCulture type: DWORDField new beFiller offset: 304;
		defineField: #elfPanose type: (StructureField type: PANOSE) offset: 308.
	self byteSize: 320! !
!EXTLOGFONTW class categoriesFor: #defineFields!**auto generated**!initializing!public! !

