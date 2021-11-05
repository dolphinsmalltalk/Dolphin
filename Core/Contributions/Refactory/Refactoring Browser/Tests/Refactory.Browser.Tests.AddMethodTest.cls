"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.AddMethodTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddMethodTest guid: (Core.GUID fromString: '{6d550761-f858-4c04-be63-5475fe34219a}')!
Refactory.Browser.Tests.AddMethodTest comment: ''!
!Refactory.Browser.Tests.AddMethodTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AddMethodTest methodsFor!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')!

testAddMethod
	| refactoring |
	refactoring := AddMethodRefactoring
				addMethod: 'printString1 ^super printString'
				toClass: BasicLintRuleTestData
				inProtocols: #(#accessing).
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.BasicLintRuleTestData')
				parseTreeFor: #printString1)
		equals: (self parseMethod: 'printString1 ^super printString')!

testBadMethod
	self shouldFail: (AddMethodRefactoring
				addMethod: 'asdf ^super ^printString'
				toClass: BasicLintRuleTestData
				inProtocols: #(#accessing))!

testExistingSelector
	self shouldFail: (AddMethodRefactoring
				addMethod: 'printString ^super printString'
				toClass: BasicLintRuleTestData
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
		equals: (self parseMethod: 'printString1 ^super printString')!

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
!Refactory.Browser.Tests.AddMethodTest categoriesForMethods!
setUp!public!set up! !
testAddMethod!public!tests! !
testBadMethod!failure tests!public! !
testExistingSelector!failure tests!public! !
testModelAddMethod!public!tests! !
testModelExistingSelector!failure tests!public! !
testModelInheritedSelector!failure tests!public! !
!

