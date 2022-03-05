"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #TBBUTTONINFOW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_cchText _OffsetOf_cx _OffsetOf_dwMask _OffsetOf_dwSize _OffsetOf_fsState _OffsetOf_fsStyle _OffsetOf_idCommand _OffsetOf_iImage _OffsetOf_lParam _OffsetOf_pszText'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TBBUTTONINFOW guid: (GUID fromString: '{7fe067e4-441c-11d3-97ac-0080c8d59432}')!
TBBUTTONINFOW addClassConstant: '_OffsetOf_cchText' value: 16r1C!
TBBUTTONINFOW addClassConstant: '_OffsetOf_cx' value: 16r12!
TBBUTTONINFOW addClassConstant: '_OffsetOf_dwMask' value: 16r4!
TBBUTTONINFOW addClassConstant: '_OffsetOf_dwSize' value: 16r0!
TBBUTTONINFOW addClassConstant: '_OffsetOf_fsState' value: 16r10!
TBBUTTONINFOW addClassConstant: '_OffsetOf_fsStyle' value: 16r11!
TBBUTTONINFOW addClassConstant: '_OffsetOf_idCommand' value: 16r8!
TBBUTTONINFOW addClassConstant: '_OffsetOf_iImage' value: 16rC!
TBBUTTONINFOW addClassConstant: '_OffsetOf_lParam' value: 16r14!
TBBUTTONINFOW addClassConstant: '_OffsetOf_pszText' value: 16r18!
TBBUTTONINFOW comment: ''!
!TBBUTTONINFOW categoriesForClass!External-Data-Structured-Win32! !
!TBBUTTONINFOW methodsFor!

cx
	"Answer the <Integer> value of the receiver's 'cx' field."

	^bytes wordAtOffset: _OffsetOf_cx!

cx: anInteger
	"Set the receiver's 'cx' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_cx put: anInteger!

dwMask
	"Answer the <Integer> value of the receiver's 'dwMask' field."

	^bytes dwordAtOffset: _OffsetOf_dwMask!

dwMask: anInteger
	"Set the receiver's 'dwMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwMask put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_dwSize put: anInteger!

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

idCommand
	"Answer the <Integer> value of the receiver's 'idCommand' field."

	^bytes sdwordAtOffset: _OffsetOf_idCommand!

idCommand: anInteger
	"Set the receiver's 'idCommand' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_idCommand put: anInteger!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes sdwordAtOffset: _OffsetOf_iImage!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iImage put: anInteger! !
!TBBUTTONINFOW categoriesForMethods!
cx!**compiled accessors**!public! !
cx:!**compiled accessors**!public! !
dwMask!**compiled accessors**!public! !
dwMask:!**compiled accessors**!public! !
dwSize:!**compiled accessors**!public! !
fsState!**compiled accessors**!public! !
fsState:!**compiled accessors**!public! !
fsStyle!**compiled accessors**!public! !
fsStyle:!**compiled accessors**!public! !
idCommand!**compiled accessors**!public! !
idCommand:!**compiled accessors**!public! !
iImage!**compiled accessors**!public! !
iImage:!**compiled accessors**!public! !
!

!TBBUTTONINFOW class methodsFor!

defineFields
	"Define the fields of the Win32 TBBUTTONINFO structure.

		self compileDefinition

		typedef struct {
			UINT cbSize;
			DWORD dwMask;
			int idCommand;
			int iImage;
			BYTE fsState;
			BYTE fsStyle;
			WORD cx;
			DWORD_PTR lParam;
			LPWSTR pszText;
			int cchText; } TBBUTTONINFOW, *LPTBBUTTONINFOW;"

	self
		defineField: #dwSize type: SDWORDField writeOnly beOverride;
		defineField: #dwMask type: DWORDField new;
		defineField: #idCommand type: SDWORDField new;
		defineField: #iImage type: SDWORDField new;
		defineField: #fsState type: BYTEField new;
		defineField: #fsStyle type: BYTEField new;
		defineField: #cx type: WORDField new;
		defineField: #lParam type: UINT_PTRField filler;
		defineField: #pszText type: (PointerField type: Utf16String) beFiller;
		defineField: #cchText type: SDWORDField filler!

getFieldNames
	^#(#dwSize #dwMask #idCommand #iImage #fsState #fsStyle #cx)! !
!TBBUTTONINFOW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

