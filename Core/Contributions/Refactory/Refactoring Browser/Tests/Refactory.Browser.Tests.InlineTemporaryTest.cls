"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.InlineTemporaryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.InlineTemporaryTest guid: (Core.GUID fromString: '{241fc5f5-5254-43d6-a840-dcd08c4e6b21}')!
Refactory.Browser.Tests.InlineTemporaryTest comment: ''!
!Refactory.Browser.Tests.InlineTemporaryTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.InlineTemporaryTest methodsFor!

testInlineTemporary
	| refactoring |
	refactoring := InlineTemporaryRefactoring
				inline: (self convertInterval: (24 to: 72) for: (RefactoryTestDataApp sourceCodeAt: #inlineMethod))
				from: #inlineMethod
				in: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp')
				parseTreeFor: #inlineMethod)
		equals: (RBParser
				parseMethod: 'inlineMethod
										^self
													foo;
													inlineMethod;
													bar')!

testInlineTemporaryBadInterval
	self shouldFail: (InlineTemporaryRefactoring
				inline: (self convertInterval: (29 to: 100) for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				from: #moveDefinition
				in: RefactoryTestDataApp)!

testInlineTemporaryMutlipleAssignment
	self shouldFail: (InlineTemporaryRefactoring
				inline: (self convertInterval: (60 to: 83) for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				from: #moveDefinition
				in: RefactoryTestDataApp)!

testInlineTemporaryReadBeforeWritten
	self shouldFail: (InlineTemporaryRefactoring
				inline: (self convertInterval: (48 to: 56) for: (RefactoryTestDataApp sourceCodeAt: #inlineTemporary))
				from: #inlineTemporary
				in: RefactoryTestDataApp)! !
!Refactory.Browser.Tests.InlineTemporaryTest categoriesFor: #testInlineTemporary!public!tests! !
!Refactory.Browser.Tests.InlineTemporaryTest categoriesFor: #testInlineTemporaryBadInterval!public!tests! !
!Refactory.Browser.Tests.InlineTemporaryTest categoriesFor: #testInlineTemporaryMutlipleAssignment!public!tests! !
!Refactory.Browser.Tests.InlineTemporaryTest categoriesFor: #testInlineTemporaryReadBeforeWritten!public!tests! !

