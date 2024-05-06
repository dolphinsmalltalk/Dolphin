"Filed out from Dolphin Smalltalk"!

CommonDialogStructure subclass: #FINDREPLACEW
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwSize _OffsetOf_flags _OffsetOf_hInstance _OffsetOf_hwndOwner _OffsetOf_lCustData _OffsetOf_lpfnHook _OffsetOf_lpstrFindWhat _OffsetOf_lpstrReplaceWith _OffsetOf_lpTemplateName _OffsetOf_wFindWhatLen _OffsetOf_wReplaceWithLen'
	poolDictionaries: 'CommonDialogConstants'
	classInstanceVariableNames: ''!

FINDREPLACEW guid: (GUID fromString: '{87b4c5f2-026e-11d3-9fd7-00a0cc3e4a32}')!

FINDREPLACEW addClassConstant: '_OffsetOf_dwSize' value: 16r0!
FINDREPLACEW addClassConstant: '_OffsetOf_flags' value: 16rC!
FINDREPLACEW addClassConstant: '_OffsetOf_hInstance' value: 16r8!
FINDREPLACEW addClassConstant: '_OffsetOf_hwndOwner' value: 16r4!
FINDREPLACEW addClassConstant: '_OffsetOf_lCustData' value: 16r1C!
FINDREPLACEW addClassConstant: '_OffsetOf_lpfnHook' value: 16r20!
FINDREPLACEW addClassConstant: '_OffsetOf_lpstrFindWhat' value: 16r10!
FINDREPLACEW addClassConstant: '_OffsetOf_lpstrReplaceWith' value: 16r14!
FINDREPLACEW addClassConstant: '_OffsetOf_lpTemplateName' value: 16r24!
FINDREPLACEW addClassConstant: '_OffsetOf_wFindWhatLen' value: 16r18!
FINDREPLACEW addClassConstant: '_OffsetOf_wReplaceWithLen' value: 16r1A!

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

!FINDREPLACEW categoriesForMethods!
dwSize:!**compiled accessors**!public! !
findDetails!event handling!public! !
findWhat!accessing!public! !
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
hookFlag!accessing!public! !
hwndOwner:!**compiled accessors**!public! !
isCaseSensitive!public!testing! !
isClosing!public!testing! !
isForwards!public!testing! !
isReplace!public!testing! !
isReplaceAll!public!testing! !
isWholeWord!public!testing! !
lpfnHook:!**compiled accessors**!public! !
lpstrFindWhat!**compiled accessors**!public! !
lpstrFindWhat:!**compiled accessors**!public! !
lpstrReplaceWith!**compiled accessors**!public! !
lpstrReplaceWith:!**compiled accessors**!public! !
ownerView:!accessing!public! !
replaceWith!accessing!public! !
wFindWhatLen:!**compiled accessors**!public! !
wReplaceWithLen:!**compiled accessors**!public! !
!

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

!FINDREPLACEW class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

