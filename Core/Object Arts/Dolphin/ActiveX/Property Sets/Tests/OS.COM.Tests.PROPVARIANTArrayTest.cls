"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.OleVariantArrayTest
	subclass: #'OS.COM.Tests.PROPVARIANTArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.PROPVARIANTArrayTest guid: (Core.GUID fromString: '{03f09658-4d13-483d-a565-4420c960f406}')!

OS.COM.Tests.PROPVARIANTArrayTest comment: ''!

!OS.COM.Tests.PROPVARIANTArrayTest methodsFor!

testSelfEvaluating
	| subject |
	subject := self newTestSubjectOfSize: 6.
	self deny: subject isSelfEvaluating.
	self assert: subject printString equals: 'a COM.PROPVARIANTArray(nil ''a🐬b'' (COM.CALPOLESTR withAll: #(''£1.5'' ''a🐬b'')) a POINTL(100@200) (COM.CABOOL withAll: #(true false)) ''a£b'')'! !

!OS.COM.Tests.PROPVARIANTArrayTest categoriesForMethods!
testSelfEvaluating!public!unit tests! !
!

!OS.COM.Tests.PROPVARIANTArrayTest class methodsFor!

arrayClass
	^PROPVARIANTArray!

elementFromIndex: anInteger
	^{
		nil.
		'a🐬b'.
		Utf16StringArray withAll: #('£1.5' 'a🐬b').
		100@200.
		BOOLArray withAll: #(true false).
		'a£b' asAnsiString
	} at: anInteger ! !

!OS.COM.Tests.PROPVARIANTArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

