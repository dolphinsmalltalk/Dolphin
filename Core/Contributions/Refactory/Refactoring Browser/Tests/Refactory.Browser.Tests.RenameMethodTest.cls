"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RenameMethodTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RenameMethodTest guid: (Core.GUID fromString: '{56462b45-7329-483d-afc5-f1c199753156}')!
Refactory.Browser.Tests.RenameMethodTest comment: ''!
!Refactory.Browser.Tests.RenameMethodTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RenameMethodTest methodsFor!

setUp
	super setUp.
	model := RBNamespace onEnvironment: (BrowserEnvironment new
						forClasses: {Object. SmallInteger. OrderedCollection. Kernel.DefaultSortAlgorithm})!

testExistingSelector
	self shouldFail: (RenameMethodRefactoring
				renameMethod: #checkClass:
				in: BasicLintRuleTestData
				to: #runOnEnvironment:
				permutation: (1 to: 1))!

testMultipleSelectors
	| subject implementors |
	"Constrain the refactoring to just the RBTestMethods package so that we get a known set of implementors"
	model := RBNamespace
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
			implementors := classes.
			false].
	self should: [self executeRefactoring: subject] raise: OperationAborted.
	{Refactory.Browser.Tests.BasicLintRuleTestData.
		Refactory.Browser.Tests.CompositeLintRuleTestData.
		Refactory.Browser.Tests.LintRuleTestData}
			do: [:each | self assert: (implementors includes: (subject model classFor: each))]!

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
		equals: (self parseMethod: 'exampleCall ^self rename: 2 two: 1')!

testRenamePrimitive
	| refactoring count |
	count := 0.
	model allReferencesTo: #basicAt:put: do: [:method | count := count + 1].
	"Primitives can be renamed, as long as the argument count and order remains the same"
	refactoring := RenameMethodRefactoring
				model: model
				renameMethod: #basicAt:put:
				in: Object
				to: ('at:' , 'bar:') asSymbol
				permutation: (1 to: 2).
	refactoring setOption: #renameAllDefinitions toUse: [:ref :classes :selector | true].
	self executeRefactoring: refactoring.
	"All refs should have been rewritten"
	model allReferencesTo: #basicAt:put: do: [:method | self assert: false].
	model allReferencesTo: ('at:' , 'bar:') asSymbol do: [:method | count := count - 1].
	self assert: count equals: 0!

testRenameTestMethod
	| refactoring class |
	refactoring := RenameMethodRefactoring
				renameMethod: ('rename' , 'ThisMethod:') asSymbol
				in: RefactoryTestDataApp
				to: #renameThisMethod2:
				permutation: (1 to: 1).
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp'.
	self assert: (class parseTreeFor: #renameThisMethod2:)
		equals: (self parseMethod: 'renameThisMethod2: anArg
	^self').
	self assert: (class parseTreeFor: #callMethod)
		equals: (self parseMethod: 'callMethod
	^(self renameThisMethod2: 5)').
	self assert: (class parseTreeFor: #symbolReference)
		equals: (self parseMethod: 'symbolReference
		^ #(#renameThisMethod2: #(4 #renameThisMethod2:))').
	self deny: (class directlyDefinesMethod: ('rename' , 'ThisMethod:') asSymbol)!

testRenameTestMethod1
	| refactoring class change |
	refactoring := RenameMethodRefactoring
				renameMethod: ('test' , 'Method1') asSymbol
				in: RefactoryTestDataApp
				to: #testMethod2
				permutation: (1 to: 0).
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp'.
	self assert: (class parseTreeFor: #testMethod2)
		equals: (self
				parseMethod: 'testMethod2 <namespace: Tools>
	^self testMethod2 , ([:each | each testMethod2] value: #(#(#testMethod2) 2 #testMethod2))').
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.BasicLintRuleTestData')
				parseTreeFor: #classBlock:)
		equals: (self parseMethod: 'classBlock: aBlock
	classBlock := aBlock testMethod2').
	self deny: (class directlyDefinesMethod: ('test' , 'Method1') asSymbol).
	change := refactoring model changes changes first.
	self assert: change package identicalTo: self class owningPackage.
	self assert: change environment identicalTo: Tools! !
!Refactory.Browser.Tests.RenameMethodTest categoriesForMethods!
setUp!public!set up! !
testExistingSelector!failure tests!public! !
testMultipleSelectors!failure tests!public! !
testRenamePermuteArgs!public!tests! !
testRenamePrimitive!public!tests! !
testRenameTestMethod!public!tests! !
testRenameTestMethod1!public!tests! !
!

