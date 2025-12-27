"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'XProgramming.SUnit.MockUnorderedObjectTest'
	instanceVariableNames: 'mock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.MockUnorderedObjectTest guid: (Core.GUID fromString: '{2b2a7722-e718-4e93-af9a-176a6c54f618}')!

XProgramming.SUnit.MockUnorderedObjectTest comment: ''!

!XProgramming.SUnit.MockUnorderedObjectTest methodsFor!

setUp

	super setUp.
	mock := MockUnorderedObject new.
	mock
		on: #meaningOfLife 
		respond: 42. 
	mock 
		on: #secondMeaning
		respond: 84.
	!

testMeaningOfLife

	<ignoreNotImplementedSelectors: #(meaningOfLife secondMeaning)>
	
	"Messages sent out of order, and multiple times"
	self assert: mock secondMeaning equals: 84.
	self assert: mock meaningOfLife equals: 42.
	self assert: mock meaningOfLife equals: 42.
	self assert: mock secondMeaning equals: 84.

!

testUnexpected

	self should: [mock foo] raise: TestFailure! !

!XProgramming.SUnit.MockUnorderedObjectTest categoriesForMethods!
setUp!public!running! !
testMeaningOfLife!public!running! !
testUnexpected!public!running! !
!

