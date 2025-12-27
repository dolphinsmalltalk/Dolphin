"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'XProgramming.SUnit.MockMessageSequenceTest'
	instanceVariableNames: 'mock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.MockMessageSequenceTest guid: (Core.GUID fromString: '{95be5718-837f-4f6e-b754-7d29b1fae441}')!

XProgramming.SUnit.MockMessageSequenceTest comment: ''!

!XProgramming.SUnit.MockMessageSequenceTest methodsFor!

setUp

	super setUp.
	mock := MockObject new.
	mock
		on: #meaningOfLife 
		respond: 42. 
	mock 
		on: #meaningOfLife
		respond: 43.
	mock 
		on: #meaningOfLife
		respond: 44
	!

testThatASequenceOfTheSameMessageReturnsTheCorrespondingValue
	<ignoreNotImplementedSelectors: #(meaningOfLife secondMeaning)>
	
	self assert: mock meaningOfLife equals: 42.
	self assert: mock meaningOfLife equals: 43.
	self assert: mock meaningOfLife equals: 44.
	! !

!XProgramming.SUnit.MockMessageSequenceTest categoriesForMethods!
setUp!public!running! !
testThatASequenceOfTheSameMessageReturnsTheCorrespondingValue!public!running! !
!

