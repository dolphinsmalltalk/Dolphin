"Filed out from Dolphin Smalltalk"!

ExternalRectangleTest subclass: #RECTLTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RECTLTest guid: (GUID fromString: '{b9abab45-a64b-49f6-a20d-b3750487cc16}')!

RECTLTest comment: ''!

!RECTLTest categoriesForClass!Unclassified! !

!RECTLTest methodsFor!

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

!RECTLTest categoriesForMethods!
subjectClass!constants!private! !
testScaleToDpiFrom!public!unit tests! !
!

