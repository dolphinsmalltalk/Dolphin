"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.RenameMethodRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RenameMethodRefactoringTest guid: (Core.GUID fromString: '{56462b45-7329-483d-afc5-f1c199753156}')!
Refactory.Browser.Tests.RenameMethodRefactoringTest comment: ''!
!Refactory.Browser.Tests.RenameMethodRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RenameMethodRefactoringTest methodsFor!

setUp
	super setUp.
	model := RBModel onEnvironment: (BrowserEnvironment new
						forClasses: {Object. SmallInteger. OrderedCollection. DefaultSortAlgorithm})!

testExistingSelector
	self shouldFail: (RenameMethodRefactoring
				renameMethod: #checkClass:
				in: BasicLintRuleTestData
				to: #runOnEnvironment:
				permutation: (1 to: 1))
		withMessage: 'The selectors are not equivalent AND *LintRuleTestData or a subclass understands #runOnEnvironment:'!

testMultipleSelectors
	| subject optionCalled |
	"Constrain the refactoring to just the RBTestMethods package so that we get a known set of implementors"
	model := RBModel
				onEnvironment: (BrowserEnvironment new forPackages: {BasicLintRuleTestData owningPackage}).
	subject := RenameMethodRefactoring
				model: model
				renameMethod: #checkClass:
				in: BasicLintRuleTestData
				to: #foo:
				permutation: (1 to: 1).
	"In Dolphin 8 we no longer raise a warning for renames where there are multiple implementors because requesting option input allows for a better user experience"
	subject setOption: #renameAllDefinitions
		toUse: 
			[:ref :classes :selector |
			optionCalled := true.
			self assert: selector identicalTo: #checkClass:.
			{BasicLintRuleTestData. CompositeLintRuleTestData. LintRuleTestData}
				do: [:each | self assert: (classes includes: (subject model classFor: each))].
			false].
	self shouldAbort: subject.
	self assert: optionCalled!

testRenamePermuteArgs
	| refactoring class |
	refactoring := RenameMethodRefactoring
				renameMethod: ('rename:' , 'two:') asSymbol
				in: RefactoryTestDataApp
				to: ('rename:' , 'two:') asSymbol
				permutation: #(2 1).
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: RefactoryTestDataApp fullName.
	self assert: (class parseTreeFor: ('rename:' , 'two:') asSymbol)
		equals: (self parseMethod: 'rename: argumentMethod two: this ^self printString, this, argumentMethod').
	self assert: (class parseTreeFor: #exampleCall)
		equals: (self parseMethod: 'exampleCall ^self rename: 2 two: 1').
	self assert: (class parseTreeFor: #annotationReferenceTwo)
		equals: (self parseMethod: 'annotationReferenceTwo <rename: #bar two: #foo')!

testRenamePrimitive
	| refactoring count optionCalled refs |
	count := 0.
	count := (model allReferencesTo: #basicAt:put:) size.

	"Primitives can be renamed, as long as the argument count and order remains the same"
	refactoring := RenameMethodRefactoring
				model: model
				renameMethod: #basicAt:put:
				in: Object
				to: ('at:' , 'bar:') asSymbol
				permutation: (1 to: 2).
	optionCalled := false.
	refactoring setOption: #renameAllDefinitions
		toUse: 
			[:ref :classes :selector |
			optionCalled := true.
			self assert: selector identicalTo: #basicAt:put:.
			self assert: classes equals: (model allImplementorsOf: selector).
			true].
	self executeRefactoring: refactoring.
	self assert: optionCalled.
	refs := model allReferencesTo: #basicAt:put:.
	self assert: refs isEmpty description: 'All refs should have been rewritten'.
	refs := model allReferencesTo: ('at:' , 'bar:') asSymbol.
	self assert: refs size equals: count!

testRenameTestMethod
	| refactoring class |
	refactoring := RenameMethodRefactoring
				renameMethod: ('rename' , 'ThisMethod:') asSymbol
				in: RefactoryTestDataApp
				to: #renameThisMethod2:
				permutation: (1 to: 1).
	self executeRefactoring: refactoring.
	class := refactoring model classFor: RefactoryTestDataApp.
	self assert: (class parseTreeFor: #renameThisMethod2:)
		equals: (self parseMethod: 'renameThisMethod2: anArg
	^self').
	self assert: (class parseTreeFor: #callMethod)
		equals: (self parseMethod: 'callMethod
	^(self renameThisMethod2: 5)').
	self assert: (class parseTreeFor: #symbolReference)
		equals: (self parseMethod: 'symbolReference
		^ #(#renameThisMethod2: #(4 #renameThisMethod2:))').
	self assert: (class parseTreeFor: #annotationReference)
		equals: (self parseMethod: 'annotationReference <renameThisMethod2: #foo> ^self').
	self deny: (class directlyDefinesMethod: ('rename' , 'ThisMethod:') asSymbol)!

testRenameTestMethod1
	| refactoring class change |
	refactoring := RenameMethodRefactoring
				renameMethod: ('test' , 'Method1') asSymbol
				in: RefactoryTestDataApp
				to: #testMethod2
				permutation: (1 to: 0).
	self executeRefactoring: refactoring.
	class := refactoring model classFor: RefactoryTestDataApp.
	self assert: (class parseTreeFor: #testMethod2)
		equals: (self
				parseMethod: 'testMethod2 <namespace: Tools>
	^self testMethod2 , ([:each | each testMethod2] value: #(#(#testMethod2) 2 #testMethod2))').
	self assert: ((refactoring model classNamed: #'Refactory.Browser.TestData.BasicLintRuleTestData')
				parseTreeFor: #classBlock:)
		equals: (self parseMethod: 'classBlock: aBlock
	classBlock := aBlock testMethod2').
	self deny: (class directlyDefinesMethod: ('test' , 'Method1') asSymbol).
	change := refactoring model changes changes first.
	self assert: change package identicalTo: self class owningPackage.
	self assert: change environment identicalTo: Tools! !
!Refactory.Browser.Tests.RenameMethodRefactoringTest categoriesForMethods!
setUp!public!set up! !
testExistingSelector!failure tests!public! !
testMultipleSelectors!failure tests!public! !
testRenamePermuteArgs!public!tests! !
testRenamePrimitive!public!tests! !
testRenameTestMethod!public!tests! !
testRenameTestMethod1!public!tests! !
!

