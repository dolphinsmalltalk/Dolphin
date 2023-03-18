"Filed out from Dolphin Smalltalk"!

External.Tests.GUIDTest
	subclass: #'OS.COM.Tests.CLSIDTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.COM.Tests.CLSIDTest guid: (Core.GUID fromString: '{b2531b96-ea2a-4bae-a00c-9e17f59bcac2}')!
OS.COM.Tests.CLSIDTest comment: ''!
!OS.COM.Tests.CLSIDTest categoriesForClass!Tests-Network-UUID! !
!OS.COM.Tests.CLSIDTest methodsFor!

subjectClass
	^CLSID!

testDisplayStringProgId
	| subject |
	subject := self subjectClass fromProgID: 'ADODB.Command'.
	self assert: subject displayString equals: subject progID!

testFromStringProgId
	| subject actual subject2 |
	subject := CLSID fromString: 'ADODB.Command'.
	actual := subject progID.
	self assert: (actual beginsWith: 'ADODB.Command').
	subject2 := CLSID fromString: subject asString.
	self assert: subject2 equals: subject!

testProgId
	| subject actual |
	subject := self subjectClass fromProgID: 'ADODB.Command'.
	actual := subject progID.
	self assert: (actual beginsWith: 'ADODB.Command')! !
!OS.COM.Tests.CLSIDTest categoriesForMethods!
subjectClass!constants!private! !
testDisplayStringProgId!constants!public! !
testFromStringProgId!public!unit tests! !
testProgId!constants!public! !
!

