"Filed out from Dolphin Smalltalk"!

Object subclass: #TestCase
	instanceVariableNames: 'testSelector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestCase guid: (GUID fromString: '{5e96793a-0810-11d4-a876-0050da643bf9}')!
TestCase isAbstract: true!
TestCase comment: ''!
!TestCase categoriesForClass!SUnit! !
!TestCase methodsFor!

addDependentToHierachy: anObject 
	"an empty method. for Composite compability with TestSuite"
!

assert: aBoolean
	aBoolean ifFalse: [self signalFailure: 'Assertion failed']!

assert: aBoolean description: aStringOrValuable
	aBoolean ifFalse: [self fail: (self getDescription: aStringOrValuable)]!

assert: aBoolean description: aStringOrValuable resumable: resumableBoolean
	aBoolean
		ifFalse: 
			[| exception description |
			description := self getDescription: aStringOrValuable.
			self logFailure: description.
			exception := resumableBoolean ifTrue: [TestResult resumableFailure] ifFalse: [TestResult failure].
			exception signal: description]!

assert: actualObject equals: expectedObject
	expectedObject = actualObject
		ifFalse: [self fail: (self comparingStringBetween: expectedObject and: actualObject)]!

comparingStringBetween: expectedObject and: actualObject
	^(String writeStream: 100)
		nextPutAll: 'Expected: ';
		print: expectedObject;
		nextPutAll: ' Actual: ';
		print: actualObject;
		nextPutAll: '.';
		contents!

debug
	self resources do: [:res | res isAvailable ifFalse: [^res signalInitializationError]].
	[(self class selector: testSelector) runCase] ensure: [self resources do: [:each | each reset]]!

debugAsFailure
	| semaphore |
	semaphore := Semaphore new.
	self resources do: [:res | res isAvailable ifFalse: [^res signalInitializationError]].
	
	[semaphore wait.
	self resources do: [:each | each reset]] fork.
	(self class selector: testSelector) runCaseAsFailure: semaphore!

deny: aBoolean
	self assert: aBoolean not!

deny: aBoolean description: aStringOrValuable
	self assert: aBoolean not description: aStringOrValuable!

deny: aBoolean description: aStringOrValuable resumable: resumableBoolean
	self
		assert: aBoolean not
		description: aStringOrValuable
		resumable: resumableBoolean!

executeShould: aBlock inScopeOf: anExceptionalEvent
	^
	[aBlock value.
	false]
			on: anExceptionalEvent
			do: [:ex | true]
			on: TestResult error
			do: [:ex | false]!

fail: aString
	self logFailure: aString.
	TestResult failure signal: aString!

failureLog
	"dialect-specific"
	"VA - System errorLog"
	"VW, Dolphin - Transcript"
	
	^self subclassResponsibility
!

getDescription: aStringOrValuable
	^aStringOrValuable isString ifTrue: [aStringOrValuable] ifFalse: [aStringOrValuable value]!

isLogging
	^false!

logFailure: aString
	self isLogging ifTrue: [
		self failureLog 
			cr; 
			nextPutAll: aString; 
			flush]!

openDebuggerOnFailingTestMethod
	"SUnit has halted one step in front of the failing test method. Step over the 'self halt' and 
	 send into 'self perform: testSelector' to see the failure from the beginning"
	self
		halt;
		performTest!

performTest
	self perform: testSelector asSymbol!

printOn: aStream
	aStream
		nextPutAll: self class printString;
		nextPutAll: '>>';
		nextPutAll: testSelector!

removeDependentFromHierachy: anObject 
	"an empty method. for Composite compability with TestSuite"
!

resources
	| allResources resourceQueue |
	allResources := Set new.
	resourceQueue := OrderedCollection new.
	resourceQueue addAll: self class resources.
	[resourceQueue isEmpty] whileFalse: [
		| next |
		next := resourceQueue removeFirst.
		allResources add: next.
		resourceQueue addAll: next resources].
	^allResources!

run
	| result |
	result := TestResult new.
	self run: result.
	^result!

run: aResult
	aResult runCase: self!

runCase
	
	[self setUp.
	self performTest] ensure: [self tearDown]!

runCaseAsFailure: aSemaphore
	
	[self setUp.
	self openDebuggerOnFailingTestMethod] ensure: 
				[self tearDown.
				aSemaphore signal]!

selector
	^testSelector!

setTestSelector: aSymbol
	testSelector := aSymbol!

setUp!

should: aBlock
	self assert: aBlock value!

should: aBlock description: aStringOrValuable
	self assert: aBlock value description: aStringOrValuable!

should: aBlock raise: anExceptionalEvent 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)!

should: aBlock raise: anExceptionalEvent description: aStringOrValuable
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aStringOrValuable!

shouldnt: aBlock
	self deny: aBlock value!

shouldnt: aBlock description: aStringOrValuable
	self deny: aBlock value description: aStringOrValuable!

shouldnt: aBlock raise: anExceptionalEvent 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not!

shouldnt: aBlock raise: anExceptionalEvent description: aStringOrValuable
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not
		description: aStringOrValuable!

signalFailure: aString
	TestResult failure signal: aString!

skip
	"Don't run this test, and don't mark it as failure"

	TestSkip signal!

skip: aComment
	"Don't run this test, and don't mark it as failure"

	TestSkip signal: aComment!

tearDown! !
!TestCase categoriesForMethods!
addDependentToHierachy:!dependencies!public! !
assert:!asserting!public! !
assert:description:!asserting!public! !
assert:description:resumable:!asserting!public! !
assert:equals:!asserting!public! !
comparingStringBetween:and:!helpers!private! !
debug!public!running! !
debugAsFailure!public!running! !
deny:!asserting!public! !
deny:description:!asserting!public! !
deny:description:resumable:!asserting!public! !
executeShould:inScopeOf:!private!running! !
fail:!asserting!public! !
failureLog!accessing!public! !
getDescription:!helpers!private! !
isLogging!accessing!public! !
logFailure:!asserting!public! !
openDebuggerOnFailingTestMethod!public!running! !
performTest!private!running! !
printOn:!printing!public! !
removeDependentFromHierachy:!dependencies!public! !
resources!accessing!public! !
run!public!running! !
run:!public!running! !
runCase!public!running! !
runCaseAsFailure:!public!running! !
selector!accessing!public! !
setTestSelector:!initializing!private! !
setUp!public!running! !
should:!asserting!public! !
should:description:!asserting!public! !
should:raise:!asserting!public! !
should:raise:description:!asserting!public! !
shouldnt:!asserting!public! !
shouldnt:description:!asserting!public! !
shouldnt:raise:!asserting!public! !
shouldnt:raise:description:!asserting!public! !
signalFailure:!asserting!public! !
skip!asserting!public! !
skip:!asserting!public! !
tearDown!public!running! !
!

!TestCase class methodsFor!

allTestSelectors
	^self allSelectors
		select: [:each | (each beginsWith: 'test') and: [(each identityIncludes: $:) not]]!

buildSuite

	| suite |
	^self isAbstract 
		ifTrue: 
			[suite := TestSuite new.
			suite name: self name asString.
			self allSubclasses do: [:each | each isAbstract ifFalse: [suite addTest: each buildSuiteFromSelectors]].
			suite]
		ifFalse: [self buildSuiteFromSelectors]!

buildSuiteFromAllSelectors
	^self buildSuiteFromMethods: self allTestSelectors!

buildSuiteFromLocalSelectors
	^self buildSuiteFromMethods: self testSelectors!

buildSuiteFromMethods: testMethods 
	^testMethods asSortedCollection
		inject: ((TestSuite new)
				name: self name asString;
				yourself)
		into: 
			[:suite :selector | 
			suite
				addTest: (self selector: selector);
				yourself]!

buildSuiteFromSelectors
	^self shouldInheritSelectors
		ifTrue: [self buildSuiteFromAllSelectors]
		ifFalse: [self buildSuiteFromLocalSelectors]!

debug: aSymbol
	^(self selector: aSymbol) debug!

debugAsFailure: aSymbol
	^(self selector: aSymbol) debugAsFailure!

resources
	^#()!

run: aSymbol
	^(self selector: aSymbol) run!

selector: aSymbol
	^self new setTestSelector: aSymbol!

shouldInheritSelectors
	"answer true to inherit selectors from superclasses"

	^true!

suite
	^self buildSuite!

testSelectors
	^self selectors asSortedCollection asOrderedCollection
		select: [:each | (each beginsWith: 'test') and: [each numArgs isZero]]!

version
	^'3.1'! !
!TestCase class categoriesForMethods!
allTestSelectors!Accessing!public! !
buildSuite!Building Suites!public! !
buildSuiteFromAllSelectors!Building Suites!public! !
buildSuiteFromLocalSelectors!Building Suites!public! !
buildSuiteFromMethods:!Building Suites!public! !
buildSuiteFromSelectors!Building Suites!public! !
debug:!Instance Creation!public! !
debugAsFailure:!Instance Creation!public! !
resources!Accessing!public! !
run:!Instance Creation!public! !
selector:!Instance Creation!public! !
shouldInheritSelectors!public!Testing! !
suite!Instance Creation!public! !
testSelectors!Accessing!public! !
version!Accessing!public! !
!

