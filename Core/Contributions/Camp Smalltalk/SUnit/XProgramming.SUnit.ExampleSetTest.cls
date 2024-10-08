﻿"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'XProgramming.SUnit.ExampleSetTest'
	instanceVariableNames: 'full empty'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.ExampleSetTest guid: (Core.GUID fromString: '{5e96793d-0810-11d4-a876-0050da643bf9}')!

XProgramming.SUnit.ExampleSetTest comment: ''!

!XProgramming.SUnit.ExampleSetTest categoriesForClass!SUnitTests! !

!XProgramming.SUnit.ExampleSetTest methodsFor!

setUp
	empty := Set new.
	full := Set with: 5 with: #abc!

testAdd
	empty add: 5.
	self assert: (empty includes: 5)!

testGrow
	empty addAll: (1 to: 100).
	self assert: empty size equals: 100!

testIllegal
	self should: [empty at: 5] raise: TestResult error.
	self should: [empty at: 5 put: #abc] raise: TestResult error!

testIncludes
	self assert: (full includes: 5).
	self assert: (full includes: #abc)!

testOccurrences
	self assert: (empty occurrencesOf: 0) equals: 0.
	self assert: (full occurrencesOf: 5) equals: 1.
	full add: 5.
	self assert: (full occurrencesOf: 5) equals: 1!

testRemove
	full remove: 5.
	self assert: (full includes: #abc).
	self deny: (full includes: 5)! !

!XProgramming.SUnit.ExampleSetTest categoriesForMethods!
setUp!public!Running! !
testAdd!public!Testing! !
testGrow!public!Testing! !
testIllegal!public!Testing! !
testIncludes!public!Testing! !
testOccurrences!public!Testing! !
testRemove!public!Testing! !
!

