"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.UnqualifyStaticVariablesRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.UnqualifyStaticVariablesRefactoringTest guid: (Core.GUID fromString: '{68a6ac55-73c9-4f71-97b2-d5a2a093d2e7}')!

Refactory.Browser.Tests.UnqualifyStaticVariablesRefactoringTest comment: ''!

!Refactory.Browser.Tests.UnqualifyStaticVariablesRefactoringTest methodsFor!

refersToPoolConstantBindingFullyQualified
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToPoolConstantBindingFullyQualified
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToPoolConstantBindingFullyQualified)
		equals: (self parseMethod: 'refersToImportedPoolConstantUnqualified ^OS.CRTConstants.EINVAL')!

testRefersToClassBindingNotFound
	| refactoring refDataApp source |
	refDataApp := model classFor: RefactoryTestDataApp.
	source := refDataApp sourceCodeFor: #refersToClassBindingNotFound.
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewrite: ((source indexOf: $^) + 1 to: source size)
				inMethod: #refersToClassBindingNotFound
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToClassBindingNotFound)
		equals: (self parseMethod: source)!

testRefersToClassConstantFullyQualified
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToClassConstantFullyQualified
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToClassConstantFullyQualified)
		equals: (self parseMethod: 'refersToClassConstantFullyQualified ^Tests.ClassToRename.ClassConst1')!

testRefersToClassConstantMinimallyQualified
	| refactoring |
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToClassConstantPartiallyQualified
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	"No unqualification is possible, so no changes expected"
	self assert: model changes isEmpty!

testRefersToClassConstantPartiallyQualifiedWithNamespace
	| refactoring |
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToClassConstantPartiallyQualifiedWithNamespace
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	"No unqualification is possible, so no changes expected"
	self assert: model changes isEmpty!

testRefersToClassConstantPartiallyQualifiedWithNamespace2
	| refactoring refDataApp |
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToClassConstantPartiallyQualifiedWithNamespace
				forClass: RefactoryTestDataApp.
	refDataApp := model classFor: RefactoryTestDataApp.
	refDataApp compile: 'refersToClassConstantPartiallyQualifiedWithNamespace
	<namespace: Refactory.Browser.Tests>
	^Tests.ClassToRename.ClassConst1'.
	self executeRefactoring: refactoring.
	"Additional qualificaion we added should be removed"
	self assert: (refDataApp parseTreeFor: #refersToClassConstantPartiallyQualifiedWithNamespace)
		equals: (self parseMethod: 'refersToClassConstantPartiallyQualifiedWithNamespace
	<namespace: Refactory.Browser.Tests>
	^ClassToRename.ClassConst1').!

testRefersToClassFullyQualifiedBinding
	| refactoring refDataApp source |
	refDataApp := model classFor: RefactoryTestDataApp.
	source := refDataApp sourceCodeFor: #refersToClassFullyQualifiedBinding.
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewrite: ((source indexOf: $^) + 1 to: source size)
				inMethod: #refersToClassFullyQualifiedBinding
				forClass: refDataApp.
	self executeRefactoring: refactoring.
	"In this case we are specifically asking for qualification to be removed, so we expect a relative reference where possible"
	self assert: (refDataApp parseTreeFor: #refersToClassFullyQualifiedBinding)
		equals: (self parseMethod: 'refersToClassFullyQualifiedBinding ^#{_.Tests.ClassToRename}')!

testRefersToClassPartiallyQualified
	| refactoring class |
	class := model classFor: SubclassOfClassToRename.
	#(#refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2) do: 
			[:selector |
			refactoring := UnqualifyStaticVariablesRefactoring
						model: model
						rewriteMethod: selector
						forClass: class.
			self executeRefactoring: refactoring].
	#(#refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2) do: 
			[:selector |
			self assert: (class parseTreeFor: selector)
				equals: (self parseMethod: '<1s> ^ClassToRename' << selector)]!

testRefersToClassPartiallyQualifiedBinding
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	#(#refersToClassPartiallyQualifiedBinding1 #refersToClassPartiallyQualifiedBinding2) do: 
			[:selector |
			| source |
			source := refDataApp sourceCodeFor: selector.
			refactoring := UnqualifyStaticVariablesRefactoring
						model: model
						rewrite: ((source indexOf: $^) + 1 to: source size)
						inMethod: selector
						forClass: refDataApp.
			self executeRefactoring: refactoring].
	#(#refersToClassPartiallyQualifiedBinding1 #refersToClassPartiallyQualifiedBinding2) do: 
			[:selector |
			self assert: (refDataApp parseTreeFor: selector)
				equals: (self parseMethod: '<1s> ^#{_.Tests.ClassToRename}' << selector)]!

testRefersToClassPartiallyQualifiedBindingInArray
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToClassPartiallyQualifiedBindingInArray
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToClassPartiallyQualifiedBindingInArray)
		equals: (self
				parseMethod: 'refersToClassPartiallyQualifiedBindingInArray ^#(#{_.Tests.ClassToRename class})')!

testRefersToClassUnqualified
	| refactoring refDataApp source |
	refDataApp := model classFor: RefactoryTestDataApp.
	source := refDataApp sourceCodeFor: #refersToClassUnqualified.
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewrite: ((source indexOf: $^) + 1 to: source size)
				inMethod: #refersToClassUnqualified
				forClass: refDataApp.
	self executeRefactoring: refactoring.
	self assert: model changes isEmpty!

testRefersToClassUnqualifiedBinding
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToClassUnqualifiedBinding
				forClass: refDataApp.
	self executeRefactoring: refactoring.
	"The namespace annotation should always be fully qualified, so there should be no change here"
	self assert: (refDataApp parseTreeFor: #refersToClassUnqualifiedBinding)
		equals: (self
				parseMethod: 'refersToClassUnqualifiedBinding
	<namespace: Refactory.Browser.Tests>
	^#{ClassToRename private}')!

testRefersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	"Because namespace annotations should always be fully-qualified, the refactoring rewrites it as such"
	self
		assert: (refDataApp parseTreeFor: #refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation)
		equals: (self
				parseMethod: 'refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation
	<namespace: Refactory.Browser.Tests>
	^ClassToRename')!

testRefersToDolphinTestPartiallyQualifiedBindingMethodNamespace
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToDolphinTestPartiallyQualifiedBindingMethodNamespace
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToDolphinTestPartiallyQualifiedBindingMethodNamespace)
		equals: (self
				parseMethod: 'refersToDolphinTestPartiallyQualifiedBindingMethodNamespace
	<namespace: Core>
	^#{_.Tests.DolphinTest}')!

testRefersToImportedPoolConstantFullyQualified
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToImportedPoolConstantFullyQualified
				forClass: refDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToImportedPoolConstantFullyQualified)
		equals: (self parseMethod: 'refersToImportedPoolConstantFullyQualified ^EINVAL')!

testRefersToImportedPoolConstantUnqualified
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToImportedPoolConstantUnqualified
				forClass: refDataApp.
	self executeRefactoring: refactoring.
	self assert: model changes isEmpty!

testRefersToOwnClassVariable
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := UnqualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToOwnClassVariable
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: model changes isEmpty! !

!Refactory.Browser.Tests.UnqualifyStaticVariablesRefactoringTest categoriesForMethods!
refersToPoolConstantBindingFullyQualified!public! !
testRefersToClassBindingNotFound!public! !
testRefersToClassConstantFullyQualified!public! !
testRefersToClassConstantMinimallyQualified!public! !
testRefersToClassConstantPartiallyQualifiedWithNamespace!public! !
testRefersToClassConstantPartiallyQualifiedWithNamespace2!public! !
testRefersToClassFullyQualifiedBinding!public! !
testRefersToClassPartiallyQualified!public! !
testRefersToClassPartiallyQualifiedBinding!public! !
testRefersToClassPartiallyQualifiedBindingInArray!public! !
testRefersToClassUnqualified!public! !
testRefersToClassUnqualifiedBinding!public! !
testRefersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation!public! !
testRefersToDolphinTestPartiallyQualifiedBindingMethodNamespace!public! !
testRefersToImportedPoolConstantFullyQualified!public! !
testRefersToImportedPoolConstantUnqualified!public! !
testRefersToOwnClassVariable!public! !
!

