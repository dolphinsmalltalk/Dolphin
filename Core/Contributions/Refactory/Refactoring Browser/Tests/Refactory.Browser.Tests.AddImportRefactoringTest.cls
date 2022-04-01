"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.AddImportRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddImportRefactoringTest guid: (Core.GUID fromString: '{22a8d5c2-2eb1-4d2a-a7e5-6987f758d87e}')!
Refactory.Browser.Tests.AddImportRefactoringTest comment: ''!
!Refactory.Browser.Tests.AddImportRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AddImportRefactoringTest methodsFor!

testAddImport
	| class subject bindingRef importsBefore |
	class := model classFor: RefactoryTestDataApp.
	bindingRef := #{Refactory.Browser.Tests private}.
	self deny: (class importsNamespace: bindingRef).
	subject := AddImportRefactoring
				model: model
				addImport: bindingRef
				to: class.
	importsBefore := class imports.
	self executeRefactoring: subject.
	self assert: (class directlyImportsNamespace: bindingRef).
	self assert: class imports equals: (importsBefore copyWith: (bindingRef referenceInModel: model)).
	#(#refersToClassFullyQualified #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2)
		do: 
			[:each |
			self
				verifyMethod: each
				of: class
				equals: '<1s> ^ClassToRename' << each].
	"We do expect that the partially qualified namespace annotation is rewritten, as they should be fully-qualified, even though this method doesn't striclty need to be rewritten as part of this refactoring."
	self
		verifyMethod: #refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation
		of: class
		equals: 'refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation <namespace: Refactory.Browser.Tests> ^ClassToRename'.
	"However there shouldn't be any change if for namespace annotations that are already fully qualified."
	self assertIsNil: (model changes changeForClassNamed: class fullyQualifiedReference
				selector: #refersToClassUnqualified).
	"Also class side"
	self
		verifyMethod: #refersToClassPartiallyQualified1
		of: class metaclass
		equals: 'refersToClassPartiallyQualified1 ^ClassToRename'.
	#(#refersToClassVariableFullyQualified #refersToClassVariablePartiallyQualified) do: 
			[:each |
			self
				verifyMethod: each
				of: class
				equals: '<1s> ^ClassToRename.ClassVar1' << each].
	"Should not have needed to rewrite other global references, e.g. to Smalltalk or Transcript"
	#(#smalltalkAtIfAbsent #called:on1:) do: 
			[:each |
			self assertIsNil: (model changes changeForClassNamed: class fullyQualifiedReference selector: each)].
	#(#classSideGlobalRef) do: 
			[:each |
			self assertIsNil: (model changes changeForClassNamed: class metaclass fullyQualifiedReference
						selector: each)]!

testExistingImport
	"Note that RefactoringBrowserTest is currently importing TestData privately. Attempting to add it as a public import should also be considered a duplicate."

	| class |
	class := model classFor: self class.
	self assert: (class importsNamespace: #{Refactory.Browser.TestData}).
	self shouldFail: (AddImportRefactoring
				model: model
				addImport: #{Refactory.Browser.TestData}
				to: class)
		withMessage: class printString , ' already imports #{Refactory.Browser.TestData}'!

testImportClassVar
	self shouldFail: (AddImportRefactoring
				model: model
				addImport: #{Object._EventsRegister}
				to: self class)
		withMessage: '#{Object._EventsRegister} does not refer to a defined class binding'!

testImportPool
	| class subject bindingRef importsBefore |
	class := model classFor: RefactoryTestDataApp.
	bindingRef := #{OS.Win32Constants}.
	self deny: (class importsNamespace: bindingRef).
	subject := AddImportRefactoring
				model: model
				addImport: bindingRef
				to: class.
	importsBefore := class imports.
	self executeRefactoring: subject.
	self assert: (class directlyImportsNamespace: bindingRef).
	self assert: class imports equals: (importsBefore copyWith: (bindingRef referenceInModel: model)).
	self
		verifyMethod: #refersToPoolConstantFullyQualified
		of: class
		equals: '<1s> ^COLOR_DESKTOP' << #refersToPoolConstantFullyQualified.
	"Fully-qualified binding reference should have been left unchanged"
	self assertIsNil: (model changes changeForClassNamed: RefactoryTestDataApp fullyQualifiedReference selector: #refersToPoolConstantBindingFullyQualified)!

testRootNotImportable
	self shouldFail: (AddImportRefactoring
				model: model
				addImport: #{Root}
				to: self class)
		withMessage: 'Root is not an importable namespace'!

testUndefinedImport
	self shouldFail: (AddImportRefactoring
				model: model
				addImport: #{Core.Blah}
				to: self class)
		withMessage: '#{Core.Blah} does not refer to a defined class binding'! !
!Refactory.Browser.Tests.AddImportRefactoringTest categoriesForMethods!
testAddImport!public! !
testExistingImport!public! !
testImportClassVar!public! !
testImportPool!public! !
testRootNotImportable!public! !
testUndefinedImport!public! !
!

