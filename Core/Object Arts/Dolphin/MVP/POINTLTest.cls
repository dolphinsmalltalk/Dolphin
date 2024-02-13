"Filed out from Dolphin Smalltalk"!

ExternalPointTest subclass: #POINTLTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

POINTLTest guid: (GUID fromString: '{10c5c3a8-def8-4e74-a3d7-1bb3783e1c3e}')!

POINTLTest comment: ''!

!POINTLTest categoriesForClass!Unclassified! !

!POINTLTest methodsFor!

subjectClass
	^POINTL!

testDivideLarge
	| largeNeg largePos subject |
	largeNeg := SmallInteger minimum - 1.
	largePos := SmallInteger maximum + 1.
	subject := self subjectClass x: largeNeg y: largePos.
	self assert: subject / largeNeg equals: 1 @ (largePos / largeNeg)! !

!POINTLTest categoriesForMethods!
subjectClass!constants!private! !
testDivideLarge!public! !
!

