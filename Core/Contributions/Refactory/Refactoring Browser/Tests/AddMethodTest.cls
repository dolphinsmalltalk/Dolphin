"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #AddMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AddMethodTest guid: (GUID fromString: '{6d550761-f858-4c04-be63-5475fe34219a}')!

AddMethodTest comment: ''!

!AddMethodTest categoriesForClass!Refactory-Testing! !

!AddMethodTest methodsFor!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')!

testAddMethod
	| refactoring |
	refactoring := AddMethodRefactoring
				addMethod: 'printString1 ^super printString'
				toClass: BasicLintRuleTest
				inProtocols: #(#accessing).
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #BasicLintRuleTest) parseTreeFor: #printString1)
		equals: (RBParser parseMethod: 'printString1 ^super printString')!

testBadMethod
	self shouldFail: (AddMethodRefactoring 
				addMethod: 'asdf ^super ^printString'
				toClass: BasicLintRuleTest
				inProtocols: #(#accessing))!

testExistingSelector
	self shouldFail: (AddMethodRefactoring 
				addMethod: 'printString ^super printString'
				toClass: BasicLintRuleTest
				inProtocols: #(#accessing))!

testModelAddMethod
	| refactoring class |
	class := model metaclassNamed: #Bar.
	refactoring := AddMethodRefactoring
				model: model
				addMethod: 'printString1 ^super printString'
				toClass: class
				inProtocols: #(#accessing).
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #printString1)
		equals: (RBParser parseMethod: 'printString1 ^super printString')!

testModelExistingSelector
	| refactoring |
	refactoring := AddMethodRefactoring 
				model: model
				addMethod: 'classVarName1 ^super printString'
				toClass: (model classNamed: #Bar)
				inProtocols: #(#accessing).
	self shouldFail: refactoring!

testModelInheritedSelector
	| refactoring |
	refactoring := AddMethodRefactoring 
				model: model
				addMethod: 'printString ^super printString'
				toClass: (model classNamed: #Bar)
				inProtocols: #(#accessing).
	self shouldFail: refactoring! !

!AddMethodTest categoriesForMethods!
setUp!public!set up! !
testAddMethod!public!tests! !
testBadMethod!failure tests!public! !
testExistingSelector!failure tests!public! !
testModelAddMethod!public!tests! !
testModelExistingSelector!failure tests!public! !
testModelInheritedSelector!failure tests!public! !
!

