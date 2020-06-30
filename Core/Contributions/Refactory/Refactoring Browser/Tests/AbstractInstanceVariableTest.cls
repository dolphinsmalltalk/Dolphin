"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #AbstractInstanceVariableTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractInstanceVariableTest guid: (GUID fromString: '{c64428af-5374-4e12-8c73-d6b9ec653c13}')!
AbstractInstanceVariableTest comment: ''!
!AbstractInstanceVariableTest categoriesForClass!Refactory-Testing! !
!AbstractInstanceVariableTest methodsFor!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')!

testAbstractInstanceVariable
	| refactoring class |
	refactoring := AbstractInstanceVariableRefactoring variable: 'class' class: TransformationRuleTest.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #TransformationRuleTest.
	self assert: (class parseTreeFor: #class1) equals: (RBParser parseMethod: 'class1 ^class').
	self assert: (class parseTreeFor: #class:)
		equals: (RBParser parseMethod: 'class: anObject
	class := anObject').
	self assert: (class parseTreeFor: #superSends)
		equals: (RBParser
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
		equals: (RBParser
				parseMethod: 'checkMethod: aSmalllintContext 
	self class: aSmalllintContext selectedClass.
	(rewriteRule executeTree: aSmalllintContext parseTree) 
		ifTrue: 
			[(RecursiveSelfRule executeTree: rewriteRule tree initialAnswer: false) 
				ifFalse: 
					[builder 
						compile: rewriteRule tree printString
						in: self class1
						classified: aSmalllintContext protocols]]')!

testAbstractWithAssignmentUsed
	| refactoring class |
	class := model classNamed: #Foo.
	refactoring := AbstractInstanceVariableRefactoring
				model: model
				variable: 'instVarName2'
				class: class.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #foo)
		equals: (RBParser parseMethod: 'foo
						^self instVarName21: 3').
	self assert: (class parseTreeFor: #instVarName2:)
		equals: (RBParser parseMethod: 'instVarName2: anObject
						self instVarName21: anObject').
	self assert: (class parseTreeFor: #instVarName21:)
		equals: (RBParser parseMethod: 'instVarName21: anObject
						^instVarName2 := anObject').
	self assert: (class parseTreeFor: #instVarName2)
		equals: (RBParser parseMethod: 'instVarName2
						^instVarName2').
	self assert: ((model classNamed: #Bar) parseTreeFor: #foo)
		equals: (RBParser
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
		equals: (RBParser
				parseMethod: 'bar
						"Add one to instVarName1"

						self instVarName11: self instVarName11 + 1').
	self assert: (class parseTreeFor: #instVarName11:)
		equals: (RBParser parseMethod: 'instVarName11: anObject
						instVarName1 := anObject').
	self assert: (class parseTreeFor: #instVarName11)
		equals: (RBParser parseMethod: 'instVarName11
						^instVarName1').
	self assert: ((model classNamed: #Bar) parseTreeFor: #foo)
		equals: (RBParser
				parseMethod: 'foo
						self instVarName11: self instVarName11 + instVarName2 + ClassVarName1')!

testInheritedName
	self shouldFail: (AbstractInstanceVariableRefactoring variable: 'name'
				class: BasicLintRuleTest)!

testMetaclassInstanceVariables
	| refactoring class |
	class := model metaclassNamed: #Foo.
	class addInstanceVariable: 'foo'.
	class compile: 'zzz ^foo := foo + foo * 2' classified: #(#testing).
	refactoring := AbstractInstanceVariableRefactoring
				model: model
				variable: 'foo'
				class: class.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #foo1) equals: (RBParser parseMethod: 'foo1
						^foo').
	self assert: (class parseTreeFor: #foo:)
		equals: (RBParser parseMethod: 'foo: anObject
						^foo := anObject').
	self assert: (class parseTreeFor: #zzz)
		equals: (RBParser parseMethod: 'zzz ^self foo: self foo1 + self foo1 * 2')!

testNonExistantName
	self shouldFail: (AbstractInstanceVariableRefactoring variable: 'foo'
				class: BasicLintRuleTest)! !
!AbstractInstanceVariableTest categoriesFor: #setUp!public!set up! !
!AbstractInstanceVariableTest categoriesFor: #testAbstractInstanceVariable!public!tests! !
!AbstractInstanceVariableTest categoriesFor: #testAbstractWithAssignmentUsed!public!tests! !
!AbstractInstanceVariableTest categoriesFor: #testAbstractWithDefaultNamesUsed!public!tests! !
!AbstractInstanceVariableTest categoriesFor: #testInheritedName!failure tests!public! !
!AbstractInstanceVariableTest categoriesFor: #testMetaclassInstanceVariables!public!tests! !
!AbstractInstanceVariableTest categoriesFor: #testNonExistantName!failure tests!public! !

