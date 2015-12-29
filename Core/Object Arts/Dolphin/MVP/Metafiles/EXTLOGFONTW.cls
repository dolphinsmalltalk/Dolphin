"Filed out from Dolphin Smalltalk X6.1"!

ExternalStructure subclass: #EXTLOGFONTW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EXTLOGFONTW guid: (GUID fromString: '{2CDCAE37-591A-42A5-A44A-B92E4C362921}')!
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

elfCulture
	"Answer the receiver's elfCulture field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #elfCulture)!

elfCulture: anObject 
	"Set the receiver's elfCulture field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #elfCulture) put: anObject!

elfFullName
	"Answer the receiver's elfFullName field as a Smalltalk object."

	^UnicodeString fromAddress: bytes yourAddress + ##(self offsetOf: #elfFullName)!

elfFullName: anObject 
	"Set the receiver's elfFullName field to the value of anObject."

	| size |
	size := anObject byteSize - 2 min: ##(63 * 2).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #elfFullName) + 1)
		to: ##(self offsetOf: #elfFullName) + size
		startingAt: 1.
	bytes wordAtOffset: ##(self offsetOf: #elfFullName) + size put: 0!

elfLogFont
	"Answer the receiver's elfLogFont field as a Smalltalk object."

	^LOGFONTW fromAddress: bytes yourAddress!

elfLogFont: anObject 
	"Set the receiver's elfLogFont field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: 1
		to: ##(LOGFONTW basicByteSize)
		startingAt: 1!

elfMatch
	"Answer the receiver's elfMatch field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #elfMatch)!

elfMatch: anObject 
	"Set the receiver's elfMatch field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #elfMatch) put: anObject!

elfPanose
	"Answer the receiver's elfPanose field as a Smalltalk object."

	^PANOSE fromAddress: bytes yourAddress + ##(self offsetOf: #elfPanose)!

elfPanose: anObject 
	"Set the receiver's elfPanose field to the value of anObject."

	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #elfPanose) + 1)
		to: ##((self offsetOf: #elfPanose) + PANOSE basicByteSize)
		startingAt: 1!

elfReserved
	"Answer the receiver's elfReserved field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #elfReserved)!

elfReserved: anObject 
	"Set the receiver's elfReserved field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #elfReserved) put: anObject!

elfStyle
	"Answer the receiver's elfStyle field as a Smalltalk object."

	^UnicodeString fromAddress: bytes yourAddress + ##(self offsetOf: #elfStyle)!

elfStyle: anObject 
	"Set the receiver's elfStyle field to the value of anObject."

	| size |
	size := anObject byteSize - 2 min: ##(31 * 2).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #elfStyle) + 1)
		to: ##(self offsetOf: #elfStyle) + size
		startingAt: 1.
	bytes wordAtOffset: ##(self offsetOf: #elfStyle) + size put: 0!

elfStyleSize
	"Answer the receiver's elfStyleSize field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #elfStyleSize)!

elfStyleSize: anObject 
	"Set the receiver's elfStyleSize field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #elfStyleSize) put: anObject!

elfVendorId
	"Answer the receiver's elfVendorId field as a Smalltalk object."

	^ByteArray fromAddress: bytes yourAddress + ##(self offsetOf: #elfVendorId) length: 4!

elfVendorId: anObject 
	"Set the receiver's elfVendorId field to the value of anObject."

	| size |
	size := anObject byteSize min: ##(4 * ByteArray elementSize).
	anObject 
		replaceBytesOf: bytes
		from: ##((self offsetOf: #elfVendorId) + 1)
		to: ##(self offsetOf: #elfVendorId) + size
		startingAt: 1!

elfVersion
	"Answer the receiver's elfVersion field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #elfVersion)!

elfVersion: anObject 
	"Set the receiver's elfVersion field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #elfVersion) put: anObject! !
!EXTLOGFONTW categoriesFor: #elfCulture!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfCulture:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfFullName!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfFullName:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfLogFont!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfLogFont:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfMatch!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfMatch:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfPanose!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfPanose:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfReserved!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfReserved:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfStyle!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfStyle:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfStyleSize!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfStyleSize:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfVendorId!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfVendorId:!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfVersion!**compiled accessors**!public! !
!EXTLOGFONTW categoriesFor: #elfVersion:!**compiled accessors**!public! !

!EXTLOGFONTW class methodsFor!

defineFields
	"Define the fields of the EXTLOGFONTW structure.

	EXTLOGFONTW  compileDefinition

		typedef [uuid(2CDCAE37-591A-42A5-A44A-B92E4C362921)]
		struct tagEXTLOGFONTW {
			LOGFONTW elfLogFont;
			unsigned short elfFullName[64];
			unsigned short elfStyle[32];
			[helpstring('0 for the first release of NT ')] DWORD elfVersion;
			DWORD elfStyleSize;
			DWORD elfMatch;
			DWORD elfReserved;
			BYTE elfVendorId[4];
			[helpstring('0 for Latin')] DWORD elfCulture;
			PANOSE elfPanose;
		} EXTLOGFONTW;
"

	self
		defineField: #elfLogFont type: (StructureField type: LOGFONTW) offset: 0;
		defineField: #elfFullName type: (StringField type: UnicodeString length: 64) offset: 92;
		defineField: #elfStyle type: (StringField type: UnicodeString length: 32) offset: 220;
		defineField: #elfVersion type: DWORDField new offset: 284;
		defineField: #elfStyleSize type: DWORDField new offset: 288;
		defineField: #elfMatch type: DWORDField new offset: 292;
		defineField: #elfReserved type: DWORDField new offset: 296;
		defineField: #elfVendorId type: (ArrayField type: ByteArray length: 4) offset: 300;
		defineField: #elfCulture type: DWORDField new offset: 304;
		defineField: #elfPanose type: (StructureField type: PANOSE) offset: 308.
	self byteSize: 320! !
!EXTLOGFONTW class categoriesFor: #defineFields!initializing!public! !

