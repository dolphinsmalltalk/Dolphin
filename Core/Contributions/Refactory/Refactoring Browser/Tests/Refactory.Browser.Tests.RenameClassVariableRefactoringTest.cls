"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.RenameClassVariableRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RenameClassVariableRefactoringTest guid: (Core.GUID fromString: '{5d45357d-1056-4b27-b1a1-1df41ee18851}')!
Refactory.Browser.Tests.RenameClassVariableRefactoringTest comment: ''!
!Refactory.Browser.Tests.RenameClassVariableRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RenameClassVariableRefactoringTest methodsFor!

testAlreadyExistingName
	self shouldFail: (RenameClassVariableRefactoring
				rename: #RecursiveSelfRule
				to: self objectClassVariable
				in: TransformationRuleTestData)
		withMessage: 'TransformationRuleTestData or one of its subclasses defines variable ''_EventsRegister'''!

testMetaClassFailure
	self shouldFail: (RenameClassVariableRefactoring
				rename: #RecursiveSelfRule
				to: #Foo
				in: TransformationRuleTestData class)
		withMessage: 'TransformationRuleTestData class is a metaclass'!

testNonExistantName
	self shouldFail: (RenameClassVariableRefactoring
				rename: #foo
				to: #newFoo
				in: BasicLintRuleTestData)
		withMessage: '''newFoo'' is not a valid class variable name'!

testRenameClassVar
	| refactoring class |
	refactoring := RenameClassVariableRefactoring
				rename: #RecursiveSelfRule
				to: #RSR
				in: TransformationRuleTestData.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: TransformationRuleTestData fullName.
	self assert: (class directlyDefinesClassVariable: #RSR).
	self deny: (class directlyDefinesClassVariable: #RecursiveSelfRule).
	self assert: (class metaclass parseTreeFor: #initializeAfterLoad1)
		equals: (self
				parseMethod: 'initializeAfterLoad1
								RSR := ParseTreeSearcher new.
								RSR
									addMethodSearches: #(''`@methodName: `@args | `@temps | self `@methodName: `@args'' ''`@methodName: `@args | `@temps | ^self `@methodName: `@args'')
											-> [:aNode :answer | true]').
	self assert: (class metaclass parseTreeFor: #nuke)
		equals: (self parseMethod: 'nuke
								RSR := nil').
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (self
				parseMethod: 'checkMethod: aSmalllintContext 
								class := aSmalllintContext selectedClass.
								(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
										[(RSR executeTree: rewriteRule tree initialAnswer: false)
											ifFalse: 
												[builder compile: rewriteRule tree printString
													in: class
													categories: aSmalllintContext protocols]]')!

testRenameClassVarWithExternalReferences
	"Class variables/constants can be referenced from classes outside the defined hierarchy (external classes) by using qualified names. These references must also be updated."

	| refactoring class externalClass subclass |
	refactoring := RenameClassVariableRefactoring
				rename: 'ClassVar1'
				to: 'CV1'
				in: ClassToRename.
	subclass := refactoring model classFor: SubclassOfClassToRename.
	subclass
		compile: 'refersToInheritedClassVariableWithShadowing 
	| CV1 |
	CV1 :=  ClassToRename.ClassVar1, SubclassOfClassToRename.ClassVar1.
	^CV1'.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: ClassToRename.
	self assert: (class directlyDefinesClassVariable: 'CV1').
	self deny: (class directlyDefinesClassVariable: 'ClassVar1').
	self
		verifyMethod: #refersToOwnClassVariable
		of: class
		equals: 'refersToOwnClassVariable ^CV1'.
	self
		verifyMethod: #initialize
		of: class metaclass
		equals: 'initialize CV1 := ''ClassVar1 of ClassToRename'''.
	#(#refersToInheritedClassVariable #refersToInheritedClassVariableQualifiedByOwnName #refersToInheritedClassVariableFullyQualified)
		do: 
			[:each |
			self
				verifyMethod: each
				of: subclass
				equals: '<1s> ^CV1' << each].
	self
		verifyMethod: #refersToInheritedClassVariableFullyQualifiedBinding
		of: subclass
		equals: 'refersToInheritedClassVariableFullyQualifiedBinding ^#{Refactory.Browser.Tests.ClassToRename.CV1}'.
	self
		verifyMethod: #refersToInheritedClassVariableWithShadowing
		of: subclass
		equals: 'refersToInheritedClassVariableWithShadowing 
	| CV1 |
	CV1 :=  ClassToRename.CV1, ClassToRename.CV1.
	^CV1'.
	"Ref from a class outside the hierarchy where the class var is defined - this is legal if the variable is not marked exp[icitly as private"
	externalClass := refactoring model classFor: RefactoryTestDataApp.
	#(#refersToClassVariablePartiallyQualified #refersToClassVariableFullyQualified) do: 
			[:each |
			self
				verifyMethod: each
				of: externalClass
				equals: '<1s> ^Tests.ClassToRename.CV1' << each].
	self
		verifyMethod: #refersToClassVariablePartiallyQualifiedBinding
		of: externalClass
		equals: 'refersToClassVariablePartiallyQualifiedBinding ^#{_.Tests.ClassToRename.CV1} binding'! !
!Refactory.Browser.Tests.RenameClassVariableRefactoringTest categoriesForMethods!
testAlreadyExistingName!failure tests!public! !
testMetaClassFailure!failure tests!public! !
testNonExistantName!failure tests!public! !
testRenameClassVar!public!tests! !
testRenameClassVarWithExternalReferences!public!tests! !
!

