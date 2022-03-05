"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #InlineTemporaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InlineTemporaryTest guid: (GUID fromString: '{241fc5f5-5254-43d6-a840-dcd08c4e6b21}')!
InlineTemporaryTest comment: ''!
!InlineTemporaryTest categoriesForClass!Refactory-Testing! !
!InlineTemporaryTest methodsFor!

testInlineTemporary
	| refactoring |
	refactoring := InlineTemporaryRefactoring
				inline: (self convertInterval: (24 to: 72) for: (RefactoryTestDataApp sourceCodeAt: #inlineMethod))
				from: #inlineMethod
				in: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #RefactoryTestDataApp) parseTreeFor: #inlineMethod)
		equals: (RBParser
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
!InlineTemporaryTest categoriesForMethods!
testInlineTemporary!public!tests! !
testInlineTemporaryBadInterval!public!tests! !
testInlineTemporaryMutlipleAssignment!public!tests! !
testInlineTemporaryReadBeforeWritten!public!tests! !
!

