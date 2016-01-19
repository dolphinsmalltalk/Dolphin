"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #ExtractMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExtractMethodTest guid: (GUID fromString: '{E6D6D232-8068-4ED9-97F4-59B812529DAF}')!
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

testModelExtractMethodWithTemporariesSelected
	| class refactoring |
	model := RBNamespace new.
	class := model classNamed: self class name.
	class compile: 'foo [| temp | temp := 5. temp * temp] value'
		classified: #(#accessing).
	refactoring := ExtractMethodRefactoring 
				model: model
				extract: (6 to: 36)
				from: #foo
				in: class.
	self setupMethodNameFor: refactoring toReturn: #foobar.
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #foo) 
				= (RBParser parseMethod: 'foo [self foobar] value').
	self assert: (class parseTreeFor: #foobar) 
				= (RBParser parseMethod: 'foobar |temp | temp := 5. ^temp * temp')!

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
				= (RBParser parseMethod: 'foo | temp | temp := self foobar. ^temp * temp').
	self 
		assert: ((class parseTreeFor: #foobar) 
					equalTo: (RBParser 
						parseMethod: 'foobar | bar temp | bar := 5. temp := bar * bar. Transcript show: temp printString; cr. ^temp.') 
					exceptForVariables: #())!

testNonExistantSelector
	self shouldFail: (ExtractMethodRefactoring 
				extract: (10 to: 20)
				from: #checkClass1:
				in: BasicLintRuleTest)! !
!ExtractMethodTest categoriesFor: #testBadInterval!failure tests!public! !
!ExtractMethodTest categoriesFor: #testExtractFailure!failure tests!public! !
!ExtractMethodTest categoriesFor: #testModelExtractMethodWithTemporariesSelected!public!tests! !
!ExtractMethodTest categoriesFor: #testModelExtractMethodWithTemporaryAssigned!public!tests! !
!ExtractMethodTest categoriesFor: #testNonExistantSelector!failure tests!public! !

