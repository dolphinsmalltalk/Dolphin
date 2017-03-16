"Filed out from Dolphin Smalltalk 7"!

NMTTDISPINFO subclass: #NMTTDISPINFOW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMTTDISPINFOW guid: (GUID fromString: '{87b4c62e-026e-11d3-9fd7-00a0cc3e4a32}')!
NMTTDISPINFOW comment: 'NMTTDISPINFOW is the class of <ExternalStructure> which represent the Windows Common Control structure of the same name.

NMTTDISPINFOW accompanies TTN_NEEDTEXTW notifications that are sent by a Toolbar control to its parent when it wishes to determine the Unicode (double-byte character) tool-tip text to be displayed for a toolbar button which the user is hovering over. See the Win32 documentation for further details.'!
!NMTTDISPINFOW categoriesForClass!ToolTip-Structs! !
!NMTTDISPINFOW methodsFor!

lpszText: anObject 
	"Set the receiver's lpszText field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszText) put: anObject yourAddress!

text: aString 
	"Private - Set the receiver's tip text to a Unicode version of the <readableString> argument,
	and answer that."

	"Implementation Note: The answer must be referenced until the TOOLTIPTEXT is no longer required to
	prevent it being prematurely GC'd, so we answer it in order that the caller can reference it."

	| unicode |
	unicode := aString asUnicodeString.
	self lpszText: unicode.
	^unicode!

uFlags
	"Answer the receiver's uFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #uFlags)! !
!NMTTDISPINFOW categoriesFor: #lpszText:!**compiled accessors**!public! !
!NMTTDISPINFOW categoriesFor: #text:!accessing!private! !
!NMTTDISPINFOW categoriesFor: #uFlags!**compiled accessors**!public! !

!NMTTDISPINFOW class methodsFor!

defineFields
	"Define the fields of the NMTTDISPINFOW structure.
		NMTTDISPINFOW compileDefinition
	
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
		defineField: #lpszText type: (PointerField type: UnicodeString) beWriteOnly;
		defineField: #szText type: (ArrayField type: UnicodeString length: 80) beFiller;
		defineField: #hinst type: HANDLEField filler;
		defineField: #uFlags type: DWORDField readOnly;
		defineField: #lParam type: INT_PTRField filler! !
!NMTTDISPINFOW class categoriesFor: #defineFields!initializing!public! !

