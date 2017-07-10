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

finishedRun: aTestResult in: anInteger knownSlowTests: aCollection
	self subclassResponsibility!

startingCase: aTestCase
	"By default, do nothing"!

startingRun: aTestSuite
	^self subclassResponsibility! !
!TestRunLogger categoriesFor: #finishedCase:result:in:!private! !
!TestRunLogger categoriesFor: #finishedCase:runtime:!public! !
!TestRunLogger categoriesFor: #finishedRun:in:knownSlowTests:!helpers!public! !
!TestRunLogger categoriesFor: #startingCase:!public! !
!TestRunLogger categoriesFor: #startingRun:!public! !

