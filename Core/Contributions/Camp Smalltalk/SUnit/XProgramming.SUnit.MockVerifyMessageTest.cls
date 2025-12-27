"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'XProgramming.SUnit.MockVerifyMessageTest'
	instanceVariableNames: 'mock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

XProgramming.SUnit.MockVerifyMessageTest guid: (Core.GUID fromString: '{c8e0d576-035e-4c7e-95ad-a31889f7ac6d}')!

XProgramming.SUnit.MockVerifyMessageTest comment: ''!

!XProgramming.SUnit.MockVerifyMessageTest methodsFor!

setUp
	super setUp.
	mock := MockObject new.
	mock on: #meaningOfLife respond: 42.
	mock
		on: #meaningOfLife:
		with: 12
		verify: [:arg | arg even]!

testVerify
	<ignoreNotImplementedSelectors: #(#meaningOfLife #meaningOfLife:)>
	self assert: mock meaningOfLife equals: 42.
	"2nd expected message not received"
	self
		should: [self verify: mock]
		raise: TestFailure
		matching: [:ex | ex description = 'Mock still has messages pending']!

testVerify2
	"When the arguments are correct, the verify block is executed and it should return true."

	<ignoreNotImplementedSelectors: #(#meaningOfLife #meaningOfLife:)>
	mock
		meaningOfLife;
		meaningOfLife: 12.
	self verify: mock! !

!XProgramming.SUnit.MockVerifyMessageTest categoriesForMethods!
setUp!public!running! !
testVerify!public!running! !
testVerify2!public!running! !
!

