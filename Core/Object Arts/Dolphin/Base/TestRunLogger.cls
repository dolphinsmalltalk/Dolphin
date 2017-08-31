"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TestRunLogger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TestRunLogger guid: (GUID fromString: '{00fd980b-da74-44be-888f-6735ffb8e96b}')!
TestRunLogger comment: ''!
!TestRunLogger categoriesForClass!Kernel-Objects! !
!TestRunLogger methodsFor!

finishedCase: aSymbol
	^self subclassResponsibility!

finishedRun: aTestResult knownSlowTests: aCollection
	self subclassResponsibility!

slowTestThreshold
	"Answer the execution time threshold, in milliseconds, over which tests are reported as slow."

	^500!

startingCase: aTestCase
	"By default, do nothing"!

startingRun: aTestSuite
! !
!TestRunLogger categoriesFor: #finishedCase:!logging!public! !
!TestRunLogger categoriesFor: #finishedRun:knownSlowTests:!helpers!logging!public! !
!TestRunLogger categoriesFor: #slowTestThreshold!helpers!private! !
!TestRunLogger categoriesFor: #startingCase:!logging!public! !
!TestRunLogger categoriesFor: #startingRun:!logging!public! !

!TestRunLogger class methodsFor!

printDuration: microsecondsInteger on: aPuttableStream
	| mS |
	mS := microsecondsInteger / 1000.0.
	mS < 1000.0
		ifTrue: 
			[mS printOn: aPuttableStream decimalPlaces: (mS < 1.0 ifTrue: [3] ifFalse: [0]).
			aPuttableStream nextPutAll: ' mS']
		ifFalse: 
			[| secs |
			secs := mS / 1000.0.
			secs printOn: aPuttableStream decimalPlaces: (secs < 10.0 ifTrue: [1] ifFalse: [0]).
			aPuttableStream nextPutAll: ' s']! !
!TestRunLogger class categoriesFor: #printDuration:on:!helpers!private! !

