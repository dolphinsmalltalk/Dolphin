"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TBBUTTONINFOW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TBBUTTONINFOW guid: (GUID fromString: '{7fe067e4-441c-11d3-97ac-0080c8d59432}')!
TBBUTTONINFOW comment: ''!
!TBBUTTONINFOW categoriesForClass!External-Data-Structured-Win32! !
!TBBUTTONINFOW methodsFor!

cx
	"Answer the <Integer> value of the receiver's 'cx' field."

	^bytes wordAtOffset: ##(self offsetOf: #cx)!

cx: anInteger
	"Set the receiver's 'cx' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #cx) put: anInteger!

dwMask
	"Answer the <Integer> value of the receiver's 'dwMask' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwMask)!

dwMask: anInteger
	"Set the receiver's 'dwMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: ##(self offsetOf: #dwMask) put: anInteger!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: 0 put: anInteger!

fsState
	"Answer the <Integer> value of the receiver's 'fsState' field."

	^bytes byteAtOffset: ##(self offsetOf: #fsState)!

fsState: anInteger
	"Set the receiver's 'fsState' field to the value of the argument, anInteger"

	bytes byteAtOffset: ##(self offsetOf: #fsState) put: anInteger!

fsStyle
	"Answer the <Integer> value of the receiver's 'fsStyle' field."

	^bytes byteAtOffset: ##(self offsetOf: #fsStyle)!

fsStyle: anInteger
	"Set the receiver's 'fsStyle' field to the value of the argument, anInteger"

	bytes byteAtOffset: ##(self offsetOf: #fsStyle) put: anInteger!

idCommand
	"Answer the <Integer> value of the receiver's 'idCommand' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #idCommand)!

idCommand: anInteger
	"Set the receiver's 'idCommand' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #idCommand) put: anInteger!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iImage)!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #iImage) put: anInteger! !
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
!TBBUTTONINFOW class categoriesFor: #defineFields!initializing!public! !
!TBBUTTONINFOW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

