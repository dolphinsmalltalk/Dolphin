"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.CCITEMTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.CCITEMTest guid: (Core.GUID fromString: '{dac52b06-6287-4083-8ce5-db04742e148e}')!
OS.Tests.CCITEMTest isNonInstantiable: true!
OS.Tests.CCITEMTest comment: ''!
!OS.Tests.CCITEMTest methodsFor!

subjectClass
	^self subclassResponsibility!

testTextInBuffer
	| subject |
	subject := self subjectClass newBuffer.
	subject text: '1234567ZX'.
	"Shouldn't this be +1 for null terminator?"
	self assert: subject cchTextMax equals: 10.
	"Leave a char on the end to check for overflow"
	subject cchTextMax: 8.
	"The display string of the argument should be used"
	self assert: (subject textInBuffer: Character dolphin) equals: '🐬'.
	self assert: subject text equals: '🐬' , (String with: $\x0) , '4567ZX'.
	"Set some text for which there is insufficient space (with null terminator), and which ends with an extended char requiring two code-units"
	self assert: (subject textInBuffer: 'abcdef🐬') equals: 'abcdef…'.
	self assert: subject text equals: 'abcdef…' , (String with: $\x0) , 'X'.
	"Set some non-overflowing text"
	self assert: (subject textInBuffer: '1234567') equals: '1234567'.
	self assert: subject text equals: '1234567' , (String with: $\x0) , 'X'.
	"Set some overflowing text again, but this time not splitting an extended char"
	self assert: (subject textInBuffer: 87654321) equals: '876543…'.
	self assert: subject text equals: '876543…' , (String with: $\x0) , 'X'! !
!OS.Tests.CCITEMTest categoriesForMethods!
subjectClass!constants!public! !
testTextInBuffer!constants!public! !
!

