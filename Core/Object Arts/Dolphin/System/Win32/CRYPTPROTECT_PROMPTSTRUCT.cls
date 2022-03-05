"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #CRYPTPROTECT_PROMPTSTRUCT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwPromptFlags _OffsetOf_dwSize _OffsetOf_hwndApp _OffsetOf_szPrompt'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CRYPTPROTECT_PROMPTSTRUCT guid: (GUID fromString: '{870680a4-0d5d-45b2-88b4-74774c010bc5}')!
CRYPTPROTECT_PROMPTSTRUCT addClassConstant: '_OffsetOf_dwPromptFlags' value: 16r4!
CRYPTPROTECT_PROMPTSTRUCT addClassConstant: '_OffsetOf_dwSize' value: 16r0!
CRYPTPROTECT_PROMPTSTRUCT addClassConstant: '_OffsetOf_hwndApp' value: 16r8!
CRYPTPROTECT_PROMPTSTRUCT addClassConstant: '_OffsetOf_szPrompt' value: 16rC!
CRYPTPROTECT_PROMPTSTRUCT comment: '<CRYPTPROTECT_PROMPTSTRUCT> is an <ExternalStructure> class to wrap the struct ''Win32.CRYPTPROTECT_PROMPTSTRUCT'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagCRYPTPROTECT_PROMPTSTRUCT {
} CRYPTPROTECT_PROMPTSTRUCT;
'!
!CRYPTPROTECT_PROMPTSTRUCT categoriesForClass!Win32-Structs! !
!CRYPTPROTECT_PROMPTSTRUCT methodsFor!

dwPromptFlags
	"Answer the <Integer> value of the receiver's 'dwPromptFlags' field."

	^bytes dwordAtOffset: _OffsetOf_dwPromptFlags!

dwPromptFlags: anInteger
	"Set the receiver's 'dwPromptFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwPromptFlags put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

hwndApp
	"Answer the <ExternalHandle> value of the receiver's 'hwndApp' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hwndApp) asExternalHandle!

hwndApp: anExternalHandle
	"Set the receiver's 'hwndApp' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwndApp put: anExternalHandle!

szPrompt
	"Answer the <Utf16String> value of the receiver's 'szPrompt' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_szPrompt)!

szPrompt: anUtf16String
	"Set the receiver's 'szPrompt' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_szPrompt put: anUtf16String yourAddress! !
!CRYPTPROTECT_PROMPTSTRUCT categoriesForMethods!
dwPromptFlags!**compiled accessors**!public! !
dwPromptFlags:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
hwndApp!**compiled accessors**!public! !
hwndApp:!**compiled accessors**!public! !
szPrompt!**compiled accessors**!public! !
szPrompt:!**compiled accessors**!public! !
!

!CRYPTPROTECT_PROMPTSTRUCT class methodsFor!

defineFields
	"Define the fields of the CRYPTPROTECT_PROMPTSTRUCT structure.

	CRYPTPROTECT_PROMPTSTRUCT  compileDefinition

		typedef 
		struct tagCRYPTPROTECT_PROMPTSTRUCT {
			unsigned long cbSize;
			unsigned long dwPromptFlags;
			HWND hwndApp;
			LPCWSTR szPrompt;
		} CRYPTPROTECT_PROMPTSTRUCT;
"

	self
		defineField: #dwSize type: DWORDField new beWriteOnly offset: 0;
		defineField: #dwPromptFlags type: DWORDField new offset: 4;
		defineField: #hwndApp type: HANDLEField new offset: 8;
		defineField: #szPrompt type: (PointerField type: Utf16String) offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#dwSize #dwPromptFlags #hwndApp #szPrompt)! !
!CRYPTPROTECT_PROMPTSTRUCT class categoriesForMethods!
defineFields!**auto generated**!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

