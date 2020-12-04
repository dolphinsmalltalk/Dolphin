"Filed out from Dolphin Smalltalk 7"!

OS.NMHDR subclass: #'OS.NMTBDISPINFOW'
	instanceVariableNames: 'text'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_cchText' -> 16r20.
		'_OffsetOf_dwMask' -> 16rC.
		'_OffsetOf_idCommand' -> 16r10.
		'_OffsetOf_iImage' -> 16r18.
		'_OffsetOf_lParam' -> 16r14.
		'_OffsetOf_pszText' -> 16r1C
	}!
OS.NMTBDISPINFOW guid: (Core.GUID fromString: '{9b3478db-36e6-431d-8f12-66016b6b5ef8}')!
OS.NMTBDISPINFOW comment: '<NMTBDISPINFOW> is an <ExternalStructure> class to wrap the struct ''Win32.NMTBDISPINFOW'' from type information in the ''Win32 API'' library.

The type library contains no documentation for this struct

** This comment was automatically generated from a type library. Delete this line to prevent any manual edits from being overwritten if the wrapper class is regenerated. **

IDL definition follows:

typedef [uuid(9b3478db-36e6-431d-8f12-66016b6b5ef8)]
struct tagNMTBDISPINFOW {
	[readonly] NMHDR hdr;
	DWORD dwMask;
	int idCommand;
	ULONG_PTR lParam;
	int iImage;
	[string] LPWSTR pszText;
	int cchText;
} NMTBDISPINFOW;
'!
!OS.NMTBDISPINFOW categoriesForClass!Win32-Structs! !
!OS.NMTBDISPINFOW methodsFor!

cchText
	"Answer the <Integer> value of the receiver's 'cchText' field."

	^bytes sdwordAtOffset: _OffsetOf_cchText!

cchText: anInteger
	"Set the receiver's 'cchText' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_cchText put: anInteger!

dwMask
	"Answer the <Integer> value of the receiver's 'dwMask' field."

	^bytes dwordAtOffset: _OffsetOf_dwMask!

dwMask: anInteger
	"Set the receiver's 'dwMask' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_dwMask put: anInteger!

idCommand
	"Answer the <Integer> value of the receiver's 'idCommand' field."

	^bytes sdwordAtOffset: _OffsetOf_idCommand!

idCommand: anInteger
	"Set the receiver's 'idCommand' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_idCommand put: anInteger!

iImage
	"Answer the <Integer> value of the receiver's 'iImage' field."

	^bytes sdwordAtOffset: _OffsetOf_iImage!

iImage: anInteger
	"Set the receiver's 'iImage' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_iImage put: anInteger!

lParam
	"Answer the <Integer> value of the receiver's 'lParam' field."

	^bytes uintPtrAtOffset: _OffsetOf_lParam!

lParam: anInteger
	"Set the receiver's 'lParam' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_lParam put: anInteger!

pszText
	"Answer the <Utf16String> value of the receiver's 'pszText' field."

	^Utf16String fromAddress: (bytes intPtrAtOffset: _OffsetOf_pszText)!

pszText: anUtf16String
	"Set the receiver's 'pszText' field to the value of the argument, anUtf16String"

	bytes uintPtrAtOffset: _OffsetOf_pszText put: anUtf16String yourAddress!

text
	^text!

text: aString
	"Set the receiver's tip text to a Unicode version of the <readableString> argument,
	and answer that."

	"Implementation Note: The answer must be referenced until the TOOLTIPTEXT is no longer required to
	prevent it being prematurely GC'd, so we answer it in order that the caller can reference it."

	text := aString displayString asUtf16String.
	self pszText: text.
	^text! !
!OS.NMTBDISPINFOW categoriesFor: #cchText!**compiled accessors**!public! !
!OS.NMTBDISPINFOW categoriesFor: #cchText:!**compiled accessors**!public! !
!OS.NMTBDISPINFOW categoriesFor: #dwMask!**compiled accessors**!public! !
!OS.NMTBDISPINFOW categoriesFor: #dwMask:!**compiled accessors**!public! !
!OS.NMTBDISPINFOW categoriesFor: #idCommand!**compiled accessors**!public! !
!OS.NMTBDISPINFOW categoriesFor: #idCommand:!**compiled accessors**!public! !
!OS.NMTBDISPINFOW categoriesFor: #iImage!**compiled accessors**!public! !
!OS.NMTBDISPINFOW categoriesFor: #iImage:!**compiled accessors**!public! !
!OS.NMTBDISPINFOW categoriesFor: #lParam!**compiled accessors**!public! !
!OS.NMTBDISPINFOW categoriesFor: #lParam:!**compiled accessors**!public! !
!OS.NMTBDISPINFOW categoriesFor: #pszText!**compiled accessors**!public! !
!OS.NMTBDISPINFOW categoriesFor: #pszText:!**compiled accessors**!public! !
!OS.NMTBDISPINFOW categoriesFor: #text!accessing!public! !
!OS.NMTBDISPINFOW categoriesFor: #text:!accessing!public! !

!OS.NMTBDISPINFOW class methodsFor!

defineFields
	"Define the fields of the NMTBDISPINFOW structure.

	NMTBDISPINFOW compileDefinition

		typedef [uuid(9b3478db-36e6-431d-8f12-66016b6b5ef8)]
		struct tagNMTBDISPINFOW {
			[readonly] NMHDR hdr;
			DWORD dwMask;
			int idCommand;
			ULONG_PTR lParam;
			int iImage;
			[string] LPWSTR pszText;
			int cchText;
		} NMTBDISPINFOW;
"

	super defineFields.
	self
		defineField: #dwMask type: DWORDField new offset: 12;
		defineField: #idCommand type: SDWORDField new offset: 16;
		defineField: #lParam type: UINT_PTRField new offset: 20;
		defineField: #iImage type: SDWORDField new offset: 24;
		defineField: #pszText type: (PointerField type: Utf16String) offset: 28;
		defineField: #cchText type: SDWORDField new offset: 32.
	self byteSize: 36!

getFieldNames
	^#(#hwndFrom #idFrom #code #dwMask #idCommand #lParam #iImage #pszText #cchText)! !
!OS.NMTBDISPINFOW class categoriesFor: #defineFields!**auto generated**!public!template definition! !
!OS.NMTBDISPINFOW class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

