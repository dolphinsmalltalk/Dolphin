"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TBADDBITMAP
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TBADDBITMAP guid: (GUID fromString: '{87b4c613-026e-11d3-9fd7-00a0cc3e4a32}')!
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

