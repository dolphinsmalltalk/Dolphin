"Filed out from Dolphin Smalltalk 7"!

OS.Tests.AbstractIN_ADDRTest subclass: #'OS.Tests.IN_ADDRTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.IN_ADDRTest guid: (Core.GUID fromString: '{c567e844-3b49-4f5d-8d2d-63d64ced8ff3}')!
OS.Tests.IN_ADDRTest comment: ''!
!OS.Tests.IN_ADDRTest categoriesForClass!Unclassified! !
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
!OS.Tests.IN_ADDRTest categoriesFor: #canonicalInstance!helpers!private! !
!OS.Tests.IN_ADDRTest categoriesFor: #testAddress!public!unit tests! !
!OS.Tests.IN_ADDRTest categoriesFor: #testDisplayOn!public!unit tests! !

