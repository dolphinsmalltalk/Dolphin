"Filed out from Dolphin Smalltalk"!

OS.Win32Structure subclass: #'OS.TBBUTTON'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwData' -> 16rC.
		'_OffsetOf_fsState' -> 16r8.
		'_OffsetOf_fsStyle' -> 16r9.
		'_OffsetOf_iBitmap' -> 16r0.
		'_OffsetOf_idCommand' -> 16r4.
		'_OffsetOf_iString' -> 16r10.
		'_TBBUTTON_Size' -> 16r14
	}!
OS.TBBUTTON guid: (Core.GUID fromString: '{87b4c614-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.TBBUTTON comment: ''!
!OS.TBBUTTON categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!OS.TBBUTTON methodsFor!

dwData
	"Answer the <Integer> value of the receiver's 'dwData' field."

	^bytes uintPtrAtOffset: _OffsetOf_dwData!

dwData: anInteger
	"Set the receiver's 'dwData' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_dwData put: anInteger!

fsState
	"Answer the <Integer> value of the receiver's 'fsState' field."

	^bytes byteAtOffset: _OffsetOf_fsState!

fsState: anInteger
	"Set the receiver's 'fsState' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_fsState put: anInteger!

fsStyle
	"Answer the <Integer> value of the receiver's 'fsStyle' field."

	^bytes byteAtOffset: _OffsetOf_fsStyle!

fsStyle: anInteger
	"Set the receiver's 'fsStyle' field to the value of the argument, anInteger"

	bytes byteAtOffset: _OffsetOf_fsStyle put: anInteger!

iBitmap
	"Answer the <Integer> value of the receiver's 'iBitmap' field."

	^bytes sdwordAtOffset: _OffsetOf_iBitmap!

iBitmap: anInteger
	"Set the receiver's 'iBitmap' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iBitmap put: anInteger!

idCommand
	"Answer the <Integer> value of the receiver's 'idCommand' field."

	^bytes sdwordAtOffset: _OffsetOf_idCommand!

idCommand: anInteger
	"Set the receiver's 'idCommand' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_idCommand put: anInteger!

iString
	"Answer the <Integer> value of the receiver's 'iString' field."

	^bytes intPtrAtOffset: _OffsetOf_iString!

iString: anInteger
	"Set the receiver's 'iString' field to the value of the argument, anInteger"

	bytes intPtrAtOffset: _OffsetOf_iString put: anInteger! !
!OS.TBBUTTON categoriesForMethods!
dwData!**compiled accessors**!public! !
dwData:!**compiled accessors**!public! !
fsState!**compiled accessors**!public! !
fsState:!**compiled accessors**!public! !
fsStyle!**compiled accessors**!public! !
fsStyle:!**compiled accessors**!public! !
iBitmap!**compiled accessors**!public! !
iBitmap:!**compiled accessors**!public! !
idCommand!**compiled accessors**!public! !
idCommand:!**compiled accessors**!public! !
iString!**compiled accessors**!public! !
iString:!**compiled accessors**!public! !
!

!OS.TBBUTTON class methodsFor!

byteSize
	^_TBBUTTON_Size!

defineFields
	"Define the fields of the Win32 TBBUTTON structure.

		TBBUTTON compileDefinition

	typedef struct _TBBUTTON { \\ tbb 
		int iBitmap; 
		int idCommand; 
		BYTE fsState; 
		BYTE fsStyle; 
		// May be padding here!!
		DWORD_PTR dwData; 
		INT_PTR iString; 
	} TBBUTTON, NEAR* PTBBUTTON, FAR* LPTBBUTTON; 
	typedef const TBBUTTON FAR* LPCTBBUTTON"

	self
		defineField: #iBitmap type: SDWORDField new;
		defineField: #idCommand type: SDWORDField new;
		defineField: #fsState type: BYTEField new;
		defineField: #fsStyle type: BYTEField new;
		defineField: #dwData type: UINT_PTRField new;
		defineField: #iString type: INT_PTRField new!

getFieldNames
	^#(#iBitmap #idCommand #fsState #fsStyle #dwData #iString)! !
!OS.TBBUTTON class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

