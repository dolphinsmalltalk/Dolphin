"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #ExtractToTemporaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExtractToTemporaryTest guid: (GUID fromString: '{1e11f73f-781c-4123-b98b-51d3251e5ae5}')!

ExtractToTemporaryTest comment: ''!

!ExtractToTemporaryTest categoriesForClass!Refactory-Testing! !

!ExtractToTemporaryTest methodsFor!

testBadInterval
	self
		shouldFail: (ExtractToTemporaryRefactoring 
					extract: (self convertInterval: (24 to: 30)
							for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					to: 'asdf'
					from: #testMethod
					in: RefactoryTestDataApp);
		shouldFail: (ExtractToTemporaryRefactoring 
					extract: (self convertInterval: (14 to: 105)
							for: (RefactoryTestDataApp sourceCodeAt: #testMethod1))
					to: 'asdf'
					from: #testMethod1
					in: RefactoryTestDataApp);
		shouldFail: (ExtractToTemporaryRefactoring 
					extract: (self convertInterval: (61 to: 101)
							for: (RefactoryTestDataApp sourceCodeAt: #noMoveDefinition))
					to: 'asdf'
					from: #noMoveDefinition
					in: RefactoryTestDataApp)!

testBadName
	self shouldFail: (ExtractToTemporaryRefactoring 
				extract: (self convertInterval: (14 to: 23)
						for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
				to: 'a sdf'
				from: #testMethod
				in: RefactoryTestDataApp)!

testExtractToTemporaryForLastStatementInBlock
	| refactoring |
	refactoring := ExtractToTemporaryRefactoring
				extract: (self convertInterval: (52 to: 73) for: (RefactoryTestDataApp sourceCodeAt: #caller2))
				to: 'temp'
				from: #caller2
				in: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #RefactoryTestDataApp) parseTreeFor: #caller2)
		equals: (RBParser
				parseMethod: 'caller2
	^(1 to: 10) inject: 1 into: [:sum :each | | temp | temp := sum * (self foo: each). temp]')!

testExtractToTemporaryInsideBlock
	| refactoring |
	refactoring := ExtractToTemporaryRefactoring
				extract: (self convertInterval: (133 to: 141)
						for: (RefactoryTestDataApp sourceCodeAt: #noMoveDefinition))
				to: 'asdf'
				from: #noMoveDefinition
				in: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #RefactoryTestDataApp) parseTreeFor: #noMoveDefinition)
		equals: (RBParser
				parseMethod: 'noMoveDefinition
	| temp |
	^(self collect: 
			[:each | 
			temp := each printString.
			temp , temp]) 
		select: [:each | | asdf | asdf := each size. temp := asdf + temp]')!

testNonExistantSelector
	self shouldFail: (ExtractToTemporaryRefactoring 
				extract: (14 to: 23)
				to: 'asdf'
				from: #checkClass1:
				in: RefactoryTestDataApp)! !

!ExtractToTemporaryTest categoriesForMethods!
testBadInterval!failure tests!public! !
testBadName!failure tests!public! !
testExtractToTemporaryForLastStatementInBlock!public!tests! !
testExtractToTemporaryInsideBlock!public!tests! !
testNonExistantSelector!failure tests!public! !
!

