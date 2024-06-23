"Filed out from Dolphin Smalltalk"!

SUnitAbsWrapper subclass: #SUnitTestCaseWrapper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!SUnitTestCaseWrapper categoriesForMethods!
allTests!accessing!public! !
debug!actions!public! !
isFor:withResult:!public! !
name!accessing!public! !
numberCorrect!accessing!public! !
numberErrors!accessing!public! !
numberFailures!accessing!public! !
numberNotYetRun!accessing!public! !
numberTests!accessing!public! !
selector!accessing!public! !
step!actions!public! !
testCase!accessing!private! !
testCase:!accessing!private! !
!

!SUnitTestCaseWrapper class methodsFor!

newOn: aTestCase model: anSUnitBrowserModel

	^(self newOn: anSUnitBrowserModel)
		testCase: aTestCase;
		yourself! !

!SUnitTestCaseWrapper class categoriesForMethods!
newOn:model:!instantiating!public! !
!

