"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.AbstractClassVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AbstractClassVariableRefactoringTest guid: (Core.GUID fromString: '{38fd1ddb-aa95-40b7-80bb-c8a7ea9dcd59}')!
Refactory.Browser.Tests.AbstractClassVariableRefactoringTest comment: ''!
!Refactory.Browser.Tests.AbstractClassVariableRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AbstractClassVariableRefactoringTest methodsFor!

setUp
	super setUp.
	model := self abstractVariableTestData!

testAbstractClassVariable
	| refactoring meta class |
	refactoring := AbstractClassVariableRefactoring variable: 'RecursiveSelfRule'
				class: TransformationRuleTestData.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.TestData.TransformationRuleTestData'.
	meta := class metaclass.
	self assert: (meta parseTreeFor: #recursiveSelfRule)
		equals: (self parseMethod: 'recursiveSelfRule ^RecursiveSelfRule').
	self assert: (meta parseTreeFor: #recursiveSelfRule:)
		equals: (self parseMethod: 'recursiveSelfRule: anObject RecursiveSelfRule := anObject').
	self assert: (meta parseTreeFor: #nuke)
		equals: (self parseMethod: 'nuke
							self recursiveSelfRule: nil').
	self assert: (meta parseTreeFor: #initializeAfterLoad1)
		equals: (self
				parseMethod: 'initializeAfterLoad1
							self recursiveSelfRule: ParseTreeSearcher new.
							self recursiveSelfRule
								addMethodSearches: #(''`@methodName: `@args | `@temps | self `@methodName: `@args'' ''`@methodName: `@args | `@temps | ^self `@methodName: `@args'')
										-> [:aNode :answer | true]').
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (self
				parseMethod: 'checkMethod: aSmalllintContext 
							class := aSmalllintContext selectedClass.
							(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
									[(self class recursiveSelfRule executeTree: rewriteRule tree initialAnswer: false)
										ifFalse: 
											[builder compile: rewriteRule tree printString
												in: class
												categories: aSmalllintContext protocols]]')!

testAbstractClassVariableFullyQualified
	| refactoring meta class subclass externalClass |
	refactoring := AbstractClassVariableRefactoring variable: 'ClassVar1' class: ClassToRename.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: ClassToRename.
	meta := class metaclass.
	self assert: (meta parseTreeFor: #classVar1) equals: (self parseMethod: 'classVar1 ^ClassVar1').
	self assert: (meta parseTreeFor: #classVar1:)
		equals: (self parseMethod: 'classVar1: anObject ClassVar1 := anObject').
	self assert: (meta parseTreeFor: #initialize)
		equals: (self parseMethod: 'initialize self classVar1: ''ClassVar1 of ClassToRename''').
	self assert: (class parseTreeFor: #refersToOwnClassVariable)
		equals: (self parseMethod: 'refersToOwnClassVariable ^self class classVar1').
	self assert: (class parseTreeFor: #refersToOwnClassVariableFullyQualified)
		equals: (self parseMethod: 'refersToOwnClassVariableFullyQualified ^self class classVar1').
	"The refs from the subclass should also be rewritten"
	subclass := refactoring model classFor: SubclassOfClassToRename.
	#(#refersToInheritedClassVariable #refersToInheritedClassVariableFullyQualified #refersToInheritedClassVariableQualifiedByOwnName)
		do: 
			[:selector |
			self assert: (subclass parseTreeFor: selector)
				equals: (self parseMethod: '<1s> ^self class classVar1' << selector)].
	self assert: (subclass parseTreeFor: #refersToInheritedClassVariableWithShadowing)
		equals: (self
				parseMethod: 'refersToInheritedClassVariableWithShadowing | ClassVar1 | ClassVar1 := self class classVar1, self class classVar1. ^ClassVar1').
	"Binding refs should be unchanged, although these will obviously be by-passing the desired abstraction by directly binding to the variable."
	self assert: (subclass parseTreeFor: #refersToInheritedClassVariableUnqualifiedBinding)
		equals: (self parseMethod: 'refersToInheritedClassVariableUnqualifiedBinding ^#{ClassVar1}').
	self assert: (subclass parseTreeFor: #refersToInheritedClassVariableFullyQualifiedBinding)
		equals: (self
				parseMethod: 'refersToInheritedClassVariableFullyQualifiedBinding ^#{Refactory.Browser.Tests.ClassToRename.ClassVar1}').
	"Likewise external references from classes outside the defining hierarchy should also be abstracted."
	externalClass := refactoring model classFor: RefactoryTestDataApp.
	#(#refersToClassVariableFullyQualified #refersToClassVariablePartiallyQualified)
		do: 
			[:selector |
			self assert: (externalClass parseTreeFor: selector)
				equals: (self parseMethod: '<1s> ^Refactory.Browser.Tests.ClassToRename classVar1' << selector)].!

testInheritedName
	self shouldFail: (AbstractClassVariableRefactoring variable: #DependentsFields
				class: BasicLintRuleTestData)
		withMessage: 'BasicLintRuleTestData does not directly define class variable #DependentsFields'!

testInvalidClass
	self shouldFail: (AbstractClassVariableRefactoring variable: #DependentsFields class: Object)
		withMessage: 'Object does not directly define class variable #DependentsFields'!

testMetaClassFailure
	self shouldFail: (AbstractClassVariableRefactoring variable: #RecursiveSelfRule
				class: TransformationRuleTestData class)
		withMessage: 'TransformationRuleTestData class is a metaclass'!

testModelAbstractClassVariable
	| refactoring meta class |
	class := model classNamed: #Foo.
	meta := class metaclass.
	refactoring := AbstractClassVariableRefactoring
				model: model
				variable: 'ClassVarName1'
				class: class.
	self executeRefactoring: refactoring.
	self assert: (meta parseTreeFor: #classVarName1)
		equals: (self parseMethod: 'classVarName1 ^ClassVarName1').
	self assert: (meta parseTreeFor: #classVarName1:)
		equals: (self parseMethod: 'classVarName1: anObject ^ClassVarName1 := anObject').
	self assert: (meta parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo
					^self classVarName1: self classVarName1 * self classVarName1 * self classVarName1').
	self assert: (class parseTreeFor: #classVarName1)
		equals: (self parseMethod: 'classVarName1
							^self class classVarName1').
	self assert: (class parseTreeFor: #classVarName1:)
		equals: (self parseMethod: 'classVarName1: anObject
							^self class classVarName1: anObject').
	self assert: (class parseTreeFor: #asdf)
		equals: (self
				parseMethod: 'asdf
						^self classVarName1: (self class classVarName1: self class classVarName1 + 1)').
	self assert: ((model classNamed: #Bar) parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo
					instVarName1 := instVarName1 + instVarName2 + self class classVarName1').
	self assert: ((model classNamed: #Bar) parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo
						instVarName1 := instVarName1 + instVarName2 + self class classVarName1')!

testModelAbstractClassVariableOverridenMethodsInSubclass
	| refactoring meta class |
	class := model classNamed: #Foo.
	meta := class metaclass.
	refactoring := AbstractClassVariableRefactoring
				model: model
				variable: 'ClassVarName2'
				class: class.
	self executeRefactoring: refactoring.
	self assert: (meta parseTreeFor: #classVarName21)
		equals: (self parseMethod: 'classVarName21 ^ClassVarName2').
	self assert: (meta parseTreeFor: #classVarName21:)
		equals: (self parseMethod: 'classVarName21: anObject ClassVarName2 := anObject')!

testNonExistantName
	self shouldFail: (AbstractClassVariableRefactoring variable: #Foo class: BasicLintRuleTestData)
		withMessage: 'BasicLintRuleTestData does not directly define class variable #Foo'! !
!Refactory.Browser.Tests.AbstractClassVariableRefactoringTest categoriesForMethods!
setUp!public!set up! !
testAbstractClassVariable!public!tests! !
testAbstractClassVariableFullyQualified!public!tests! !
testInheritedName!failure tests!public! !
testInvalidClass!failure tests!public! !
testMetaClassFailure!failure tests!public! !
testModelAbstractClassVariable!public!tests! !
testModelAbstractClassVariableOverridenMethodsInSubclass!public!tests! !
testNonExistantName!failure tests!public! !
!

