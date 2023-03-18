"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringBrowserTest
	subclass: #'Refactory.Browser.Tests.RefactoringManagerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RefactoringManagerTest guid: (Core.GUID fromString: '{1d4be8fc-d3e1-4c69-aa7d-6b289b8219cc}')!
Refactory.Browser.Tests.RefactoringManagerTest comment: ''!
!Refactory.Browser.Tests.RefactoringManagerTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RefactoringManagerTest methodsFor!

testPrintRefactoringManager
	Transcript
		show: RefactoringManager instance printString;
		cr;
		flush! !
!Refactory.Browser.Tests.RefactoringManagerTest categoriesForMethods!
testPrintRefactoringManager!public!tests! !
!

