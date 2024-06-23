"Filed out from Dolphin Smalltalk"!

OS.SizedStructure
	subclass: #'OS.TBBUTTONINFOW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_cchText' -> 16r1C.
			'_OffsetOf_cx' -> 16r12.
			'_OffsetOf_dwMask' -> 16r4.
			'_OffsetOf_fsState' -> 16r10.
			'_OffsetOf_fsStyle' -> 16r11.
			'_OffsetOf_idCommand' -> 16r8.
			'_OffsetOf_iImage' -> 16rC.
			'_OffsetOf_lParam' -> 16r14.
			'_OffsetOf_pszText' -> 16r18.
			'_TBBUTTONINFOW_Size' -> 16r20
		}!

OS.TBBUTTONINFOW guid: (Core.GUID fromString: '{7fe067e4-441c-11d3-97ac-0080c8d59432}')!

OS.TBBUTTONINFOW comment: ''!

!OS.TBBUTTONINFOW categoriesForClass!External-Data-Structured-Win32! !

!OS.TBBUTTONINFOW methodsFor!

cx
	"Answer the <Integer> value of the receiver's 'cx' field."

	^bytes uint16AtOffset: _OffsetOf_cx!

cx: anInteger
	"Set the receiver's 'cx' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_cx put: anInteger!

dwMask
	"Answer the <Integer> value of the receiver's 'dwMask' field."

	^bytes uint32AtOffset: _OffsetOf_dwMask!

dwMask: anInteger
	"Set the receiver's 'dwMask' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_dwMask put: anInteger!

fsState
	"Answer the <Integer> value of the receiver's 'fsState' field."

	^bytes uint8AtOffset: _OffsetOf_fsState!

fsState: anInteger
	"Set the receiver's 'fsState' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_fsState put: anInteger!

fsStyle
	"Answer the <Integer> value of the receiver's 'fsStyle' field."

	^bytes uint8AtOffset: _OffsetOf_fsStyle!

fsStyle: anInteger
	"Set the receiver's 'fsStyle' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_fsStyle put: anInteger!

idCommand
	"Answer the <Integer> value of the receiver's 'idCommand' field."

	^bytes int32AtOffset: _OffsetOf_idCommand!

idCommand: anInteger
	"Set the receiver's 'idCommand' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_idCommand put: anInteger!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes int32AtOffset: _OffsetOf_iImage!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes int32AtOffset: _OffsetOf_iImage put: anInteger! !

!OS.TBBUTTONINFOW categoriesForMethods!
cx!**compiled accessors**!public! !
cx:!**compiled accessors**!public! !
dwMask!**compiled accessors**!public! !
dwMask:!**compiled accessors**!public! !
fsState!**compiled accessors**!public! !
fsState:!**compiled accessors**!public! !
fsStyle!**compiled accessors**!public! !
fsStyle:!**compiled accessors**!public! !
idCommand!**compiled accessors**!public! !
idCommand:!**compiled accessors**!public! !
iImage!**compiled accessors**!public! !
iImage:!**compiled accessors**!public! !
!

!OS.TBBUTTONINFOW class methodsFor!

byteSize
	^_TBBUTTONINFOW_Size!

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

	super defineFields.
	self
		defineField: #dwMask type: UInt32Field new;
		defineField: #idCommand type: Int32Field new;
		defineField: #iImage type: Int32Field new;
		defineField: #fsState type: UInt8Field new;
		defineField: #fsStyle type: UInt8Field new;
		defineField: #cx type: UInt16Field new;
		defineField: #lParam type: UIntPtrField filler;
		defineField: #pszText type: (PointerField type: Utf16String) beFiller;
		defineField: #cchText type: Int32Field filler!

getFieldNames
	^#(#dwSize #dwMask #idCommand #iImage #fsState #fsStyle #cx)! !

!OS.TBBUTTONINFOW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

