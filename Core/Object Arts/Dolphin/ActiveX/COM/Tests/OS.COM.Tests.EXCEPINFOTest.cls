"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.EXCEPINFOTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.EXCEPINFOTest guid: (Core.GUID fromString: '{00685cc4-a260-4b8f-9721-b0bb8a4cfaef}')!

OS.COM.Tests.EXCEPINFOTest comment: ''!

!OS.COM.Tests.EXCEPINFOTest methodsFor!

testDescription
	| subject expected actual |
	subject := EXCEPINFO new.
	self assertIsNil: subject description.
	expected := 'Foo'.
	subject description: expected.
	self assert: (OleAut32 sysStringLen: subject pwszDescription) equals: 3.
	actual := subject description.
	self assert: actual isKindOf: Utf16String.
	self assert: actual equals: expected.
	expected := 'Bar' asUtf16String.
	subject description: expected.
	self assert: (OleAut32 sysStringLen: subject pwszDescription) equals: 3.
	actual := subject description.
	self assert: actual isKindOf: Utf16String.
	self assert: actual equals: expected.
	expected := 'FooBar' asBSTR.
	subject description: expected.
	self assert: (OleAut32 sysStringLen: subject pwszDescription) equals: 6.
	"Should store a copy of the BSTR"
	self deny: subject pwszDescription equals: expected yourAddress.
	actual := subject description.
	self assert: actual isKindOf: Utf16String.
	self assert: actual equals: expected value.
	subject free.
	self assertIsNil: subject bytes! !

!OS.COM.Tests.EXCEPINFOTest categoriesForMethods!
testDescription!public! !
!

