"Filed out from Dolphin Smalltalk 2002 release 5.02"!

TestCase subclass: #TestEndNotifierTestCase
	instanceVariableNames: 'result'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestEndNotifierTestCase guid: (GUID fromString: '{D9EA2E92-992E-4BF9-A4B0-529B761331FF}')!
TestEndNotifierTestCase comment: ''!
!TestEndNotifierTestCase categoriesForClass!SUnit! !
!TestEndNotifierTestCase methodsFor!

run: aResult
	result := aResult.
	aResult runCase: self
!

tearDown
	TestEndNotifierResource current result: result!

testError
	"3 zork"
!

testFail
	self assert: false description: 'this test should fail'
!

testStub
	"Do nothing. This method is only here so that the resource will be initialized
	and something will be executed"! !
!TestEndNotifierTestCase categoriesFor: #run:!public! !
!TestEndNotifierTestCase categoriesFor: #tearDown!public! !
!TestEndNotifierTestCase categoriesFor: #testError!public! !
!TestEndNotifierTestCase categoriesFor: #testFail!public! !
!TestEndNotifierTestCase categoriesFor: #testStub!public! !

!TestEndNotifierTestCase class methodsFor!

resources
	^Array with: TestEndNotifierResource! !
!TestEndNotifierTestCase class categoriesFor: #resources!public! !

