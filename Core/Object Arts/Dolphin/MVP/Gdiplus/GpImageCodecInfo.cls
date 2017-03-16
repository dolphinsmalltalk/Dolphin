"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #GpImageCodecInfo
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GpImageCodecInfo guid: (GUID fromString: '{059e6e3a-2877-4ea7-a11c-7e5c1ac62165}')!
GpImageCodecInfo comment: '<GpImageCodecInfo> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpImageCodecInfo'' from type information in the ''GDI+ Library 1.0'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(059E6E3A-2877-4EA7-A11C-7E5C1AC62165)]
struct tagGpImageCodecInfo {
	GUID Clsid;
	GUID FormatID;
	short* CodecName;
	short* DllName;
	short* FormatDescription;
	short* FilenameExtension;
	short* MimeType;
	unsigned long flags;
	unsigned long Version;
	unsigned long SigCount;
	unsigned long SigSize;
	BYTE* SigPattern;
	BYTE* SigMask;
} GpImageCodecInfo;
'!
!GpImageCodecInfo categoriesForClass!Unclassified! !
!GpImageCodecInfo methodsFor!

Clsid
	"Answer the receiver's Clsid field as a Smalltalk object."

	^GUID fromAddress: (bytes yourAddress)!

Clsid: anObject
	"Set the receiver's Clsid field to the value of anObject."

	anObject replaceBytesOf: bytes from: 1 to: 16 startingAt: 1!

CodecName
	"Answer the receiver's CodecName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes sdwordAtOffset: 32)!

CodecName: anObject
	"Set the receiver's CodecName field to the value of anObject."

	bytes dwordAtOffset: 32 put: anObject yourAddress!

DllName
	"Answer the receiver's DllName field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes sdwordAtOffset: 36)!

DllName: anObject
	"Set the receiver's DllName field to the value of anObject."

	bytes dwordAtOffset: 36 put: anObject yourAddress!

FilenameExtension
	"Answer the receiver's FilenameExtension field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes sdwordAtOffset: 44)!

FilenameExtension: anObject
	"Set the receiver's FilenameExtension field to the value of anObject."

	bytes dwordAtOffset: 44 put: anObject yourAddress!

Flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: 52!

Flags: anObject 
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: 52 put: anObject!

FormatDescription
	"Answer the receiver's FormatDescription field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes sdwordAtOffset: 40)!

FormatDescription: anObject
	"Set the receiver's FormatDescription field to the value of anObject."

	bytes dwordAtOffset: 40 put: anObject yourAddress!

FormatID
	"Answer the receiver's FormatID field as a Smalltalk object."

	^GUID fromAddress: (bytes yourAddress + 16)!

FormatID: anObject
	"Set the receiver's FormatID field to the value of anObject."

	anObject replaceBytesOf: bytes from: 17 to: 32 startingAt: 1!

MimeType
	"Answer the receiver's MimeType field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes sdwordAtOffset: 48)!

MimeType: anObject
	"Set the receiver's MimeType field to the value of anObject."

	bytes dwordAtOffset: 48 put: anObject yourAddress!

SigCount
	"Answer the receiver's SigCount field as a Smalltalk object."

	^(bytes dwordAtOffset: 60)!

SigCount: anObject
	"Set the receiver's SigCount field to the value of anObject."

	bytes dwordAtOffset: 60 put: anObject!

SigMask
	"Answer the receiver's SigMask field as a Smalltalk object."

	^BYTE fromAddress: (bytes sdwordAtOffset: 72)!

SigMask: anObject
	"Set the receiver's SigMask field to the value of anObject."

	bytes dwordAtOffset: 72 put: anObject yourAddress!

SigPattern
	"Answer the receiver's SigPattern field as a Smalltalk object."

	^BYTE fromAddress: (bytes sdwordAtOffset: 68)!

SigPattern: anObject
	"Set the receiver's SigPattern field to the value of anObject."

	bytes dwordAtOffset: 68 put: anObject yourAddress!

SigSize
	"Answer the receiver's SigSize field as a Smalltalk object."

	^(bytes dwordAtOffset: 64)!

SigSize: anObject
	"Set the receiver's SigSize field to the value of anObject."

	bytes dwordAtOffset: 64 put: anObject!

Version
	"Answer the receiver's Version field as a Smalltalk object."

	^(bytes dwordAtOffset: 56)!

Version: anObject
	"Set the receiver's Version field to the value of anObject."

	bytes dwordAtOffset: 56 put: anObject! !
!GpImageCodecInfo categoriesFor: #Clsid!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #Clsid:!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #CodecName!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #CodecName:!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #DllName!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #DllName:!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #FilenameExtension!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #FilenameExtension:!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #Flags!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #Flags:!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #FormatDescription!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #FormatDescription:!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #FormatID!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #FormatID:!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #MimeType!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #MimeType:!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #SigCount!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #SigCount:!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #SigMask!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #SigMask:!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #SigPattern!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #SigPattern:!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #SigSize!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #SigSize:!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #Version!**compiled accessors**!public! !
!GpImageCodecInfo categoriesFor: #Version:!**compiled accessors**!public! !

!GpImageCodecInfo class methodsFor!

defineFields
	"Define the fields of the GpImageCodecInfo structure.
		GpImageCodecInfo compileDefinition
	
		typedef [uuid(059E6E3A-2877-4EA7-A11C-7E5C1AC62165)]
		struct tagGpImageCodecInfo {
			GUID Clsid;
			GUID FormatID;
			LPWSTR CodecName;
			LPWSTR DllName;
			LPWSTR FormatDescription;
			LPWSTR FilenameExtension;
			LPWSTR MimeType;
			unsigned long Flags;
			unsigned long Version;
			unsigned long SigCount;
			unsigned long SigSize;
			BYTE* SigPattern;
			BYTE* SigMask;
		} GpImageCodecInfo;
"

	self
		defineField: #Clsid type: (StructureField type: GUID) offset: 0;
		defineField: #FormatID type: (StructureField type: GUID) offset: 16;
		defineField: #CodecName type: (PointerField type: UnicodeString) offset: 32;
		defineField: #DllName type: (PointerField type: UnicodeString) offset: 36;
		defineField: #FormatDescription type: (PointerField type: UnicodeString) offset: 40;
		defineField: #FilenameExtension type: (PointerField type: UnicodeString) offset: 44;
		defineField: #MimeType type: (PointerField type: UnicodeString) offset: 48;
		defineField: #Flags type: DWORDField new offset: 52;
		defineField: #Version type: DWORDField new offset: 56;
		defineField: #SigCount type: DWORDField new offset: 60;
		defineField: #SigSize type: DWORDField new offset: 64;
		defineField: #SigPattern type: (PointerField type: BYTE) offset: 68;
		defineField: #SigMask type: (PointerField type: BYTE) offset: 72.
	self byteSize: 76! !
!GpImageCodecInfo class categoriesFor: #defineFields!**auto generated**!initializing!public! !

