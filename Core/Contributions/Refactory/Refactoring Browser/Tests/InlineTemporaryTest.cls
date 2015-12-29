"Filed out from Dolphin Smalltalk 2000 release 4.01"!

RefactoringTest subclass: #InlineTemporaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InlineTemporaryTest comment: ''!

InlineTemporaryTest guid: (GUID fromString: '{241FC5F5-5254-43D6-A840-DCD08C4E6B21}')!

!InlineTemporaryTest categoriesForClass!Refactory-Testing! !
!InlineTemporaryTest methodsFor!

testInlineTemporary
	| refactoring |
	refactoring := InlineTemporaryRefactoring 
				inline: (self convertInterval: (24 to: 72)
						for: (RefactoryTestDataApp sourceCodeAt: #inlineMethod))
				from: #inlineMethod
				in: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self 
		assert: ((refactoring model classNamed: #RefactoryTestDataApp) 
				parseTreeFor: #inlineMethod) = (RBParser 
							parseMethod: 'inlineMethod
										^self
													foo;
													inlineMethod;
													bar')!

testInlineTemporaryBadInterval
	self shouldFail: (InlineTemporaryRefactoring 
				inline: (self convertInterval: (29 to: 100)
						for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				from: #moveDefinition
				in: RefactoryTestDataApp)!

testInlineTemporaryMutlipleAssignment
	self shouldFail: (InlineTemporaryRefactoring 
				inline: (self convertInterval: (60 to: 83)
						for: (RefactoryTestDataApp sourceCodeAt: #moveDefinition))
				from: #moveDefinition
				in: RefactoryTestDataApp)!

testInlineTemporaryReadBeforeWritten
	self shouldFail: (InlineTemporaryRefactoring 
				inline: (self convertInterval: (48 to: 56)
						for: (RefactoryTestDataApp sourceCodeAt: #inlineTemporary))
				from: #inlineTemporary
				in: RefactoryTestDataApp)! !
!InlineTemporaryTest categoriesFor: #testInlineTemporary!public!tests! !
!InlineTemporaryTest categoriesFor: #testInlineTemporaryBadInterval!public!tests! !
!InlineTemporaryTest categoriesFor: #testInlineTemporaryMutlipleAssignment!public!tests! !
!InlineTemporaryTest categoriesFor: #testInlineTemporaryReadBeforeWritten!public!tests! !

