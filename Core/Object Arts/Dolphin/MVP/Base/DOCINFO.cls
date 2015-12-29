"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #DOCINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DOCINFO guid: (GUID fromString: '{87B4C5E8-026E-11D3-9FD7-00A0CC3E4A32}')!
DOCINFO comment: 'DOCINFO is an <ExternalStructure> class which represents the Win32 DOCINFO structure of the same name.

DOCINFO is used in conjunction with the StartDoc() GDI call.'!
!DOCINFO categoriesForClass!External-Data-Structured-Win32! !
!DOCINFO methodsFor!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

fwType: anObject 
	"Set the receiver's fwType field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #fwType) put: anObject!

lpszDatatype: anObject 
	"Set the receiver's lpszDatatype field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszDatatype) put: anObject yourAddress!

lpszDocName: anObject 
	"Set the receiver's lpszDocName field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszDocName) put: anObject yourAddress!

lpszOutput: anObject 
	"Set the receiver's lpszOutput field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszOutput) put: anObject yourAddress! !
!DOCINFO categoriesFor: #dwSize:!**compiled accessors**!public! !
!DOCINFO categoriesFor: #fwType:!**compiled accessors**!public! !
!DOCINFO categoriesFor: #lpszDatatype:!**compiled accessors**!public! !
!DOCINFO categoriesFor: #lpszDocName:!**compiled accessors**!public! !
!DOCINFO categoriesFor: #lpszOutput:!**compiled accessors**!public! !

!DOCINFO class methodsFor!

defineFields
	"Define the fields of the Win32 DOCINFO structure.

		DOCINFO compileDefinition

	typedef struct {		// di  
		int		cbSize;
		LPCTSTR	lpszDocName;
		LPCTSTR	lpszOutput;
		LPCTSTR	lpszDatatype;	// Windows 95 only; ignored on Windows NT
		DWORD	fwType;		// Windows 95 only; ignored on Windows NT
		} DOCINFO;"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #lpszDocName type: (PointerField type: String) beWriteOnly;
		defineField: #lpszOutput type: (PointerField type: String) beWriteOnly;
		defineField: #lpszDatatype type: (PointerField type: String) beWriteOnly;
		defineField: #fwType type: DWORDField writeOnly! !
!DOCINFO class categoriesFor: #defineFields!initializing!public! !

