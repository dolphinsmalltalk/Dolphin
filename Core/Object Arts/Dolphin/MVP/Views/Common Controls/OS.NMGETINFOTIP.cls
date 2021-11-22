"Filed out from Dolphin Smalltalk"!

OS.NMHDR subclass: #'OS.NMGETINFOTIP'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.NMGETINFOTIP guid: (Core.GUID fromString: '{c10cd176-4f7d-4640-b3ce-5368bfcbfbbc}')!
OS.NMGETINFOTIP isNonInstantiable: true!
OS.NMGETINFOTIP comment: ''!
!OS.NMGETINFOTIP categoriesForClass!External-Data-Structured-Win32! !
!OS.NMGETINFOTIP methodsFor!

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
	tipText size >= (max := self cchTextMax)
		ifTrue: 
			[| last |
			"We need to allow space for a U+2026 and the null terminator"
			last := max - 2.
			"Ensure we don't truncate in the middle of a character"
			(tipText at: last) isUtf16Lead ifTrue: [last := last - 1].
			tipText := (tipText copyFrom: 1 to: last) , '…'].
	tipText copyToBuffer: self pszText ofSize: max.
	^tipText! !
!OS.NMGETINFOTIP categoriesForMethods!
cchTextMax!accessing!public! !
pszText!accessing!public! !
text!accessing!public! !
text:!accessing!public! !
!

