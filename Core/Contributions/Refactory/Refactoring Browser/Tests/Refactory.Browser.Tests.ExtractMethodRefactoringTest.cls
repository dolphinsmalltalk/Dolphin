"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.ExtractMethodRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.ExtractMethodRefactoringTest guid: (Core.GUID fromString: '{e6d6d232-8068-4ed9-97f4-59b812529daf}')!
Refactory.Browser.Tests.ExtractMethodRefactoringTest comment: ''!
!Refactory.Browser.Tests.ExtractMethodRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.ExtractMethodRefactoringTest methodsFor!

testBadInterval
	self
		shouldFail: (ExtractMethodRefactoring
					extract: (self convertInterval: (24 to: 30) for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					from: #testMethod
					in: RefactoryTestDataApp)
			withMessage: 'Invalid interval';
		shouldFail: (ExtractMethodRefactoring
					extract: (self convertInterval: (80 to: 147)
							for: (BasicLintRuleTestData class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTestData class)
			withMessage: 'Invalid source to extract'!

testExtractBindingReference
	| method source refactoring class start stop |
	method := RefactoryTestDataApp compiledMethodAt: #refersToClassVariablePartiallyQualifiedBinding.
	source := method getSource.
	start := source indexOf: $#.
	stop := source
				nextIndexOf: $}
				from: start
				to: source size.
	refactoring := ExtractMethodRefactoring
				extract: (start to: stop)
				from: method selector
				in: method methodClass.
	self setupMethodNameFor: refactoring toReturn: #foo.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: method methodClass.
	self assert: (class parseTreeFor: #foo)
		equals: (self parseMethod: 'foo ^#{_.Tests.ClassToRename.ClassVar1} ').
	self assert: (class parseTreeFor: method selector)
		equals: (self parseMethod: '<1s> ^self foo binding' << method selector)!

testExtractFailure
	self
		shouldFail: (ExtractMethodRefactoring
					extract: (self convertInterval: (80 to: 269)
							for: (BasicLintRuleTestData class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTestData class)
			withMessage: 'Couldn''t extract code since it contains a return.';
		shouldFail: (ExtractMethodRefactoring
					extract: (self convertInterval: (53 to: 56)
							for: (BasicLintRuleTestData class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTestData class)
			withMessage: 'Cannot extract left hand side of an assignment';
		shouldFail: (ExtractMethodRefactoring
					extract: (self convertInterval: (77 to: 222)
							for: (BasicLintRuleTestData class sourceCodeAt: #subclassResponsibilityNotDefined))
					from: #subclassResponsibilityNotDefined
					in: BasicLintRuleTestData class)
			withMessage: 'Cannot extract assignment without all references: #(detector subclassResponsibilitySymbol)'!

testExtractFromMethodInCustomNamespace
	| method source refactoring class start stop rectangleMetaclass selector extractedMethod |
	rectangleMetaclass := #{Graphics.Rectangle class} value.
	method := rectangleMetaclass compiledMethodAt: #publishedAspectsOfInstances.
	self assert: method environment equals: Tools.
	source := method getSource.
	start := source indexOf: $(.
	stop := source
				nextIndexOf: $;
				from: start
				to: source size.
	refactoring := ExtractMethodRefactoring
				extract: (method parseTree bestNodeFor: (start to: stop)) parent sourceInterval
				from: #publishedAspectsOfInstances
				in: rectangleMetaclass.
	selector := 'topAspect' asSymbol.
	self setupMethodNameFor: refactoring toReturn: selector.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Graphics.Rectangle'.
	self assert: (class metaclass parseTreeFor: #publishedAspectsOfInstances)
		equals: (self
				parseMethod: 'publishedAspectsOfInstances
	"Answer a <LookupTable> of the <Aspect>s published by instances of the receiver."

	^super publishedAspectsOfInstances
		add: self topAspect;
		add: ((Aspect integer: #left)
					defaultValue: 0;
					yourself);
		add: ((Aspect integer: #bottom)
					defaultValue: 0;
					yourself);
		add: ((Aspect integer: #right)
					defaultValue: 0;
					yourself);
		yourself').
	extractedMethod := class metaclass methodFor: selector.
	self assertNotNil: extractedMethod.
	self assert: extractedMethod parseTree
		equals: (self parseMethod: 'topAspect
	^(Aspect integer: #top) defaultValue: 0; yourself').
	self assert: extractedMethod owningPackageIfLoose identicalTo: method owningPackage.
	self assert: extractedMethod environment equals: (refactoring model classFor: Tools).
	self assert: refactoring model changes changes first environment identicalTo: Tools!

testExtractMethodAtEndOfMethodThatNeedsReturn
	| refactoring class |
	refactoring := ExtractMethodRefactoring
				extract: (73 to: 184)
				from: #openEditor
				in: LintRuleTestData.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: LintRuleTestData.
	self assert: (class parseTreeFor: #openEditor)
		equals: (self
				parseMethod: 'openEditor
	<namespace: Tools>
	| rules |
	rules := self failedRules.
	^self foo: rules').
	self assert: (class parseTreeFor: #foo:)
		equals: (self
				parseMethod: 'foo: rules
	<namespace: Tools>
	rules isEmpty ifTrue: [^self].
	rules size == 1 ifTrue: [^rules first viewResults].
	self result openEditor')!

testExtractMethodThatMovesTemporaryVariable
	| refactoring class |
	refactoring := ExtractMethodRefactoring
				extract: (self convertInterval: (22 to: 280)
						for: (TransformationRuleTestData sourceCodeAt: #superSends))
				from: #superSends
				in: TransformationRuleTestData.
	self setupMethodNameFor: refactoring toReturn: #foo.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: TransformationRuleTestData.
	self assert: (class parseTreeFor: #superSends)
		equals: (self parseMethod: 'superSends
	| rule |
	rule := self foo.
	self rewriteUsing: rule').
	self assert: (class parseTreeFor: #foo)
		equals: (self
				parseMethod: 'foo | rule | 	rule := ParseTreeRewriter new.
	rule addSearch: ''super `@message: ``@args''
				-> (
					[:aNode | 
					(class withAllSubclasses
						detect: [:each | each includesSelector: aNode selector]
						ifNone: [nil]) isNil]
							-> ''self `@message: ``@args'').
		^rule')!

testExtractMethodThatNeedsArgument
	| refactoring class |
	refactoring := ExtractMethodRefactoring
				extract: (self convertInterval: (145 to: 343)
						for: (TransformationRuleTestData sourceCodeAt: #checkMethod:))
				from: #checkMethod:
				in: TransformationRuleTestData.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: TransformationRuleTestData.
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (self
				parseMethod: 'checkMethod: aSmalllintContext 
	class := aSmalllintContext selectedClass.
	(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
			[self foo: aSmalllintContext]').
	self assert: (class parseTreeFor: #foo:)
		equals: (self
				parseMethod: 'foo: aSmalllintContext (RecursiveSelfRule executeTree: rewriteRule tree initialAnswer: false)
				ifFalse: 
					[builder compile: rewriteRule tree printString
						in: class
						categories: aSmalllintContext protocols]')!

testExtractMethodThatNeedsTemporaryVariable
	| refactoring class |
	refactoring := ExtractMethodRefactoring
				extract: (self convertInterval: (78 to: 197) for: (LintRuleTestData sourceCodeAt: #displayName))
				from: #displayName
				in: LintRuleTestData.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: LintRuleTestData.
	self assert: (class parseTreeFor: #displayName)
		equals: (self
				parseMethod: 'displayName
	| nameStream |
	nameStream := WriteStream on: (String new: 64).
	self foo: nameStream.
	^nameStream contents').
	self assert: (class parseTreeFor: #foo:)
		equals: (self
				parseMethod: 'foo: nameStream 	nameStream nextPutAll: self name;
		nextPutAll: '' (''.
	self problemCount printOn: nameStream.
	nameStream nextPut: $).')!

testModelExtractMethodWithTemporariesSelected
	| class refactoring |
	model := RBModel new.
	class := model classNamed: self class fullName.
	class compile: 'foo [| temp | temp := 5. temp * temp] value' classified: #accessing.
	refactoring := ExtractMethodRefactoring
				model: model
				extract: (6 to: 36)
				from: #foo
				in: class.
	self setupMethodNameFor: refactoring toReturn: #foobar.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #foo) equals: (self parseMethod: 'foo [self foobar] value').
	self assert: (class parseTreeFor: #foobar)
		equals: (self parseMethod: 'foobar |temp | temp := 5. ^temp * temp')!

testModelExtractMethodWithTemporaryAssigned
	| class refactoring |
	model := RBModel new.
	class := model classNamed: self class fullName.
	class
		compile: 'foo 				| temp bar | 				bar := 5. 				temp := bar * bar. 				Transcript show: temp printString; cr. 				^temp * temp'
		classified: #accessing.
	refactoring := ExtractMethodRefactoring
				model: model
				extract: (26 to: 102)
				from: #foo
				in: class.
	self setupMethodNameFor: refactoring toReturn: #foobar.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #foo)
		equals: (self parseMethod: 'foo | temp | temp := self foobar. ^temp * temp').
	self
		assert: ((class parseTreeFor: #foobar) equalTo: (self
						parseMethod: 'foobar | bar temp | bar := 5. temp := bar * bar. Transcript show: temp printString; cr. ^temp.')
				exceptForVariables: #())!

testNonExistantSelector
	self shouldFail: (ExtractMethodRefactoring
				extract: (10 to: 20)
				from: #checkClass1:
				in: BasicLintRuleTestData)
		withMessage: 'BasicLintRuleTestData does not define #checkClass1:'! !
!Refactory.Browser.Tests.ExtractMethodRefactoringTest categoriesForMethods!
testBadInterval!failure tests!public! !
testExtractBindingReference!failure tests!public! !
testExtractFailure!failure tests!public! !
testExtractFromMethodInCustomNamespace!failure tests!public! !
testExtractMethodAtEndOfMethodThatNeedsReturn!public!tests! !
testExtractMethodThatMovesTemporaryVariable!public!tests! !
testExtractMethodThatNeedsArgument!public!tests! !
testExtractMethodThatNeedsTemporaryVariable!public!tests! !
testModelExtractMethodWithTemporariesSelected!public!tests! !
testModelExtractMethodWithTemporaryAssigned!public!tests! !
testNonExistantSelector!failure tests!public! !
!

