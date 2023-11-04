"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.CRYPTPROTECT_PROMPTSTRUCT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_CRYPTPROTECT_PROMPTSTRUCT_Size' -> 16r10.
			'_OffsetOf_dwPromptFlags' -> 16r4.
			'_OffsetOf_hwndApp' -> 16r8.
			'_OffsetOf_szPrompt' -> 16rC
		}!
OS.CRYPTPROTECT_PROMPTSTRUCT guid: (Core.GUID fromString: '{870680a4-0d5d-45b2-88b4-74774c010bc5}')!
OS.CRYPTPROTECT_PROMPTSTRUCT comment: '<CRYPTPROTECT_PROMPTSTRUCT> is an <ExternalStructure> class to wrap the struct ''Win32.CRYPTPROTECT_PROMPTSTRUCT'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagCRYPTPROTECT_PROMPTSTRUCT {
} CRYPTPROTECT_PROMPTSTRUCT;
'!
!OS.CRYPTPROTECT_PROMPTSTRUCT categoriesForClass!Win32-Structs! !
!OS.CRYPTPROTECT_PROMPTSTRUCT methodsFor!

dwPromptFlags
	"Answer the <Integer> value of the receiver's 'dwPromptFlags' field."

	^bytes uint32AtOffset: _OffsetOf_dwPromptFlags!

dwPromptFlags: anInteger
	"Set the receiver's 'dwPromptFlags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwPromptFlags put: anInteger!

hwndApp
	"Answer the <Handle> value of the receiver's 'hwndApp' field."

	^(bytes uintPtrAtOffset: _OffsetOf_hwndApp) asExternalHandle!

hwndApp: aHandle
	"Set the receiver's 'hwndApp' field to the value of the argument, aHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwndApp put: aHandle!

szPrompt
	"Answer the <Utf16String> value of the receiver's 'szPrompt' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_szPrompt)!

szPrompt: anUtf16String
	"Set the receiver's 'szPrompt' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_szPrompt put: anUtf16String yourAddress! !
!OS.CRYPTPROTECT_PROMPTSTRUCT categoriesForMethods!
dwPromptFlags!**compiled accessors**!public! !
dwPromptFlags:!**compiled accessors**!public! !
hwndApp!**compiled accessors**!public! !
hwndApp:!**compiled accessors**!public! !
szPrompt!**compiled accessors**!public! !
szPrompt:!**compiled accessors**!public! !
!

!OS.CRYPTPROTECT_PROMPTSTRUCT class methodsFor!

byteSize
	^_CRYPTPROTECT_PROMPTSTRUCT_Size!

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

	super defineFields.
	self
		defineField: #dwPromptFlags
			type: UInt32Field new
			offset: 4;
		defineField: #hwndApp
			type: HANDLEField new
			offset: 8;
		defineField: #szPrompt
			type: (PointerField type: Utf16String)
			offset: 12.
	self byteSize: 16!

getFieldNames
	^#(#dwSize #dwPromptFlags #hwndApp #szPrompt)! !
!OS.CRYPTPROTECT_PROMPTSTRUCT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

