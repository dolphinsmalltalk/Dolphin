"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TBADDBITMAP
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hInst' -> 16r0.
		'_OffsetOf_nID' -> 16r4
	}!
TBADDBITMAP guid: (GUID fromString: '{87b4c613-026e-11d3-9fd7-00a0cc3e4a32}')!
TBADDBITMAP comment: ''!
!TBADDBITMAP categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!TBADDBITMAP methodsFor!

hInst: anInteger
	"Set the receiver's 'hInst' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hInst put: anInteger!

nID: anInteger
	"Set the receiver's 'nID' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_nID put: anInteger! !
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
		defineField: #nID type: UINT_PTRField writeOnly!

getFieldNames
	^#(#hInst #nID)! !
!TBADDBITMAP class categoriesFor: #defineFields!public!template definition! !
!TBADDBITMAP class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

