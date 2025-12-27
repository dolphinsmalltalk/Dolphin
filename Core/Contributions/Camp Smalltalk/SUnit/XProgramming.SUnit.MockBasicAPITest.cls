"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'XProgramming.SUnit.MockBasicAPITest'
	instanceVariableNames: 'mock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.MockBasicAPITest guid: (Core.GUID fromString: '{9d259c78-8459-45ac-ab85-292117a3e5af}')!

XProgramming.SUnit.MockBasicAPITest comment: ''!

!XProgramming.SUnit.MockBasicAPITest methodsFor!

setUp

	super setUp.
	mock := MockObject new.
	mock
		on: #meaningOfLife 
		respond: 42. 
	mock 
		on: #secondMeaning
		respond: 84.
	!

testMeaningOfLife

	<ignoreNotImplementedSelectors: #(meaningOfLife secondMeaning)>
	
	self assert: mock meaningOfLife equals: 42.
	"We verify that all the messages have been consumed. 
	Since this is not the case we raise an error."
	self should: [ self verify: mock ] raise: TestFailure.
	self assert: mock secondMeaning equals: 84.
	self verify: mock!

testMeaningOfLifeIsFirst

	<ignoreNotImplementedSelectors: #( meaningOfLife secondMeaning )>
	self assert: mock meaningOfLife equals: 42.
	self assert: mock secondMeaning equals: 84.
	
	"We verify that all the messages have been consumed. 
	Since this is the case we did not get an error."
	self shouldnt: [ self verify: mock ] raise: TestFailure.!

testMeaningOfLifeIsSentTwice

	<ignoreNotImplementedSelectors: #( meaningOfLife )>
	self assert: mock meaningOfLife equals: 42.
	self should: [ self assert: mock meaningOfLife equals: 42 ] raise: TestFailure!

testUnexpected
	<ignoreNotImplementedSelectors: #(meaningOfLife secondMeaning)>

	self should: [mock foo] raise: TestFailure.
	self assert: mock meaningOfLife equals: 42.
	self should: [mock foo] raise: TestFailure.
	self assert: mock secondMeaning equals: 84.
	self should: [mock foo] raise: TestFailure.
	self verify: mock 
!

testVerifyChecksThatAllTheMessageGotSent

	<ignoreNotImplementedSelectors: #( meaningOfLife secondMeaning )>
	self assert: mock meaningOfLife equals: 42.
	self assert: mock secondMeaning equals: 84.
	self verify: mock!

testVerifyFailsWhenMessageShouldBeSent

	<ignoreNotImplementedSelectors: #( meaningOfLife )>
	self assert: mock meaningOfLife equals: 42.
	self should: [ self verify: mock ] raise: TestFailure! !

!XProgramming.SUnit.MockBasicAPITest categoriesForMethods!
setUp!public!running! !
testMeaningOfLife!public!running! !
testMeaningOfLifeIsFirst!public!running! !
testMeaningOfLifeIsSentTwice!public!running! !
testUnexpected!public!running! !
testVerifyChecksThatAllTheMessageGotSent!public!running! !
testVerifyFailsWhenMessageShouldBeSent!public!running! !
!

