"Filed out from Dolphin Smalltalk"!

Object subclass: #TestRunLogger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

TestRunLogger guid: (GUID fromString: '{00fd980b-da74-44be-888f-6735ffb8e96b}')!

TestRunLogger isAbstract: true!

TestRunLogger comment: ''!

!TestRunLogger categoriesForClass!Kernel-Objects! !

!TestRunLogger methodsFor!

finishedCase: aSymbol
	^self subclassResponsibility!

finishedRun: aTestResult knownSlowTests: aCollection
	self subclassResponsibility!

slowTestThreshold
	"Answer a <Duration> which is the execution time threshold over which tests should be reported as slow."

	^500 milliseconds!

startingCase: aTestCase
	"By default, do nothing"!

startingRun: aTestSuite
! !

!TestRunLogger categoriesForMethods!
finishedCase:!logging!public! !
finishedRun:knownSlowTests:!helpers!logging!public! !
slowTestThreshold!helpers!private! !
startingCase:!logging!public! !
startingRun:!logging!public! !
!

