"Filed out from Dolphin Smalltalk 7"!

CommonDialogStructure subclass: #FINDREPLACEW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'CommonDialogConstants'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_flags' -> 16rC.
		'_OffsetOf_hInstance' -> 16r8.
		'_OffsetOf_hwndOwner' -> 16r4.
		'_OffsetOf_lCustData' -> 16r1C.
		'_OffsetOf_lpfnHook' -> 16r20.
		'_OffsetOf_lpstrFindWhat' -> 16r10.
		'_OffsetOf_lpstrReplaceWith' -> 16r14.
		'_OffsetOf_lpTemplateName' -> 16r24.
		'_OffsetOf_wFindWhatLen' -> 16r18.
		'_OffsetOf_wReplaceWithLen' -> 16r1A
	}!
FINDREPLACEW guid: (GUID fromString: '{87b4c5f2-026e-11d3-9fd7-00a0cc3e4a32}')!
FINDREPLACEW comment: 'FINDREPLACE is a <Win32lStructure> which represents the Windows common dialog structure of the same name. It is used in conjunction with the FindText() and ReplaceText() APIs to to contain information about a search or replace operation.
'!
!FINDREPLACEW categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!FINDREPLACEW methodsFor!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

findDetails
	^(FindDetails new)
		pattern: self findWhat;
		replaceWith: self replaceWith;
		isForwards: self isForwards;
		isCaseSensitive: self isCaseSensitive;
		isWholeWord: self isWholeWord;
		action: (self isReplaceAll 
					ifTrue: [#replaceAll]
					ifFalse: [self isReplace ifTrue: [#replace] ifFalse: [#findNext]]);
		yourself!

findWhat
	"Answer the String to find"

	^self lpstrFindWhat!

flags
	"Answer the <Integer> value of the receiver's 'flags' field."

	^bytes dwordAtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_flags put: anInteger!

hookFlag
	^FR_ENABLEHOOK!

hwndOwner: anExternalHandle
	"Set the receiver's 'hwndOwner' field to the value of the argument, anExternalHandle"

	bytes uintPtrAtOffset: _OffsetOf_hwndOwner put: anExternalHandle!

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

lpfnHook: anExternalAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anExternalAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpfnHook put: anExternalAddress!

lpstrFindWhat
	"Answer the <Utf16String> value of the receiver's 'lpstrFindWhat' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpstrFindWhat)!

lpstrFindWhat: anUtf16String
	"Set the receiver's 'lpstrFindWhat' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrFindWhat put: anUtf16String yourAddress!

lpstrReplaceWith
	"Answer the <Utf16String> value of the receiver's 'lpstrReplaceWith' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpstrReplaceWith)!

lpstrReplaceWith: anUtf16String
	"Set the receiver's 'lpstrReplaceWith' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpstrReplaceWith put: anUtf16String yourAddress!

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

wFindWhatLen: anInteger
	"Set the receiver's 'wFindWhatLen' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wFindWhatLen put: anInteger!

wReplaceWithLen: anInteger
	"Set the receiver's 'wReplaceWithLen' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wReplaceWithLen put: anInteger! !
!FINDREPLACEW categoriesFor: #dwSize:!**compiled accessors**!public! !
!FINDREPLACEW categoriesFor: #findDetails!event handling!public! !
!FINDREPLACEW categoriesFor: #findWhat!accessing!public! !
!FINDREPLACEW categoriesFor: #flags!**compiled accessors**!public! !
!FINDREPLACEW categoriesFor: #flags:!**compiled accessors**!public! !
!FINDREPLACEW categoriesFor: #hookFlag!accessing!public! !
!FINDREPLACEW categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!FINDREPLACEW categoriesFor: #isCaseSensitive!public!testing! !
!FINDREPLACEW categoriesFor: #isClosing!public!testing! !
!FINDREPLACEW categoriesFor: #isForwards!public!testing! !
!FINDREPLACEW categoriesFor: #isReplace!public!testing! !
!FINDREPLACEW categoriesFor: #isReplaceAll!public!testing! !
!FINDREPLACEW categoriesFor: #isWholeWord!public!testing! !
!FINDREPLACEW categoriesFor: #lpfnHook:!**compiled accessors**!public! !
!FINDREPLACEW categoriesFor: #lpstrFindWhat!**compiled accessors**!public! !
!FINDREPLACEW categoriesFor: #lpstrFindWhat:!**compiled accessors**!public! !
!FINDREPLACEW categoriesFor: #lpstrReplaceWith!**compiled accessors**!public! !
!FINDREPLACEW categoriesFor: #lpstrReplaceWith:!**compiled accessors**!public! !
!FINDREPLACEW categoriesFor: #ownerView:!accessing!public! !
!FINDREPLACEW categoriesFor: #replaceWith!accessing!public! !
!FINDREPLACEW categoriesFor: #wFindWhatLen:!**compiled accessors**!public! !
!FINDREPLACEW categoriesFor: #wReplaceWithLen:!**compiled accessors**!public! !

!FINDREPLACEW class methodsFor!

defineFields
	"Define the fields of the Win32 FINDREPLACE structure.

		self compileDefinition

		typedef struct {// fr  
			DWORD		lStructSize;
			HWND			hwndOwner;
			HINSTANCE		hInstance;
			DWORD		Flags;
			LPWSTR		lpstrFindWhat;
			LPWSTR		lpstrReplaceWith;
			WORD			wFindWhatLen;
			WORD			wReplaceWithLen;
			LPARAM		lCustData;
			LPFRHOOKPROC	lpfnHook;
			LPCWSTR		lpTemplateName;
		} FINDREPLACE;"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #hwndOwner type: HANDLEField writeOnly;
		defineField: #hInstance type: HANDLEField filler;
		defineField: #flags type: DWORDField new beOverride;
		defineField: #lpstrFindWhat type: (PointerField type: Utf16String);
		defineField: #lpstrReplaceWith type: (PointerField type: Utf16String);
		defineField: #wFindWhatLen type: WORDField writeOnly;
		defineField: #wReplaceWithLen type: WORDField writeOnly;
		defineField: #lCustData type: INT_PTRField filler;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lpTemplateName type: (PointerField type: Utf16String) beFiller!

getFieldNames
	^#(#dwSize #hwndOwner #flags #lpstrFindWhat #lpstrReplaceWith #wFindWhatLen #wReplaceWithLen #lpfnHook)! !
!FINDREPLACEW class categoriesFor: #defineFields!public!template definition! !
!FINDREPLACEW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

