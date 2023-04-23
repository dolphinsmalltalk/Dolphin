"Filed out from Dolphin Smalltalk"!

OS.NMHDR
	subclass: #'OS.NMGETINFOTIP'
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
	^self pszText!

text: anObject
	"Set the receiver's tip text to the displayString representation of the argument, up to the maximum number of characters specified by the receiver's #cchTextMax field.  If the string is too large for the buffer, it is ellipsised with U+2026. Answer the potentially truncated text."

	| utf16 max |
	utf16 := anObject displayString asUtf16String.
	utf16 size >= (max := self cchTextMax)
		ifTrue: 
			["We need to allow space for a U+2026 and the null terminator, ensuring we don't truncate in the middle of a character"
			utf16 := (utf16 copyFrom: 1
						to: ((utf16 at: max - 2) isUtf16Lead ifTrue: [max - 3] ifFalse: [max - 2])) , '…'].
	OS.Ucrt
		wcsncpy_s: (bytes intPtrAtOffset: self textPointerOffset)
		bufferSize: max
		strSource: utf16
		count: OS.CRTConstants._TRUNCATE.
	^utf16!

textPointerOffset
	"Private - Answer the offset of the text pointer in the receiver. "

	^self subclassResponsibility! !
!OS.NMGETINFOTIP categoriesForMethods!
cchTextMax!accessing!public! !
pszText!accessing!public! !
text!accessing!public! !
text:!accessing!public! !
textPointerOffset!constants!private! !
!

