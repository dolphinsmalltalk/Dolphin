"Filed out from Dolphin Smalltalk"!

ExternalPointTest subclass: #POINTSTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

POINTSTest guid: (GUID fromString: '{e0771f6e-c3db-4a2b-9c85-bfebc2b2913b}')!

POINTSTest comment: ''!

!POINTSTest categoriesForClass!Unclassified! !

!POINTSTest methodsFor!

subjectClass
	^POINTS!

testAsDwordOverflow
	| subject |
	"Can't overflow 32-bits in this case"
	subject := self subjectClass x: 16r7FFF y: 16r7FFF.
	self assert: subject asDword equals: 16r7FFF7FFF.
	subject := self subjectClass x: 16r7FFF y: -16r8000.
	self assert: subject asDword equals: 16r80007FFF.
	subject := self subjectClass x: -16r8000 y: 16r7FFF.
	self assert: subject asDword equals: 16r7FFF8000.
	subject := self subjectClass x: -16r8000 y: -16r8000.
	self assert: subject asDword equals: 16r80008000! !

!POINTSTest categoriesForMethods!
subjectClass!constants!private! !
testAsDwordOverflow!public!unit tests! !
!

