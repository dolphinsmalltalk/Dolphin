"Filed out from Dolphin Smalltalk"!

GdiplusTests subclass: #GpColorMatrixTest
	instanceVariableNames: 'matrix'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GpColorMatrixTest guid: (GUID fromString: '{00610fdc-d988-4d65-a319-78a2dd28b367}')!

GpColorMatrixTest comment: ''!

!GpColorMatrixTest categoriesForClass!Unclassified! !

!GpColorMatrixTest methodsFor!

assertIsIdentity
	1 to: 5
		do: [:r | 1 to: 5 do: [:c | self assert: (matrix atPoint: r @ c) equals: (r = c ifTrue: [1] ifFalse: [0])]]!

createCanonicalSubject
	^self subjectClass identity!

setUp
	super setUp.
	matrix := GpColorMatrix identity!

subjectClass
	^GpColorMatrix!

testAccessing
	self newCanonicalModel.
	(OrderedCollection new
		add: 1 @ 1;
		add: 2 @ 1;
		add: 1 @ 2;
		add: 5 @ 5;
		yourself) do: 
				[:each |
				model atPoint: each put: 0.5.
				self assert: (model atPoint: each) equals: 0.5]!

testIdentity
	self newCanonicalModel.
	self assert: (model atPoint: 1 @ 1) equals: 1.
	self assertIsIdentity!

testWithAll
	| matrix2 elements |
	elements := 1 to: 25.
	model := self subjectClass withAll: elements.
	self assert: model m equals: elements.
	matrix2 := self subjectClass withAll: model m.
	self assert: matrix2 equals: model.
	self deny: model bytes identicalTo: matrix2 bytes.
	elements := (1 to: 25) collect: [:each | 1 / each].
	matrix2 := self subjectClass withAll: elements.
	self assert: (matrix2 closeTo: elements).
	self should: [self subjectClass withAll: (1 to: 26)] raise: InvalidArgumentError! !

!GpColorMatrixTest categoriesForMethods!
assertIsIdentity!helpers!private! !
createCanonicalSubject!helpers!private! !
setUp!public!setup! !
subjectClass!constants!private! !
testAccessing!public!unit tests! !
testIdentity!public!unit tests! !
testWithAll!public!unit tests! !
!

