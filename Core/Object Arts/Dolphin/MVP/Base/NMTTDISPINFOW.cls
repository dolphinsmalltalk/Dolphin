"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMTTDISPINFOW
	instanceVariableNames: 'text'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hinst' -> 16rB0.
		'_OffsetOf_lParam' -> 16rB8.
		'_OffsetOf_lpszText' -> 16rC.
		'_OffsetOf_szText' -> 16r10.
		'_OffsetOf_uFlags' -> 16rB4
	}!
NMTTDISPINFOW guid: (GUID fromString: '{fd2f4864-6901-4633-8b54-accb5c28a265}')!
NMTTDISPINFOW comment: ''!
!NMTTDISPINFOW categoriesForClass!External-Data-Structured-Win32! !
!NMTTDISPINFOW methodsFor!

idIsHandle
	"Answer true if id stored in the receiver's header is a window handle, or false
	if it is a tool id (e.g. for a toolbar button)."

	^self uFlags anyMask: CommCtrlConstants.TTF_IDISHWND!

lpszText
	"Answer the <Utf16String> value of the receiver's 'lpszText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_lpszText)!

lpszText: anUtf16String
	"Set the receiver's 'lpszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpszText put: anUtf16String yourAddress!

text
	^text!

text: aString
	"Set the receiver's tip text to a Unicode version of the <readableString> argument,
	and answer that."

	"Implementation Note: The answer must be referenced until the TOOLTIPTEXT is no longer required to
	prevent it being prematurely GC'd, so we answer it in order that the caller can reference it."

	text := aString displayString asUtf16String.
	self lpszText: text.
	^text!

uFlags
	"Answer the <Integer> value of the receiver's 'uFlags' field."

	^bytes dwordAtOffset: _OffsetOf_uFlags! !
!NMTTDISPINFOW categoriesFor: #idIsHandle!private!testing! !
!NMTTDISPINFOW categoriesFor: #lpszText!**compiled accessors**!public! !
!NMTTDISPINFOW categoriesFor: #lpszText:!**compiled accessors**!public! !
!NMTTDISPINFOW categoriesFor: #text!accessing!public! !
!NMTTDISPINFOW categoriesFor: #text:!accessing!public! !
!NMTTDISPINFOW categoriesFor: #uFlags!**compiled accessors**!public! !

!NMTTDISPINFOW class methodsFor!

defineFields
	"Define the fields of the NMTTDISPINFOW structure.
		self compileDefinition
	
		typedef 		struct tagNMTTDISPINFOW {
			NMHDR hdr;
			LPWSTR lpszText;
			WCHAR szText[80];
			HINSTANCE hinst;
			UINT uFlags;
			LONG_PTR lParam;
		} NMTTDISPINFOW;
"

	super defineFields.
	self
		defineField: #lpszText type: (PointerField type: Utf16String);
		defineField: #szText type: (ArrayField type: Utf16String length: 80) beFiller;
		defineField: #hinst type: HANDLEField filler;
		defineField: #uFlags type: DWORDField readOnly;
		defineField: #lParam type: INT_PTRField filler!

getFieldNames
	^#(#hwndFrom #idFrom #code #lpszText #uFlags)! !
!NMTTDISPINFOW class categoriesFor: #defineFields!public!template definition! !
!NMTTDISPINFOW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

