"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.ExpandImportsRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ExpandImportsRefactoringTest guid: (Core.GUID fromString: '{80dc1f93-4069-41fa-9050-c78718fcbf76}')!
Refactory.Browser.Tests.ExpandImportsRefactoringTest comment: ''!
!Refactory.Browser.Tests.ExpandImportsRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ExpandImportsRefactoringTest methodsFor!

testExpandImports
	| opcodes bytecodeDispatcher subject thisClass |
	opcodes := model classFor: OpcodePool.
	bytecodeDispatcher := model classFor: ByteCodeDispatcher.
	thisClass := model classFor: self class.
	self deny: (thisClass imports includes: opcodes asQualifiedReference).
	subject := ExpandImportsRefactoring
				model: model
				forMethod: (bytecodeDispatcher metaclass parseTreeFor: #initialize)
				fromClass: ByteCodeDispatcher
				toClasses: {thisClass}.
	subject setOption: #movePools toUse: [:rename :pools | true].
	self executeRefactoring: subject.
	self assert: (thisClass imports includes: opcodes asQualifiedReference)! !
!Refactory.Browser.Tests.ExpandImportsRefactoringTest categoriesForMethods!
testExpandImports!public! !
!

