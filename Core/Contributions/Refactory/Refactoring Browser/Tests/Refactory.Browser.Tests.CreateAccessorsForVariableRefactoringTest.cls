"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.CreateAccessorsForVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.CreateAccessorsForVariableRefactoringTest guid: (Core.GUID fromString: '{cf036663-3be7-40e4-9e4f-c090ff6abb4b}')!
Refactory.Browser.Tests.CreateAccessorsForVariableRefactoringTest comment: ''!
!Refactory.Browser.Tests.CreateAccessorsForVariableRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.CreateAccessorsForVariableRefactoringTest methodsFor!

testExistingInstanceVariableAccessors
	| ref |
	ref := CreateAccessorsForVariableRefactoring
				variable: 'name'
				class: LintRuleTestData
				classVariable: false.
	self executeRefactoring: ref.
	self assert: ref changes changes isEmpty.
	self assert: ref setterMethod identicalTo: #name:.
	self assert: ref getterMethod identicalTo: #name!

testNewClassVariableAccessors
	| ref class |
	ref := CreateAccessorsForVariableRefactoring
				variable: 'Foo1'
				class: LintRuleTestData
				classVariable: true.
	self executeRefactoring: ref.
	class := ref model metaclassNamed: #'Refactory.Browser.TestData.LintRuleTestData'.
	self deny: ref changes changes isEmpty.
	self assert: ref setterMethod identicalTo: #foo1:.
	self assert: ref getterMethod identicalTo: #foo1.
	self assert: (class parseTreeFor: #foo1) equals: (self parseMethod: 'foo1 ^Foo1').
	self assert: (class parseTreeFor: #foo1:)
		equals: (self parseMethod: 'foo1: anObject Foo1 := anObject')!

testNewInstanceVariableAccessors
	| ref class |
	ref := CreateAccessorsForVariableRefactoring
				variable: 'foo1'
				class: LintRuleTestData
				classVariable: false.
	self executeRefactoring: ref.
	class := ref model classFor: LintRuleTestData.
	self deny: ref changes changes isEmpty.
	self assert: ref setterMethod identicalTo: #foo1:.
	self assert: ref getterMethod identicalTo: #foo1.
	self assert: (class parseTreeFor: #foo1) equals: (self parseMethod: 'foo1 ^foo1').
	self assert: (class parseTreeFor: #foo1:)
		equals: (self parseMethod: 'foo1: anObject foo1 := anObject')!

testNonExistantName
	self
		shouldFail: (CreateAccessorsForVariableRefactoring
					variable: #Foo
					class: BasicLintRuleTestData
					classVariable: true)
			withMessage: ('BasicLintRuleTestData does not define class variable #Foo');
		shouldFail: (CreateAccessorsForVariableRefactoring
					variable: 'foo'
					class: BasicLintRuleTestData
					classVariable: true)
			withMessage: ('BasicLintRuleTestData does not define class variable ''foo''')! !
!Refactory.Browser.Tests.CreateAccessorsForVariableRefactoringTest categoriesForMethods!
testExistingInstanceVariableAccessors!public!tests! !
testNewClassVariableAccessors!public!tests! !
testNewInstanceVariableAccessors!public!tests! !
testNonExistantName!failure tests!public! !
!

