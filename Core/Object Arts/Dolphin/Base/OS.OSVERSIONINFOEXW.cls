"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.OSVERSIONINFOEXW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwBuildNumber' -> 16rC.
		'_OffsetOf_dwMajorVersion' -> 16r4.
		'_OffsetOf_dwMinorVersion' -> 16r8.
		'_OffsetOf_dwPlatformId' -> 16r10.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_szCSDVersion' -> 16r14.
		'_OffsetOf_wProductType' -> 16r11A.
		'_OffsetOf_wReserved' -> 16r11B.
		'_OffsetOf_wServicePackMajor' -> 16r114.
		'_OffsetOf_wServicePackMinor' -> 16r116.
		'_OffsetOf_wSuiteMask' -> 16r118.
		'_OSVERSIONINFOEXW_Size' -> 16r11C
	}!
OS.OSVERSIONINFOEXW guid: (Core.GUID fromString: '{1c5e8929-8791-4aa9-b7ea-152ef36b23dd}')!
OS.OSVERSIONINFOEXW comment: '<OSVERSIONINFOEX> is an <ExternalStructure> class to wrap the struct ''Win32.OSVERSIONINFOEXW'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(1c5e8929-8791-4aa9-b7ea-152ef36b23dd)]
struct tagOSVERSIONINFOEXW {
	[restricted] DWORD dwSize;
	DWORD dwMajorVersion;
	DWORD dwMinorVersion;
	DWORD dwBuildNumber;
	DWORD dwPlatformId;
	[readonly, string] unsigned short szCSDVersion[128];
	WORD wServicePackMajor;
	WORD wServicePackMinor;
	WORD wSuiteMask;
	BYTE wProductType;
	[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] BYTE wReserved;
} OSVERSIONINFOEXW;
'!
!OS.OSVERSIONINFOEXW categoriesForClass!Win32-Structs! !
!OS.OSVERSIONINFOEXW methodsFor!

dwBuildNumber
	"Answer the <Integer> value of the receiver's 'dwBuildNumber' field."

	^bytes uint32AtOffset: _OffsetOf_dwBuildNumber!

dwBuildNumber: anInteger
	"Set the receiver's 'dwBuildNumber' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwBuildNumber put: anInteger!

dwMajorVersion
	"Answer the <Integer> value of the receiver's 'dwMajorVersion' field."

	^bytes uint32AtOffset: _OffsetOf_dwMajorVersion!

dwMajorVersion: anInteger
	"Set the receiver's 'dwMajorVersion' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwMajorVersion put: anInteger!

dwMinorVersion
	"Answer the <Integer> value of the receiver's 'dwMinorVersion' field."

	^bytes uint32AtOffset: _OffsetOf_dwMinorVersion!

dwMinorVersion: anInteger
	"Set the receiver's 'dwMinorVersion' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwMinorVersion put: anInteger!

dwPlatformId
	"Answer the <Integer> value of the receiver's 'dwPlatformId' field."

	^bytes uint32AtOffset: _OffsetOf_dwPlatformId!

dwPlatformId: anInteger
	"Set the receiver's 'dwPlatformId' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwPlatformId put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwSize put: anInteger!

szCSDVersion
	"Answer the <Utf16String> value of the receiver's 'szCSDVersion' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szCSDVersion!

wProductType
	"Answer the <Integer> value of the receiver's 'wProductType' field."

	^bytes uint8AtOffset: _OffsetOf_wProductType!

wProductType: anInteger
	"Set the receiver's 'wProductType' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_wProductType put: anInteger!

wServicePackMajor
	"Answer the <Integer> value of the receiver's 'wServicePackMajor' field."

	^bytes uint16AtOffset: _OffsetOf_wServicePackMajor!

wServicePackMajor: anInteger
	"Set the receiver's 'wServicePackMajor' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wServicePackMajor put: anInteger!

wServicePackMinor
	"Answer the <Integer> value of the receiver's 'wServicePackMinor' field."

	^bytes uint16AtOffset: _OffsetOf_wServicePackMinor!

wServicePackMinor: anInteger
	"Set the receiver's 'wServicePackMinor' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wServicePackMinor put: anInteger!

wSuiteMask
	"Answer the <Integer> value of the receiver's 'wSuiteMask' field."

	^bytes uint16AtOffset: _OffsetOf_wSuiteMask!

wSuiteMask: anInteger
	"Set the receiver's 'wSuiteMask' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wSuiteMask put: anInteger! !
!OS.OSVERSIONINFOEXW categoriesForMethods!
dwBuildNumber!**compiled accessors**!public! !
dwBuildNumber:!**compiled accessors**!public! !
dwMajorVersion!**compiled accessors**!public! !
dwMajorVersion:!**compiled accessors**!public! !
dwMinorVersion!**compiled accessors**!public! !
dwMinorVersion:!**compiled accessors**!public! !
dwPlatformId!**compiled accessors**!public! !
dwPlatformId:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
szCSDVersion!**compiled accessors**!public! !
wProductType!**compiled accessors**!public! !
wProductType:!**compiled accessors**!public! !
wServicePackMajor!**compiled accessors**!public! !
wServicePackMajor:!**compiled accessors**!public! !
wServicePackMinor!**compiled accessors**!public! !
wServicePackMinor:!**compiled accessors**!public! !
wSuiteMask!**compiled accessors**!public! !
wSuiteMask:!**compiled accessors**!public! !
!

!OS.OSVERSIONINFOEXW class methodsFor!

byteSize
	^_OSVERSIONINFOEXW_Size!

defineFields
	"Define the fields of the OSVERSIONINFOEXW structure.

	OSVERSIONINFOEXW compileDefinition

		typedef [uuid(1c5e8929-8791-4aa9-b7ea-152ef36b23dd)]
		struct tagOSVERSIONINFOEXW {
			[restricted] DWORD dwSize;
			DWORD dwMajorVersion;
			DWORD dwMinorVersion;
			DWORD dwBuildNumber;
			DWORD dwPlatformId;
			[readonly, string] unsigned short szCSDVersion[128];
			WORD wServicePackMajor;
			WORD wServicePackMinor;
			WORD wSuiteMask;
			BYTE wProductType;
			[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] BYTE wReserved;
		} OSVERSIONINFOEXW;
"

	self
		defineField: #dwSize
			type: UInt32Field new beWriteOnly
			offset: 0;
		defineField: #dwMajorVersion
			type: UInt32Field new
			offset: 4;
		defineField: #dwMinorVersion
			type: UInt32Field new
			offset: 8;
		defineField: #dwBuildNumber
			type: UInt32Field new
			offset: 12;
		defineField: #dwPlatformId
			type: UInt32Field new
			offset: 16;
		defineField: #szCSDVersion
			type: (StringField type: Utf16String length: 128) beReadOnly
			offset: 20;
		defineField: #wServicePackMajor
			type: UInt16Field new
			offset: 276;
		defineField: #wServicePackMinor
			type: UInt16Field new
			offset: 278;
		defineField: #wSuiteMask
			type: UInt16Field new
			offset: 280;
		defineField: #wProductType
			type: UInt8Field new
			offset: 282;
		defineField: #wReserved
			type: UInt8Field new beFiller
			offset: 283.
	self byteSize: 284!

getFieldNames
	^#(#dwSize #dwMajorVersion #dwMinorVersion #dwBuildNumber #dwPlatformId #szCSDVersion #wServicePackMajor #wServicePackMinor #wSuiteMask #wProductType)! !
!OS.OSVERSIONINFOEXW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

