"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TBBUTTONINFOW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cchText' -> 16r1C.
		'_OffsetOf_cx' -> 16r12.
		'_OffsetOf_dwMask' -> 16r4.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_fsState' -> 16r10.
		'_OffsetOf_fsStyle' -> 16r11.
		'_OffsetOf_idCommand' -> 16r8.
		'_OffsetOf_iImage' -> 16rC.
		'_OffsetOf_lParam' -> 16r14.
		'_OffsetOf_pszText' -> 16r18
	}!
TBBUTTONINFOW guid: (GUID fromString: '{7fe067e4-441c-11d3-97ac-0080c8d59432}')!
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
!TBBUTTONINFOW categoriesFor: #cx!**compiled accessors**!public! !
!TBBUTTONINFOW categoriesFor: #cx:!**compiled accessors**!public! !
!TBBUTTONINFOW categoriesFor: #dwMask!**compiled accessors**!public! !
!TBBUTTONINFOW categoriesFor: #dwMask:!**compiled accessors**!public! !
!TBBUTTONINFOW categoriesFor: #dwSize:!**compiled accessors**!public! !
!TBBUTTONINFOW categoriesFor: #fsState!**compiled accessors**!public! !
!TBBUTTONINFOW categoriesFor: #fsState:!**compiled accessors**!public! !
!TBBUTTONINFOW categoriesFor: #fsStyle!**compiled accessors**!public! !
!TBBUTTONINFOW categoriesFor: #fsStyle:!**compiled accessors**!public! !
!TBBUTTONINFOW categoriesFor: #idCommand!**compiled accessors**!public! !
!TBBUTTONINFOW categoriesFor: #idCommand:!**compiled accessors**!public! !
!TBBUTTONINFOW categoriesFor: #iImage!**compiled accessors**!public! !
!TBBUTTONINFOW categoriesFor: #iImage:!**compiled accessors**!public! !

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
!TBBUTTONINFOW class categoriesFor: #defineFields!public!template definition! !
!TBBUTTONINFOW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

