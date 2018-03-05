"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #DOCINFOW
	instanceVariableNames: 'docName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DOCINFOW guid: (GUID fromString: '{87b4c5e8-026e-11d3-9fd7-00a0cc3e4a32}')!
DOCINFOW comment: 'DOCINFO is an <ExternalStructure> class which represents the Win32 DOCINFO structure of the same name.

DOCINFO is used in conjunction with the StartDoc() GDI call.'!
!DOCINFOW categoriesForClass!External-Data-Structured-Win32! !
!DOCINFOW methodsFor!

docName: aString
	docName := aString asUtf16String.
	self lpszDocName: docName!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: 0 put: anInteger!

fwType: anInteger
	"Set the receiver's 'fwType' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #fwType) put: anInteger!

lpszDatatype: anUtf16String
	"Set the receiver's 'lpszDatatype' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszDatatype) put: anUtf16String yourAddress!

lpszDocName: anUtf16String
	"Set the receiver's 'lpszDocName' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszDocName) put: anUtf16String yourAddress!

lpszOutput: anUtf16String
	"Set the receiver's 'lpszOutput' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszOutput) put: anUtf16String yourAddress! !
!DOCINFOW categoriesFor: #docName:!accessing!public! !
!DOCINFOW categoriesFor: #dwSize:!**compiled accessors**!public! !
!DOCINFOW categoriesFor: #fwType:!**compiled accessors**!public! !
!DOCINFOW categoriesFor: #lpszDatatype:!**compiled accessors**!public! !
!DOCINFOW categoriesFor: #lpszDocName:!**compiled accessors**!public! !
!DOCINFOW categoriesFor: #lpszOutput:!**compiled accessors**!public! !

!DOCINFOW class methodsFor!

defineFields
	"Define the fields of the Win32 DOCINFOW structure.

		self compileDefinition

	typedef struct {		// di  
		int		cbSize;
		LPCWSTR	lpszDocName;
		LPCWSTR	lpszOutput;
		LPCWSTR	lpszDatatype;	// Windows 95 only; ignored on Windows NT
		DWORD	fwType;		// Windows 95 only; ignored on Windows NT
		} DOCINFO;"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #lpszDocName type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #lpszOutput type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #lpszDatatype type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #fwType type: DWORDField writeOnly! !
!DOCINFOW class categoriesFor: #defineFields!initializing!public! !

