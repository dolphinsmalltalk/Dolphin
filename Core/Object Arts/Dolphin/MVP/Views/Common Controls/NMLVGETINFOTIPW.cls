"Filed out from Dolphin Smalltalk 7"!

NMHDR subclass: #NMLVGETINFOTIPW
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
NMLVGETINFOTIPW guid: (GUID fromString: '{cfd19e11-86a3-4b65-ae78-55b3c8c34b0c}')!
NMLVGETINFOTIPW comment: ''!
!NMLVGETINFOTIPW categoriesForClass!External-Data-Structured-Win32! !
!NMLVGETINFOTIPW methodsFor!

cchTextMax
	"Answer the <Integer> value of the receiver's 'cchTextMax' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #cchTextMax)!

dwFlags
	"Answer the <Integer> value of the receiver's 'dwFlags' field."

	^bytes dwordAtOffset: ##(self offsetOf: #dwFlags)!

iItem
	"Answer the <Integer> value of the receiver's 'iItem' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iItem)!

iSubItem
	"Answer the <Integer> value of the receiver's 'iSubItem' field."

	^bytes sdwordAtOffset: ##(self offsetOf: #iSubItem)!

itemHandle
	"Answer the 'handle' of the receiver's item."

	^self iItem + 1!

pszText
	"Answer the <ExternalAddress> value of the receiver's 'pszText' field."

	^(bytes uintPtrAtOffset: ##(self offsetOf: #pszText)) asExternalAddress!

text
	^Utf16String fromAddress: self pszText!

text: text
	"Private - Set the receiver's tip text to the string representation of the argument, text,
	up to the maximum number of characters specified by the receiver's #cchTextMax field.
	Answer the potentially truncated text."

	| tipText max |
	tipText := text displayString asUtf16String.
	max := self cchTextMax.
	tipText size >= max
		ifTrue: 
			[| last |
			last := max - 4.
			(tipText at: last) isSurrogate ifTrue: [last := last - 1].
			tipText := (tipText copyFrom: 1 to: last) , '...'].
	tipText copyToBuffer: self pszText ofSize: max.
	^tipText!

textClass
	^Utf16String! !
!NMLVGETINFOTIPW categoriesFor: #cchTextMax!**compiled accessors**!public! !
!NMLVGETINFOTIPW categoriesFor: #dwFlags!**compiled accessors**!public! !
!NMLVGETINFOTIPW categoriesFor: #iItem!**compiled accessors**!public! !
!NMLVGETINFOTIPW categoriesFor: #iSubItem!**compiled accessors**!public! !
!NMLVGETINFOTIPW categoriesFor: #itemHandle!accessing!public! !
!NMLVGETINFOTIPW categoriesFor: #pszText!**compiled accessors**!public! !
!NMLVGETINFOTIPW categoriesFor: #text!accessing!public! !
!NMLVGETINFOTIPW categoriesFor: #text:!accessing!private! !
!NMLVGETINFOTIPW categoriesFor: #textClass!constants!private! !

!NMLVGETINFOTIPW class methodsFor!

defineFields
	"Define the structure template for Win32 NMLVGETINFOTIPA structure.
	Implementation Note: We define the text field as an address because we
	need to write back to the buffer pointed at by that field rather than overwrite
	it.

		self compileDefinition

		typedef struct tagNMLVGETINFOTIPW
		{
			NMHDR hdr;
			DWORD dwFlags;
			LPWSTR pszText;
			int cchTextMax;
			int iItem;
			int iSubItem;
			LPARAM lParam;
		} NMLVGETINFOTIPW, *LPNMLVGETINFOTIPW;"

	super defineFields.
	self
		defineField: #dwFlags type: DWORDField readOnly;
		defineField: #pszText type: LPVOIDField readOnly;
		defineField: #cchTextMax type: SDWORDField readOnly;
		defineField: #iItem type: SDWORDField readOnly;
		defineField: #iSubItem type: SDWORDField readOnly;
		defineField: #lParam type: INT_PTRField filler! !
!NMLVGETINFOTIPW class categoriesFor: #defineFields!initializing!public! !

