"Filed out from Dolphin Smalltalk 7"!

CommonDialogStructure subclass: #PRINTDLGEX
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PRINTDLGEX guid: (GUID fromString: '{46f06e70-1bb5-4b02-98ee-6ab442f3b43f}')!
PRINTDLGEX comment: '<PRINTDLGEX> is an <ExternalStructure> class to wrap the struct ''Win32.PRINTDLGEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef [uuid(46F06E70-1BB5-4B02-98EE-6AB442F3B43F)]
struct tagPRINTDLGEX {
	DWORD lStructSize;
	HWND hwndOwner;
	HGLOBAL hDevMode;
	HGLOBAL hDevNames;
	HDC HDC;
	DWORD flags;
	DWORD Flags2;
	DWORD ExclusionFlags;
	DWORD nPageRanges;
	DWORD nMaxPageRanges;
	PRINTPAGERANGE* lpPageRanges;
	DWORD nMinPage;
	DWORD nMaxPage;
	DWORD nCopies;
	HINSTANCE HINSTANCE;
	LPCSTR lpPrintTemplateName;
	IUnknown* lpCallback;
	DWORD nPropertyPages;
	HPROPSHEETPAGE* lphPropertyPages;
	DWORD nStartPage;
	DWORD dwResultAction;
} PRINTDLGEX;
'!
!PRINTDLGEX categoriesForClass!Win32-Structs! !
!PRINTDLGEX methodsFor!

dwResultAction
	"Answer the receiver's dwResultAction field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwResultAction)!

dwResultAction: anObject 
	"Set the receiver's dwResultAction field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwResultAction) put: anObject!

ExclusionFlags
	"Answer the receiver's ExclusionFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #ExclusionFlags)!

ExclusionFlags: anObject 
	"Set the receiver's ExclusionFlags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #ExclusionFlags) put: anObject!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anObject 
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anObject!

Flags2
	"Answer the receiver's Flags2 field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #Flags2)!

Flags2: anObject 
	"Set the receiver's Flags2 field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #Flags2) put: anObject!

hDC
	"Answer the receiver's hDC field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hDC)) asExternalHandle!

hDC: anObject 
	"Set the receiver's hDC field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hDC) put: anObject!

hDevMode
	"Answer the receiver's hDevMode field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hDevMode)) asExternalHandle!

hDevMode: anObject 
	"Set the receiver's hDevMode field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hDevMode) put: anObject!

hDevNames
	"Answer the receiver's hDevNames field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hDevNames)) asExternalHandle!

hDevNames: anObject 
	"Set the receiver's hDevNames field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hDevNames) put: anObject!

hInstance
	"Answer the receiver's hInstance field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hInstance)) asExternalHandle!

hInstance: anObject 
	"Set the receiver's hInstance field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hInstance) put: anObject!

hwndOwner
	"Answer the receiver's hwndOwner field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hwndOwner)) asExternalHandle!

hwndOwner: anObject 
	"Set the receiver's hwndOwner field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hwndOwner) put: anObject!

lpCallback
	"Answer the receiver's lpCallback field as a Smalltalk object."

	^IUnknown fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpCallback))!

lpCallback: anObject 
	"Set the receiver's lpCallback field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpCallback) put: anObject yourAddress!

lphPropertyPages
	"Answer the receiver's lphPropertyPages field as a Smalltalk object."

	^ExternalHandle fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lphPropertyPages))!

lphPropertyPages: anObject 
	"Set the receiver's lphPropertyPages field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lphPropertyPages) put: anObject yourAddress!

lpPageRanges
	"Answer the receiver's lpPageRanges field as a Smalltalk object."

	^PRINTPAGERANGE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpPageRanges))!

lpPageRanges: anObject 
	"Set the receiver's lpPageRanges field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpPageRanges) put: anObject yourAddress!

lpPrintTemplateName
	"Answer the receiver's lpPrintTemplateName field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpPrintTemplateName))!

lpPrintTemplateName: anObject 
	"Set the receiver's lpPrintTemplateName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpPrintTemplateName) put: anObject yourAddress!

lStructSize
	"Answer the receiver's lStructSize field as a Smalltalk object."

	^bytes dwordAtOffset: 0!

lStructSize: anObject 
	"Set the receiver's lStructSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

nCopies
	"Answer the receiver's nCopies field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nCopies)!

nCopies: anObject 
	"Set the receiver's nCopies field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nCopies) put: anObject!

nMaxPage
	"Answer the receiver's nMaxPage field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nMaxPage)!

nMaxPage: anObject 
	"Set the receiver's nMaxPage field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nMaxPage) put: anObject!

nMaxPageRanges
	"Answer the receiver's nMaxPageRanges field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nMaxPageRanges)!

nMaxPageRanges: anObject 
	"Set the receiver's nMaxPageRanges field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nMaxPageRanges) put: anObject!

nMinPage
	"Answer the receiver's nMinPage field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nMinPage)!

nMinPage: anObject 
	"Set the receiver's nMinPage field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nMinPage) put: anObject!

nPageRanges
	"Answer the receiver's nPageRanges field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nPageRanges)!

nPageRanges: anObject 
	"Set the receiver's nPageRanges field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nPageRanges) put: anObject!

nPropertyPages
	"Answer the receiver's nPropertyPages field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nPropertyPages)!

nPropertyPages: anObject 
	"Set the receiver's nPropertyPages field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nPropertyPages) put: anObject!

nStartPage
	"Answer the receiver's nStartPage field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #nStartPage)!

nStartPage: anObject 
	"Set the receiver's nStartPage field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #nStartPage) put: anObject! !
!PRINTDLGEX categoriesFor: #dwResultAction!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #dwResultAction:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #ExclusionFlags!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #ExclusionFlags:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #flags!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #flags:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #Flags2!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #Flags2:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #hDC!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #hDC:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #hDevMode!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #hDevMode:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #hDevNames!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #hDevNames:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #hInstance!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #hInstance:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #hwndOwner!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #lpCallback!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #lpCallback:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #lphPropertyPages!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #lphPropertyPages:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #lpPageRanges!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #lpPageRanges:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #lpPrintTemplateName!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #lpPrintTemplateName:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #lStructSize!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #lStructSize:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nCopies!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nCopies:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nMaxPage!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nMaxPage:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nMaxPageRanges!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nMaxPageRanges:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nMinPage!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nMinPage:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nPageRanges!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nPageRanges:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nPropertyPages!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nPropertyPages:!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nStartPage!**compiled accessors**!public! !
!PRINTDLGEX categoriesFor: #nStartPage:!**compiled accessors**!public! !

!PRINTDLGEX class methodsFor!

defineFields
	"Define the fields of the PRINTDLGEX structure.

	PRINTDLGEX  compileDefinition

		typedef [uuid(46F06E70-1BB5-4B02-98EE-6AB442F3B43F)]
		struct tagPRINTDLGEX {
			DWORD lStructSize;
			HWND hwndOwner;
			HGLOBAL hDevMode;
			HGLOBAL hDevNames;
			HDC HDC;
			DWORD flags;
			DWORD Flags2;
			DWORD ExclusionFlags;
			DWORD nPageRanges;
			DWORD nMaxPageRanges;
			PRINTPAGERANGE* lpPageRanges;
			DWORD nMinPage;
			DWORD nMaxPage;
			DWORD nCopies;
			HINSTANCE HINSTANCE;
			LPCSTR lpPrintTemplateName;
			IUnknown* lpCallback;
			DWORD nPropertyPages;
			HPROPSHEETPAGE* lphPropertyPages;
			DWORD nStartPage;
			DWORD dwResultAction;
		} PRINTDLGEX;
"

	self
		defineField: #lStructSize type: DWORDField new;
		defineField: #hwndOwner type: HANDLEField new;
		defineField: #hDevMode type: HANDLEField new;
		defineField: #hDevNames type: HANDLEField new;
		defineField: #hDC type: HANDLEField new;
		defineField: #flags type: DWORDField new;
		defineField: #Flags2 type: DWORDField new;
		defineField: #ExclusionFlags type: DWORDField new;
		defineField: #nPageRanges type: DWORDField new;
		defineField: #nMaxPageRanges type: DWORDField new;
		defineField: #lpPageRanges type: (PointerField type: PRINTPAGERANGE);
		defineField: #nMinPage type: DWORDField new;
		defineField: #nMaxPage type: DWORDField new;
		defineField: #nCopies type: DWORDField new;
		defineField: #hInstance type: HANDLEField new;
		defineField: #lpPrintTemplateName type: (PointerField type: String);
		defineField: #lpCallback type: (PointerField type: IUnknown);
		defineField: #nPropertyPages type: DWORDField new;
		defineField: #lphPropertyPages type: (PointerField type: ExternalHandle);
		defineField: #nStartPage type: DWORDField new;
		defineField: #dwResultAction type: DWORDField new! !
!PRINTDLGEX class categoriesFor: #defineFields!**auto generated**!initializing!public! !

