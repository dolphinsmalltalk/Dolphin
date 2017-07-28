"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TestCaseResult
	instanceVariableNames: 'case status duration signal stacktrace'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestCaseResult guid: (GUID fromString: '{a233feef-eabb-4fa9-9cf3-09531d206233}')!
TestCaseResult comment: ''!
!TestCaseResult categoriesForClass!Kernel-Objects! !
!TestCaseResult methodsFor!

case
	^case!

duration
	"Answer the time the test took to run, in microseconds. If the test didn't pass, the value
	is undefined."

	^duration!

setCase: aTestCase duration: anInteger
	case := aTestCase.
	status := #passed.
	duration := anInteger!

setCase: aTestCase error: anException
	case := aTestCase.
	status := #error.
	signal := anException.
	stacktrace := anException stackTrace: 20.
	duration := 0!

setCase: aTestCase failure: aTestFailure
	case := aTestCase.
	status := #failed.
	signal := aTestFailure.
	stacktrace := aTestFailure stackTrace: 20.
	duration := 0!

signal
	"Answer the <Exception> signalled if the test failed or threw an error, or nil if the test
	passed."

	^signal!

stacktrace
	"Answer the stacktrace capture when the test failed/errored, or nil if the test passed."

	^stacktrace!

status
	^status! !
!TestCaseResult categoriesFor: #case!accessing!public! !
!TestCaseResult categoriesFor: #duration!accessing!public! !
!TestCaseResult categoriesFor: #setCase:duration:!accessing!initializing!private! !
!TestCaseResult categoriesFor: #setCase:error:!accessing!initializing!private! !
!TestCaseResult categoriesFor: #setCase:failure:!accessing!initializing!private! !
!TestCaseResult categoriesFor: #signal!accessing!public! !
!TestCaseResult categoriesFor: #stacktrace!accessing!public! !
!TestCaseResult categoriesFor: #status!accessing!public! !

!TestCaseResult class methodsFor!

case: aTestCase duration: anInteger
	^self new setCase: aTestCase duration: anInteger!

case: aTestCase error: anException
	^self new
		setCase: aTestCase error: anException!

case: aTestCase failure: anException
	^self new
		setCase: aTestCase failure: anException! !
!TestCaseResult class categoriesFor: #case:duration:!public! !
!TestCaseResult class categoriesFor: #case:error:!public! !
!TestCaseResult class categoriesFor: #case:failure:!public! !

