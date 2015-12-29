"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #TBADDBITMAP
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TBADDBITMAP guid: (GUID fromString: '{87B4C613-026E-11D3-9FD7-00A0CC3E4A32}')!
TBADDBITMAP comment: ''!
!TBADDBITMAP categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!TBADDBITMAP methodsFor!

hInst: anObject 
	"Set the receiver's hInst field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

nID: anObject 
	"Set the receiver's nID field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #nID) put: anObject! !
!TBADDBITMAP categoriesFor: #hInst:!**compiled accessors**!public! !
!TBADDBITMAP categoriesFor: #nID:!**compiled accessors**!public! !

!TBADDBITMAP class methodsFor!

defineFields
	"Define the fields of the Win32 TBADDBITMAP structure.

	TBADDBITMAP compileDefinition

	typedef struct {  // tbab 
		HINSTANCE hInst; 
		UINT_PTR nID; 
	} TBADDBITMAP, *LPTBADDBITMAP"

	self
		defineField: #hInst type: DWORDField writeOnly;
		defineField: #nID type: UINT_PTRField writeOnly! !
!TBADDBITMAP class categoriesFor: #defineFields!initializing!public! !

