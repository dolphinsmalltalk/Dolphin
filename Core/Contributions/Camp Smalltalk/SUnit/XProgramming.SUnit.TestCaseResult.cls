"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'XProgramming.SUnit.TestCaseResult'
	instanceVariableNames: 'case outcome duration signal stacktrace ip testMethod'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XProgramming.SUnit.TestCaseResult guid: (Core.GUID fromString: '{a233feef-eabb-4fa9-9cf3-09531d206233}')!
XProgramming.SUnit.TestCaseResult comment: 'Represents the results of executing an individual <TestCase>'!
!XProgramming.SUnit.TestCaseResult categoriesForClass!SUnit! !
!XProgramming.SUnit.TestCaseResult methodsFor!

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
	entry := map at: (Kernel.StackFrame findIP: ip inTextMap: map).
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

setCase: aTestCase outcome: aSymbol signal: anException after: aDuration
	case := aTestCase.
	outcome := aSymbol.
	signal := anException.
	duration := aDuration.
	self captureDiagnostics: anException!

signal
	"Answer the <Exception> signalled if the test failed or threw an error, or nil if the test
	passed."

	^signal!

stacktrace
	"Answer the stacktrace capture when the test failed/errored, or nil if the test passed."

	^stacktrace! !
!XProgramming.SUnit.TestCaseResult categoriesForMethods!
captureDiagnostics:!initializing!private! !
case!accessing!public! !
diagnostic!accessing!public! !
displayOn:!printing!private! !
duration!accessing!public! !
outcome!accessing!public! !
printSourceOn:!printing!private! !
setCase:duration:!initializing!private! !
setCase:outcome:signal:after:!initializing!private! !
signal!accessing!public! !
stacktrace!accessing!public! !
!

!XProgramming.SUnit.TestCaseResult class methodsFor!

case: aTestCase duration: anInteger
	^self new setCase: aTestCase duration: anInteger!

case: aTestCase error: anException after: aDuration
	^self new
		setCase: aTestCase
		outcome: #error
		signal: anException
		after: aDuration!

case: aTestCase failure: aTestFailure after: aDuration
	^self new
		setCase: aTestCase
		outcome: #failed
		signal: aTestFailure
		after: aDuration!

case: aTestCase skipped: aTestSkip
	^self new
		setCase: aTestCase
		outcome: #skipped
		signal: aTestSkip
		after: 0 seconds! !
!XProgramming.SUnit.TestCaseResult class categoriesForMethods!
case:duration:!instance creation!public! !
case:error:after:!instance creation!public! !
case:failure:after:!instance creation!public! !
case:skipped:!instance creation!public! !
!

