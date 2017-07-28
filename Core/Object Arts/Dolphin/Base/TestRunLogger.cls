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

finishedCase: aTestCase result: aSymbol in: microsecondsInteger
	^self subclassResponsibility!

finishedCase: aTestCase runtime: anInteger
	^self subclassResponsibility!

finishedRun: aTestResult knownSlowTests: aCollection
	self subclassResponsibility!

slowTestThreshold
	"Answer the execution time threshold, in milliseconds, over which tests are reported as slow."

	^500!

startingCase: aTestCase
	"By default, do nothing"!

startingRun: aTestSuite
	^self subclassResponsibility! !
!TestRunLogger categoriesFor: #finishedCase:result:in:!private! !
!TestRunLogger categoriesFor: #finishedCase:runtime:!public! !
!TestRunLogger categoriesFor: #finishedRun:knownSlowTests:!helpers!public! !
!TestRunLogger categoriesFor: #slowTestThreshold!helpers!private! !
!TestRunLogger categoriesFor: #startingCase:!public! !
!TestRunLogger categoriesFor: #startingRun:!public! !

