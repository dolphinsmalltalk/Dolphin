"Filed out from Dolphin Smalltalk 7"!

External.Tests.GUIDTest subclass: #CLSIDTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CLSIDTest guid: (GUID fromString: '{b2531b96-ea2a-4bae-a00c-9e17f59bcac2}')!
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

testProgId
	| subject actual |
	subject := CLSID fromProgID: 'ADODB.Command'.
	actual := subject progID.
	self assert: (actual beginsWith: 'ADODB.Command')! !
!CLSIDTest categoriesFor: #subjectClass!constants!private! !
!CLSIDTest categoriesFor: #testDisplayString!constants!public! !
!CLSIDTest categoriesFor: #testProgId!constants!public! !

