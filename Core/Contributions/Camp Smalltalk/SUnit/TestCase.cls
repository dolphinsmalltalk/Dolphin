"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TestCase
	instanceVariableNames: 'testSelector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!TestCase categoriesFor: #addDependentToHierachy:!dependencies!public! !
!TestCase categoriesFor: #assert:!asserting!public! !
!TestCase categoriesFor: #assert:description:!asserting!public! !
!TestCase categoriesFor: #assert:description:resumable:!asserting!public! !
!TestCase categoriesFor: #assert:equals:!asserting!public! !
!TestCase categoriesFor: #comparingStringBetween:and:!helpers!private! !
!TestCase categoriesFor: #debug!public!running! !
!TestCase categoriesFor: #debugAsFailure!public!running! !
!TestCase categoriesFor: #deny:!asserting!public! !
!TestCase categoriesFor: #deny:description:!asserting!public! !
!TestCase categoriesFor: #deny:description:resumable:!asserting!public! !
!TestCase categoriesFor: #executeShould:inScopeOf:!private!running! !
!TestCase categoriesFor: #fail:!asserting!public! !
!TestCase categoriesFor: #failureLog!accessing!public! !
!TestCase categoriesFor: #getDescription:!helpers!private! !
!TestCase categoriesFor: #isLogging!accessing!public! !
!TestCase categoriesFor: #logFailure:!asserting!public! !
!TestCase categoriesFor: #openDebuggerOnFailingTestMethod!public!running! !
!TestCase categoriesFor: #performTest!private!running! !
!TestCase categoriesFor: #printOn:!printing!public! !
!TestCase categoriesFor: #removeDependentFromHierachy:!dependencies!public! !
!TestCase categoriesFor: #resources!accessing!public! !
!TestCase categoriesFor: #run!public!running! !
!TestCase categoriesFor: #run:!public!running! !
!TestCase categoriesFor: #runCase!public!running! !
!TestCase categoriesFor: #runCaseAsFailure:!public!running! !
!TestCase categoriesFor: #selector!accessing!public! !
!TestCase categoriesFor: #setTestSelector:!initializing!private! !
!TestCase categoriesFor: #setUp!public!running! !
!TestCase categoriesFor: #should:!asserting!public! !
!TestCase categoriesFor: #should:description:!asserting!public! !
!TestCase categoriesFor: #should:raise:!asserting!public! !
!TestCase categoriesFor: #should:raise:description:!asserting!public! !
!TestCase categoriesFor: #shouldnt:!asserting!public! !
!TestCase categoriesFor: #shouldnt:description:!asserting!public! !
!TestCase categoriesFor: #shouldnt:raise:!asserting!public! !
!TestCase categoriesFor: #shouldnt:raise:description:!asserting!public! !
!TestCase categoriesFor: #signalFailure:!asserting!public! !
!TestCase categoriesFor: #skip!asserting!public! !
!TestCase categoriesFor: #skip:!asserting!public! !
!TestCase categoriesFor: #tearDown!public!running! !

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
!TestCase class categoriesFor: #allTestSelectors!Accessing!public! !
!TestCase class categoriesFor: #buildSuite!Building Suites!public! !
!TestCase class categoriesFor: #buildSuiteFromAllSelectors!Building Suites!public! !
!TestCase class categoriesFor: #buildSuiteFromLocalSelectors!Building Suites!public! !
!TestCase class categoriesFor: #buildSuiteFromMethods:!Building Suites!public! !
!TestCase class categoriesFor: #buildSuiteFromSelectors!Building Suites!public! !
!TestCase class categoriesFor: #debug:!Instance Creation!public! !
!TestCase class categoriesFor: #debugAsFailure:!Instance Creation!public! !
!TestCase class categoriesFor: #resources!Accessing!public! !
!TestCase class categoriesFor: #run:!Instance Creation!public! !
!TestCase class categoriesFor: #selector:!Instance Creation!public! !
!TestCase class categoriesFor: #shouldInheritSelectors!public!Testing! !
!TestCase class categoriesFor: #suite!Instance Creation!public! !
!TestCase class categoriesFor: #testSelectors!Accessing!public! !
!TestCase class categoriesFor: #version!Accessing!public! !

