"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMTVGETINFOTIPA
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMTVGETINFOTIPA guid: (GUID fromString: '{f44c9149-2b3f-11d3-8368-7a8b5a000000}')!
NMTVGETINFOTIPA comment: ''!
!NMTVGETINFOTIPA categoriesForClass!External-Data-Structured-Win32! !
!NMTVGETINFOTIPA methodsFor!

cchTextMax
	"Answer the receiver's cchTextMax field as a Smalltalk object."

	^bytes sdwordAtOffset: ##(self offsetOf: #cchTextMax)!

hItem
	"Answer the receiver's hItem field as a Smalltalk object."

	^bytes uintPtrAtOffset: ##(self offsetOf: #hItem)!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self hItem!

lParam
	"Answer the receiver's lParam field as a Smalltalk object."

	^bytes uintPtrAtOffset: ##(self offsetOf: #lParam)!

pszText
	"Answer the receiver's pszText field as a Smalltalk object."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #pszText)) asExternalAddress!

text: text
	"Private - Set the receiver's tip text to the ANSI string representation of the argument, text,
	and answer that. If the receiver's #dwFlags field is zero then the text is appended to the existing
	text, but only up to the maximum number of characters specified by the receiver's
	#cchTextMax field."

	CRTLibrary default strncpy: self pszText strSource: text displayString count: self cchTextMax
! !
!NMTVGETINFOTIPA categoriesFor: #cchTextMax!**compiled accessors**!public! !
!NMTVGETINFOTIPA categoriesFor: #hItem!**compiled accessors**!public! !
!NMTVGETINFOTIPA categoriesFor: #itemHandle!accessing!public! !
!NMTVGETINFOTIPA categoriesFor: #lParam!**compiled accessors**!public! !
!NMTVGETINFOTIPA categoriesFor: #pszText!**compiled accessors**!public! !
!NMTVGETINFOTIPA categoriesFor: #text:!accessing!private! !

!NMTVGETINFOTIPA class methodsFor!

defineFields
	"Define the fields of the Win32 NMTVGETINFOTIPA structure.
		NMTVGETINFOTIPA compileDefinition
	"

	super defineFields.
	self
		defineField: #pszText type: LPVOIDField readOnly;
		defineField: #cchTextMax type: SDWORDField readOnly;
		defineField: #hItem type: UINT_PTRField readOnly;
		defineField: #lParam type: UINT_PTRField readOnly! !
!NMTVGETINFOTIPA class categoriesFor: #defineFields!initializing!public! !

