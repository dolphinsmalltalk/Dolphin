"Filed out from Dolphin Smalltalk 7"!

Core.Object subclass: #'XProgramming.SUnit.TestRunLogger'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
XProgramming.SUnit.TestRunLogger guid: (Core.GUID fromString: '{00fd980b-da74-44be-888f-6735ffb8e96b}')!
XProgramming.SUnit.TestRunLogger isNonInstantiable: true!
XProgramming.SUnit.TestRunLogger comment: ''!
!XProgramming.SUnit.TestRunLogger categoriesForClass!Kernel-Objects! !
!XProgramming.SUnit.TestRunLogger methodsFor!

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
!XProgramming.SUnit.TestRunLogger categoriesFor: #finishedCase:!logging!public! !
!XProgramming.SUnit.TestRunLogger categoriesFor: #finishedRun:knownSlowTests:!helpers!logging!public! !
!XProgramming.SUnit.TestRunLogger categoriesFor: #slowTestThreshold!helpers!private! !
!XProgramming.SUnit.TestRunLogger categoriesFor: #startingCase:!logging!public! !
!XProgramming.SUnit.TestRunLogger categoriesFor: #startingRun:!logging!public! !

