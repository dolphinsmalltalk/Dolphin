"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #ChildrenToSiblingsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ChildrenToSiblingsTest guid: (GUID fromString: '{ca54e227-44a3-41c9-aab6-bd11a852bf74}')!
ChildrenToSiblingsTest comment: ''!
!ChildrenToSiblingsTest categoriesForClass!Refactory-Testing! !
!ChildrenToSiblingsTest methodsFor!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'ChildrenToSiblingTest.st')!

testBadName
	self shouldFail: (ChildrenToSiblingsRefactoring
				name: #'Obje ct'
				class: LintRuleTest
				subclasses: {BasicLintRuleTest. CompositeLintRuleTest})!

testExistingName
	self
		shouldFail: (ChildrenToSiblingsRefactoring
					name: #Object
					class: LintRuleTest
					subclasses: {BasicLintRuleTest. CompositeLintRuleTest});
		shouldFail: (ChildrenToSiblingsRefactoring
					name: #Processor
					class: LintRuleTest
					subclasses: {BasicLintRuleTest. CompositeLintRuleTest})!

testInvalidSubclass
	self shouldFail: (ChildrenToSiblingsRefactoring
				name: #Foo
				class: LintRuleTest
				subclasses: {BasicLintRule. CompositeLintRule})!

testMetaClassFailure
	self shouldFail: (ChildrenToSiblingsRefactoring
				name: #Foo
				class: LintRuleTest class
				subclasses: {BasicLintRuleTest class. CompositeLintRuleTest class})!

testModelChildrenToSibling
	| refactoring class subclass superclass |
	class := model classNamed: #ConcreteSuperclass.
	subclass := model classNamed: #ConcreteSubclass.
	refactoring := ChildrenToSiblingsRefactoring
				model: model
				name: #AbstractSuperclass
				class: class
				subclasses: {subclass}.
	self executeRefactoring: refactoring.
	superclass := refactoring model classNamed: #AbstractSuperclass.
	self assert: class superclass equals: superclass.
	self assert: class metaclass superclass equals: superclass metaclass.
	self assert: subclass superclass equals: superclass.
	self assert: subclass metaclass superclass equals: superclass metaclass.
	self assert: (superclass parseTreeFor: #same)
		equals: (RBParser parseMethod: 'same ^self initialize isKindOf: AbstractSuperclass').
	self assert: (superclass parseTreeFor: #different)
		equals: (RBParser parseMethod: 'different self subclassResponsibility').
	self assert: (superclass parseTreeFor: #initialize)
		equals: (RBParser
				parseMethod: 'initialize
							instVarName1 := instVarName2 := ClassVarName1 := ClassVarName2 := 0').
	self assert: (superclass directlyDefinesInstanceVariable: 'instVarName1').
	self assert: (superclass directlyDefinesInstanceVariable: 'instVarName2').
	self assert: (superclass directlyDefinesClassVariable: 'ClassVarName1').
	self assert: (superclass directlyDefinesClassVariable: 'ClassVarName2').
	self assert: (superclass metaclass directlyDefinesInstanceVariable: 'classInstVarName1').
	self assert: (superclass metaclass parseTreeFor: #foo)
		equals: (RBParser parseMethod: 'foo
							^classInstVarName1 + ClassVarName1 + ClassVarName2').
	self assert: (superclass metaclass parseTreeFor: #new)
		equals: (RBParser parseMethod: 'new
							^super new initialize').
	self assert: (superclass metaclass parseTreeFor: #bar)
		equals: (RBParser parseMethod: 'bar
							self subclassResponsibility').
	self deny: (class directlyDefinesInstanceVariable: 'instVarName1').
	self deny: (class directlyDefinesInstanceVariable: 'instVarName2').
	self deny: (class directlyDefinesClassVariable: 'ClassVarName1').
	self deny: (class directlyDefinesClassVariable: 'ClassVarName2').
	self deny: (class metaclass directlyDefinesInstanceVariable: 'classInstVarName1').
	self deny: (class directlyDefinesMethod: #same).
	self deny: (class directlyDefinesMethod: #initialize).
	self deny: (class metaclass directlyDefinesMethod: #new).
	self assert: (class parseTreeFor: #different)
		equals: (RBParser parseMethod: 'different
							^instVarName1 + instVarName2').
	self assert: (class metaclass parseTreeFor: #bar)
		equals: (RBParser parseMethod: 'bar
							^self printString')! !
!ChildrenToSiblingsTest categoriesFor: #setUp!public!set up! !
!ChildrenToSiblingsTest categoriesFor: #testBadName!failure tests!public! !
!ChildrenToSiblingsTest categoriesFor: #testExistingName!failure tests!public! !
!ChildrenToSiblingsTest categoriesFor: #testInvalidSubclass!failure tests!public! !
!ChildrenToSiblingsTest categoriesFor: #testMetaClassFailure!failure tests!public! !
!ChildrenToSiblingsTest categoriesFor: #testModelChildrenToSibling!public!tests! !

