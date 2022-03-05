"Filed out from Dolphin Smalltalk"!

RefactoringTest subclass: #ExtractMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExtractMethodTest guid: (GUID fromString: '{e6d6d232-8068-4ed9-97f4-59b812529daf}')!
ExtractMethodTest comment: ''!
!ExtractMethodTest categoriesForClass!Refactory-Testing! !
!ExtractMethodTest methodsFor!

testBadInterval
	self
		shouldFail: (ExtractMethodRefactoring 
					extract: (self convertInterval: (24 to: 30)
							for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					from: #testMethod
					in: RefactoryTestDataApp);
		shouldFail: (ExtractMethodRefactoring 
					extract: (self convertInterval: (80 to: 147)
							for: (BasicLintRuleTest class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTest class)!

testExtractFailure
	self
		shouldFail: (ExtractMethodRefactoring 
					extract: (self convertInterval: (80 to: 269)
							for: (BasicLintRuleTest class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTest class);
		shouldFail: (ExtractMethodRefactoring 
					extract: (self convertInterval: (53 to: 56)
							for: (BasicLintRuleTest class sourceCodeAt: #subclassOf:overrides:))
					from: #subclassOf:overrides:
					in: BasicLintRuleTest class);
		shouldFail: (ExtractMethodRefactoring 
					extract: (self convertInterval: (77 to: 222)
							for: (BasicLintRuleTest class 
									sourceCodeAt: #subclassResponsibilityNotDefined))
					from: #subclassResponsibilityNotDefined
					in: BasicLintRuleTest class)!

testExtractMethodAtEndOfMethodThatNeedsReturn
	| refactoring class |
	refactoring := ExtractMethodRefactoring
				extract: (self convertInterval: (52 to: 182) for: (LintRuleTest sourceCodeAt: #openEditor))
				from: #openEditor
				in: LintRuleTest.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #LintRuleTest.
	self assert: (class parseTreeFor: #openEditor)
		equals: (RBParser
				parseMethod: 'openEditor
	| rules |
	rules := self failedRules.
	^self foo: rules').
	self assert: (class parseTreeFor: #foo:)
		equals: (RBParser
				parseMethod: 'foo: rules
	rules isEmpty ifTrue: [^self].
	rules size == 1 ifTrue: [^rules first viewResults].
	SmalllintResultEditor openOn: self label: name')!

testExtractMethodThatMovesTemporaryVariable
	| refactoring class |
	refactoring := ExtractMethodRefactoring
				extract: (self convertInterval: (22 to: 280) for: (TransformationRuleTest sourceCodeAt: #superSends))
				from: #superSends
				in: TransformationRuleTest.
	self setupMethodNameFor: refactoring toReturn: #foo.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #TransformationRuleTest.
	self assert: (class parseTreeFor: #superSends)
		equals: (RBParser parseMethod: 'superSends
	| rule |
	rule := self foo.
	self rewriteUsing: rule').
	self assert: (class parseTreeFor: #foo)
		equals: (RBParser
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
						for: (TransformationRuleTest sourceCodeAt: #checkMethod:))
				from: #checkMethod:
				in: TransformationRuleTest.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #TransformationRuleTest.
	self assert: (class parseTreeFor: #checkMethod:)
		equals: (RBParser
				parseMethod: 'checkMethod: aSmalllintContext 
	class := aSmalllintContext selectedClass.
	(rewriteRule executeTree: aSmalllintContext parseTree) ifTrue: 
			[self foo: aSmalllintContext]').
	self assert: (class parseTreeFor: #foo:)
		equals: (RBParser
				parseMethod: 'foo: aSmalllintContext (RecursiveSelfRule executeTree: rewriteRule tree initialAnswer: false)
				ifFalse: 
					[builder compile: rewriteRule tree printString
						in: class
						classified: aSmalllintContext protocols]')!

testExtractMethodThatNeedsTemporaryVariable
	| refactoring class |
	refactoring := ExtractMethodRefactoring
				extract: (self convertInterval: (78 to: 197) for: (LintRuleTest sourceCodeAt: #displayName))
				from: #displayName
				in: LintRuleTest.
	self setupMethodNameFor: refactoring toReturn: #foo:.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #LintRuleTest.
	self assert: (class parseTreeFor: #displayName)
		equals: (RBParser
				parseMethod: 'displayName
	| nameStream |
	nameStream := WriteStream on: (String new: 64).
	self foo: nameStream.
	^nameStream contents').
	self assert: (class parseTreeFor: #foo:)
		equals: (RBParser
				parseMethod: 'foo: nameStream 	nameStream nextPutAll: self name;
		nextPutAll: '' (''.
	self problemCount printOn: nameStream.
	nameStream nextPut: $).')!

testModelExtractMethodWithTemporariesSelected
	| class refactoring |
	model := RBNamespace new.
	class := model classNamed: self class name.
	class compile: 'foo [| temp | temp := 5. temp * temp] value' classified: #(#accessing).
	refactoring := ExtractMethodRefactoring
				model: model
				extract: (6 to: 36)
				from: #foo
				in: class.
	self setupMethodNameFor: refactoring toReturn: #foobar.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #foo) equals: (RBParser parseMethod: 'foo [self foobar] value').
	self assert: (class parseTreeFor: #foobar)
		equals: (RBParser parseMethod: 'foobar |temp | temp := 5. ^temp * temp')!

testModelExtractMethodWithTemporaryAssigned
	| class refactoring |
	model := RBNamespace new.
	class := model classNamed: self class name.
	class
		compile: 'foo 				| temp bar | 				bar := 5. 				temp := bar * bar. 				Transcript show: temp printString; cr. 				^temp * temp'
		classified: #(#accessing).
	refactoring := ExtractMethodRefactoring
				model: model
				extract: (26 to: 102)
				from: #foo
				in: class.
	self setupMethodNameFor: refactoring toReturn: #foobar.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #foo)
		equals: (RBParser parseMethod: 'foo | temp | temp := self foobar. ^temp * temp').
	self
		assert: ((class parseTreeFor: #foobar) equalTo: (RBParser
						parseMethod: 'foobar | bar temp | bar := 5. temp := bar * bar. Transcript show: temp printString; cr. ^temp.')
				exceptForVariables: #())!

testNonExistantSelector
	self shouldFail: (ExtractMethodRefactoring 
				extract: (10 to: 20)
				from: #checkClass1:
				in: BasicLintRuleTest)! !
!ExtractMethodTest categoriesForMethods!
testBadInterval!failure tests!public! !
testExtractFailure!failure tests!public! !
testExtractMethodAtEndOfMethodThatNeedsReturn!public!tests! !
testExtractMethodThatMovesTemporaryVariable!public!tests! !
testExtractMethodThatNeedsArgument!public!tests! !
testExtractMethodThatNeedsTemporaryVariable!public!tests! !
testModelExtractMethodWithTemporariesSelected!public!tests! !
testModelExtractMethodWithTemporaryAssigned!public!tests! !
testNonExistantSelector!failure tests!public! !
!

