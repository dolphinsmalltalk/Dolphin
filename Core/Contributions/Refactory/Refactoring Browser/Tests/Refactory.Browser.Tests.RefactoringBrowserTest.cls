"Filed out from Dolphin Smalltalk"!

XProgramming.SUnit.TestCase
	subclass: #'Refactory.Browser.Tests.RefactoringBrowserTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Refactory.Browser.TestData private})
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
	#{UI.Keyboard} valueOrNil
		ifNotNil: 
			[:keyboard |
			keyboard default isShiftDown
				ifTrue: [#{Tools.RewriteChangesBrowser} value showOn: aRefactoring model changes]].
	[self parseExpression: aRefactoring storeString] on: Parser notificationClass
		do: [:ex | self fail: ex displayString]!

objectClassVariable
	^Object classPool keys detect: [:each | true]!

parseExpression: aString
	^Parser parseExpression: aString!

parseMethod: aString
	^RBParser parseMethod: aString!

parseMethod: aString in: aRBClass
	^Parser
		parseMethod: aString
		in: aRBClass! !
!Refactory.Browser.Tests.RefactoringBrowserTest categoriesForMethods!
convertInterval:for:!private! !
executeRefactoring:!private! !
objectClassVariable!private! !
parseExpression:!helpers!public! !
parseMethod:!helpers!public! !
parseMethod:in:!helpers!public! !
!

!Refactory.Browser.Tests.RefactoringBrowserTest class methodsFor!

shouldInheritSelectors
	"answer true to inherit selectors from superclasses"

	^false! !
!Refactory.Browser.Tests.RefactoringBrowserTest class categoriesForMethods!
shouldInheritSelectors!public!Testing! !
!

