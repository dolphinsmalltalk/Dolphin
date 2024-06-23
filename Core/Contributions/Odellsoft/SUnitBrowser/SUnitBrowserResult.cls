"Filed out from Dolphin Smalltalk"!

Object subclass: #SUnitBrowserResult
	instanceVariableNames: 'testResult model failures errors passed'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

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

!SUnitBrowserResult categoriesForMethods!
add:to:!actions!private! !
areAllTestsCompleted!public!querying! !
areAnyTestsCompleted!public!querying! !
basicErrors!accessing!private! !
basicFailures!accessing!private! !
basicPassed!accessing!private! !
clear!actions!public! !
defects!accessing!public! !
errorCount!public!statistics! !
errors!accessing!public! !
errors:!accessing!private! !
failureCount!public!statistics! !
failures!accessing!public! !
failures:!accessing!private! !
hasErrors!public!statistics! !
hasFailures!public!statistics! !
hasPassed!public!statistics! !
initialize!initializing!private! !
initializeModel:!initializing!private! !
isDefect:!public!statistics! !
isError:!public!statistics! !
isFailure:!public!statistics! !
isPassed:!public!statistics! !
keyFor:!actions!private! !
merge:for:!actions!public! !
model!accessing!public! !
model:!accessing!public! !
numberCorrectFor:!public!statistics! !
numberErrorsFor:!public!statistics! !
numberFailuresFor:!public!statistics! !
numberInCollection:for:!public!statistics! !
numberNotYetRunFor:!public!statistics! !
numberOfTests!accessing!private! !
passed!accessing!public! !
passed:!accessing!private! !
passedCount!public!statistics! !
remove:!actions!public! !
removeAll:!actions!public! !
removeAt:!actions!private! !
runCount!public!statistics! !
testResult!accessing!private! !
testResult:!accessing!private! !
!

!SUnitBrowserResult class methodsFor!

new

	^super new
		initialize;
		yourself!

newOn: anSunitModel

	^self new
		initializeModel: anSunitModel;
		yourself! !

!SUnitBrowserResult class categoriesForMethods!
new!instantiating!public! !
newOn:!instantiating!public! !
!

