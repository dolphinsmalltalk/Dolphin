"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #GpImageCodecInfo
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_Clsid _OffsetOf_CodecName _OffsetOf_DllName _OffsetOf_FilenameExtension _OffsetOf_Flags _OffsetOf_FormatDescription _OffsetOf_FormatID _OffsetOf_MimeType _OffsetOf_SigCount _OffsetOf_SigMask _OffsetOf_SigPattern _OffsetOf_SigSize _OffsetOf_Version'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GpImageCodecInfo guid: (GUID fromString: '{059e6e3a-2877-4ea7-a11c-7e5c1ac62165}')!

GpImageCodecInfo addClassConstant: '_OffsetOf_Clsid' value: 16r0!
GpImageCodecInfo addClassConstant: '_OffsetOf_CodecName' value: 16r20!
GpImageCodecInfo addClassConstant: '_OffsetOf_DllName' value: 16r24!
GpImageCodecInfo addClassConstant: '_OffsetOf_FilenameExtension' value: 16r2C!
GpImageCodecInfo addClassConstant: '_OffsetOf_Flags' value: 16r34!
GpImageCodecInfo addClassConstant: '_OffsetOf_FormatDescription' value: 16r28!
GpImageCodecInfo addClassConstant: '_OffsetOf_FormatID' value: 16r10!
GpImageCodecInfo addClassConstant: '_OffsetOf_MimeType' value: 16r30!
GpImageCodecInfo addClassConstant: '_OffsetOf_SigCount' value: 16r3C!
GpImageCodecInfo addClassConstant: '_OffsetOf_SigMask' value: 16r48!
GpImageCodecInfo addClassConstant: '_OffsetOf_SigPattern' value: 16r44!
GpImageCodecInfo addClassConstant: '_OffsetOf_SigSize' value: 16r40!
GpImageCodecInfo addClassConstant: '_OffsetOf_Version' value: 16r38!

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
		from: ##(_OffsetOf_Clsid + 1)
		to: ##(_OffsetOf_Clsid + GUID basicByteSize)
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

	^bytes dwordAtOffset: _OffsetOf_Flags!

Flags: anInteger
	"Set the receiver's 'Flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Flags put: anInteger!

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
		to: ##(_OffsetOf_FormatID + GUID basicByteSize)
		startingAt: 1!

MimeType
	"Answer the <Utf16String> value of the receiver's 'MimeType' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_MimeType)!

MimeType: anUtf16String
	"Set the receiver's 'MimeType' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_MimeType put: anUtf16String yourAddress!

SigCount
	"Answer the <Integer> value of the receiver's 'SigCount' field."

	^bytes dwordAtOffset: _OffsetOf_SigCount!

SigCount: anInteger
	"Set the receiver's 'SigCount' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_SigCount put: anInteger!

SigMask
	"Answer the <BYTE> value of the receiver's 'SigMask' field."

	^BYTE fromAddress: (bytes intPtrAtOffset: _OffsetOf_SigMask)!

SigMask: aBYTE
	"Set the receiver's 'SigMask' field to the value of the argument, aBYTE"

	bytes uintPtrAtOffset: _OffsetOf_SigMask put: aBYTE yourAddress!

SigPattern
	"Answer the <BYTE> value of the receiver's 'SigPattern' field."

	^BYTE fromAddress: (bytes intPtrAtOffset: _OffsetOf_SigPattern)!

SigPattern: aBYTE
	"Set the receiver's 'SigPattern' field to the value of the argument, aBYTE"

	bytes uintPtrAtOffset: _OffsetOf_SigPattern put: aBYTE yourAddress!

SigSize
	"Answer the <Integer> value of the receiver's 'SigSize' field."

	^bytes dwordAtOffset: _OffsetOf_SigSize!

SigSize: anInteger
	"Set the receiver's 'SigSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_SigSize put: anInteger!

Version
	"Answer the <Integer> value of the receiver's 'Version' field."

	^bytes dwordAtOffset: _OffsetOf_Version!

Version: anInteger
	"Set the receiver's 'Version' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_Version put: anInteger! !

!GpImageCodecInfo categoriesForMethods!
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
	self byteSize: 76!

getFieldNames
	^#(#Clsid #FormatID #CodecName #DllName #FormatDescription #FilenameExtension #MimeType #Flags #Version #SigCount #SigSize #SigPattern #SigMask)! !

!GpImageCodecInfo class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

