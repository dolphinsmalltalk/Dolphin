"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #MSGBOXPARAMSW
	instanceVariableNames: 'text caption'
	classVariableNames: ''
	poolDictionaries: 'MessageBoxConstants'
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwContextHelpId' -> 16r1C.
		'_OffsetOf_dwLanguageId' -> 16r24.
		'_OffsetOf_dwSize' -> 16r0.
		'_OffsetOf_dwStyle' -> 16r14.
		'_OffsetOf_hInstance' -> 16r8.
		'_OffsetOf_hwndOwner' -> 16r4.
		'_OffsetOf_lpfnMsgBoxCallback' -> 16r20.
		'_OffsetOf_lpszCaption' -> 16r10.
		'_OffsetOf_lpszIcon' -> 16r18.
		'_OffsetOf_lpszText' -> 16rC
	}!
MSGBOXPARAMSW guid: (GUID fromString: '{87b4c600-026e-11d3-9fd7-00a0cc3e4a32}')!
MSGBOXPARAMSW comment: 'MSGBOXPARAMS is an <ExternalStructure> class which represents the Windows structure of the same name.

MSGBOXPARAMS is used to contain configuration details for Message Boxes.

Instance Variables:
	iconId	<integer> or <String> id of icon to be displayed in the box
	text	<String> Text to be display in box (address stored in struct, so need to prevent premature GC)
	caption 	<String> Caption of box (ditto)
	owner	<ExternalHandle>. Handle of owner view'!
!MSGBOXPARAMSW categoriesForClass!External-Data-Structured-Win32! !
!MSGBOXPARAMSW methodsFor!

caption: aString
	"Set the text to be displayed as the message box title."

	"Implementation Note: We must retain a reference to the String to ensure it is not
	garbage collected, so we store it into an inst var maintained for that purpose." 

	caption := aString asUtf16String.  
	self lpszCaption: caption!

dwSize: anInteger
	"Set the receiver's 'dwSize' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwSize put: anInteger!

dwStyle: anInteger
	"Set the receiver's 'dwStyle' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwStyle put: anInteger!

hInstance: anInteger
	"Set the receiver's 'hInstance' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hInstance put: anInteger!

hwndOwner: anInteger
	"Set the receiver's 'hwndOwner' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_hwndOwner put: anInteger!

lpszCaption: anUtf16String
	"Set the receiver's 'lpszCaption' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpszCaption put: anUtf16String yourAddress!

lpszIcon: anInteger
	"Set the receiver's 'lpszIcon' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_lpszIcon put: anInteger!

lpszText: anUtf16String
	"Set the receiver's 'lpszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_lpszText put: anUtf16String yourAddress!

text: aString
	"Set the text to be displayed in the message box."

	"Implementation Note: We must retain a reference to the String to ensure it is not
	garbage collected, so we store it into an inst var maintained for that purpose."

	text := aString asUtf16String.
	self lpszText: text! !
!MSGBOXPARAMSW categoriesFor: #caption:!accessing!public! !
!MSGBOXPARAMSW categoriesFor: #dwSize:!**compiled accessors**!public! !
!MSGBOXPARAMSW categoriesFor: #dwStyle:!**compiled accessors**!public! !
!MSGBOXPARAMSW categoriesFor: #hInstance:!**compiled accessors**!public! !
!MSGBOXPARAMSW categoriesFor: #hwndOwner:!**compiled accessors**!public! !
!MSGBOXPARAMSW categoriesFor: #lpszCaption:!**compiled accessors**!public! !
!MSGBOXPARAMSW categoriesFor: #lpszIcon:!**compiled accessors**!public! !
!MSGBOXPARAMSW categoriesFor: #lpszText:!**compiled accessors**!public! !
!MSGBOXPARAMSW categoriesFor: #text:!accessing!public! !

!MSGBOXPARAMSW class methodsFor!

defineFields
	"Define the fields of the Win32 MSGBOXPARAMSW structure.

		self compileDefinition

	typedef struct {
			UINT cbSize;
			HWND hwndOwner;
			HINSTANCE hInstance;
			LPCWSTR lpszText;
			LPCWSTR lpszCaption;
			DWORD dwStyle;
			LPCSTR lpszIcon;
			DWORD dwContextHelpId;
			MSGBOXCALLBACK lpfnMsgBoxCallback;
			DWORD dwLanguageId;
		} MSGBOXPARAMSW; 
	"

	self
		defineField: #dwSize type: DWORDField writeOnly beOverride;
		defineField: #hwndOwner type: DWORDField writeOnly;
		defineField: #hInstance type: DWORDField writeOnly;
		defineField: #lpszText type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #lpszCaption type: (PointerField type: Utf16String) beWriteOnly;
		defineField: #dwStyle type: DWORDField writeOnly;
		defineField: #lpszIcon type: DWORDField writeOnly;
		beUncompiled;
		defineField: #dwContextHelpId type: DWORDField filler;
		defineField: #lpfnMsgBoxCallback type: DWORDField filler;
		defineField: #dwLanguageId type: DWORDField writeOnly
	"This field can hold a string, or an integer resource id"!

getFieldNames
	^#(#dwSize #hwndOwner #hInstance #lpszText #lpszCaption #dwStyle #lpszIcon #dwLanguageId)! !
!MSGBOXPARAMSW class categoriesFor: #defineFields!public!template definition! !
!MSGBOXPARAMSW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

