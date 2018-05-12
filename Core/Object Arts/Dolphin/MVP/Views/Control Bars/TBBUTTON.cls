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
	"Answer the receiver's dwData field as a Smalltalk object."

	^bytes uintPtrAtOffset: ##(self offsetOf: #dwData)!

dwData: anObject 
	"Set the receiver's dwData field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #dwData) put: anObject!

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

iBitmap
	"Answer the receiver's iBitmap field as a Smalltalk object."

	^bytes sdwordAtOffset: 0!

iBitmap: anObject 
	"Set the receiver's iBitmap field to the value of anObject."

	bytes sdwordAtOffset: 0 put: anObject!

idCommand
	"Answer the receiver's idCommand field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #idCommand)!

idCommand: anObject 
	"Set the receiver's idCommand field to the value of anObject."

	bytes sdwordAtOffset: ##(self offsetOf: #idCommand) put: anObject!

iString
	"Answer the receiver's iString field as a Smalltalk object."

	^bytes intPtrAtOffset: ##(self offsetOf: #iString)!

iString: anObject 
	"Set the receiver's iString field to the value of anObject."

	bytes intPtrAtOffset: ##(self offsetOf: #iString) put: anObject! !
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
		defineField: #iString type: INT_PTRField new! !
!TBBUTTON class categoriesFor: #defineFields!initializing!public! !

