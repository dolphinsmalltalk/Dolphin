"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.RemoveClassRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.RemoveClassRefactoringTest guid: (Core.GUID fromString: '{32d88853-b152-4b03-9590-22d6b1be0d4d}')!

Refactory.Browser.Tests.RemoveClassRefactoringTest comment: ''!

!Refactory.Browser.Tests.RemoveClassRefactoringTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.RemoveClassRefactoringTest methodsFor!

removableClassWithSubclasses
	^'Refactory.Browser.TestData.Foo' , 'LintRuleTestData'!

setRemoveReferencedClassOption: refactoring toAnswer: aBoolean
	refactoring setOption: #removeReferencedClass toUse: [aBoolean]!

testBadName
	self shouldFail: (RemoveClassRefactoring classNames: #(#RecursiveSelfRule)) withMessage: 'No such class'!

testRemoveClass
	| refactoring className |
	className := self removableClassWithSubclasses.
	refactoring := RemoveClassRefactoring classNames: { className }.
	refactoring setOption: #removeReferencedClass
		toUse: 
			[:ref :class :methods |
			self assert: class identicalTo: (ref model classNamed: className).
			true].
	self executeRefactoring: refactoring.
	self assertIsNil: (refactoring model classNamed: className).
	self assert: (refactoring model classNamed: TransformationRuleTestData fullName) superclass
		equals: (refactoring model classNamed: LintRuleTestData fullName)!

testRemoveClassModelReferenced
	| refactoring className |
	className := self removableClassWithSubclasses.
	refactoring := RemoveClassRefactoring classNames: {className}.
	"Create a reference only in the model"
	(refactoring model classFor: self class) compile: 'fooLintRuleTest ^' , ($. split: className) last
		classified: 'accessing'.
	self assert: (refactoring hasReferencesTo: (refactoring model classNamed: className)).
	self setRemoveReferencedClassOption: refactoring toAnswer: false.
	self shouldAbort: refactoring.
	self assertNotNil: (refactoring model classNamed: className).

	"Now allow it to be removed"
	self setRemoveReferencedClassOption: refactoring toAnswer: true.
	self executeRefactoring: refactoring.
	self assertIsNil: (refactoring model classNamed: className)!

testRemoveClassModelReferencedByFullName
	| refactoring className |
	className := 'Refactory.Browser.TestData.Foo' , 'LintRuleTestData'.
	refactoring := RemoveClassRefactoring classNames: {className}.
	"Create a reference only in the model"
	(refactoring model classFor: self class) compile: 'fooLintRuleTest ^' , className
		classified: 'accessing'.
	self assert: (refactoring hasReferencesTo: (refactoring model classNamed: className)).
	self setRemoveReferencedClassOption: refactoring toAnswer: false.
	self shouldAbort: refactoring.
	self assertNotNil: (refactoring model classNamed: className).
	"Now allow it to be removed"
	self setRemoveReferencedClassOption: refactoring toAnswer: true.
	self executeRefactoring: refactoring.
	self assertIsNil: (refactoring model classNamed: className)!

testRemoveReferenced
	| refactoring className |
	className := 'Refactory.Browser.TestData.BasicLintRuleTestData'.
	refactoring := RemoveClassRefactoring classNames: {className}.
	self setRemoveReferencedClassOption: refactoring toAnswer: false.
	self shouldAbort: refactoring.
	self assertNotNil: (refactoring model classNamed: className).

	"The option can allow it go ahead and be removed regardless of the fact that this is no longer a refactoring"
	self setRemoveReferencedClassOption: refactoring toAnswer: true.
	model := refactoring model.
	self executeRefactoring: refactoring.
	self assertIsNil: (model classNamed: className)!

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
	model := RBModel onEnvironment: env.
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

!Refactory.Browser.Tests.RemoveClassRefactoringTest categoriesForMethods!
removableClassWithSubclasses!constants!private! !
setRemoveReferencedClassOption:toAnswer:!helpers!private! !
testBadName!failure tests!public! !
testRemoveClass!public!tests! !
testRemoveClassModelReferenced!failure tests!public! !
testRemoveClassModelReferencedByFullName!public!tests! !
testRemoveReferenced!failure tests!public! !
testRemoveSelfReferenced!failure tests!public! !
!

