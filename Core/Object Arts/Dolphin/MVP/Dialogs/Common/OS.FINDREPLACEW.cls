"Filed out from Dolphin Smalltalk"!

OS.ComDlgStructure
	subclass: #'OS.FINDREPLACEW'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_FINDREPLACEW_Size' -> 16r28.
			'_OffsetOf_flags' -> 16rC.
			'_OffsetOf_hInstance' -> 16r8.
			'_OffsetOf_lCustData' -> 16r1C.
			'_OffsetOf_lpfnHook' -> 16r20.
			'_OffsetOf_lpstrFindWhat' -> 16r10.
			'_OffsetOf_lpstrReplaceWith' -> 16r14.
			'_OffsetOf_lpTemplateName' -> 16r24.
			'_OffsetOf_wFindWhatLen' -> 16r18.
			'_OffsetOf_wReplaceWithLen' -> 16r1A
		}!
OS.FINDREPLACEW guid: (Core.GUID fromString: '{87b4c5f2-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.FINDREPLACEW comment: 'FINDREPLACE is a <Win32lStructure> which represents the Windows common dialog structure of the same name. It is used in conjunction with the FindText() and ReplaceText() APIs to to contain information about a search or replace operation.
'!
!OS.FINDREPLACEW categoriesForClass!External-Data-Structured!External-Data-Structured-Win32! !
!OS.FINDREPLACEW methodsFor!

findDetails
	^UI.FindDetails new
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

	^bytes uint32AtOffset: _OffsetOf_flags!

flags: anInteger
	"Set the receiver's 'flags' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_flags put: anInteger!

hookFlag
	^FR_ENABLEHOOK!

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

lpfnHook: anAddress
	"Set the receiver's 'lpfnHook' field to the value of the argument, anAddress"

	bytes uintPtrAtOffset: _OffsetOf_lpfnHook put: anAddress!

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

replaceWith
	"Answer the replacement String."

	^self lpstrReplaceWith!

wFindWhatLen: anInteger
	"Set the receiver's 'wFindWhatLen' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wFindWhatLen put: anInteger!

wReplaceWithLen: anInteger
	"Set the receiver's 'wReplaceWithLen' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wReplaceWithLen put: anInteger! !
!OS.FINDREPLACEW categoriesForMethods!
findDetails!event handling!public! !
findWhat!accessing!public! !
flags!**compiled accessors**!public! !
flags:!**compiled accessors**!public! !
hookFlag!accessing!private! !
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
replaceWith!accessing!public! !
wFindWhatLen:!**compiled accessors**!public! !
wReplaceWithLen:!**compiled accessors**!public! !
!

!OS.FINDREPLACEW class methodsFor!

byteSize
	^_FINDREPLACEW_Size!

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

	super defineFields.
	self
		defineField: #hInstance type: HANDLEField filler;
		defineField: #flags type: UInt32Field new beOverride;
		defineField: #lpstrFindWhat type: (PointerField type: Utf16String);
		defineField: #lpstrReplaceWith type: (PointerField type: Utf16String);
		defineField: #wFindWhatLen type: UInt16Field writeOnly;
		defineField: #wReplaceWithLen type: UInt16Field writeOnly;
		defineField: #lCustData type: IntPtrField filler;
		defineField: #lpfnHook type: LPVOIDField writeOnly beOverride;
		defineField: #lpTemplateName type: (PointerField type: Utf16String) beFiller!

getFieldNames
	^#(#dwSize #hwndOwner #flags #lpstrFindWhat #lpstrReplaceWith #wFindWhatLen #wReplaceWithLen #lpfnHook)! !
!OS.FINDREPLACEW class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

