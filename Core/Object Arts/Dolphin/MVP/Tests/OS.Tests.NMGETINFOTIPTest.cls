"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.NMGETINFOTIPTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.NMGETINFOTIPTest guid: (Core.GUID fromString: '{7f1dac6e-bff1-4ae4-ae9a-208b2ada5c3e}')!

OS.Tests.NMGETINFOTIPTest comment: ''!

!OS.Tests.NMGETINFOTIPTest methodsFor!

subjectClass
	^self subclassResponsibility!

testSetText
	| subject buf |
	subject := self subjectClass newBuffer.
	buf := '1234567ZX' asUtf16StringCopy.
	"Leave a char on the end to check for overflow"
	subject
		pszText: buf;
		cchTextMax: 8.
	"The display string of the argument should be used"
	self assert: (subject text: Character dolphin) equals: '🐬'.
	self assert: buf equals: '🐬' , (String with: $\x0) , '4567ZX'.
	"Set some text for which there is insufficient space (with null terminator), and which ends with an extended char requiring two code-units"
	self assert: (subject text: 'abcdef🐬') equals: 'abcdef…'.
	self assert: buf equals: 'abcdef…' , (String with: $\x0) , 'X'.
	"Set some non-overflowing text"
	self assert: (subject text: '1234567') equals: '1234567'.
	self assert: buf equals: '1234567' , (String with: $\x0) , 'X'.
	"Set some overflowing text again, but this time not splitting an extended char"
	self assert: (subject text: 87654321) equals: '876543…'.
	self assert: buf equals: '876543…' , (String with: $\x0) , 'X'! !

!OS.Tests.NMGETINFOTIPTest categoriesForMethods!
subjectClass!constants!public! !
testSetText!constants!public! !
!

