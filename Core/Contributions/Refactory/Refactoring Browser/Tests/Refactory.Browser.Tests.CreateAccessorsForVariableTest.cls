"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #CreateAccessorsForVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
CreateAccessorsForVariableTest guid: (GUID fromString: '{cf036663-3be7-40e4-9e4f-c090ff6abb4b}')!
CreateAccessorsForVariableTest comment: ''!
!CreateAccessorsForVariableTest categoriesForClass!Refactory-Testing! !
!CreateAccessorsForVariableTest methodsFor!

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
	class := ref model metaclassNamed: #LintRuleTest.
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
	class := ref model classNamed: #LintRuleTest.
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
!CreateAccessorsForVariableTest categoriesFor: #setUp!public!set up! !
!CreateAccessorsForVariableTest categoriesFor: #testExistingInstanceVariableAccessors!public!tests! !
!CreateAccessorsForVariableTest categoriesFor: #testNewClassVariableAccessors!public!tests! !
!CreateAccessorsForVariableTest categoriesFor: #testNewInstanceVariableAccessors!public!tests! !
!CreateAccessorsForVariableTest categoriesFor: #testNonExistantName!failure tests!public! !

