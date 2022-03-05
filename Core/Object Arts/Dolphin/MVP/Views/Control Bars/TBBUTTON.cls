"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #TBBUTTON
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwData _OffsetOf_fsState _OffsetOf_fsStyle _OffsetOf_iBitmap _OffsetOf_idCommand _OffsetOf_iString'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TBBUTTON guid: (GUID fromString: '{87b4c614-026e-11d3-9fd7-00a0cc3e4a32}')!
TBBUTTON addClassConstant: '_OffsetOf_dwData' value: 16rC!
TBBUTTON addClassConstant: '_OffsetOf_fsState' value: 16r8!
TBBUTTON addClassConstant: '_OffsetOf_fsStyle' value: 16r9!
TBBUTTON addClassConstant: '_OffsetOf_iBitmap' value: 16r0!
TBBUTTON addClassConstant: '_OffsetOf_idCommand' value: 16r4!
TBBUTTON addClassConstant: '_OffsetOf_iString' value: 16r10!
TBBUTTON comment: ''!
!TBBUTTON categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!TBBUTTON methodsFor!

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
!TBBUTTON categoriesForMethods!
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

!TBBUTTON class methodsFor!

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
!TBBUTTON class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

