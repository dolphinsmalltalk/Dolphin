"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.InlineTemporaryRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.InlineTemporaryRefactoringTest guid: (Core.GUID fromString: '{241fc5f5-5254-43d6-a840-dcd08c4e6b21}')!

Refactory.Browser.Tests.InlineTemporaryRefactoringTest comment: ''!

!Refactory.Browser.Tests.InlineTemporaryRefactoringTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.InlineTemporaryRefactoringTest methodsFor!

testInlineTemporary
	| refactoring |
	refactoring := InlineTemporaryRefactoring
				inline: (self convertInterval: (24 to: 72) for: (RefactoryTestDataApp sourceCodeAt: #inlineMethod))
				from: #inlineMethod
				in: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classFor: RefactoryTestDataApp) parseTreeFor: #inlineMethod)
		equals: (self
				parseMethod: 'inlineMethod
										^self
													foo;
													inlineMethod;
													bar')!

testInlineTemporaryBadInterval
	self shouldFail: (InlineTemporaryRefactoring
				inline: (self convertInterval: (29 to: 100) for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				from: #moveDefinition
				in: RefactoryTestDataApp)
		withMessage: 'The selection does not appear to be an assignment'!

testInlineTemporaryMutlipleAssignment
	self shouldFail: (InlineTemporaryRefactoring
				inline: (self convertInterval: (60 to: 83) for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				from: #moveDefinition
				in: RefactoryTestDataApp)
		withMessage: 'There are multiple assignments to the variable'!

testInlineTemporaryReadBeforeWritten
	self shouldFail: (InlineTemporaryRefactoring
				inline: (self convertInterval: (48 to: 56) for: (RefactoryTestDataApp sourceCodeAt: #inlineTemporary))
				from: #inlineTemporary
				in: RefactoryTestDataApp)
		withMessage: 'The variable is possibly read before it is assigned'! !

!Refactory.Browser.Tests.InlineTemporaryRefactoringTest categoriesForMethods!
testInlineTemporary!public!tests! !
testInlineTemporaryBadInterval!public!tests! !
testInlineTemporaryMutlipleAssignment!public!tests! !
testInlineTemporaryReadBeforeWritten!public!tests! !
!

