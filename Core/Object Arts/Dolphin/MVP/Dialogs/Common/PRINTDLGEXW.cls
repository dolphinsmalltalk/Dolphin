"Filed out from Dolphin Smalltalk 7"!

CommonDialogStructure subclass: #PRINTDLGEXW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PRINTDLGEXW guid: (GUID fromString: '{46f06e70-1bb5-4b02-98ee-6ab442f3b43f}')!
PRINTDLGEXW comment: '<PRINTDLGEX> is an <ExternalStructure> class to wrap the struct ''Win32.PRINTDLGEX'' from type information in the ''Win32 API (ANSI). Derived from Bruce McKinney´s Hardcore Visual Basic Type Library'' library.

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
!PRINTDLGEXW categoriesForClass!Win32-Structs! !
!PRINTDLGEXW methodsFor!

dwResultAction
	"Answer the <Integer> value of the receiver's 'dwResultAction' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwResultAction)!

dwResultAction: anInteger
	"Set the receiver's 'dwResultAction' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwResultAction) put: anInteger!

ExclusionFlags
	"Answer the <Integer> value of the receiver's 'ExclusionFlags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #ExclusionFlags)!

ExclusionFlags: anInteger
	"Set the receiver's 'ExclusionFlags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #ExclusionFlags) put: anInteger!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anInteger!

Flags2
	"Answer the <Integer> value of the receiver's 'Flags2' field."

	^bytes dwordAtOffset: ##(self offsetOf: #Flags2)!

Flags2: anInteger
	"Set the receiver's 'Flags2' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #Flags2) put: anInteger!

hDC
	"Answer the <ExternalHandle> value of the receiver's 'hDC' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hDC)) asExternalHandle!

hDC: anExternalHandle
	"Set the receiver's 'hDC' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hDC) put: anExternalHandle!

hDevMode
	"Answer the <ExternalHandle> value of the receiver's 'hDevMode' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hDevMode)) asExternalHandle!

hDevMode: anExternalHandle
	"Set the receiver's 'hDevMode' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hDevMode) put: anExternalHandle!

hDevNames
	"Answer the <ExternalHandle> value of the receiver's 'hDevNames' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hDevNames)) asExternalHandle!

hDevNames: anExternalHandle
	"Set the receiver's 'hDevNames' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hDevNames) put: anExternalHandle!

hInstance
	"Answer the <ExternalHandle> value of the receiver's 'hInstance' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hInstance)) asExternalHandle!

hInstance: anExternalHandle
	"Set the receiver's 'hInstance' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hInstance) put: anExternalHandle!

hwndOwner
	"Answer the <ExternalHandle> value of the receiver's 'hwndOwner' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #hwndOwner)) asExternalHandle!

hwndOwner: anExternalHandle
	"Set the receiver's 'hwndOwner' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #hwndOwner) put: anExternalHandle!

lpCallback
	"Answer the <IUnknown> value of the receiver's 'lpCallback' field."

	^IUnknown fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpCallback))!

lpCallback: anIUnknown
	"Set the receiver's 'lpCallback' field to the value of the argument, anIUnknown"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpCallback) put: anIUnknown yourAddress!

lphPropertyPages
	"Answer the <ExternalHandle> value of the receiver's 'lphPropertyPages' field."

	^ExternalHandle fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lphPropertyPages))!

lphPropertyPages: anExternalHandle
	"Set the receiver's 'lphPropertyPages' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: ##(self offsetOf: #lphPropertyPages) put: anExternalHandle yourAddress!

lpPageRanges
	"Answer the <PRINTPAGERANGE> value of the receiver's 'lpPageRanges' field."

	^PRINTPAGERANGE fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpPageRanges))!

lpPageRanges: aPRINTPAGERANGE
	"Set the receiver's 'lpPageRanges' field to the value of the argument, aPRINTPAGERANGE"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpPageRanges) put: aPRINTPAGERANGE yourAddress!

lpPrintTemplateName
	"Answer the <Utf16String> value of the receiver's 'lpPrintTemplateName' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpPrintTemplateName))!

lpPrintTemplateName: anUtf16String
	"Set the receiver's 'lpPrintTemplateName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpPrintTemplateName) put: anUtf16String yourAddress!

lStructSize
	"Answer the <Integer> value of the receiver's 'lStructSize' field."

	^bytes dwordAtOffset: 0!

lStructSize: anInteger
	"Set the receiver's 'lStructSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

nCopies
	"Answer the <Integer> value of the receiver's 'nCopies' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nCopies)!

nCopies: anInteger
	"Set the receiver's 'nCopies' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nCopies) put: anInteger!

nMaxPage
	"Answer the <Integer> value of the receiver's 'nMaxPage' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nMaxPage)!

nMaxPage: anInteger
	"Set the receiver's 'nMaxPage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nMaxPage) put: anInteger!

nMaxPageRanges
	"Answer the <Integer> value of the receiver's 'nMaxPageRanges' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nMaxPageRanges)!

nMaxPageRanges: anInteger
	"Set the receiver's 'nMaxPageRanges' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nMaxPageRanges) put: anInteger!

nMinPage
	"Answer the <Integer> value of the receiver's 'nMinPage' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nMinPage)!

nMinPage: anInteger
	"Set the receiver's 'nMinPage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nMinPage) put: anInteger!

nPageRanges
	"Answer the <Integer> value of the receiver's 'nPageRanges' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nPageRanges)!

nPageRanges: anInteger
	"Set the receiver's 'nPageRanges' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nPageRanges) put: anInteger!

nPropertyPages
	"Answer the <Integer> value of the receiver's 'nPropertyPages' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nPropertyPages)!

nPropertyPages: anInteger
	"Set the receiver's 'nPropertyPages' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nPropertyPages) put: anInteger!

nStartPage
	"Answer the <Integer> value of the receiver's 'nStartPage' field."

	^bytes dwordAtOffset: ##(self offsetOf: #nStartPage)!

nStartPage: anInteger
	"Set the receiver's 'nStartPage' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #nStartPage) put: anInteger! !
!PRINTDLGEXW categoriesFor: #dwResultAction!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #dwResultAction:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #ExclusionFlags!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #ExclusionFlags:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #flags!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #flags:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #Flags2!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #Flags2:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #hDC!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #hDC:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #hDevMode!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #hDevMode:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #hDevNames!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #hDevNames:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #hInstance!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #hInstance:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #hwndOwner!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #lpCallback!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #lpCallback:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #lphPropertyPages!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #lphPropertyPages:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #lpPageRanges!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #lpPageRanges:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #lpPrintTemplateName!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #lpPrintTemplateName:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #lStructSize!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #lStructSize:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nCopies!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nCopies:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nMaxPage!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nMaxPage:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nMaxPageRanges!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nMaxPageRanges:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nMinPage!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nMinPage:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nPageRanges!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nPageRanges:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nPropertyPages!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nPropertyPages:!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nStartPage!**compiled accessors**!public! !
!PRINTDLGEXW categoriesFor: #nStartPage:!**compiled accessors**!public! !

!PRINTDLGEXW class methodsFor!

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
		defineField: #lpPrintTemplateName type: (PointerField type: Utf16String);
		defineField: #lpCallback type: (PointerField type: IUnknown);
		defineField: #nPropertyPages type: DWORDField new;
		defineField: #lphPropertyPages type: (PointerField type: ExternalHandle);
		defineField: #nStartPage type: DWORDField new;
		defineField: #dwResultAction type: DWORDField new! !
!PRINTDLGEXW class categoriesFor: #defineFields!**auto generated**!initializing!public! !

