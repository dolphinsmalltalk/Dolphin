"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.RenameMethodReferencesTransformationTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RenameMethodReferencesTransformationTest guid: (Core.GUID fromString: '{56462b45-7329-483d-afc5-f1c199753156}')!
Refactory.Browser.Tests.RenameMethodReferencesTransformationTest comment: ''!
!Refactory.Browser.Tests.RenameMethodReferencesTransformationTest methodsFor!

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

testRenamePermuteArgs
	| refactoring class selector |
	selector := ('rename:' , 'two:') asSymbol.
	refactoring := RenameMethodReferencesTransformation
				renameMethod: selector
				in: RefactoryTestDataApp
				to: selector
				permutation: #(2 1).
	"Suppress the warning that this is a transformation, not a refactoring"
	refactoring setOption: #replaceReferences toUse: [true].
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: RefactoryTestDataApp fullName.
	"The method itself is unaffected"
	self assert: (class parseTreeFor: selector)
		equals: (self parseMethod: (RefactoryTestDataApp >> selector) getSource).
	"But the arguments should be permuted at the call sites"
	self assert: (class parseTreeFor: #exampleCall)
		equals: (self parseMethod: 'exampleCall ^self rename: 2 two: 1').
	self assert: (class parseTreeFor: #annotationReferenceTwo)
		equals: (self parseMethod: 'annotationReferenceTwo <rename: #bar two: #foo>')!

testRenameReferences
	| refactoring class srcSelector targetSelector |
	srcSelector := ('rename' , 'ThisMethod:') asSymbol.
	targetSelector := #inlineFoo:.
	refactoring := RenameMethodReferencesTransformation
				renameMethod: srcSelector
				in: RefactoryTestDataApp
				to: targetSelector
				permutation: (1 to: 1).
	"Suppress the warning that this is a transformation, not a refactoring"
	refactoring setOption: #replaceReferences toUse: [true].
	self executeRefactoring: refactoring.
	class := refactoring model classFor: RefactoryTestDataApp.
	self assert: (class sourceCodeFor: srcSelector) equals: (RefactoryTestDataApp >> srcSelector) getSource.
	self assert: (class parseTreeFor: #callMethod)
		equals: (self parseMethod: 'callMethod
	^(self <1d> 5)' << targetSelector).
	self assert: (class parseTreeFor: #symbolReference)
		equals: (self parseMethod: 'symbolReference
		^ #(<1p> #(4 <1p>))' << targetSelector).
	self assert: (class parseTreeFor: #annotationReference)
		equals: (self parseMethod: 'annotationReference %<<1d> #foo> ^self' << targetSelector).
	self assert: (class directlyDefinesMethod: ('rename' , 'ThisMethod:') asSymbol)!

testRenameReferences1
	| refactoring class srcSelector targetSelector |
	srcSelector := ('test' , 'Method1') asSymbol.
	targetSelector := #testMethod.
	refactoring := RenameMethodReferencesTransformation
				renameMethod: srcSelector
				in: RefactoryTestDataApp
				to: targetSelector
				permutation: (1 to: 0).
	"Suppress the warning that this is a transformation, not a refactoring"
	refactoring setOption: #replaceReferences toUse: [true].
	self executeRefactoring: refactoring.
	class := refactoring model classFor: RefactoryTestDataApp.
	self assert: (class directlyDefinesMethod: srcSelector).
	self assert: (class parseTreeFor: srcSelector)
		equals: (self
				parseMethod: '<1d> %<namespace: Tools>
	^self <2d> , ([:each | each <2d>] value: #(#(<2p>) 2 <2p>))'
						<< { srcSelector. targetSelector }).
	self assert: ((refactoring model classNamed: #'Refactory.Browser.TestData.BasicLintRuleTestData')
				parseTreeFor: #classBlock:)
		equals: (self parseMethod: 'classBlock: aBlock
	classBlock := aBlock <1d>' << targetSelector)!

testTargetMissing
	"A precondition is that the target to which references are renamed should be defined"

	self shouldFail: (RenameMethodReferencesTransformation
				renameMethod: #checkClass:
				in: BasicLintRuleTestData
				to: #checkClass2:
				permutation: (1 to: 1))
		withMessage: 'BasicLintRuleTestData and all subclasses do not understand #checkClass2:'! !
!Refactory.Browser.Tests.RenameMethodReferencesTransformationTest categoriesForMethods!
setUp!public!set up! !
testExistingSelector!failure tests!public! !
testRenamePermuteArgs!public!tests! !
testRenameReferences!public!tests! !
testRenameReferences1!public!tests! !
testTargetMissing!failure tests!public! !
!

