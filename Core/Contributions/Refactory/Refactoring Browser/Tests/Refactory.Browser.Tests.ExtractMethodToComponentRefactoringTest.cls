"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.ExtractMethodToComponentRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ExtractMethodToComponentRefactoringTest guid: (Core.GUID fromString: '{8281473f-8cd8-45ac-ad39-f2858913ecae}')!
Refactory.Browser.Tests.ExtractMethodToComponentRefactoringTest comment: ''!
!Refactory.Browser.Tests.ExtractMethodToComponentRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ExtractMethodToComponentRefactoringTest methodsFor!

testBadInterval
	self
		shouldFail: (ExtractMethodToComponentRefactoring
					extract: (self convertInterval: (24 to: 30) for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					from: #testMethod
					in: RefactoryTestDataApp)
			withMessage: 'Invalid interval';
		shouldFail: (ExtractMethodToComponentRefactoring
					extract: (self convertInterval: (80 to: 147)
							for: (BasicLintRuleTestData class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTestData class)
			withMessage: 'Invalid source to extract'!

testExtractFailure
	self
		shouldFail: (ExtractMethodToComponentRefactoring
					extract: (self convertInterval: (80 to: 269)
							for: (BasicLintRuleTestData class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTestData class)
			withMessage: 'Couldn''t extract code since it contains a return.';
		shouldFail: (ExtractMethodToComponentRefactoring
					extract: (self convertInterval: (53 to: 56)
							for: (BasicLintRuleTestData class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTestData class)
			withMessage: 'Cannot extract left hand side of an assignment';
		shouldFail: (ExtractMethodToComponentRefactoring
					extract: (self convertInterval: (77 to: 222)
							for: (BasicLintRuleTestData class sourceCodeAt: #subclassResponsibilityNotDefined))
					from: #subclassResponsibilityNotDefined
					in: BasicLintRuleTestData class)
			withMessage: 'Cannot extract assignment without all references: #(detector subclassResponsibilitySymbol)'!

testExtractMethodAtEndOfMethodThatNeedsReturn
	| refactoring class selectorsSize |
	refactoring := ExtractMethodToComponentRefactoring
				extract: (73 to: 184)
				from: #openEditor
				in: LintRuleTestData.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	self setupSelfArgumentNameFor: refactoring toReturn: 'asdf'.
	self setupVariableToMoveToFor: refactoring toReturn: 'rules'.
	self setupVariableTypesFor: refactoring
		toReturn: {refactoring model classNamed: Collection fullName}.
	class := refactoring model classFor: LintRuleTestData.
	selectorsSize := class selectors size.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #openEditor)
		equals: (self
				parseMethod: 'openEditor
								<namespace: Tools>
								| rules |
								rules := self failedRules.
								^rules foo: self').
	self assert: ((refactoring model classNamed: Collection fullName) parseTreeFor: #foo:)
		equals: (self
				parseMethod: 'foo: asdf
								<namespace: Tools>
								self isEmpty ifTrue: [^asdf].
								self size == 1 ifTrue: [^self first viewResults].
								asdf result openEditor.
								^asdf').
	self assert: class selectors size equals: selectorsSize!

testMoveToDifferentNamespace
	| refactoring source componentClass2 class componentClass1 componentClass3 |
	model := RBModel new.
	class := model classFor: LintRuleTestData.
	source := (class methodFor: #runOnEnvironment:) source.
	refactoring := ExtractMethodToComponentRefactoring
				model: model
				extract: ((source indexOf: $^) + 1 to: source size)
				from: #runOnEnvironment:
				in: class.
	self setupMethodNameFor: refactoring toReturn: #runRule:.
	self setupVariableToMoveToFor: refactoring toReturn: 'anEnvironment'.
	self setupSelfArgumentNameFor: refactoring toReturn: 'aLintRuleTestData'.
	componentClass1 := model classFor: BrowserEnvironment.
	componentClass2 := model classFor: Kernel class.
	componentClass3 := model classFor: Refactory.
	self setupVariableTypesFor: refactoring
		toReturn: {componentClass1. componentClass2. componentClass3}.
	self executeRefactoring: refactoring.
	self
		verifyMethod: #runOnEnvironment:
		of: class
		equals: 'runOnEnvironment: anEnvironment ^anEnvironment runRule: self'.
	self
		verifyMethod: #runRule:
		of: componentClass1
		equals: 'runRule: aLintRuleTestData  ^Smalllint runRule: (#{BlockLintRule} value perform: aLintRuleTestData name) onEnvironment: self'.
	self
		verifyMethod: #runRule:
		of: componentClass2
		equals: 'runRule: aLintRuleTestData  ^Refactory.Browser.Smalllint runRule: (#{Refactory.Browser.BlockLintRule} value perform: aLintRuleTestData name) onEnvironment: self'.
	self
		verifyMethod: #runRule:
		of: componentClass3
		equals: 'runRule: aLintRuleTestData  ^Browser.Smalllint runRule: (#{Refactory.Browser.BlockLintRule} value perform: aLintRuleTestData name) onEnvironment: self'!

testMoveWithoutSelfReference
	| refactoring class selectorsSize |
	refactoring := ExtractMethodToComponentRefactoring
				extract: (self convertInterval: (118 to: 285)
						for: (RBReadBeforeWrittenTester sourceCodeAt: #copyDictionary:))
				from: #copyDictionary:
				in: RBReadBeforeWrittenTester.
	self setupMethodNameFor: refactoring toReturn: #copyWithAssociations.
	self setupVariableToMoveToFor: refactoring toReturn: 'aDictionary'.
	self setupVariableTypesFor: refactoring
		toReturn: {refactoring model classNamed: Dictionary fullName}.
	class := refactoring model classNamed: #'Refactory.Browser.RBReadBeforeWrittenTester'.
	selectorsSize := class selectors size.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #copyDictionary:)
		equals: (self parseMethod: 'copyDictionary: aDictionary ^aDictionary copyWithAssociations').
	self
		assert: ((refactoring model classNamed: Dictionary fullName) parseTreeFor: #copyWithAssociations)
		equals: (self
				parseMethod: 'copyWithAssociations 
							| newDictionary |
							newDictionary := Dictionary new: self size.
							self
								keysAndValuesDo: [:key :value | newDictionary at: key put: value].
							^newDictionary').
	self assert: class selectors size equals: selectorsSize!

testNonExistantSelector
	self shouldFail: (ExtractMethodToComponentRefactoring
				extract: (10 to: 20)
				from: #checkClass1:
				in: BasicLintRuleTestData)
		withMessage: 'BasicLintRuleTestData does not define #checkClass1:'! !
!Refactory.Browser.Tests.ExtractMethodToComponentRefactoringTest categoriesForMethods!
testBadInterval!failure tests!public! !
testExtractFailure!failure tests!public! !
testExtractMethodAtEndOfMethodThatNeedsReturn!public!tests! !
testMoveToDifferentNamespace!public!tests! !
testMoveWithoutSelfReference!public!tests! !
testNonExistantSelector!failure tests!public! !
!

