"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #RefactoringBrowserTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
RefactoringBrowserTest guid: (GUID fromString: '{89b8c31b-39f7-49c7-bd85-3b0c202ccf98}')!
RefactoringBrowserTest isAbstract: true!
RefactoringBrowserTest comment: 'SUnitBrowser openOnTestCase: self'!
!RefactoringBrowserTest categoriesForClass!Refactory-Testing! !
!RefactoringBrowserTest methodsFor!

convertInterval: anInterval for: aString 
	| startOffset stopOffset index |
	startOffset := 0.
	index := 1.
	
	[index < (anInterval first + startOffset) 
		and: [index + startOffset <= aString size]] 
			whileTrue: 
				[(aString at: index + startOffset) == Character lf
					ifTrue: [startOffset := startOffset + 1]
					ifFalse: [index := index + 1]].
	stopOffset := startOffset.
	
	[index < (anInterval last + startOffset) 
		and: [index + stopOffset <= aString size]] 
			whileTrue: 
				[(aString at: index + stopOffset) == Character lf
					ifTrue: [stopOffset := stopOffset + 1]
					ifFalse: [index := index + 1]].
	^anInterval first + startOffset to: anInterval last + stopOffset!

executeRefactoring: aRefactoring 
	aRefactoring primitiveExecute.
	RBParser parseExpression: aRefactoring storeString!

objectClassVariable
	^Object classPool keys detect: [:each | true]!

proceedThroughWarning: aBlock 
	#rbFix. "Use ANSI standard #resume"
"	aBlock on: RefactoringWarning do: [:ex | ex proceed]"
	aBlock on: RefactoringWarning do: [:ex | ex resume]
! !
!RefactoringBrowserTest categoriesFor: #convertInterval:for:!private! !
!RefactoringBrowserTest categoriesFor: #executeRefactoring:!private! !
!RefactoringBrowserTest categoriesFor: #objectClassVariable!private! !
!RefactoringBrowserTest categoriesFor: #proceedThroughWarning:!private! !

!RefactoringBrowserTest class methodsFor!

shouldInheritSelectors
	"answer true to inherit selectors from superclasses"

	^false! !
!RefactoringBrowserTest class categoriesFor: #shouldInheritSelectors!public!Testing! !

