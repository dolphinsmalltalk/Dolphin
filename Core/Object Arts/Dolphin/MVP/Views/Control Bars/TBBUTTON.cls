"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #TBBUTTON
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TBBUTTON guid: (GUID fromString: '{87b4c614-026e-11d3-9fd7-00a0cc3e4a32}')!
TBBUTTON comment: ''!
!TBBUTTON categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!TBBUTTON methodsFor!

dwData
	"Answer the <Integer> value of the receiver's 'dwData' field."

	^bytes uintPtrAtOffset: ##(self offsetOf: #dwData)!

dwData: anInteger
	"Set the receiver's 'dwData' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: ##(self offsetOf: #dwData) put: anInteger!

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

iBitmap
	"Answer the <Integer> value of the receiver's 'iBitmap' field."

	^bytes sdwordAtOffset: 0!

iBitmap: anInteger
	"Set the receiver's 'iBitmap' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: 0 put: anInteger!

idCommand
	"Answer the <Integer> value of the receiver's 'idCommand' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #idCommand)!

idCommand: anInteger
	"Set the receiver's 'idCommand' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: ##(self offsetOf: #idCommand) put: anInteger!

iString
	"Answer the <Integer> value of the receiver's 'iString' field."

	^bytes intPtrAtOffset: ##(self offsetOf: #iString)!

iString: anInteger
	"Set the receiver's 'iString' field to the value of the argument, anInteger"

	bytes intPtrAtOffset: ##(self offsetOf: #iString) put: anInteger! !
!TBBUTTON categoriesFor: #dwData!**compiled accessors**!public! !
!TBBUTTON categoriesFor: #dwData:!**compiled accessors**!public! !
!TBBUTTON categoriesFor: #fsState!**compiled accessors**!public! !
!TBBUTTON categoriesFor: #fsState:!**compiled accessors**!public! !
!TBBUTTON categoriesFor: #fsStyle!**compiled accessors**!public! !
!TBBUTTON categoriesFor: #fsStyle:!**compiled accessors**!public! !
!TBBUTTON categoriesFor: #iBitmap!**compiled accessors**!public! !
!TBBUTTON categoriesFor: #iBitmap:!**compiled accessors**!public! !
!TBBUTTON categoriesFor: #idCommand!**compiled accessors**!public! !
!TBBUTTON categoriesFor: #idCommand:!**compiled accessors**!public! !
!TBBUTTON categoriesFor: #iString!**compiled accessors**!public! !
!TBBUTTON categoriesFor: #iString:!**compiled accessors**!public! !

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
!TBBUTTON class categoriesFor: #defineFields!initializing!public! !
!TBBUTTON class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

