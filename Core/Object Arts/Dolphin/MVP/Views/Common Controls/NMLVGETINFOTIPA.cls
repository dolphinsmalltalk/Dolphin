"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMLVGETINFOTIPA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLVGETINFOTIPA guid: (GUID fromString: '{f44c9147-2b3f-11d3-8368-7a8b5a000000}')!
NMLVGETINFOTIPA comment: ''!
!NMLVGETINFOTIPA categoriesForClass!External-Data-Structured-Win32! !
!NMLVGETINFOTIPA methodsFor!

cchTextMax
	"Answer the receiver's cchTextMax field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cchTextMax)!

dwFlags
	"Answer the receiver's dwFlags field as a Smalltalk object."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

iItem
	"Answer the receiver's iItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iItem)!

iSubItem
	"Answer the receiver's iSubItem field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSubItem)!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self iItem + 1!

pszText
	"Answer the receiver's pszText field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #pszText)) asExternalAddress!

text: text
	"Private - Set the receiver's tip text to the ANSI string representation of the argument, text,
	up to the maximum number of characters specified by the receiver's #cchTextMax field.
	Answer the potentially truncated text."

	| t max |
	t := text asString.
	max := self cchTextMax.
	t size >= max ifTrue: [t := (t copyFrom: 1 to: max-4), '...'].
	CRTLibrary default strncpy: self pszText strSource: t count: max.
	^t
! !
!NMLVGETINFOTIPA categoriesFor: #cchTextMax!**compiled accessors**!public! !
!NMLVGETINFOTIPA categoriesFor: #dwFlags!**compiled accessors**!public! !
!NMLVGETINFOTIPA categoriesFor: #iItem!**compiled accessors**!public! !
!NMLVGETINFOTIPA categoriesFor: #iSubItem!**compiled accessors**!public! !
!NMLVGETINFOTIPA categoriesFor: #itemHandle!accessing!public! !
!NMLVGETINFOTIPA categoriesFor: #pszText!**compiled accessors**!public! !
!NMLVGETINFOTIPA categoriesFor: #text:!accessing!private! !

!NMLVGETINFOTIPA class methodsFor!

defineFields
	"Define the structure template for Win32 NMLVGETINFOTIPA structure.
	Implementation Note: We define the text field as an address because we
	need to write back to the buffer pointed at by that field rather than overwrite
	it.

		NMLVGETINFOTIPA compileDefinition

		typedef struct tagNMLVGETINFOTIPA
		{
			NMHDR hdr;
			DWORD dwFlags;
			LPSTR pszText;
			int cchTextMax;
			int iItem;
			int iSubItem;
			LPARAM lParam;
		} NMLVGETINFOTIPA, *LPNMLVGETINFOTIPA;"

	super defineFields.
	self
		defineField: #dwFlags type: DWORDField readOnly;
		defineField: #pszText type: LPVOIDField readOnly;
		defineField: #cchTextMax type: SDWORDField readOnly;
		defineField: #iItem type: SDWORDField readOnly;
		defineField: #iSubItem type: SDWORDField readOnly;
		defineField: #lParam type: INT_PTRField filler! !
!NMLVGETINFOTIPA class categoriesFor: #defineFields!initializing!public! !

