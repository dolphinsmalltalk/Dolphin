"Filed out from Dolphin Smalltalk 7"!

OS.Tests.AbstractIN_ADDRTest subclass: #'OS.Tests.IN6_ADDRTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.IN6_ADDRTest guid: (Core.GUID fromString: '{302febaf-b335-4060-a958-94e5e30d43cf}')!
OS.Tests.IN6_ADDRTest comment: ''!
!OS.Tests.IN6_ADDRTest categoriesForClass!Unclassified! !
!OS.Tests.IN6_ADDRTest methodsFor!

canonicalInstance
	^IN6_ADDR new
		Bytes: #[254 128 0 0 0 0 0 0 210 110 222 255 254 82 70 208];
		yourself!

testDisplayOn
	| subject |
	subject := self canonicalInstance.
	self assert: subject displayString equals: 'fe80::d26e:deff:fe52:46d0'! !
!OS.Tests.IN6_ADDRTest categoriesFor: #canonicalInstance!helpers!private! !
!OS.Tests.IN6_ADDRTest categoriesFor: #testDisplayOn!public!unit tests! !

