"Filed out from Dolphin Smalltalk X6.1"!

CommonDialogStructure subclass: #FINDREPLACE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants'
	classInstanceVariableNames: ''!
FINDREPLACE guid: (GUID fromString: '{87B4C5F2-026E-11D3-9FD7-00A0CC3E4A32}')!
FINDREPLACE comment: 'FINDREPLACE is a <Win32lStructure> which represents the Windows common dialog structure of the same name. It is used in conjunction with the FindText() and ReplaceText() APIs to to contain information about a search or replace operation.
'!
!FINDREPLACE categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!FINDREPLACE methodsFor!

dwSize: anObject 
	"Set the receiver's dwSize field to the value of anObject."

	bytes dwordAtOffset: 0 put: anObject!

findDetails
	^(FindDetails new)
		pattern: self findWhat;
		replaceWith: self replaceWith;
		isForwards: self isForwards;
		isCaseSensitive: self isCaseSensitive;
		isWholeWord: self isWholeWord;
		isRegularExpression: false;
		action: (self isReplaceAll 
					ifTrue: [#replaceAll]
					ifFalse: [self isReplace ifTrue: [#replace] ifFalse: [#findNext]]);
		yourself!

findWhat
	"Answer the String to find"

	^self lpstrFindWhat!

flags
	"Answer the receiver's flags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #flags)!

flags: anObject 
	"Set the receiver's flags field to the value of anObject."

	bytes dwordAtOffset: ##(self offsetOf: #flags) put: anObject!

hookFlag
	^FR_ENABLEHOOK!

hwndOwner: anObject 
	"Set the receiver's hwndOwner field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #hwndOwner) put: anObject!

isCaseSensitive
	"Answer true if this is a case sensitive match operation"

	^self flags anyMask: FR_MATCHCASE!

isClosing
	"Answer true if this is a termination of the find operation"

	^self flags anyMask: FR_DIALOGTERM!

isForwards
	"Answer true if this is a forward direction operation"

	^self flags anyMask: FR_DOWN!

isReplace
	"Answer true if this is a replace operation"

	^self flags anyMask: FR_REPLACE!

isReplaceAll
	"Answer true if this is a replace all operation"

	^self flags anyMask: FR_REPLACEALL!

isWholeWord
	"Answer true if this is a whole word match operation"

	^self flags anyMask: FR_WHOLEWORD!

lpfnHook: anObject 
	"Set the receiver's lpfnHook field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpfnHook) put: anObject!

lpstrFindWhat
	"Answer the receiver's lpstrFindWhat field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpstrFindWhat))!

lpstrFindWhat: anObject 
	"Set the receiver's lpstrFindWhat field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpstrFindWhat) put: anObject yourAddress!

lpstrReplaceWith
	"Answer the receiver's lpstrReplaceWith field as a Smalltalk object."

	^String fromAddress: (bytes intPtrAtOffset: ##(self offsetOf: #lpstrReplaceWith))!

lpstrReplaceWith: anObject 
	"Set the receiver's lpstrReplaceWith field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpstrReplaceWith) put: anObject yourAddress!

ownerView: aView
	"Set the parent window for the dialog to aView."

	| hWnd |
	hWnd := aView asParameter.
	hWnd isNull
		ifTrue: [self hwndOwner: 0]
		ifFalse: [self hwndOwner: hWnd].!

replaceWith
	"Answer the replacement String."

	^self lpstrReplaceWith!

wFindWhatLen: anObject 
	"Set the receiver's wFindWhatLen field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #wFindWhatLen) put: anObject!

wReplaceWithLen: anObject 
	"Set the receiver's wReplaceWithLen field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #wReplaceWithLen) put: anObject! !
!FINDREPLACE categoriesFor: #dwSize:!**compiled accessors**!public! !
!FINDREPLACE categoriesFor: #findDetails!event handling!public! !
!FINDREPLACE categoriesFor: #findWhat!accessing!public! !
!FINDREPLACE categoriesFor: #flags!**compiled accessors**!public! !
!FINDREPLACE categoriesFor: #flags:!**compiled accessors**!public! !
!FINDREPLACE categoriesFor: #hookFlag!accessing!public! !
!FINDREPLACE categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!FINDREPLACE categoriesFor: #isCaseSensitive!public!testing! !
!FINDREPLACE categoriesFor: #isClosing!public!testing! !
!FINDREPLACE categoriesFor: #isForwards!public!testing! !
!FINDREPLACE categoriesFor: #isReplace!public!testing! !
!FINDREPLACE categoriesFor: #isReplaceAll!public!testing! !
!FINDREPLACE categoriesFor: #isWholeWord!public!testing! !
!FINDREPLACE categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!FINDREPLACE categoriesFor: #lpstrFindWhat!**compiled accessors**!public! !
!FINDREPLACE categoriesFor: #lpstrFindWhat:!**compiled accessors**!public! !
!FINDREPLACE categoriesFor: #lpstrReplaceWith!**compiled accessors**!public! !
!FINDREPLACE categoriesFor: #lpstrReplaceWith:!**compiled accessors**!public! !
!FINDREPLACE categoriesFor: #ownerView:!accessing!public! !
!FINDREPLACE categoriesFor: #replaceWith!accessing!public! !
!FINDREPLACE categoriesFor: #wFindWhatLen:!**compiled accessors**!public! !
!FINDREPLACE categoriesFor: #wReplaceWithLen:!**compiled accessors**!public! !

!FINDREPLACE class methodsFor!

defineFields
	"Define the fields of the Win32 FINDREPLACE structure.

		FINDREPLACE compileDefinition

		typedef struct {// fr  
			DWORD		lStructSize;
			HWND			hwndOwner;
			HINSTANCE		hInstance;
			DWORD		Flags;
			LPTSTR		lpstrFindWhat;
			LPTSTR		lpstrReplaceWith;
			WORD			wFindWhatLen;
			WORD			wReplaceWithLen;
			LPARAM		lCustData;
			LPFRHOOKPROC	lpfnHook;
			LPCTSTR		lpTemplateName;
		} FINDREPLACE;"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #hwndOwner type: HANDLEField writeOnly;
		defineField: #hInstance type: HANDLEField filler;
		defineField: #flags type: DWORDField new beOverride;
		defineField: #lpstrFindWhat type: (PointerField type: String);
		defineField: #lpstrReplaceWith type: (PointerField type: String);
		defineField: #wFindWhatLen type: WORDField writeOnly;
		defineField: #wReplaceWithLen type: WORDField writeOnly;
		defineField: #lCustData type: INT_PTRField filler;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lpTemplateName type: (PointerField type: String) beFiller! !
!FINDREPLACE class categoriesFor: #defineFields!initializing!public! !

