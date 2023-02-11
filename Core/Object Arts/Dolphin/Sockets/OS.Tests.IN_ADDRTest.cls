"Filed out from Dolphin Smalltalk"!

OS.Tests.AbstractIN_ADDRTest subclass: #'OS.Tests.IN_ADDRTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.IN_ADDRTest guid: (Core.GUID fromString: '{c567e844-3b49-4f5d-8d2d-63d64ced8ff3}')!
OS.Tests.IN_ADDRTest comment: ''!
!OS.Tests.IN_ADDRTest methodsFor!

canonicalInstance
	^IN_ADDR new
		s_addr: #[192 168 1 240];
		yourself!

testAddress
	| subject |
	subject := self canonicalInstance.
	self assert: subject address printString equals: 'an InternetAddress(192.168.1.240)'!

testDisplayOn
	| subject |
	subject := self canonicalInstance.
	self assert: subject displayString equals: '192.168.1.240'! !
!OS.Tests.IN_ADDRTest categoriesForMethods!
canonicalInstance!helpers!private! !
testAddress!public!unit tests! !
testDisplayOn!public!unit tests! !
!

