"Filed out from Dolphin Smalltalk 7"!

External.Tests.GUIDTest subclass: #CLSIDTest
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
CLSIDTest guid: (Core.GUID fromString: '{b2531b96-ea2a-4bae-a00c-9e17f59bcac2}')!
CLSIDTest comment: ''!
!CLSIDTest categoriesForClass!Tests-Network-UUID! !
!CLSIDTest methodsFor!

subjectClass
	^CLSID!

testDisplayString
	| subject |
	subject := CLSID fromProgID: 'ADODB.Command'.
	self assert: subject displayString equals: subject progID.
	super testDisplayString!

testFromProgIdString
!

testFromStringProgId
	| subject actual subject2 |
	subject := CLSID fromString: 'ADODB.Command'.
	actual := subject progID.
	self assert: (actual beginsWith: 'ADODB.Command').
	subject2 := CLSID fromString: subject asString.
	self assert: subject2 equals: subject!

testProgId
	| subject actual |
	subject := CLSID fromProgID: 'ADODB.Command'.
	actual := subject progID.
	self assert: (actual beginsWith: 'ADODB.Command')! !
!CLSIDTest categoriesFor: #subjectClass!constants!private! !
!CLSIDTest categoriesFor: #testDisplayString!constants!public! !
!CLSIDTest categoriesFor: #testFromProgIdString!public!unit tests! !
!CLSIDTest categoriesFor: #testFromStringProgId!public!unit tests! !
!CLSIDTest categoriesFor: #testProgId!constants!public! !

