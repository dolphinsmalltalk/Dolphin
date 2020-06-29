"Filed out from Dolphin Smalltalk 7"!

Object subclass: #SUnitBrowserResult
	instanceVariableNames: 'testResult model failures errors passed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SUnitBrowserResult guid: (GUID fromString: '{ca60c917-290b-444c-b572-cd6c8a99d198}')!
SUnitBrowserResult comment: ''!
!SUnitBrowserResult categoriesForClass!Unclassified! !
!SUnitBrowserResult methodsFor!

add: aTestCase to: aLookupTable

	aLookupTable
		at: (self keyFor: aTestCase)
		put: aTestCase!

areAllTestsCompleted

	^self runCount = self numberOfTests!

areAnyTestsCompleted

	^self runCount > 0!

basicErrors

	^errors!

basicFailures

	^failures!

basicPassed

	^passed!

clear

	self initialize!

defects

	^self errors copy
		addAll: self failures;
		yourself!

errorCount

	^self basicErrors size!

errors

	^self basicErrors values!

errors: anObject
	errors := anObject!

failureCount

	^self basicFailures size!

failures

	^self basicFailures values!

failures: anObject
	failures := anObject!

hasErrors

	^self basicErrors isEmpty not!

hasFailures

	^self basicFailures isEmpty not!

hasPassed

	^(self hasErrors or: [self hasFailures]) not!

initialize

	super initialize.

	self
		errors: LookupTable new;
		failures: LookupTable new;
		passed: LookupTable new!

initializeModel: anSunitModel

	self model: anSunitModel!

isDefect: aTestCase
	|  key |

	key := self keyFor: aTestCase.

	^(self basicFailures includesKey: key) or: [self basicErrors includesKey: key]!

isError: aTestCase

	^self basicErrors includesKey: (self keyFor: aTestCase)!

isFailure: aTestCase

	^self basicFailures includesKey: (self keyFor: aTestCase)!

isPassed: aTestCase

	^self basicPassed includesKey: (self keyFor: aTestCase)!

keyFor: aTestCase

	^aTestCase !

merge: aTestResult for: aTestCase

	"aTestResult is the result of running just one TestCase, aTestCase"

	self remove: aTestCase.

	aTestResult hasPassed 
		ifTrue: [ 
			self 
				add: aTestCase 
				to: self basicPassed.
			^self].

	aTestResult hasFailures 
		ifTrue: [
			self
				add: aTestCase 
				to: self basicFailures.
			^self].

	self
		add: aTestCase 
		to: self basicErrors
!

model

	^model!

model: anSunitModel

	model := anSunitModel!

numberCorrectFor: aTest

	^self
		numberInCollection: self basicPassed 
		for: aTest!

numberErrorsFor: aTest


	^self
		numberInCollection: self basicErrors
		for: aTest!

numberFailuresFor: aTest

	^self
		numberInCollection: self basicFailures
		for: aTest!

numberInCollection: aLookupTable for: aTest
	"count the number of tests in aTest (TestCase or TestSuite) that have a matching Test Case in 
	 aCollection"

	^aTest allTests
		inject: 0
		into: [:count :each |
			(aLookupTable includesKey: (self keyFor: each))
				ifTrue: [count + 1]
				ifFalse: [count]]!

numberNotYetRunFor: aTest

	^aTest allTests
		inject: 0
		into: [:count :each |
			((self numberCorrectFor: each) + (self numberErrorsFor: each) +
				(self numberFailuresFor: each) = 0)
					ifTrue: [count + 1]
					ifFalse: [count]]!

numberOfTests

	^self model numberOfTests!

passed

	^self basicPassed values!

passed: anObject
	passed := anObject!

passedCount

	^self basicPassed size!

remove: aTestCase
	"remove the results of aTestCase from the results"

	self removeAt: aTestCase!

removeAll: tests
	"remove the results of tests (TestCase or TestSuite) in aCollection"

	tests do: [:each | 
		each allTests do: [:eachTestCase | 
			self removeAt: eachTestCase]]
!

removeAt: aTestCase

	| key |

	key := self keyFor: aTestCase.

	self basicPassed
		removeKey: key 
		ifAbsent: [
			self basicErrors
				removeKey: key 
				ifAbsent: [
					self basicFailures
						removeKey: key 
						ifAbsent: []]]!

runCount

	^self passedCount + self failureCount + self errorCount!

testResult

	^testResult!

testResult: aTestResult

	testResult := aTestResult! !
!SUnitBrowserResult categoriesFor: #add:to:!actions!private! !
!SUnitBrowserResult categoriesFor: #areAllTestsCompleted!public!querying! !
!SUnitBrowserResult categoriesFor: #areAnyTestsCompleted!public!querying! !
!SUnitBrowserResult categoriesFor: #basicErrors!accessing!private! !
!SUnitBrowserResult categoriesFor: #basicFailures!accessing!private! !
!SUnitBrowserResult categoriesFor: #basicPassed!accessing!private! !
!SUnitBrowserResult categoriesFor: #clear!actions!public! !
!SUnitBrowserResult categoriesFor: #defects!accessing!public! !
!SUnitBrowserResult categoriesFor: #errorCount!public!statistics! !
!SUnitBrowserResult categoriesFor: #errors!accessing!public! !
!SUnitBrowserResult categoriesFor: #errors:!accessing!private! !
!SUnitBrowserResult categoriesFor: #failureCount!public!statistics! !
!SUnitBrowserResult categoriesFor: #failures!accessing!public! !
!SUnitBrowserResult categoriesFor: #failures:!accessing!private! !
!SUnitBrowserResult categoriesFor: #hasErrors!public!statistics! !
!SUnitBrowserResult categoriesFor: #hasFailures!public!statistics! !
!SUnitBrowserResult categoriesFor: #hasPassed!public!statistics! !
!SUnitBrowserResult categoriesFor: #initialize!initializing!private! !
!SUnitBrowserResult categoriesFor: #initializeModel:!initializing!private! !
!SUnitBrowserResult categoriesFor: #isDefect:!public!statistics! !
!SUnitBrowserResult categoriesFor: #isError:!public!statistics! !
!SUnitBrowserResult categoriesFor: #isFailure:!public!statistics! !
!SUnitBrowserResult categoriesFor: #isPassed:!public!statistics! !
!SUnitBrowserResult categoriesFor: #keyFor:!actions!private! !
!SUnitBrowserResult categoriesFor: #merge:for:!actions!public! !
!SUnitBrowserResult categoriesFor: #model!accessing!public! !
!SUnitBrowserResult categoriesFor: #model:!accessing!public! !
!SUnitBrowserResult categoriesFor: #numberCorrectFor:!public!statistics! !
!SUnitBrowserResult categoriesFor: #numberErrorsFor:!public!statistics! !
!SUnitBrowserResult categoriesFor: #numberFailuresFor:!public!statistics! !
!SUnitBrowserResult categoriesFor: #numberInCollection:for:!public!statistics! !
!SUnitBrowserResult categoriesFor: #numberNotYetRunFor:!public!statistics! !
!SUnitBrowserResult categoriesFor: #numberOfTests!accessing!private! !
!SUnitBrowserResult categoriesFor: #passed!accessing!public! !
!SUnitBrowserResult categoriesFor: #passed:!accessing!private! !
!SUnitBrowserResult categoriesFor: #passedCount!public!statistics! !
!SUnitBrowserResult categoriesFor: #remove:!actions!public! !
!SUnitBrowserResult categoriesFor: #removeAll:!actions!public! !
!SUnitBrowserResult categoriesFor: #removeAt:!actions!private! !
!SUnitBrowserResult categoriesFor: #runCount!public!statistics! !
!SUnitBrowserResult categoriesFor: #testResult!accessing!private! !
!SUnitBrowserResult categoriesFor: #testResult:!accessing!private! !

!SUnitBrowserResult class methodsFor!

new

	^super new
		initialize;
		yourself!

newOn: anSunitModel

	^self new
		initializeModel: anSunitModel;
		yourself! !
!SUnitBrowserResult class categoriesFor: #new!instantiating!public! !
!SUnitBrowserResult class categoriesFor: #newOn:!instantiating!public! !

