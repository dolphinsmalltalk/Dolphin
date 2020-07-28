"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TestCaseResult
	instanceVariableNames: 'case outcome duration signal stacktrace ip testMethod'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
TestCaseResult guid: (GUID fromString: '{a233feef-eabb-4fa9-9cf3-09531d206233}')!
TestCaseResult comment: 'Represents the results of executing an individual <TestCase>'!
!TestCaseResult categoriesForClass!SUnit! !
!TestCaseResult methodsFor!

captureDiagnostics: anException
	| frame stackStream |
	stackStream := String smalltalkWriteStream: 512.
	frame := anException raisingFrame.
	ip := nil.
	
	[frame callstackDo: 
			[:each |
			"Assume the first TestCase sub-class method is the source of the failure"
			(ip isNil and: 
					[| methodClass |
					methodClass := each method methodClass.
					methodClass ~~ TestCase and: [methodClass inheritsFrom: TestCase]])
				ifTrue: 
					[testMethod := each method.
					ip := each prevIP].
			stackStream
				display: each;
				cr]
		depth: -1]
			on: Error
			do: [:e | e notify].
	stacktrace := stackStream contents!

case
	"Answer the <TestCase> instance for which this object records results."

	^case!

diagnostic
	"Answer the diagnostic information <String> for the receiver. This includes at least the stacktrace captured when the test failed. It may also include the IP of the assertion and the source of that assertion if these are relevant and available."

	| stream |
	stream := String writeStream: 512.
	self printSourceOn: stream.
	stream nextPutAll: self stacktrace.
	^stream contents!

displayOn: aPuttableStream
	aPuttableStream
		print: self case;
		nextPutAll: ' (';
		nextPutAll: self outcome;
		nextPutAll: ' in '.
	self outcome == #passed
		ifTrue: 
			[self duration printHumanReadableOn: aPuttableStream.
			aPuttableStream nextPut: $)]
		ifFalse: 
			[self printSourceOn: aPuttableStream.
			aPuttableStream nextPut: $)]!

duration
	"Answer the <Duration> of the test execution. If the test didn't pass, the value is undefined."

	^duration!

outcome
	"Answer the outcome of the testcase - one of #passed, #failed, #error, #skipped."

	^outcome!

printSourceOn: aStream
	| map entry range source |
	testMethod ifNil: [^self].
	map := testMethod textMap.
	entry := map at: (StackFrame findIP: ip inTextMap: map).
	range := entry value.
	range isEmpty ifTrue: [range := range start to: range start].
	source := testMethod getSource.
	range := range intersection: (1 to: source size).
	source := source copyFrom: range first to: range last.
	aStream
		print: testMethod;
		nextPut: $@;
		print: entry key;
		nextPutAll: ': `';
		display: source;
		nextPut: $`;
		cr;
		cr!

setCase: aTestCase duration: aDuration
	case := aTestCase.
	outcome := #passed.
	duration := aDuration!

setCase: aTestCase outcome: aSymbol signal: anException
	case := aTestCase.
	outcome := aSymbol.
	signal := anException.
	duration := 0 seconds.
	self captureDiagnostics: anException!

signal
	"Answer the <Exception> signalled if the test failed or threw an error, or nil if the test
	passed."

	^signal!

stacktrace
	"Answer the stacktrace capture when the test failed/errored, or nil if the test passed."

	^stacktrace! !
!TestCaseResult categoriesFor: #captureDiagnostics:!initializing!private! !
!TestCaseResult categoriesFor: #case!accessing!public! !
!TestCaseResult categoriesFor: #diagnostic!accessing!public! !
!TestCaseResult categoriesFor: #displayOn:!displaying!public! !
!TestCaseResult categoriesFor: #duration!accessing!public! !
!TestCaseResult categoriesFor: #outcome!accessing!public! !
!TestCaseResult categoriesFor: #printSourceOn:!printing!private! !
!TestCaseResult categoriesFor: #setCase:duration:!initializing!private! !
!TestCaseResult categoriesFor: #setCase:outcome:signal:!initializing!private! !
!TestCaseResult categoriesFor: #signal!accessing!public! !
!TestCaseResult categoriesFor: #stacktrace!accessing!public! !

!TestCaseResult class methodsFor!

case: aTestCase duration: anInteger
	^self new setCase: aTestCase duration: anInteger!

case: aTestCase error: anException
	^self new
		setCase: aTestCase
		outcome: #error
		signal: anException!

case: aTestCase failure: aTestFailure
	^self new
		setCase: aTestCase
		outcome: #failed
		signal: aTestFailure!

case: aTestCase skipped: aTestSkip
	^self new
		setCase: aTestCase
		outcome: #skipped
		signal: aTestSkip! !
!TestCaseResult class categoriesFor: #case:duration:!instance creation!public! !
!TestCaseResult class categoriesFor: #case:error:!instance creation!public! !
!TestCaseResult class categoriesFor: #case:failure:!instance creation!public! !
!TestCaseResult class categoriesFor: #case:skipped:!instance creation!public! !

