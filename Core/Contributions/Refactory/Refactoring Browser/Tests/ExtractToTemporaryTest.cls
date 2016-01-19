"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #ExtractToTemporaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExtractToTemporaryTest guid: (GUID fromString: '{1E11F73F-781C-4123-B98B-51D3251E5AE5}')!
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

testNonExistantSelector
	self shouldFail: (ExtractToTemporaryRefactoring 
				extract: (14 to: 23)
				to: 'asdf'
				from: #checkClass1:
				in: RefactoryTestDataApp)! !
!ExtractToTemporaryTest categoriesFor: #testBadInterval!failure tests!public! !
!ExtractToTemporaryTest categoriesFor: #testBadName!failure tests!public! !
!ExtractToTemporaryTest categoriesFor: #testNonExistantSelector!failure tests!public! !

