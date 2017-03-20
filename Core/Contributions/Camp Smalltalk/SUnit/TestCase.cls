"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TestCase
	instanceVariableNames: 'testSelector'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestCase guid: (GUID fromString: '{5e96793a-0810-11d4-a876-0050da643bf9}')!
TestCase comment: ''!
!TestCase categoriesForClass!SUnit! !
!TestCase methodsFor!

addDependentToHierachy: anObject 
	"an empty method. for Composite compability with TestSuite"
!

assert: aBoolean
	aBoolean ifFalse: [self signalFailure: 'Assertion failed']!

assert: aBoolean description: aString
	aBoolean ifFalse: [self fail: aString]!

assert: aBoolean description: aString resumable: resumableBoolean 

	aBoolean ifFalse: [
		| exception |
		self logFailure: aString.
		exception := resumableBoolean
			ifTrue: [TestResult resumableFailure]
			ifFalse: [TestResult failure].
		exception sunitSignalWith: aString]!

assert: expectedObject equals: actualObject
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
	[(self class selector: testSelector) runCase] 
		sunitEnsure: [self resources do: [:each | each reset]]!

debugAsFailure
	| semaphore |
	semaphore := Semaphore new.
	self resources do: [:res | res isAvailable ifFalse: [^res signalInitializationError]].
	
	[semaphore wait.
	self resources do: [:each | each reset]] fork.
	(self class selector: testSelector) runCaseAsFailure: semaphore!

deny: aBoolean
	self assert: aBoolean not!

deny: aBoolean description: aString
	self assert: aBoolean not description: aString!

deny: aBoolean description: aString resumable: resumableBoolean
	self 
		assert: aBoolean not
		description: aString
		resumable: resumableBoolean!

executeShould: aBlock inScopeOf: anExceptionalEvent 
	[[aBlock value]
		sunitOn: anExceptionalEvent
		do: [:ex | ^true]]
			sunitOn: TestResult error
			do: [:ex | ^false].
	^false.!

fail: aString
	self logFailure: aString.
	TestResult failure sunitSignalWith: aString!

failureLog
	"dialect-specific"
	"VA - System errorLog"
	"VW, Dolphin - Transcript"
	
	^self subclassResponsibility
!

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
	self perform: testSelector sunitAsSymbol!

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
	self performTest] sunitEnsure: [self tearDown]!

runCaseAsFailure: aSemaphore
	[self setUp.
	self openDebuggerOnFailingTestMethod] sunitEnsure: [
		self tearDown.
		aSemaphore signal]!

selector
	^testSelector!

setTestSelector: aSymbol
	testSelector := aSymbol!

setUp!

should: aBlock
	self assert: aBlock value!

should: aBlock description: aString
	self assert: aBlock value description: aString!

should: aBlock raise: anExceptionalEvent 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)!

should: aBlock raise: anExceptionalEvent description: aString 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent)
		description: aString!

shouldnt: aBlock
	self deny: aBlock value!

shouldnt: aBlock description: aString
	self deny: aBlock value description: aString!

shouldnt: aBlock raise: anExceptionalEvent 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not!

shouldnt: aBlock raise: anExceptionalEvent description: aString 
	^self assert: (self executeShould: aBlock inScopeOf: anExceptionalEvent) not 		description: aString!

signalFailure: aString
	TestResult failure sunitSignalWith: aString!

tearDown! !
!TestCase categoriesFor: #addDependentToHierachy:!Dependencies!public! !
!TestCase categoriesFor: #assert:!Accessing!public! !
!TestCase categoriesFor: #assert:description:!Accessing!public! !
!TestCase categoriesFor: #assert:description:resumable:!Accessing!public! !
!TestCase categoriesFor: #assert:equals:!converting!public! !
!TestCase categoriesFor: #comparingStringBetween:and:!converting!public! !
!TestCase categoriesFor: #debug!public!Running! !
!TestCase categoriesFor: #debugAsFailure!public!Running! !
!TestCase categoriesFor: #deny:!Accessing!public! !
!TestCase categoriesFor: #deny:description:!Accessing!public! !
!TestCase categoriesFor: #deny:description:resumable:!Accessing!public! !
!TestCase categoriesFor: #executeShould:inScopeOf:!helpers!private! !
!TestCase categoriesFor: #fail:!accessing!public! !
!TestCase categoriesFor: #failureLog!Accessing!public! !
!TestCase categoriesFor: #isLogging!Accessing!public! !
!TestCase categoriesFor: #logFailure:!Accessing!public! !
!TestCase categoriesFor: #openDebuggerOnFailingTestMethod!public!Running! !
!TestCase categoriesFor: #performTest!helpers!private! !
!TestCase categoriesFor: #printOn:!Printing!public! !
!TestCase categoriesFor: #removeDependentFromHierachy:!Dependencies!public! !
!TestCase categoriesFor: #resources!Accessing!public! !
!TestCase categoriesFor: #run!public!Running! !
!TestCase categoriesFor: #run:!public!Running! !
!TestCase categoriesFor: #runCase!public!Running! !
!TestCase categoriesFor: #runCaseAsFailure:!public!Running! !
!TestCase categoriesFor: #selector!Accessing!public! !
!TestCase categoriesFor: #setTestSelector:!helpers!private! !
!TestCase categoriesFor: #setUp!public!Running! !
!TestCase categoriesFor: #should:!Accessing!public! !
!TestCase categoriesFor: #should:description:!Accessing!public! !
!TestCase categoriesFor: #should:raise:!Accessing!public! !
!TestCase categoriesFor: #should:raise:description:!Accessing!public! !
!TestCase categoriesFor: #shouldnt:!Accessing!public! !
!TestCase categoriesFor: #shouldnt:description:!Accessing!public! !
!TestCase categoriesFor: #shouldnt:raise:!Accessing!public! !
!TestCase categoriesFor: #shouldnt:raise:description:!Accessing!public! !
!TestCase categoriesFor: #signalFailure:!Accessing!public! !
!TestCase categoriesFor: #tearDown!public!Running! !

!TestCase class methodsFor!

allTestSelectors
	^self sunitAllSelectors select: [:each | 'test*' sunitMatch: each]!

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
	^testMethods 
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

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"
	^self name = #TestCase.!

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
	^self sunitSelectors select: [:each | 'test*' sunitMatch: each]!

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
!TestCase class categoriesFor: #isAbstract!public!Testing! !
!TestCase class categoriesFor: #resources!Accessing!public! !
!TestCase class categoriesFor: #run:!Instance Creation!public! !
!TestCase class categoriesFor: #selector:!Instance Creation!public! !
!TestCase class categoriesFor: #shouldInheritSelectors!public!Testing! !
!TestCase class categoriesFor: #suite!Instance Creation!public! !
!TestCase class categoriesFor: #testSelectors!Accessing!public! !
!TestCase class categoriesFor: #version!Accessing!public! !

