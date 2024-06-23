"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.QualifyStaticVariablesRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.QualifyStaticVariablesRefactoringTest guid: (Core.GUID fromString: '{68a6ac55-73c9-4f71-97b2-d5a2a093d2e7}')!

Refactory.Browser.Tests.QualifyStaticVariablesRefactoringTest comment: ''!

!Refactory.Browser.Tests.QualifyStaticVariablesRefactoringTest methodsFor!

testRefersToClassBindingNotFound
	| refactoring refDataApp source |
	refDataApp := model classFor: RefactoryTestDataApp.
	source := refDataApp sourceCodeFor: #refersToClassBindingNotFound.
	refactoring := QualifyStaticVariablesRefactoring
				model: model
				rewrite: ((source indexOf: $^) + 1 to: source size)
				inMethod: #refersToClassBindingNotFound
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToClassBindingNotFound)
		equals: (self parseMethod: source)!

testRefersToClassConstantPartiallyQualified
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := QualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToClassConstantPartiallyQualified
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToClassConstantPartiallyQualified)
		equals: (self
				parseMethod: 'refersToClassConstantPartiallyQualified ^Refactory.Browser.Tests.ClassToRename.ClassConst1')!

testRefersToClassPartiallyQualified
	| refactoring refDataApp source |
	refDataApp := model classFor: RefactoryTestDataApp.
	source := refDataApp sourceCodeFor: #refersToClassPartiallyQualified1.
	refactoring := QualifyStaticVariablesRefactoring
				model: model
				rewrite: ((source indexOf: $^) + 1 to: source size)
				inMethod: #refersToClassPartiallyQualified1
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToClassPartiallyQualified1)
		equals: (self
				parseMethod: 'refersToClassPartiallyQualified1 ^Refactory.Browser.Tests.ClassToRename')!

testRefersToClassPartiallyQualifiedBinding
	| refactoring refDataApp source |
	refDataApp := model classFor: RefactoryTestDataApp.
	source := refDataApp sourceCodeFor: #refersToClassPartiallyQualifiedBinding1.
	refactoring := QualifyStaticVariablesRefactoring
				model: model
				rewrite: ((source indexOf: $^) + 1 to: source size)
				inMethod: #refersToClassPartiallyQualifiedBinding1
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToClassPartiallyQualifiedBinding1)
		equals: (self
				parseMethod: 'refersToClassPartiallyQualifiedBinding1 ^#{Refactory.Browser.Tests.ClassToRename}')!

testRefersToClassPartiallyQualifiedBindingInArray
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := QualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToClassPartiallyQualifiedBindingInArray
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToClassPartiallyQualifiedBindingInArray)
		equals: (self
				parseMethod: 'refersToClassPartiallyQualifiedBindingInArray ^#(#{Refactory.Browser.Tests.ClassToRename class})')!

testRefersToClassUnqualified
	| refactoring refDataApp source |
	refDataApp := model classFor: RefactoryTestDataApp.
	source := refDataApp sourceCodeFor: #refersToClassUnqualified.
	refactoring := QualifyStaticVariablesRefactoring
				model: model
				rewrite: ((source indexOf: $^) + 1 to: source size)
				inMethod: #refersToClassUnqualified
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToClassUnqualified)
		equals: (self
				parseMethod: 'refersToClassUnqualified
	<namespace: Refactory.Browser.Tests>
	^Refactory.Browser.Tests.ClassToRename')!

testRefersToClassUnqualifiedBinding
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := QualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToClassUnqualifiedBinding
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToClassUnqualifiedBinding)
		equals: (self
				parseMethod: 'refersToClassUnqualifiedBinding
	<namespace: Refactory.Browser.Tests>
	^#{Refactory.Browser.Tests.ClassToRename private}')!

testRefersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := QualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self
		assert: (refDataApp parseTreeFor: #refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation)
		equals: (self
				parseMethod: 'refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation
	<namespace: Refactory.Browser.Tests>
	^Refactory.Browser.Tests.ClassToRename')!

testRefersToDolphinTestPartiallyQualifiedBindingMethodNamespace
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := QualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToDolphinTestPartiallyQualifiedBindingMethodNamespace
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToDolphinTestPartiallyQualifiedBindingMethodNamespace)
		equals: (self
				parseMethod: 'refersToDolphinTestPartiallyQualifiedBindingMethodNamespace
	<namespace: Core>
	^#{Core.Tests.DolphinTest}')!

testRefersToImportedPoolConstantUnqualified
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := QualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToImportedPoolConstantUnqualified
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToImportedPoolConstantUnqualified)
		equals: (self parseMethod: 'refersToImportedPoolConstantUnqualified ^OS.CRTConstants.EINVAL')!

testRefersToOwnClassVariable
	| refactoring refDataApp |
	refDataApp := model classFor: RefactoryTestDataApp.
	refactoring := QualifyStaticVariablesRefactoring
				model: model
				rewriteMethod: #refersToOwnClassVariable
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #refersToOwnClassVariable)
		equals: (self parseMethod: 'refersToOwnClassVariable ^Refactory.Browser.TestData.RefactoryTestDataApp.ClassVar1')! !

!Refactory.Browser.Tests.QualifyStaticVariablesRefactoringTest categoriesForMethods!
testRefersToClassBindingNotFound!public! !
testRefersToClassConstantPartiallyQualified!public! !
testRefersToClassPartiallyQualified!public! !
testRefersToClassPartiallyQualifiedBinding!public! !
testRefersToClassPartiallyQualifiedBindingInArray!public! !
testRefersToClassUnqualified!public! !
testRefersToClassUnqualifiedBinding!public! !
testRefersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation!public! !
testRefersToDolphinTestPartiallyQualifiedBindingMethodNamespace!public! !
testRefersToImportedPoolConstantUnqualified!public! !
testRefersToOwnClassVariable!public! !
!

