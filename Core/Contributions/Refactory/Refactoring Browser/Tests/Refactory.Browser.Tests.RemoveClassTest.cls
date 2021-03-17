"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RemoveClassTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveClassTest guid: (Core.GUID fromString: '{32d88853-b152-4b03-9590-22d6b1be0d4d}')!
Refactory.Browser.Tests.RemoveClassTest comment: ''!
!Refactory.Browser.Tests.RemoveClassTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveClassTest methodsFor!

removableClassWithSubclasses
	^'Refactory.Browser.Tests.Foo' , 'LintRuleTest'!

testBadName
	self shouldFail: (RemoveClassRefactoring classNames: #(#RecursiveSelfRule))!

testRemoveClass
	| refactoring className |
	className := self removableClassWithSubclasses.
	refactoring := RemoveClassRefactoring classNames: {className}.
	self executeRefactoring: refactoring.
	self assertIsNil: (refactoring model classNamed: className).
	self assert: (refactoring model classNamed: TransformationRuleTest fullName) superclass
		equals: (refactoring model classNamed: LintRuleTest fullName)!

testRemoveClassModelReferenced
	| refactoring className |
	className := self removableClassWithSubclasses.
	refactoring := RemoveClassRefactoring classNames: {className}.
	"Create a reference only in the model"
	(refactoring model classFor: self class) compile: 'fooLintRuleTest ^' , ($. split: className) last
		classified: 'accessing'.
	self assert: (refactoring hasReferencesTo: (refactoring model classNamed: className)).
	self shouldFail: refactoring!

testRemoveClassModelReferencedByFullName
	| refactoring className |
	className := 'Refactory.Browser.Tests.Foo' , 'LintRuleTest'.
	refactoring := RemoveClassRefactoring classNames: {className}.
	"Create a reference only in the model"
	(refactoring model classFor: self class) compile: 'fooLintRuleTest ^' , className
		classified: 'accessing'.
	self assert: (refactoring hasReferencesTo: (refactoring model classNamed: className)).
	self shouldFail: refactoring!

testRemoveReferenced
	self
		shouldFail: (RemoveClassRefactoring classNames: #(#'Refactory.Browser.Tests.BasicLintRuleTest'))!

testRemoveSelfReferenced
	| refactoring classNames env refs |
	classNames := ClassToRename withAllSubclasses collect: [:each | each fullName].
	"We limit the scope to exclude refs from other tests to test classes"
	env := BrowserEnvironment new forClassHierarchyOf: Model.
	"Sanity checks - we want the only reference to the classes we are going to remove to be from themselves (in the scoped environment)"
	refs := env referencesTo: ClassToRename.
	self assert: (refs classNames difference: classNames) isEmpty.
	"The subclass is expected to ref its parent already"
	self assert: (refs classes includes: SubclassOfClassToRename).
	"We don't expect the subclass to have any references at present, certainly not outside the hierarchy"
	refs := env referencesTo: SubclassOfClassToRename.
	self assert: (refs classNames difference: classNames) isEmpty.
	model := RBNamespace onEnvironment: env.
	refactoring := RemoveClassRefactoring model: model classNames: classNames.
	"Create a reference only in the model class to itself, and to the subclass (which has existing refs to the parent)"
	(model classFor: ClassToRename)
		compile: 'selfRef ^' , classNames first classified: 'constants';
		compile: 'sub ^' , classNames second classified: 'constants'.
	"There are references to the class, but only from one of the classes to be removed, in this case itself and its subclass."
	classNames do: [:each | self deny: (refactoring hasReferencesTo: (model classNamed: each))].
	self executeRefactoring: refactoring.
	"Classes were unreferenced outside those being removed (within the scope) so should be gone"
	classNames do: [:each | self assertIsNil: (model classNamed: each)]! !
!Refactory.Browser.Tests.RemoveClassTest categoriesFor: #removableClassWithSubclasses!constants!private! !
!Refactory.Browser.Tests.RemoveClassTest categoriesFor: #testBadName!failure tests!public! !
!Refactory.Browser.Tests.RemoveClassTest categoriesFor: #testRemoveClass!public!tests! !
!Refactory.Browser.Tests.RemoveClassTest categoriesFor: #testRemoveClassModelReferenced!failure tests!public! !
!Refactory.Browser.Tests.RemoveClassTest categoriesFor: #testRemoveClassModelReferencedByFullName!public!tests! !
!Refactory.Browser.Tests.RemoveClassTest categoriesFor: #testRemoveReferenced!failure tests!public! !
!Refactory.Browser.Tests.RemoveClassTest categoriesFor: #testRemoveSelfReferenced!failure tests!public! !

