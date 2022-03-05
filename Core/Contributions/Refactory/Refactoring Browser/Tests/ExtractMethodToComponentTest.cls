"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #ExtractMethodToComponentTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExtractMethodToComponentTest guid: (GUID fromString: '{8281473f-8cd8-45ac-ad39-f2858913ecae}')!
ExtractMethodToComponentTest comment: ''!
!ExtractMethodToComponentTest categoriesForClass!Refactory-Testing! !
!ExtractMethodToComponentTest methodsFor!

testBadInterval
	self
		shouldFail: (ExtractMethodToComponentRefactoring 
					extract: (self convertInterval: (24 to: 30)
							for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
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
							for: (BasicLintRuleTest class 
									sourceCodeAt: #subclassResponsibilityNotDefined))
					from: #subclassResponsibilityNotDefined
					in: BasicLintRuleTest class)!

testExtractMethodAtEndOfMethodThatNeedsReturn
	| refactoring class selectorsSize |
	refactoring := ExtractMethodToComponentRefactoring
				extract: (self convertInterval: (52 to: 182) for: (LintRuleTest sourceCodeAt: #openEditor))
				from: #openEditor
				in: LintRuleTest.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	self setupSelfArgumentNameFor: refactoring toReturn: 'asdf'.
	self setupVariableToMoveToFor: refactoring toReturn: 'rules'.
	self setupVariableTypesFor: refactoring
		toReturn: (Array with: (refactoring model classNamed: #Collection)).
	class := refactoring model classNamed: #LintRuleTest.
	selectorsSize := class selectors size.
	self proceedThroughWarning: [self executeRefactoring: refactoring].
	self assert: (class parseTreeFor: #openEditor)
		equals: (RBParser
				parseMethod: 'openEditor
								| rules |
								rules := self failedRules.
								^rules foo: self').
	self assert: ((refactoring model classNamed: #Collection) parseTreeFor: #foo:)
		equals: (RBParser
				parseMethod: 'foo: asdf
								self isEmpty ifTrue: [^asdf].
								self size == 1 ifTrue: [^self first viewResults].
								SmalllintResultEditor openOn: asdf label: asdf name.
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
	self setupVariableTypesFor: refactoring
		toReturn: (Array with: (refactoring model classNamed: #Dictionary)).
	class := refactoring model classNamed: #RBReadBeforeWrittenTester.
	selectorsSize := class selectors size.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #copyDictionary:)
		equals: (RBParser parseMethod: 'copyDictionary: aDictionary ^aDictionary copyWithAssociations').
	self assert: ((refactoring model classNamed: #Dictionary) parseTreeFor: #copyWithAssociations)
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
!ExtractMethodToComponentTest categoriesForMethods!
testBadInterval!failure tests!public! !
testExtractFailure!failure tests!public! !
testExtractMethodAtEndOfMethodThatNeedsReturn!public!tests! !
testMoveWithoutSelfReference!public!tests! !
testNonExistantSelector!failure tests!public! !
!

