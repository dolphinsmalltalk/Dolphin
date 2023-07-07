"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.RemoveClassVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveClassVariableRefactoringTest guid: (Core.GUID fromString: '{0c64e4ad-979f-4e25-9c48-f1adeebc74b6}')!
Refactory.Browser.Tests.RemoveClassVariableRefactoringTest comment: ''!
!Refactory.Browser.Tests.RemoveClassVariableRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveClassVariableRefactoringTest methodsFor!

setRemoveReferencedVariableOption: refactoring toAnswer: aBoolean
	refactoring setOption: #removeReferencedVariable toUse: [aBoolean]!

testAttemptToRemoveClass
	self
		shouldFail: (RemoveClassVariableRefactoring variable: self class name class: self class environment)
		withMessage: '<1d> does not define class variable #<2s>' << {self class environment. self class name}!

testNonExistantName
	self shouldFail: (RemoveClassVariableRefactoring variable: #RecursiveSelfRule1
				class: TransformationRuleTestData)
		withMessage: '<1p> does not define class variable #RecursiveSelfRule1' << TransformationRuleTestData!

testReferencedVariable
	| refactoring class |
	refactoring := RemoveClassVariableRefactoring variable: #RecursiveSelfRule
				class: TransformationRuleTestData.
	self setRemoveReferencedVariableOption: refactoring toAnswer: false.
	self shouldAbort: refactoring.
	class := refactoring model classFor: TransformationRuleTestData.
	self assert: (class directlyDefinesClassVariable: 'RecursiveSelfRule').

	"The option can allow it go ahead and be removed regardless of the fact that this is no longer a refactoring"
	self setRemoveReferencedVariableOption: refactoring toAnswer: true.
	self executeRefactoring: refactoring.
	self deny: (class directlyDefinesClassVariable: 'RecursiveSelfRule')!

testReferencedVariableFromForeignMethod
	"Using qualified names, it is possible to access the class vars/constants of classes outside one's immediate hierarchy. Such references should be detected by the preconditions."

	| refactoring class |
	refactoring := RemoveClassVariableRefactoring variable: 'ClassVar2' class: RefactoryTestDataApp.
	class := refactoring model classFor: RefactoryTestDataApp.
	class metaclass removeSelector: #initialize.
	refactoring setOption: #removeReferencedVariable
		toUse: 
			[:rfg :binding :refs |
			self assert: (refs
						includes: ((rfg model classFor: ClassToRename) methodFor: #refersToClassVariableInCustomNamespace)).
			false].
	self shouldAbort: refactoring.
	self assert: (class directlyDefinesClassVariable: 'ClassVar2')!

testRemoveClassConstant
	| refactoring class |
	refactoring := RemoveClassVariableRefactoring variable: 'ClassConst1' class: ClassToRename.
	class := refactoring model classFor: ClassToRename.
	self assert: (class definesClassVariable: 'ClassConst1').
	self setRemoveReferencedVariableOption: refactoring toAnswer: true.
	self executeRefactoring: refactoring.
	self deny: (class definesClassVariable: 'ClassConst1').
	self assert: refactoring model changes afterText
		equals: 'Refactory.Browser.Tests.ClassToRename removeClassConstant: ''ClassConst1'' -> 1!!'!

testRemoveClassVar
	| refactoring class |
	refactoring := RemoveClassVariableRefactoring
				model: model
				variable: 'Foo1'
				class: LintRuleTestData.
	class := model classFor: LintRuleTestData.
	self assert: (class definesClassVariable: 'Foo1').
	refactoring setOption: #removeReferencedVariable
		toUse: 
			[:ref :var :methods |
			self assert: var identicalTo: (class localBindingFor: 'Foo1').
			methods
				do: [:each | self assert: each methodClass equals: (model classFor: BasicLintRuleTestData) metaclass].
			true].
	self executeRefactoring: refactoring.
	self deny: (class definesClassVariable: 'Foo1')! !
!Refactory.Browser.Tests.RemoveClassVariableRefactoringTest categoriesForMethods!
setRemoveReferencedVariableOption:toAnswer:!helpers!private! !
testAttemptToRemoveClass!public!tests! !
testNonExistantName!failure tests!public! !
testReferencedVariable!failure tests!public! !
testReferencedVariableFromForeignMethod!failure tests!public! !
testRemoveClassConstant!public!tests! !
testRemoveClassVar!public!tests! !
!

