"Filed out from Dolphin Smalltalk 7"!

RefactoringBrowserTest subclass: #RefactoringManagerTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RefactoringManagerTest guid: (GUID fromString: '{1d4be8fc-d3e1-4c69-aa7d-6b289b8219cc}')!
RefactoringManagerTest comment: ''!
!RefactoringManagerTest categoriesForClass!Refactory-Testing! !
!RefactoringManagerTest methodsFor!

testPrintRefactoringManager
	Transcript
		show: RefactoringManager instance printString;
		cr;
		flush! !
!RefactoringManagerTest categoriesFor: #testPrintRefactoringManager!public!tests! !

