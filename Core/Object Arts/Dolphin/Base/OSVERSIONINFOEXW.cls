"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #OSVERSIONINFOEXW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwBuildNumber _OffsetOf_dwMajorVersion _OffsetOf_dwMinorVersion _OffsetOf_dwPlatformId _OffsetOf_dwSize _OffsetOf_szCSDVersion _OffsetOf_wProductType _OffsetOf_wReserved _OffsetOf_wServicePackMajor _OffsetOf_wServicePackMinor _OffsetOf_wSuiteMask'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

OSVERSIONINFOEXW guid: (GUID fromString: '{1c5e8929-8791-4aa9-b7ea-152ef36b23dd}')!

OSVERSIONINFOEXW addClassConstant: '_OffsetOf_dwBuildNumber' value: 16rC!
OSVERSIONINFOEXW addClassConstant: '_OffsetOf_dwMajorVersion' value: 16r4!
OSVERSIONINFOEXW addClassConstant: '_OffsetOf_dwMinorVersion' value: 16r8!
OSVERSIONINFOEXW addClassConstant: '_OffsetOf_dwPlatformId' value: 16r10!
OSVERSIONINFOEXW addClassConstant: '_OffsetOf_dwSize' value: 16r0!
OSVERSIONINFOEXW addClassConstant: '_OffsetOf_szCSDVersion' value: 16r14!
OSVERSIONINFOEXW addClassConstant: '_OffsetOf_wProductType' value: 16r11A!
OSVERSIONINFOEXW addClassConstant: '_OffsetOf_wReserved' value: 16r11B!
OSVERSIONINFOEXW addClassConstant: '_OffsetOf_wServicePackMajor' value: 16r114!
OSVERSIONINFOEXW addClassConstant: '_OffsetOf_wServicePackMinor' value: 16r116!
OSVERSIONINFOEXW addClassConstant: '_OffsetOf_wSuiteMask' value: 16r118!

OSVERSIONINFOEXW comment: '<OSVERSIONINFOEX> is an <ExternalStructure> class to wrap the struct ''Win32.OSVERSIONINFOEXW'' from type information in the ''Win32 API'' library.

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

!OSVERSIONINFOEXW categoriesForClass!Win32-Structs! !

!OSVERSIONINFOEXW methodsFor!

dwBuildNumber
	"Answer the <Integer> value of the receiver's 'dwBuildNumber' field."

	^bytes dwordAtOffset: _OffsetOf_dwBuildNumber!

dwBuildNumber: anInteger
	"Set the receiver's 'dwBuildNumber' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwBuildNumber put: anInteger!

dwMajorVersion
	"Answer the <Integer> value of the receiver's 'dwMajorVersion' field."

	^bytes dwordAtOffset: _OffsetOf_dwMajorVersion!

dwMajorVersion: anInteger
	"Set the receiver's 'dwMajorVersion' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwMajorVersion put: anInteger!

dwMinorVersion
	"Answer the <Integer> value of the receiver's 'dwMinorVersion' field."

	^bytes dwordAtOffset: _OffsetOf_dwMinorVersion!

dwMinorVersion: anInteger
	"Set the receiver's 'dwMinorVersion' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwMinorVersion put: anInteger!

dwPlatformId
	"Answer the <Integer> value of the receiver's 'dwPlatformId' field."

	^bytes dwordAtOffset: _OffsetOf_dwPlatformId!

dwPlatformId: anInteger
	"Set the receiver's 'dwPlatformId' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwPlatformId put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

szCSDVersion
	"Answer the <Utf16String> value of the receiver's 'szCSDVersion' field."

	^Utf16String fromAddress: bytes yourAddress + _OffsetOf_szCSDVersion!

wProductType
	"Answer the <Integer> value of the receiver's 'wProductType' field."

	^bytes byteAtOffset: _OffsetOf_wProductType!

wProductType: anInteger
	"Set the receiver's 'wProductType' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_wProductType put: anInteger!

wServicePackMajor
	"Answer the <Integer> value of the receiver's 'wServicePackMajor' field."

	^bytes wordAtOffset: _OffsetOf_wServicePackMajor!

wServicePackMajor: anInteger
	"Set the receiver's 'wServicePackMajor' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wServicePackMajor put: anInteger!

wServicePackMinor
	"Answer the <Integer> value of the receiver's 'wServicePackMinor' field."

	^bytes wordAtOffset: _OffsetOf_wServicePackMinor!

wServicePackMinor: anInteger
	"Set the receiver's 'wServicePackMinor' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wServicePackMinor put: anInteger!

wSuiteMask
	"Answer the <Integer> value of the receiver's 'wSuiteMask' field."

	^bytes wordAtOffset: _OffsetOf_wSuiteMask!

wSuiteMask: anInteger
	"Set the receiver's 'wSuiteMask' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wSuiteMask put: anInteger! !

!OSVERSIONINFOEXW categoriesForMethods!
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

!OSVERSIONINFOEXW class methodsFor!

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
		defineField: #dwSize type: DWORDField new beWriteOnly offset: 0;
		defineField: #dwMajorVersion type: DWORDField new offset: 4;
		defineField: #dwMinorVersion type: DWORDField new offset: 8;
		defineField: #dwBuildNumber type: DWORDField new offset: 12;
		defineField: #dwPlatformId type: DWORDField new offset: 16;
		defineField: #szCSDVersion type: (StringField type: Utf16String length: 128) beReadOnly offset: 20;
		defineField: #wServicePackMajor type: WORDField new offset: 276;
		defineField: #wServicePackMinor type: WORDField new offset: 278;
		defineField: #wSuiteMask type: WORDField new offset: 280;
		defineField: #wProductType type: BYTEField new offset: 282;
		defineField: #wReserved type: BYTEField new beFiller offset: 283.
	self byteSize: 284!

getFieldNames
	^#(#dwSize #dwMajorVersion #dwMinorVersion #dwBuildNumber #dwPlatformId #szCSDVersion #wServicePackMajor #wServicePackMinor #wSuiteMask #wProductType)! !

!OSVERSIONINFOEXW class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

