"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'XProgramming.SUnit.TestCase'
	instanceVariableNames: 'testSelector'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XProgramming.SUnit.TestCase guid: (Core.GUID fromString: '{5e96793a-0810-11d4-a876-0050da643bf9}')!
XProgramming.SUnit.TestCase isNonInstantiable: true!
XProgramming.SUnit.TestCase comment: ''!
!XProgramming.SUnit.TestCase categoriesForClass!SUnit! !
!XProgramming.SUnit.TestCase methodsFor!

addDependentToHierachy: anObject 
	"an empty method. for Composite compability with TestSuite"
!

assert: aBoolean
	aBoolean ifFalse: [self signalFailure: 'Assertion failed']!

assert: aBoolean description: aStringOrValuable
	aBoolean ifFalse: [self fail: aStringOrValuable value]!

assert: aBoolean description: aStringOrValuable resumable: resumableBoolean
	aBoolean
		ifFalse: 
			[| exception description |
			description := aStringOrValuable value.
			self logFailure: description.
			exception := resumableBoolean ifTrue: [TestResult resumableFailure] ifFalse: [TestResult failure].
			exception signal: description]!

assert: actualObject equals: expectedObject
	expectedObject = actualObject
		ifFalse: [self fail: (self comparingStringBetween: expectedObject and: actualObject)].

	"
	(Smalltalk.DiffBrowser show: 'Vertical view') compare: actualObject fullPrintString id: 'Actual' and: expectedObject fullPrintString id: 'Expected'
	"
!

comparingStringBetween: expectedObject and: actualObject
	^(String writeStream: 128)
		nextPutAll: 'Expected: ';
		nextPutAll: (expectedObject printStringLimitedTo: 256);
		nextPutAll: ' Actual: ';
		nextPutAll: (actualObject printStringLimitedTo: 256);
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

fail: aString
	self logFailure: aString.
	TestResult failure signal: aString!

failureLog
	"dialect-specific"
	"VA - System errorLog"
	"VW, Dolphin - Transcript"
	
	^Transcript
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
	self perform: testSelector asSymbol!

printOn: aStream
	aStream
		print: self class;
		nextPutAll: '>>';
		print: testSelector!

removeDependentFromHierachy: anObject 
	"an empty method. for Composite compability with TestSuite"
!

resources
	| allResources resourceQueue |
	allResources := Set new.
	resourceQueue := OrderedCollection new.
	resourceQueue addAll: self class resources.
	[resourceQueue isEmpty] whileFalse: 
			[| next |
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
	
	[#todo.	"Modified to replace original separate statements with a cascade to workaround compiler/debugger bug mapping from release to debug IP if halt inside the setUp method"
	self
		setUp;
		performTest]
			ensure: [self tearDown]!

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

should: aNiladicValuable
	self assert: aNiladicValuable value!

should: aNiladicValuable description: aStringOrValuable
	self assert: aNiladicValuable value description: aStringOrValuable!

should: aNiladicValuable raise: anExceptionSelector
	self
		should: aNiladicValuable
		raise: anExceptionSelector
		description: ['Expected <1p>' << anExceptionSelector]!

should: aNiladicValuable raise: anExceptionSelector description: aStringOrValuable
	"If the code completes without the expected error (or any other) assert. If any other error occurs, let it pass to outer handlers (or likely go unhandled) so that the error stack is preserved for debugging, or to allow nesting of should/shouldnt:raise:. In the original implementation other errors would also cause an assertion failure, losing crucial information for debugging and preventing nesting."

	^self assert: (
			[aNiladicValuable value.
			false] on: anExceptionSelector do: [:ex | true])
		description: aStringOrValuable!

shouldnt: aNiladicValuable
	self deny: aNiladicValuable value!

shouldnt: aNiladicValuable description: aStringOrValuable
	self deny: aNiladicValuable value description: aStringOrValuable!

shouldnt: aNiladicValuable raise: anExceptionSelector
	self
		shouldnt: aNiladicValuable
		raise: anExceptionSelector
		description: 'Unexpected exception: <1p>'!

shouldnt: aNiladicValuable raise: anExceptionSelector description: aStringOrValuable
	[aNiladicValuable value]
		on: anExceptionSelector
		do: 
			[:ex |
			"In the original SUnit implementation the exception info was lost because the code asserted after completion of the handler block. By asserting from the handler, we preserve the original exception info on the stack for debugging purposes."
			self fail: aStringOrValuable value << ex]
		on: Error
		do: 
			[:ex |
			"Historically other errors have been suppressed. This doesn't seem right (hey, I don't want this particular error, but any other is fine?), but would be a breaking change to fix."
			]!

signalFailure: aString
	TestResult failure signal: aString!

skip
	"Don't run this test, and don't mark it as failure"

	TestSkip signal!

skip: aComment
	"Don't run this test, and don't mark it as failure"

	TestSkip signal: aComment!

tearDown! !
!XProgramming.SUnit.TestCase categoriesForMethods!
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
fail:!asserting!public! !
failureLog!Accessing!public! !
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

!XProgramming.SUnit.TestCase class methodsFor!

allTestSelectors
	^self allSelectors select: [:each | self isTestSelector: each]!

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
	| suite |
	suite := TestSuite new.
	testMethods asSortedArray do: [:selector | suite addTest: (self selector: selector)].
	suite name: (suite tests size = 1 ifTrue: [suite tests first printString] ifFalse: [self fullName]).
	^suite!

buildSuiteFromSelectors
	^self shouldInheritSelectors
		ifTrue: [self buildSuiteFromAllSelectors]
		ifFalse: [self buildSuiteFromLocalSelectors]!

debug: aSymbol
	^(self selector: aSymbol) debug!

debugAsFailure: aSymbol
	^(self selector: aSymbol) debugAsFailure!

isTestMethod: aCompiledMethod
	^(aCompiledMethod methodClass inheritsFrom: self) and: [self isTestSelector: aCompiledMethod selector]!

isTestSelector: aSymbol
	^(aSymbol beginsWith: 'test') and: [(aSymbol identityIncludes: $:) not]!

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
	^self selectors asSortedArray select: [:each | (each beginsWith: 'test') and: [each numArgs isZero]]!

version
	^'3.1'! !
!XProgramming.SUnit.TestCase class categoriesForMethods!
allTestSelectors!Accessing!public! !
buildSuite!Building Suites!public! !
buildSuiteFromAllSelectors!Building Suites!public! !
buildSuiteFromLocalSelectors!Building Suites!public! !
buildSuiteFromMethods:!Building Suites!public! !
buildSuiteFromSelectors!Building Suites!public! !
debug:!Instance Creation!public! !
debugAsFailure:!Instance Creation!public! !
isTestMethod:!enquiries!public! !
isTestSelector:!enquiries!public! !
resources!Accessing!public! !
run:!Instance Creation!public! !
selector:!Instance Creation!public! !
shouldInheritSelectors!public!Testing! !
suite!Instance Creation!public! !
testSelectors!Accessing!public! !
version!Accessing!public! !
!

