"Filed out from Dolphin Smalltalk"!

External.Tests.RECTTest
	subclass: #'OS.Tests.RECTLTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.RECTLTest guid: (Core.GUID fromString: '{b9abab45-a64b-49f6-a20d-b3750487cc16}')!

OS.Tests.RECTLTest comment: ''!

!OS.Tests.RECTLTest methodsFor!

subjectClass
	^RECTL!

testScaleToDpiFrom
	"Test DPI scaling in-place"

	| rect |
	super testScaleToDpiFrom.
	rect := self subjectClass marshal: (1@1 extent: 186@21).
	rect scaleToDpi: 120 from: 96.
	self assert: rect equals: (1@1 corner: 233@27)
! !

!OS.Tests.RECTLTest categoriesForMethods!
subjectClass!constants!private! !
testScaleToDpiFrom!public!unit tests! !
!

