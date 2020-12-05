"Filed out from Dolphin Smalltalk 7"!

XProgramming.SUnit.TestCase subclass: #'Refactory.Browser.Tests.RefactoringBrowserTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RefactoringBrowserTest guid: (Core.GUID fromString: '{89b8c31b-39f7-49c7-bd85-3b0c202ccf98}')!
Refactory.Browser.Tests.RefactoringBrowserTest isNonInstantiable: true!
Refactory.Browser.Tests.RefactoringBrowserTest comment: 'SUnitBrowser openOnTestCase: self'!
!Refactory.Browser.Tests.RefactoringBrowserTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RefactoringBrowserTest methodsFor!

convertInterval: anInterval for: aString
	| startOffset stopOffset index |
	startOffset := 0.
	index := 1.
	[index < (anInterval first + startOffset) and: [index + startOffset <= aString size]] whileTrue: 
			[(aString at: index + startOffset) == Character lf
				ifTrue: [startOffset := startOffset + 1]
				ifFalse: [index := index + 1]].
	stopOffset := startOffset.
	[index < (anInterval last + startOffset) and: [index + stopOffset <= aString size]] whileTrue: 
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
	#rbFix.	"Use ANSI standard #resume"
	"	aBlock on: RefactoringWarning do: [:ex | ex proceed]"
	aBlock on: RefactoringWarning do: [:ex | ex resume]! !
!Refactory.Browser.Tests.RefactoringBrowserTest categoriesFor: #convertInterval:for:!private! !
!Refactory.Browser.Tests.RefactoringBrowserTest categoriesFor: #executeRefactoring:!private! !
!Refactory.Browser.Tests.RefactoringBrowserTest categoriesFor: #objectClassVariable!private! !
!Refactory.Browser.Tests.RefactoringBrowserTest categoriesFor: #proceedThroughWarning:!private! !

!Refactory.Browser.Tests.RefactoringBrowserTest class methodsFor!

shouldInheritSelectors
	"answer true to inherit selectors from superclasses"

	^false! !
!Refactory.Browser.Tests.RefactoringBrowserTest class categoriesFor: #shouldInheritSelectors!public!Testing! !

