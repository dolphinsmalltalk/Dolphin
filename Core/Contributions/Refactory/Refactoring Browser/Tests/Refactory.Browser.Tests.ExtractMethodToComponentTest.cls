"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.ExtractMethodToComponentTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ExtractMethodToComponentTest guid: (Core.GUID fromString: '{8281473f-8cd8-45ac-ad39-f2858913ecae}')!
Refactory.Browser.Tests.ExtractMethodToComponentTest comment: ''!
!Refactory.Browser.Tests.ExtractMethodToComponentTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ExtractMethodToComponentTest methodsFor!

testBadInterval
	self
		shouldFail: (ExtractMethodToComponentRefactoring
					extract: (self convertInterval: (24 to: 30) for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					from: #testMethod
					in: RefactoryTestDataApp);
		shouldFail: (ExtractMethodToComponentRefactoring
					extract: (self convertInterval: (80 to: 147)
							for: (BasicLintRuleTest class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTest class)!

testExtractFailure
	self
		shouldFail: (ExtractMethodToComponentRefactoring
					extract: (self convertInterval: (80 to: 269)
							for: (BasicLintRuleTest class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTest class);
		shouldFail: (ExtractMethodToComponentRefactoring
					extract: (self convertInterval: (53 to: 56)
							for: (BasicLintRuleTest class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTest class);
		shouldFail: (ExtractMethodToComponentRefactoring
					extract: (self convertInterval: (77 to: 222)
							for: (BasicLintRuleTest class sourceCodeAt: #subclassResponsibilityNotDefined))
					from: #subclassResponsibilityNotDefined
					in: BasicLintRuleTest class)!

testExtractMethodAtEndOfMethodThatNeedsReturn
	| refactoring class selectorsSize |
	refactoring := ExtractMethodToComponentRefactoring
				extract: (73 to: 216)
				from: #openEditor
				in: LintRuleTest.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	self setupSelfArgumentNameFor: refactoring toReturn: 'asdf'.
	self setupVariableToMoveToFor: refactoring toReturn: 'rules'.
	self setupVariableTypesFor: refactoring
		toReturn: {refactoring model classNamed: Collection fullName}.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.LintRuleTest'.
	selectorsSize := class selectors size.
	self proceedThroughWarning: [self executeRefactoring: refactoring].
	self assert: (class parseTreeFor: #openEditor)
		equals: (RBParser
				parseMethod: 'openEditor
								<namespace: Tools>
								| rules |
								rules := self failedRules.
								^rules foo: self').
	self assert: ((refactoring model classNamed: Collection fullName) parseTreeFor: #foo:)
		equals: (RBParser
				parseMethod: 'foo: asdf
								<namespace: Tools>
								self isEmpty ifTrue: [^asdf].
								self size == 1 ifTrue: [^self first viewResults].
								SmalltalkSystem current browseEnvironment: asdf result.
								^asdf').
	self assert: class selectors size equals: selectorsSize!

testMoveWithoutSelfReference
	| refactoring class selectorsSize |
	refactoring := ExtractMethodToComponentRefactoring
				extract: (self convertInterval: (118 to: 285)
						for: (RBReadBeforeWrittenTester sourceCodeAt: #copyDictionary:))
				from: #copyDictionary:
				in: RBReadBeforeWrittenTester.
	self setupMethodNameFor: refactoring toReturn: #copyWithAssociations.
	self setupVariableToMoveToFor: refactoring toReturn: 'aDictionary'.
	self setupVariableTypesFor: refactoring toReturn: {refactoring model classNamed: Dictionary fullName}.
	class := refactoring model classNamed: #'Refactory.Browser.RBReadBeforeWrittenTester'.
	selectorsSize := class selectors size.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #copyDictionary:)
		equals: (RBParser parseMethod: 'copyDictionary: aDictionary ^aDictionary copyWithAssociations').
	self assert: ((refactoring model classNamed: Dictionary fullName) parseTreeFor: #copyWithAssociations)
		equals: (RBParser
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
				in: BasicLintRuleTest)! !
!Refactory.Browser.Tests.ExtractMethodToComponentTest categoriesForMethods!
testBadInterval!failure tests!public! !
testExtractFailure!failure tests!public! !
testExtractMethodAtEndOfMethodThatNeedsReturn!public!tests! !
testMoveWithoutSelfReference!public!tests! !
testNonExistantSelector!failure tests!public! !
!

