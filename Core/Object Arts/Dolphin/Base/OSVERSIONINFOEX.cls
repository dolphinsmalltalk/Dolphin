"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #OSVERSIONINFOEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OSVERSIONINFOEX guid: (GUID fromString: '{1c5e8929-8791-4aa9-b7ea-152ef36b23dd}')!
OSVERSIONINFOEX comment: '<OSVERSIONINFOEX> is an <ExternalStructure> class to wrap the struct ''Win32.OSVERSIONINFOEX'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(1c5e8929-8791-4aa9-b7ea-152ef36b23dd)]
struct tagOSVERSIONINFOEX {
	[restricted] DWORD dwSize;
	DWORD dwMajorVersion;
	DWORD dwMinorVersion;
	DWORD dwBuildNumber;
	DWORD dwPlatformId;
	[readonly, string] BYTE szCSDVersion[128];
	WORD wServicePackMajor;
	WORD wServicePackMinor;
	WORD wSuiteMask;
	BYTE wProductType;
	[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] BYTE wReserved;
} OSVERSIONINFOEX;
'!
!OSVERSIONINFOEX categoriesForClass!Win32-Structs! !
!OSVERSIONINFOEX methodsFor!

dwBuildNumber
	"Answer the <Integer> value of the receiver's 'dwBuildNumber' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwBuildNumber)!

dwBuildNumber: anInteger
	"Set the receiver's 'dwBuildNumber' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwBuildNumber) put: anInteger!

dwMajorVersion
	"Answer the <Integer> value of the receiver's 'dwMajorVersion' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwMajorVersion)!

dwMajorVersion: anInteger
	"Set the receiver's 'dwMajorVersion' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwMajorVersion) put: anInteger!

dwMinorVersion
	"Answer the <Integer> value of the receiver's 'dwMinorVersion' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwMinorVersion)!

dwMinorVersion: anInteger
	"Set the receiver's 'dwMinorVersion' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwMinorVersion) put: anInteger!

dwPlatformId
	"Answer the <Integer> value of the receiver's 'dwPlatformId' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwPlatformId)!

dwPlatformId: anInteger
	"Set the receiver's 'dwPlatformId' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwPlatformId) put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

szCSDVersion
	"Answer the <String> value of the receiver's 'szCSDVersion' field."

	^String fromAddress: bytes yourAddress + ##(self offsetOf: #szCSDVersion)!

wProductType
	"Answer the <Integer> value of the receiver's 'wProductType' field."

	^bytes byteAtOffset: ##(self offsetOf: #wProductType)!

wProductType: anInteger
	"Set the receiver's 'wProductType' field to the value of the argument, anInteger"

	bytes byteAtOffset: ##(self offsetOf: #wProductType) put: anInteger!

wServicePackMajor
	"Answer the <Integer> value of the receiver's 'wServicePackMajor' field."

	^bytes wordAtOffset: ##(self offsetOf: #wServicePackMajor)!

wServicePackMajor: anInteger
	"Set the receiver's 'wServicePackMajor' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #wServicePackMajor) put: anInteger!

wServicePackMinor
	"Answer the <Integer> value of the receiver's 'wServicePackMinor' field."

	^bytes wordAtOffset: ##(self offsetOf: #wServicePackMinor)!

wServicePackMinor: anInteger
	"Set the receiver's 'wServicePackMinor' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #wServicePackMinor) put: anInteger!

wSuiteMask
	"Answer the <Integer> value of the receiver's 'wSuiteMask' field."

	^bytes wordAtOffset: ##(self offsetOf: #wSuiteMask)!

wSuiteMask: anInteger
	"Set the receiver's 'wSuiteMask' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #wSuiteMask) put: anInteger! !
!OSVERSIONINFOEX categoriesFor: #dwBuildNumber!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #dwBuildNumber:!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #dwMajorVersion!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #dwMajorVersion:!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #dwMinorVersion!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #dwMinorVersion:!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #dwPlatformId!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #dwPlatformId:!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #dwSize:!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #szCSDVersion!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #wProductType!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #wProductType:!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #wServicePackMajor!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #wServicePackMajor:!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #wServicePackMinor!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #wServicePackMinor:!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #wSuiteMask!**compiled accessors**!public! !
!OSVERSIONINFOEX categoriesFor: #wSuiteMask:!**compiled accessors**!public! !

!OSVERSIONINFOEX class methodsFor!

defineFields
	"Define the fields of the OSVERSIONINFOEX structure.

	OSVERSIONINFOEX compileDefinition

		typedef [uuid(1c5e8929-8791-4aa9-b7ea-152ef36b23dd)]
		struct tagOSVERSIONINFOEX {
			[restricted] DWORD dwSize;
			DWORD dwMajorVersion;
			DWORD dwMinorVersion;
			DWORD dwBuildNumber;
			DWORD dwPlatformId;
			[readonly, string] BYTE szCSDVersion[128];
			WORD wServicePackMajor;
			WORD wServicePackMinor;
			WORD wSuiteMask;
			BYTE wProductType;
			[hidden, custom(9d8468d2-88ea-4452-b32c-992c9937e29c, 0)] BYTE wReserved;
		} OSVERSIONINFOEX;
"

	self
		defineField: #dwSize type: DWORDField new beWriteOnly offset: 0;
		defineField: #dwMajorVersion type: DWORDField new offset: 4;
		defineField: #dwMinorVersion type: DWORDField new offset: 8;
		defineField: #dwBuildNumber type: DWORDField new offset: 12;
		defineField: #dwPlatformId type: DWORDField new offset: 16;
		defineField: #szCSDVersion type: (StringField type: String length: 128) beReadOnly offset: 20;
		defineField: #wServicePackMajor type: WORDField new offset: 148;
		defineField: #wServicePackMinor type: WORDField new offset: 150;
		defineField: #wSuiteMask type: WORDField new offset: 152;
		defineField: #wProductType type: BYTEField new offset: 154;
		defineField: #wReserved type: BYTEField new beFiller offset: 155.
	self byteSize: 156! !
!OSVERSIONINFOEX class categoriesFor: #defineFields!**auto generated**!initializing!public! !

