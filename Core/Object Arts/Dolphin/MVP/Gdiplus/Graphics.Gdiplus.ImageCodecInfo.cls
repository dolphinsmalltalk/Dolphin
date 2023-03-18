"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GpStructure
	subclass: #'Graphics.Gdiplus.ImageCodecInfo'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_ImageCodecInfo_Size' -> 16r4C.
			'_OffsetOf_Clsid' -> 16r0.
			'_OffsetOf_CodecName' -> 16r20.
			'_OffsetOf_DllName' -> 16r24.
			'_OffsetOf_FilenameExtension' -> 16r2C.
			'_OffsetOf_Flags' -> 16r34.
			'_OffsetOf_FormatDescription' -> 16r28.
			'_OffsetOf_FormatID' -> 16r10.
			'_OffsetOf_MimeType' -> 16r30.
			'_OffsetOf_SigCount' -> 16r3C.
			'_OffsetOf_SigMask' -> 16r48.
			'_OffsetOf_SigPattern' -> 16r44.
			'_OffsetOf_SigSize' -> 16r40.
			'_OffsetOf_Version' -> 16r38
		}!
Graphics.Gdiplus.ImageCodecInfo guid: (Core.GUID fromString: '{059e6e3a-2877-4ea7-a11c-7e5c1ac62165}')!
Graphics.Gdiplus.ImageCodecInfo comment: '<GpImageCodecInfo> is an <ExternalStructure> class to wrap the struct ''Gdiplus.GpImageCodecInfo'' from type information in the ''GDI+ Library 1.0'' library.

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
!Graphics.Gdiplus.ImageCodecInfo methodsFor!

Clsid
	"Answer the <GUID> value of the receiver's 'Clsid' field."

	^GUID fromAddress: bytes yourAddress!

Clsid: aGUID
	"Set the receiver's 'Clsid' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: ##(_OffsetOf_Clsid + 1)
		to: ##(_OffsetOf_Clsid + GUID._GUID_Size)
		startingAt: 1!

CodecName
	"Answer the <Utf16String> value of the receiver's 'CodecName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_CodecName)!

CodecName: anUtf16String
	"Set the receiver's 'CodecName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_CodecName put: anUtf16String yourAddress!

DllName
	"Answer the <Utf16String> value of the receiver's 'DllName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_DllName)!

DllName: anUtf16String
	"Set the receiver's 'DllName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_DllName put: anUtf16String yourAddress!

FilenameExtension
	"Answer the <Utf16String> value of the receiver's 'FilenameExtension' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_FilenameExtension)!

FilenameExtension: anUtf16String
	"Set the receiver's 'FilenameExtension' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_FilenameExtension put: anUtf16String yourAddress!

Flags
	"Answer the <Integer> value of the receiver's 'Flags' field."

	^bytes uint32AtOffset: _OffsetOf_Flags!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Flags put: anInteger!

FormatDescription
	"Answer the <Utf16String> value of the receiver's 'FormatDescription' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_FormatDescription)!

FormatDescription: anUtf16String
	"Set the receiver's 'FormatDescription' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_FormatDescription put: anUtf16String yourAddress!

FormatID
	"Answer the <GUID> value of the receiver's 'FormatID' field."

	^GUID fromAddress: bytes yourAddress + _OffsetOf_FormatID!

FormatID: aGUID
	"Set the receiver's 'FormatID' field to the value of the argument, aGUID"

	aGUID
		replaceBytesOf: bytes
		from: ##(_OffsetOf_FormatID + 1)
		to: ##(_OffsetOf_FormatID + GUID._GUID_Size)
		startingAt: 1!

MimeType
	"Answer the <Utf16String> value of the receiver's 'MimeType' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_MimeType)!

MimeType: anUtf16String
	"Set the receiver's 'MimeType' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_MimeType put: anUtf16String yourAddress!

SigCount
	"Answer the <Integer> value of the receiver's 'SigCount' field."

	^bytes uint32AtOffset: _OffsetOf_SigCount!

SigCount: anInteger
	"Set the receiver's 'SigCount' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_SigCount put: anInteger!

SigMask
	"Answer the <UInt8> value of the receiver's 'SigMask' field."

	^UInt8 fromAddress: (bytes intPtrAtOffset: _OffsetOf_SigMask)!

SigMask: aBYTE
	"Set the receiver's 'SigMask' field to the value of the argument, aBYTE"

	bytes uintPtrAtOffset: _OffsetOf_SigMask put: aBYTE yourAddress!

SigPattern
	"Answer the <UInt8> value of the receiver's 'SigPattern' field."

	^UInt8 fromAddress: (bytes intPtrAtOffset: _OffsetOf_SigPattern)!

SigPattern: aBYTE
	"Set the receiver's 'SigPattern' field to the value of the argument, aBYTE"

	bytes uintPtrAtOffset: _OffsetOf_SigPattern put: aBYTE yourAddress!

SigSize
	"Answer the <Integer> value of the receiver's 'SigSize' field."

	^bytes uint32AtOffset: _OffsetOf_SigSize!

SigSize: anInteger
	"Set the receiver's 'SigSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_SigSize put: anInteger!

Version
	"Answer the <Integer> value of the receiver's 'Version' field."

	^bytes uint32AtOffset: _OffsetOf_Version!

Version: anInteger
	"Set the receiver's 'Version' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_Version put: anInteger! !
!Graphics.Gdiplus.ImageCodecInfo categoriesForMethods!
Clsid!**compiled accessors**!public! !
Clsid:!**compiled accessors**!public! !
CodecName!**compiled accessors**!public! !
CodecName:!**compiled accessors**!public! !
DllName!**compiled accessors**!public! !
DllName:!**compiled accessors**!public! !
FilenameExtension!**compiled accessors**!public! !
FilenameExtension:!**compiled accessors**!public! !
Flags!**compiled accessors**!public! !
Flags:!**compiled accessors**!public! !
FormatDescription!**compiled accessors**!public! !
FormatDescription:!**compiled accessors**!public! !
FormatID!**compiled accessors**!public! !
FormatID:!**compiled accessors**!public! !
MimeType!**compiled accessors**!public! !
MimeType:!**compiled accessors**!public! !
SigCount!**compiled accessors**!public! !
SigCount:!**compiled accessors**!public! !
SigMask!**compiled accessors**!public! !
SigMask:!**compiled accessors**!public! !
SigPattern!**compiled accessors**!public! !
SigPattern:!**compiled accessors**!public! !
SigSize!**compiled accessors**!public! !
SigSize:!**compiled accessors**!public! !
Version!**compiled accessors**!public! !
Version:!**compiled accessors**!public! !
!

!Graphics.Gdiplus.ImageCodecInfo class methodsFor!

byteSize
	^_ImageCodecInfo_Size!

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
		defineField: #Clsid
			type: (StructureField type: GUID)
			offset: 0;
		defineField: #FormatID
			type: (StructureField type: GUID)
			offset: 16;
		defineField: #CodecName
			type: (PointerField type: Utf16String)
			offset: 32;
		defineField: #DllName
			type: (PointerField type: Utf16String)
			offset: 36;
		defineField: #FormatDescription
			type: (PointerField type: Utf16String)
			offset: 40;
		defineField: #FilenameExtension
			type: (PointerField type: Utf16String)
			offset: 44;
		defineField: #MimeType
			type: (PointerField type: Utf16String)
			offset: 48;
		defineField: #Flags
			type: UInt32Field new
			offset: 52;
		defineField: #Version
			type: UInt32Field new
			offset: 56;
		defineField: #SigCount
			type: UInt32Field new
			offset: 60;
		defineField: #SigSize
			type: UInt32Field new
			offset: 64;
		defineField: #SigPattern
			type: (PointerField type: UInt8)
			offset: 68;
		defineField: #SigMask
			type: (PointerField type: UInt8)
			offset: 72.
	self byteSize: 76!

getFieldNames
	^#(#Clsid #FormatID #CodecName #DllName #FormatDescription #FilenameExtension #MimeType #Flags #Version #SigCount #SigSize #SigPattern #SigMask)! !
!Graphics.Gdiplus.ImageCodecInfo class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

