"Filed out from Dolphin Smalltalk"!

NMHDR subclass: #NMGETINFOTIP
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

NMGETINFOTIP guid: (GUID fromString: '{c10cd176-4f7d-4640-b3ce-5368bfcbfbbc}')!

NMGETINFOTIP isAbstract: true!

NMGETINFOTIP comment: ''!

!NMGETINFOTIP categoriesForClass!External-Data-Structured-Win32! !

!NMGETINFOTIP methodsFor!

cchTextMax
	"Answer the <Integer> value of the receiver's 'cchTextMax' field."

	^self subclassResponsibility!

pszText
	"Answer the <ExternalAddress> value of the receiver's 'pszText' field."

	^self subclassResponsibility!

text
	^Utf16String fromAddress: self pszText!

text: text
	"Set the receiver's tip text to the string representation of the argument, text,
	up to the maximum number of characters specified by the receiver's #cchTextMax field.
	Answer the potentially truncated text."

	| tipText max |
	tipText := text displayString asUtf16String.
	max := self cchTextMax.
	tipText size >= max
		ifTrue: 
			[| last |
			last := max - 4.
			"Ensure we don't truncate in the middle of a character"
			(tipText at: last) isUtf16Lead ifTrue: [last := last - 1].
			tipText := (tipText copyFrom: 1 to: last) , '...'].
	tipText copyToBuffer: self pszText ofSize: max.
	^tipText! !

!NMGETINFOTIP categoriesForMethods!
cchTextMax!accessing!public! !
pszText!accessing!public! !
text!accessing!public! !
text:!accessing!public! !
!

