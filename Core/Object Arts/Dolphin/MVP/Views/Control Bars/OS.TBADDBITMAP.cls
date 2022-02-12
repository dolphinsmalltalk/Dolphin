"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.TBADDBITMAP'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hInst' -> 16r0.
		'_OffsetOf_nID' -> 16r4.
		'_TBADDBITMAP_Size' -> 16r8
	}!
OS.TBADDBITMAP guid: (Core.GUID fromString: '{87b4c613-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.TBADDBITMAP comment: ''!
!OS.TBADDBITMAP categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!OS.TBADDBITMAP methodsFor!

hInst: anInteger
	"Set the receiver's 'hInst' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hInst put: anInteger!

nID: anInteger
	"Set the receiver's 'nID' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_nID put: anInteger! !
!OS.TBADDBITMAP categoriesForMethods!
hInst:!**compiled accessors**!public! !
nID:!**compiled accessors**!public! !
!

!OS.TBADDBITMAP class methodsFor!

byteSize
	^_TBADDBITMAP_Size!

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
!OS.TBADDBITMAP class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

