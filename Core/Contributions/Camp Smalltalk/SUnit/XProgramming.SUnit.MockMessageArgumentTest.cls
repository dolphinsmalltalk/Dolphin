"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'XProgramming.SUnit.MockMessageArgumentTest'
	instanceVariableNames: 'mock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.MockMessageArgumentTest guid: (Core.GUID fromString: '{c061b818-a6ac-4481-a945-2aba6d4760ed}')!

XProgramming.SUnit.MockMessageArgumentTest comment: ''!

!XProgramming.SUnit.MockMessageArgumentTest methodsFor!

setUp

	super setUp.
	mock := MockObject new.
	mock
		on: #meaningOfLife: 
		with: 22
		respond: 42. 
	mock 
		on: #secondMeaning:and:
		with: 32
		with: 64
		respond: 84.
	!

testMeaningOfLife
	<ignoreNotImplementedSelectors: #(meaningOfLife: secondMeaning:and:)>
	
	self assert: (mock meaningOfLife: 22) equals: 42.
	self assert: (mock secondMeaning: 32 and: 64) equals: 84.
	self shouldnt: [ self verify: mock ] raise: TestFailure!

testMeaningOfLifeDoesNotPassCorrectValue
	<ignoreNotImplementedSelectors: #(meaningOfLife:)>
	
	self should: [ self assert: (mock meaningOfLife: 33) equals: 42 ] raise: TestFailure!

testMeaningOfLifeFailing
	<ignoreNotImplementedSelectors: #(#meaningOfLife: #secondMeaning:and:)>
	self assert: (mock meaningOfLife: 22) equals: 42.
	self should: [mock secondMeaning: 32 and: 65] raise: TestFailure.
	self should: [mock secondMeaning: 32 and: 65] raise: TestFailure! !

!XProgramming.SUnit.MockMessageArgumentTest categoriesForMethods!
setUp!public!running! !
testMeaningOfLife!public!running! !
testMeaningOfLifeDoesNotPassCorrectValue!public!running! !
testMeaningOfLifeFailing!public!running! !
!

