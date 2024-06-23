"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.ChildrenToSiblingsRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.ChildrenToSiblingsRefactoringTest guid: (Core.GUID fromString: '{ca54e227-44a3-41c9-aab6-bd11a852bf74}')!

Refactory.Browser.Tests.ChildrenToSiblingsRefactoringTest comment: ''!

!Refactory.Browser.Tests.ChildrenToSiblingsRefactoringTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.ChildrenToSiblingsRefactoringTest methodsFor!

testBadName
	| badName |
	badName := #'Obje ct'.
	self shouldFail: (ChildrenToSiblingsRefactoring
				name: badName
				class: LintRuleTestData
				subclasses: {BasicLintRuleTestData. CompositeLintRuleTestData})
		withMessage: ClassBuilder.ErrorInvalidClassName << badName!

testChildToSibling
	| refactoring class subclass superclass |
	refactoring := ChildrenToSiblingsRefactoring
				name: #'Refactory.Browser.Tests.ClassToRenameAbstract'
				class: ClassToRename
				subclasses: {SubclassOfClassToRename}.
	model := refactoring model.
	self assert: refactoring environment equals: (model classFor: Refactory.Browser.Tests).
	self executeRefactoring: refactoring.
	class := model classNamed: #'Refactory.Browser.Tests.ClassToRename'.
	subclass := model classNamed: #'Refactory.Browser.Tests.SubclassOfClassToRename'.
	superclass := refactoring model classNamed: #'Refactory.Browser.Tests.ClassToRenameAbstract'.
	self assert: superclass isNonInstantiable.
	self assert: class superclass equals: superclass.
	self assert: class metaclass superclass equals: superclass metaclass.
	self assert: subclass superclass equals: superclass.
	self assert: subclass metaclass superclass equals: superclass metaclass.
	"Inst vars should have been pushed up"
	self assert: class instanceVariableNames isEmpty.
	self assert: superclass instanceVariableNames equals: ClassToRename instanceVariableNames.
	"Ditto class vars"
	self assert: class classVariableNames isEmpty.
	self assert: superclass classVariableNames equals: ClassToRename classVariableNames.
	self assert: class classConstants isEmpty.
	self assert: (Dictionary withAll: superclass classConstants) equals: (Dictionary withAll: ClassToRename classConstants).
	"Methods all pushed up too"
	self assert: class selectors isEmpty.
	self assert: superclass selectors equals: ClassToRename selectors.
	self assert: class metaclass selectors isEmpty.
	self assert: superclass metaclass selectors equals: ClassToRename class selectors.
!

testExistingName
	self shouldFail: (ChildrenToSiblingsRefactoring
				name: #'Core.Object'
				class: LintRuleTestData
				subclasses: {BasicLintRuleTestData. CompositeLintRuleTestData})
		existingVariable: 'Core.Object'.
	self shouldFail: (ChildrenToSiblingsRefactoring
				name: 'Core.Processor'
				class: LintRuleTestData
				subclasses: {BasicLintRuleTestData. CompositeLintRuleTestData})
		existingVariable: 'Core.Processor'!

testInvalidSubclass
	self shouldFail: (ChildrenToSiblingsRefactoring
				name: #Foo
				class: LintRuleTestData
				subclasses: {BasicLintRule. CompositeLintRule})
		withMessage: 'BasicLintRule is not an immediate subclass of Refactory.Browser.TestData.LintRuleTestData'!

testMetaClassFailure
	self shouldFail: (ChildrenToSiblingsRefactoring
				name: #Foo
				class: LintRuleTestData class
				subclasses: {BasicLintRuleTestData class. CompositeLintRuleTestData class})
		withMessage: 'Superclass must not be a metaclass'!

testModelChildrenToSibling
	| refactoring class subclass superclass noMove |
	model := self childrenToSiblingTestData.
	class := model classNamed: #'Refactory.Browser.Tests.ConcreteSuperclass'.
	subclass := model classNamed: #'Refactory.Browser.Tests.ConcreteSubclass'.
	noMove := model classNamed: #'Refactory.Browser.Tests.NoMoveSubclass'.
	self assert: (noMove parseTreeFor: #qualifiedRef) formattedCode
		equals: 'qualifiedRef
	^self initialize isKindOf: Refactory.Browser.Tests.ConcreteSuperclass	"Hello"'.
	refactoring := ChildrenToSiblingsRefactoring
				model: model
				name: #'Refactory.Browser.Tests.AbstractSuperclass'
				class: class
				subclasses: {subclass}.
	self executeRefactoring: refactoring.
	superclass := refactoring model classNamed: #'Refactory.Browser.Tests.AbstractSuperclass'.
	self assert: superclass isNonInstantiable.
	self assert: class superclass equals: superclass.
	self assert: class metaclass superclass equals: superclass metaclass.
	self assert: subclass superclass equals: superclass.
	self assert: subclass metaclass superclass equals: superclass metaclass.
	self assert: (superclass parseTreeFor: #same)
		equals: (self parseMethod: 'same ^self initialize isKindOf: AbstractSuperclass').
	self assert: (superclass parseTreeFor: #different)
		equals: (self parseMethod: 'different self subclassResponsibility').
	self assert: (superclass parseTreeFor: #initialize)
		equals: (self
				parseMethod: 'initialize
							instVarName1 := instVarName2 := ClassVarName1 := ClassVarName2 := 0').
	"The qualified name can be shortened. The comment should be preserved."
	self assert: (noMove parseTreeFor: #qualifiedRef) formattedCode
		equals: 'qualifiedRef
	^self initialize isKindOf: AbstractSuperclass	"Hello"'.
	self assert: (superclass directlyDefinesInstanceVariable: 'instVarName1').
	self assert: (superclass directlyDefinesInstanceVariable: 'instVarName2').
	self assert: (superclass directlyDefinesClassVariable: 'ClassVarName1').
	self assert: (superclass directlyDefinesClassVariable: 'ClassVarName2').
	self assert: (superclass metaclass directlyDefinesInstanceVariable: 'classInstVarName1').
	self assert: (superclass metaclass parseTreeFor: #foo)
		equals: (self parseMethod: 'foo
							^classInstVarName1 + ClassVarName1 + ClassVarName2').
	self assert: (superclass metaclass parseTreeFor: #new)
		equals: (self parseMethod: 'new
							^super new initialize').
	self assert: (superclass metaclass parseTreeFor: #bar)
		equals: (self parseMethod: 'bar
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
		equals: (self parseMethod: 'different
							^instVarName1 + instVarName2').
	self assert: (class metaclass parseTreeFor: #bar)
		equals: (self parseMethod: 'bar
							^self printString')! !

!Refactory.Browser.Tests.ChildrenToSiblingsRefactoringTest categoriesForMethods!
testBadName!failure tests!public! !
testChildToSibling!public!tests! !
testExistingName!failure tests!public! !
testInvalidSubclass!failure tests!public! !
testMetaClassFailure!failure tests!public! !
testModelChildrenToSibling!public!tests! !
!

