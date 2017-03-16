"Filed out from Dolphin Smalltalk 7"!

NMTTDISPINFO subclass: #NMTTDISPINFOA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMTTDISPINFOA guid: (GUID fromString: '{87b4c62d-026e-11d3-9fd7-00a0cc3e4a32}')!
NMTTDISPINFOA comment: 'NMTTDISPINFOA is the class of <ExternalStructure> which represent the Windows Common Control structure of the same name.

NMTTDISPINFOA accompanies TTN_NEEDTEXTA notifications that are sent by a Toolbar control to its parent when it wishes to determine the ANSI (single-byte character) tool-tip text to be displayed for a toolbar button which the user is hovering over. See the Win32 documentation for further details.'!
!NMTTDISPINFOA categoriesForClass!ToolTip-Structs! !
!NMTTDISPINFOA methodsFor!

lpszText: anObject 
	"Set the receiver's lpszText field to the value of anObject."

	bytes uintPtrAtOffset: ##(self offsetOf: #lpszText) put: anObject yourAddress!

text: aString
	"Private - Set the receiver's tip text to aN ANSI version of the argument, aString,
	and answer that.
	N.B. The answer must be referenced until the TOOLTIPTEXT is no longer required to
	prevent it being prematurely GC'd."

	| ansi |
	ansi := aString asString.
	self lpszText: ansi.
	^ansi!

uFlags
	"Answer the receiver's uFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #uFlags)! !
!NMTTDISPINFOA categoriesFor: #lpszText:!**compiled accessors**!public! !
!NMTTDISPINFOA categoriesFor: #text:!accessing!private! !
!NMTTDISPINFOA categoriesFor: #uFlags!**compiled accessors**!public! !

!NMTTDISPINFOA class methodsFor!

defineFields
	"Define the fields of the NMTTDISPINFOA structure.
		NMTTDISPINFOA compileDefinition
	
		typedef 		struct tagNMTTDISPINFOA {
			NMHDR hdr;
			LPSTR lpszText;
			CHAR szText[80];
			HINSTANCE hinst;
			UINT uFlags;
			LONG_PTR lParam;
		} NMTTDISPINFOA;
"

	super defineFields.
	self
		defineField: #lpszText type: (PointerField type: String) beWriteOnly;
		defineField: #szText type: (StringField length: 80) beFiller;
		defineField: #hinst type: HANDLEField filler;
		defineField: #uFlags type: DWORDField readOnly;
		defineField: #lParam type: INT_PTRField filler! !
!NMTTDISPINFOA class categoriesFor: #defineFields!initializing!public! !

