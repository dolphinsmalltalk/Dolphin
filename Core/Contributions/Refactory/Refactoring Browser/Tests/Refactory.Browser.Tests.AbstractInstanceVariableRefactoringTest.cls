"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.AbstractInstanceVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.AbstractInstanceVariableRefactoringTest guid: (Core.GUID fromString: '{c64428af-5374-4e12-8c73-d6b9ec653c13}')!

Refactory.Browser.Tests.AbstractInstanceVariableRefactoringTest comment: ''!

!Refactory.Browser.Tests.AbstractInstanceVariableRefactoringTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.AbstractInstanceVariableRefactoringTest methodsFor!

setUp
	super setUp.
	model := self abstractVariableTestData!

testAbstractInstanceVariable
	| refactoring class |
	refactoring := AbstractInstanceVariableRefactoring variable: 'class'
				class: TransformationRuleTestData.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.TestData.TransformationRuleTestData'.
	self assert: (class parseTreeFor: #class1) equals: (self parseMethod: 'class1 ^class').
	self assert: (class parseTreeFor: #class:)
		equals: (self parseMethod: 'class: anObject
	class := anObject').
	self assert: (class parseTreeFor: #superSends)
		equals: (self
				parseMethod: 'superSends
	| rule |
	rule := ParseTreeRewriter new.
	rule addSearch: ''super `@message: ``@args'' 
				-> (
					[:aNode | 
					(self class1 withAllSubclasses 
						detect: [:each | each includesSelector: aNode selector]
						ifNone: [nil]) isNil] 
							-> ''self `@message: ``@args'').
	self rewriteUsing: rule').
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (self
				parseMethod: 'checkMethod: aSmalllintContext 
	self class: aSmalllintContext selectedClass.
	(rewriteRule executeTree: aSmalllintContext parseTree) 
		ifTrue: 
			[(RecursiveSelfRule executeTree: rewriteRule tree initialAnswer: false) 
				ifFalse: 
					[builder 
						compile: rewriteRule tree printString
						in: self class1
						categories: aSmalllintContext protocols]]')!

testAbstractWithAssignmentUsed
	| refactoring class |
	class := model classNamed: #Foo.
	refactoring := AbstractInstanceVariableRefactoring
				model: model
				variable: 'instVarName2'
				class: class.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #foo)
		equals: (self parseMethod: 'foo
						^self instVarName21: 3').
	self assert: (class parseTreeFor: #instVarName2:)
		equals: (self parseMethod: 'instVarName2: anObject
						self instVarName21: anObject').
	self assert: (class parseTreeFor: #instVarName21:)
		equals: (self parseMethod: 'instVarName21: anObject
						^instVarName2 := anObject').
	self assert: (class parseTreeFor: #instVarName2)
		equals: (self parseMethod: 'instVarName2
						^instVarName2').
	self assert: ((model classNamed: #Bar) parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo
						instVarName1 := instVarName1 + self instVarName2 + ClassVarName1')!

testAbstractWithDefaultNamesUsed
	| refactoring class |
	class := model classNamed: #Foo.
	refactoring := AbstractInstanceVariableRefactoring
				model: model
				variable: 'instVarName1'
				class: class.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #bar)
		equals: (self
				parseMethod: 'bar
						"Add one to instVarName1"

						self instVarName11: self instVarName11 + 1').
	self assert: (class parseTreeFor: #instVarName11:)
		equals: (self parseMethod: 'instVarName11: anObject
						instVarName1 := anObject').
	self assert: (class parseTreeFor: #instVarName11)
		equals: (self parseMethod: 'instVarName11
						^instVarName1').
	self assert: ((model classNamed: #Bar) parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo
						self instVarName11: self instVarName11 + instVarName2 + ClassVarName1')!

testInheritedName
	self shouldFail: (AbstractInstanceVariableRefactoring variable: 'name' class: BasicLintRuleTestData)
		withMessage: 'BasicLintRuleTestData does not directly define instance variable ''name'''!

testMetaclassInstanceVariables
	| refactoring class |
	class := model metaclassNamed: #Foo.
	class addInstanceVariable: 'foo'.
	class compile: 'zzz ^foo := foo + foo * 2' classified: #testing.
	refactoring := AbstractInstanceVariableRefactoring
				model: model
				variable: 'foo'
				class: class.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #foo1) equals: (self parseMethod: 'foo1
						^foo').
	self assert: (class parseTreeFor: #foo:)
		equals: (self parseMethod: 'foo: anObject
						^foo := anObject').
	self assert: (class parseTreeFor: #zzz)
		equals: (self parseMethod: 'zzz ^self foo: self foo1 + self foo1 * 2')!

testNonExistantName
	self shouldFail: (AbstractInstanceVariableRefactoring variable: 'foo' class: BasicLintRuleTestData)
		withMessage: 'BasicLintRuleTestData does not directly define instance variable ''foo'''! !

!Refactory.Browser.Tests.AbstractInstanceVariableRefactoringTest categoriesForMethods!
setUp!public!set up! !
testAbstractInstanceVariable!public!tests! !
testAbstractWithAssignmentUsed!public!tests! !
testAbstractWithDefaultNamesUsed!public!tests! !
testInheritedName!failure tests!public! !
testMetaclassInstanceVariables!public!tests! !
testNonExistantName!failure tests!public! !
!

