"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #OSVERSIONINFOEXW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
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
		'_OffsetOf_wSuiteMask' -> 16r118
	}!
OSVERSIONINFOEXW guid: (GUID fromString: '{1c5e8929-8791-4aa9-b7ea-152ef36b23dd}')!
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
!OSVERSIONINFOEXW categoriesFor: #dwBuildNumber!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #dwBuildNumber:!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #dwMajorVersion!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #dwMajorVersion:!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #dwMinorVersion!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #dwMinorVersion:!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #dwPlatformId!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #dwPlatformId:!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #dwSize:!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #szCSDVersion!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #wProductType!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #wProductType:!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #wServicePackMajor!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #wServicePackMajor:!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #wServicePackMinor!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #wServicePackMinor:!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #wSuiteMask!**compiled accessors**!public! !
!OSVERSIONINFOEXW categoriesFor: #wSuiteMask:!**compiled accessors**!public! !

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
!OSVERSIONINFOEXW class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OSVERSIONINFOEXW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

