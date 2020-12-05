"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.CreateAccessorsForVariableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.CreateAccessorsForVariableTest guid: (Core.GUID fromString: '{cf036663-3be7-40e4-9e4f-c090ff6abb4b}')!
Refactory.Browser.Tests.CreateAccessorsForVariableTest comment: ''!
!Refactory.Browser.Tests.CreateAccessorsForVariableTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.CreateAccessorsForVariableTest methodsFor!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')!

testExistingInstanceVariableAccessors
	| ref |
	ref := CreateAccessorsForVariableRefactoring
				variable: 'name'
				class: LintRuleTest
				classVariable: false.
	self executeRefactoring: ref.
	self assert: ref changes changes isEmpty.
	self assert: ref setterMethod identicalTo: #name:.
	self assert: ref getterMethod identicalTo: #name!

testNewClassVariableAccessors
	| ref class |
	ref := CreateAccessorsForVariableRefactoring
				variable: 'Foo1'
				class: LintRuleTest
				classVariable: true.
	self executeRefactoring: ref.
	class := ref model metaclassNamed: #'Refactory.Browser.Tests.LintRuleTest'.
	self deny: ref changes changes isEmpty.
	self assert: ref setterMethod identicalTo: #foo1:.
	self assert: ref getterMethod identicalTo: #foo1.
	self assert: (class parseTreeFor: #foo1) equals: (RBParser parseMethod: 'foo1 ^Foo1').
	self assert: (class parseTreeFor: #foo1:)
		equals: (RBParser parseMethod: 'foo1: anObject Foo1 := anObject')!

testNewInstanceVariableAccessors
	| ref class |
	ref := CreateAccessorsForVariableRefactoring
				variable: 'foo1'
				class: LintRuleTest
				classVariable: false.
	self executeRefactoring: ref.
	class := ref model classNamed: #'Refactory.Browser.Tests.LintRuleTest'.
	self deny: ref changes changes isEmpty.
	self assert: ref setterMethod identicalTo: #foo1:.
	self assert: ref getterMethod identicalTo: #foo1.
	self assert: (class parseTreeFor: #foo1) equals: (RBParser parseMethod: 'foo1 ^foo1').
	self assert: (class parseTreeFor: #foo1:)
		equals: (RBParser parseMethod: 'foo1: anObject foo1 := anObject')!

testNonExistantName
	self
		shouldFail: (CreateAccessorsForVariableRefactoring
					variable: #Foo
					class: BasicLintRuleTest
					classVariable: true);
		shouldFail: (CreateAccessorsForVariableRefactoring
					variable: 'foo'
					class: BasicLintRuleTest
					classVariable: true)! !
!Refactory.Browser.Tests.CreateAccessorsForVariableTest categoriesFor: #setUp!public!set up! !
!Refactory.Browser.Tests.CreateAccessorsForVariableTest categoriesFor: #testExistingInstanceVariableAccessors!public!tests! !
!Refactory.Browser.Tests.CreateAccessorsForVariableTest categoriesFor: #testNewClassVariableAccessors!public!tests! !
!Refactory.Browser.Tests.CreateAccessorsForVariableTest categoriesFor: #testNewInstanceVariableAccessors!public!tests! !
!Refactory.Browser.Tests.CreateAccessorsForVariableTest categoriesFor: #testNonExistantName!failure tests!public! !

