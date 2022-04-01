"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RemoveImportRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RemoveImportRefactoringTest guid: (Core.GUID fromString: '{c5a25e16-ed38-40ce-9ab0-7d3b8c6ca8eb}')!
Refactory.Browser.Tests.RemoveImportRefactoringTest comment: ''!
!Refactory.Browser.Tests.RemoveImportRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RemoveImportRefactoringTest methodsFor!

testNonExistantImport
	"Note that RefactoringBrowserTest is currently importing TestData privately. Attempting to add it as a public import should also be considered a duplicate."

	self shouldFail: (RemoveImportRefactoring
				model: model
				removeImport: #{Refactory.Browser.TestData}
				from: self class)
		withMessage: self class printString , ' does not directly import #{Refactory.Browser.TestData}'!

testRemoveImport
	| class subject bindingRef importsBefore |
	class := model classFor: RefactoryTestDataApp.
	bindingRef := #{OS.CRTConstants}.
	self assert: (class directlyImportsNamespace: bindingRef).
	subject := RemoveImportRefactoring
				model: model
				removeImport: bindingRef
				from: class.
	importsBefore := class imports.
	self executeRefactoring: subject.
	self deny: (class directlyImportsNamespace: bindingRef).
	self assert: class imports equals: (importsBefore copyWithout: (bindingRef referenceInModel: model)).
	"With the import removed, any refs to its variables will have to be fully qualified now"
	self
		verifyMethod: #refersToImportedPoolConstantUnqualified
		of: class
		equals: '<1s> ^OS.CRTConstants.EINVAL' << #refersToImportedPoolConstantUnqualified.
	self
		verifyMethod: #refersToImportedPoolConstantBindingUnqualified
		of: class
		equals: '<1s> ^#{OS.CRTConstants.EINVAL}' << #refersToImportedPoolConstantBindingUnqualified.
	"Fully-qualified binding reference should have been left unchanged"
	self assertIsNil: (model changes changeForClassNamed: RefactoryTestDataApp fullyQualifiedReference
				selector: #refersToPoolConstantBindingFullyQualified)! !
!Refactory.Browser.Tests.RemoveImportRefactoringTest categoriesForMethods!
testNonExistantImport!public! !
testRemoveImport!public! !
!

