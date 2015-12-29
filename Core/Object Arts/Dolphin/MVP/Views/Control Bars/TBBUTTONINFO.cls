"Filed out from Dolphin Smalltalk X6.1"!

Win32Structure subclass: #TBBUTTONINFO
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TBBUTTONINFO guid: (GUID fromString: '{7FE067E4-441C-11D3-97AC-0080C8D59432}')!
TBBUTTONINFO comment: ''!
!TBBUTTONINFO categoriesForClass!External-Data-Structured-Win32! !
!TBBUTTONINFO methodsFor!

cx
	"Answer the receiver's cx field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #cx)!

cx: anObject 
	"Set the receiver's cx field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #cx) put: anObject!

dwMask
	"Answer the receiver's dwMask field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwMask)!

dwMask: anObject 
	"Set the receiver's dwMask field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #dwMask) put: anObject!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

fsState
	"Answer the receiver's fsState field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #fsState)!

fsState: anObject 
	"Set the receiver's fsState field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #fsState) put: anObject!

fsStyle
	"Answer the receiver's fsStyle field as a Smalltalk object."

	^bytes byteAtOffset: ##(self offsetOf: #fsStyle)!

fsStyle: anObject 
	"Set the receiver's fsStyle field to the value of anObject."

	bytes byteAtOffset: ##(self offsetOf: #fsStyle) put: anObject!

idCommand
	"Answer the receiver's idCommand field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #idCommand)!

idCommand: anObject 
	"Set the receiver's idCommand field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #idCommand) put: anObject!

iImage
	"Answer the receiver's iImage field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iImage)!

iImage: anObject 
	"Set the receiver's iImage field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #iImage) put: anObject! !
!TBBUTTONINFO categoriesFor: #cx!**compiled accessors**!public! !
!TBBUTTONINFO categoriesFor: #cx:!**compiled accessors**!public! !
!TBBUTTONINFO categoriesFor: #dwMask!**compiled accessors**!public! !
!TBBUTTONINFO categoriesFor: #dwMask:!**compiled accessors**!public! !
!TBBUTTONINFO categoriesFor: #dwSize:!**compiled accessors**!public! !
!TBBUTTONINFO categoriesFor: #fsState!**compiled accessors**!public! !
!TBBUTTONINFO categoriesFor: #fsState:!**compiled accessors**!public! !
!TBBUTTONINFO categoriesFor: #fsStyle!**compiled accessors**!public! !
!TBBUTTONINFO categoriesFor: #fsStyle:!**compiled accessors**!public! !
!TBBUTTONINFO categoriesFor: #idCommand!**compiled accessors**!public! !
!TBBUTTONINFO categoriesFor: #idCommand:!**compiled accessors**!public! !
!TBBUTTONINFO categoriesFor: #iImage!**compiled accessors**!public! !
!TBBUTTONINFO categoriesFor: #iImage:!**compiled accessors**!public! !

!TBBUTTONINFO class methodsFor!

defineFields
	"Define the fields of the Win32 TBBUTTONINFO structure.

		TBBUTTONINFO compileDefinition

		typedef struct {
			UINT cbSize;
			DWORD dwMask;
			int idCommand;
			int iImage;
			BYTE fsState;
			BYTE fsStyle;
			WORD cx;
			DWORD_PTR lParam;
			LPTSTR pszText;
			int cchText; } TBBUTTONINFOA, *LPTBBUTTONINFOA;"

	self
		defineField: #dwSize type: SDWORDField writeOnly beOverride;
		defineField: #dwMask type: DWORDField new;
		defineField: #idCommand type: SDWORDField new;
		defineField: #iImage type: SDWORDField new;
		defineField: #fsState type: BYTEField new;
		defineField: #fsStyle type: BYTEField new;
		defineField: #cx type: WORDField new;
		defineField: #lParam type: UINT_PTRField filler;
		defineField: #pszText type: (PointerField type: String) beFiller;
		defineField: #cchText type: SDWORDField filler! !
!TBBUTTONINFO class categoriesFor: #defineFields!initializing!public! !

