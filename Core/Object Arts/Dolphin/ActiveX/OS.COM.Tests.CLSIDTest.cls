"Filed out from Dolphin Smalltalk 7"!

External.Tests.GUIDTest subclass: #'OS.COM.Tests.CLSIDTest'
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

testDisplayString
	| subject |
	subject := self subjectClass fromProgID: 'ADODB.Command'.
	self assert: subject displayString equals: subject progID.
	super testDisplayString!

testProgId
	| subject actual |
	subject := self subjectClass fromProgID: 'ADODB.Command'.
	actual := subject progID.
	self assert: (actual beginsWith: 'ADODB.Command')! !
!OS.COM.Tests.CLSIDTest categoriesFor: #subjectClass!constants!private! !
!OS.COM.Tests.CLSIDTest categoriesFor: #testDisplayString!constants!public! !
!OS.COM.Tests.CLSIDTest categoriesFor: #testProgId!constants!public! !

