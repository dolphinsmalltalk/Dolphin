"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'XProgramming.SUnit.TestRunLogger'
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

finishedRun: aTestResult
	self subclassResponsibility!

initializedResource: aTestResource in: aDuration
	!

initializingResouce: aTestResource
!

notify: aNotification
!

slowTestThreshold
	"Answer a <Duration> which is the execution time threshold over which tests should be reported as slow."

	^500 milliseconds!

startingCase: aTestCase
	"By default, do nothing"!

startingRun: aTestSuite
! !
!XProgramming.SUnit.TestRunLogger categoriesForMethods!
finishedCase:!logging!public! !
finishedRun:!helpers!logging!public! !
initializedResource:in:!logging!public! !
initializingResouce:!logging!public! !
notify:!logging!public! !
slowTestThreshold!helpers!private! !
startingCase:!logging!public! !
startingRun:!logging!public! !
!

