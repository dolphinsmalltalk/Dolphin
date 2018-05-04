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
	"Answer the <GUID> value of the receiver's 'Clsid' field."

	^GUID fromAddress: bytes yourAddress!

Clsid: aGUID
	"Set the receiver's 'Clsid' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: 1
		to: ##(GUID basicByteSize)
		startingAt: 1!

CodecName
	"Answer the <Utf16String> value of the receiver's 'CodecName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #CodecName))!

CodecName: anUtf16String
	"Set the receiver's 'CodecName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #CodecName) put: anUtf16String yourAddress!

DllName
	"Answer the <Utf16String> value of the receiver's 'DllName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #DllName))!

DllName: anUtf16String
	"Set the receiver's 'DllName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #DllName) put: anUtf16String yourAddress!

FilenameExtension
	"Answer the <Utf16String> value of the receiver's 'FilenameExtension' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #FilenameExtension))!

FilenameExtension: anUtf16String
	"Set the receiver's 'FilenameExtension' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #FilenameExtension) put: anUtf16String yourAddress!

Flags
	"Answer the <Integer> value of the receiver's 'Flags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #Flags)!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #Flags) put: anInteger!

FormatDescription
	"Answer the <Utf16String> value of the receiver's 'FormatDescription' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #FormatDescription))!

FormatDescription: anUtf16String
	"Set the receiver's 'FormatDescription' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #FormatDescription) put: anUtf16String yourAddress!

FormatID
	"Answer the <GUID> value of the receiver's 'FormatID' field."

	^GUID fromAddress: bytes yourAddress + ##(self offsetOf: #FormatID)!

FormatID: aGUID
	"Set the receiver's 'FormatID' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: ##((self offsetOf: #FormatID) + 1)
		to: ##((self offsetOf: #FormatID) + GUID basicByteSize)
		startingAt: 1!

MimeType
	"Answer the <Utf16String> value of the receiver's 'MimeType' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #MimeType))!

MimeType: anUtf16String
	"Set the receiver's 'MimeType' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #MimeType) put: anUtf16String yourAddress!

SigCount
	"Answer the <Integer> value of the receiver's 'SigCount' field."

	^bytes dwordAtOffset: ##(self offsetOf: #SigCount)!

SigCount: anInteger
	"Set the receiver's 'SigCount' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #SigCount) put: anInteger!

SigMask
	"Answer the <BYTE> value of the receiver's 'SigMask' field."

	^BYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #SigMask))!

SigMask: aBYTE
	"Set the receiver's 'SigMask' field to the value of the argument, aBYTE"

	bytes uintPtrAtOffset: ##(self offsetOf: #SigMask) put: aBYTE yourAddress!

SigPattern
	"Answer the <BYTE> value of the receiver's 'SigPattern' field."

	^BYTE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #SigPattern))!

SigPattern: aBYTE
	"Set the receiver's 'SigPattern' field to the value of the argument, aBYTE"

	bytes uintPtrAtOffset: ##(self offsetOf: #SigPattern) put: aBYTE yourAddress!

SigSize
	"Answer the <Integer> value of the receiver's 'SigSize' field."

	^bytes dwordAtOffset: ##(self offsetOf: #SigSize)!

SigSize: anInteger
	"Set the receiver's 'SigSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #SigSize) put: anInteger!

Version
	"Answer the <Integer> value of the receiver's 'Version' field."

	^bytes dwordAtOffset: ##(self offsetOf: #Version)!

Version: anInteger
	"Set the receiver's 'Version' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #Version) put: anInteger! !
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
		defineField: #CodecName type: (PointerField type: Utf16String) offset: 32;
		defineField: #DllName type: (PointerField type: Utf16String) offset: 36;
		defineField: #FormatDescription type: (PointerField type: Utf16String) offset: 40;
		defineField: #FilenameExtension type: (PointerField type: Utf16String) offset: 44;
		defineField: #MimeType type: (PointerField type: Utf16String) offset: 48;
		defineField: #Flags type: DWORDField new offset: 52;
		defineField: #Version type: DWORDField new offset: 56;
		defineField: #SigCount type: DWORDField new offset: 60;
		defineField: #SigSize type: DWORDField new offset: 64;
		defineField: #SigPattern type: (PointerField type: BYTE) offset: 68;
		defineField: #SigMask type: (PointerField type: BYTE) offset: 72.
	self byteSize: 76! !
!GpImageCodecInfo class categoriesFor: #defineFields!**auto generated**!initializing!public! !

