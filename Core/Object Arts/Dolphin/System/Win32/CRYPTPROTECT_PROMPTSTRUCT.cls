"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #CRYPTPROTECT_PROMPTSTRUCT
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CRYPTPROTECT_PROMPTSTRUCT guid: (GUID fromString: '{870680a4-0d5d-45b2-88b4-74774c010bc5}')!
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
	"Answer the receiver's dwPromptFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwPromptFlags)!

dwPromptFlags: anObject
	"Set the receiver's dwPromptFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwPromptFlags) put: anObject!

dwSize: anObject
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

hwndApp
	"Answer the receiver's hwndApp field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hwndApp)) asExternalHandle!

hwndApp: anObject
	"Set the receiver's hwndApp field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hwndApp) put: anObject!

szPrompt
	"Answer the receiver's szPrompt field as a Smalltalk object."

	^UnicodeString fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #szPrompt))!

szPrompt: anObject
	"Set the receiver's szPrompt field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #szPrompt) put: anObject yourAddress! !
!CRYPTPROTECT_PROMPTSTRUCT categoriesFor: #dwPromptFlags!**compiled accessors**!public! !
!CRYPTPROTECT_PROMPTSTRUCT categoriesFor: #dwPromptFlags:!**compiled accessors**!public! !
!CRYPTPROTECT_PROMPTSTRUCT categoriesFor: #dwSize:!**compiled accessors**!public! !
!CRYPTPROTECT_PROMPTSTRUCT categoriesFor: #hwndApp!**compiled accessors**!public! !
!CRYPTPROTECT_PROMPTSTRUCT categoriesFor: #hwndApp:!**compiled accessors**!public! !
!CRYPTPROTECT_PROMPTSTRUCT categoriesFor: #szPrompt!**compiled accessors**!public! !
!CRYPTPROTECT_PROMPTSTRUCT categoriesFor: #szPrompt:!**compiled accessors**!public! !

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
		defineField: #szPrompt type: (PointerField type: UnicodeString) offset: 12.
	self byteSize: 16! !
!CRYPTPROTECT_PROMPTSTRUCT class categoriesFor: #defineFields!**auto generated**!initializing!public! !

