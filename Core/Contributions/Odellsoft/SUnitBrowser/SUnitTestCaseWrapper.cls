"Filed out from Dolphin Smalltalk 7"!

SUnitAbsWrapper subclass: #SUnitTestCaseWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SUnitTestCaseWrapper guid: (GUID fromString: '{3d7b400c-2a38-4ac3-a42b-7ccf511ca323}')!
SUnitTestCaseWrapper comment: ''!
!SUnitTestCaseWrapper categoriesForClass!Unclassified! !
!SUnitTestCaseWrapper methodsFor!

allTests

	^self testCase allTests!

debug

	self testCase debug!

isFor: aTestCase withResult: aTestResult

	^self allTests anySatisfy: [ :each | each = aTestCase]!

name

	^self model useDisplayNames
		ifTrue: [self testCase displayName]
		ifFalse: [self testCase name]
!

numberCorrect

	^self model numberCorrectFor: self testCase!

numberErrors

	^self model numberErrorsFor: self testCase!

numberFailures

	^self model numberFailuresFor: self testCase!

numberNotYetRun

	^self model numberNotYetRunFor: self testCase!

numberTests

	^self model numberTestsIn: self testCase!

selector

	^self testCase selector!

step

	self testCase step!

testCase

	^self subject!

testCase: anObject

	self subject: anObject! !
!SUnitTestCaseWrapper categoriesFor: #allTests!accessing!public! !
!SUnitTestCaseWrapper categoriesFor: #debug!actions!public! !
!SUnitTestCaseWrapper categoriesFor: #isFor:withResult:!public! !
!SUnitTestCaseWrapper categoriesFor: #name!accessing!public! !
!SUnitTestCaseWrapper categoriesFor: #numberCorrect!accessing!public! !
!SUnitTestCaseWrapper categoriesFor: #numberErrors!accessing!public! !
!SUnitTestCaseWrapper categoriesFor: #numberFailures!accessing!public! !
!SUnitTestCaseWrapper categoriesFor: #numberNotYetRun!accessing!public! !
!SUnitTestCaseWrapper categoriesFor: #numberTests!accessing!public! !
!SUnitTestCaseWrapper categoriesFor: #selector!accessing!public! !
!SUnitTestCaseWrapper categoriesFor: #step!actions!public! !
!SUnitTestCaseWrapper categoriesFor: #testCase!accessing!private! !
!SUnitTestCaseWrapper categoriesFor: #testCase:!accessing!private! !

!SUnitTestCaseWrapper class methodsFor!

newOn: aTestCase model: anSUnitBrowserModel

	^(self newOn: anSUnitBrowserModel)
		testCase: aTestCase;
		yourself! !
!SUnitTestCaseWrapper class categoriesFor: #newOn:model:!instantiating!public! !

