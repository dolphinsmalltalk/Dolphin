"Filed out from Dolphin Smalltalk"!

OS.COM.Tests.OleVariantArrayTest
	subclass: #'OS.COM.Tests.VARIANTArrayTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.VARIANTArrayTest guid: (Core.GUID fromString: '{03f09658-4d13-483d-a565-4420c960f406}')!

OS.COM.Tests.VARIANTArrayTest comment: ''!

!OS.COM.Tests.VARIANTArrayTest methodsFor!

testSelfEvaluating
	| subject |
	subject := self newTestSubjectOfSize: 6.
	self deny: subject isSelfEvaluating.
	self assert: subject printString equals: 'a COM.VARIANTArray(nil ''a🐬b'' a SAFEARRAY(a BSTR(''£1.5'') a BSTR(''a🐬b'')) a POINTL(100@200) a SAFEARRAY(VARIANT_TRUE VARIANT_FALSE) ''a£b'')'! !

!OS.COM.Tests.VARIANTArrayTest categoriesForMethods!
testSelfEvaluating!public!unit tests! !
!

!OS.COM.Tests.VARIANTArrayTest class methodsFor!

arrayClass
	^VARIANTArray!

elementFromIndex: anInteger
	^{
		nil.
		'a🐬b'.
		(Utf16StringArray withAll: #('£1.5' 'a🐬b')) asSAFEARRAY.
		100@200.
		(BOOLArray withAll: #(true false)) asSAFEARRAY.
		'a£b' asAnsiString
	} at: anInteger ! !

!OS.COM.Tests.VARIANTArrayTest class categoriesForMethods!
arrayClass!constants!private! !
elementFromIndex:!helpers!private! !
!

