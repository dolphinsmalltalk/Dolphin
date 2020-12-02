"Filed out from Dolphin Smalltalk 7"!

Object subclass: #TestRunLogger
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!TestRunLogger categoriesFor: #finishedCase:!logging!public! !
!TestRunLogger categoriesFor: #finishedRun:knownSlowTests:!helpers!logging!public! !
!TestRunLogger categoriesFor: #slowTestThreshold!helpers!private! !
!TestRunLogger categoriesFor: #startingCase:!logging!public! !
!TestRunLogger categoriesFor: #startingRun:!logging!public! !

