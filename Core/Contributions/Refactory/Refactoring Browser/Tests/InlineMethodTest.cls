"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #InlineMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
InlineMethodTest guid: (GUID fromString: '{F70132AA-F38C-4F5D-AD58-1801C2C8F8B1}')!
InlineMethodTest comment: ''!
!InlineMethodTest categoriesForClass!Refactory-Testing! !
!InlineMethodTest methodsFor!

testBadInterval
	self
		shouldFail: (InlineMethodRefactoring 
					inline: (self convertInterval: (13 to: 23)
							for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					inMethod: #testMethod
					forClass: RefactoryTestDataApp);
		shouldFail: (InlineMethodRefactoring 
					inline: (self convertInterval: (14 to: 17)
							for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					inMethod: #testMethod
					forClass: RefactoryTestDataApp);
		shouldFail: (InlineMethodRefactoring 
					inline: (self convertInterval: (24 to: 30)
							for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					inMethod: #testMethod
					forClass: RefactoryTestDataApp);
		shouldFail: (InlineMethodRefactoring 
					inline: (self convertInterval: (1 to: 30)
							for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					inMethod: #testMethod
					forClass: RefactoryTestDataApp)!

testInlineMethod3
	| refactoring |
	refactoring := InlineMethodRefactoring 
				inline: (self convertInterval: (58 to: 73)
						for: (RefactoryTestDataApp sourceCodeAt: #caller2))
				inMethod: #caller2
				forClass: RefactoryTestDataApp.
	self setupInlineExpressionFor: refactoring toReturn: false.
	self executeRefactoring: refactoring.
	self 
		assert: ((refactoring model classNamed: #RefactoryTestDataApp) 
				parseTreeFor: #caller2) = (RBParser 
							parseMethod: 'caller2
								^(1 to: 10) inject: 1 into: [:sum :each | sum * ((1 to: 10) inject: each into: [:sum1 :each1 | sum1 + each1])]	')!

testInlineMethodForSuperSend
	| refactoring |
	model := Compiler evaluate: (self readFile: 'InlineMethodTest.st').
	(model classNamed: #RenameVariableChange) removeMethod: #executeNotifying:.
	refactoring := InlineMethodRefactoring 
				model: model
				inline: (self convertInterval: (102 to: 131)
						for: ((model classNamed: #RenameInstanceVariableChange) 
								sourceCodeFor: #executeNotifying:))
				inMethod: #executeNotifying:
				forClass: (model classNamed: #RenameInstanceVariableChange).
	self executeRefactoring: refactoring.
	self 
		assert: ((model classNamed: #RenameInstanceVariableChange) 
				parseTreeFor: #executeNotifying:) = (RBParser 
							parseMethod: 'executeNotifying: aBlock 
									| undo undos undo1 |
									self addNewVariable.
									self copyOldValuesToNewVariable.
									undos := changes collect: [:each | each executeNotifying: aBlock].
									undo1 := self copy.
									undo1 changes: undos reverse.
									undo := undo1.
									self removeOldVariable.
									^undo')!

testInlineMethodForSuperSendThatAlsoSendsSuper
	| refactoring |
	model := Compiler evaluate: (self readFile: 'InlineMethodTest.st').
	refactoring := InlineMethodRefactoring 
				inline: (102 to: 131)
				inMethod: #executeNotifying:
				forClass: (model classNamed: #RenameInstanceVariableChange).
	self shouldFail: refactoring!

testInlineRecursiveCascadedMethod
	| refactoring |
	refactoring := InlineMethodRefactoring 
				inline: (self convertInterval: (33 to: 62)
						for: (RefactoryTestDataApp sourceCodeAt: #inlineMethod))
				inMethod: #inlineMethod
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self 
		assert: ((refactoring model classNamed: #RefactoryTestDataApp) 
				parseTreeFor: #inlineMethod) = (RBParser 
							parseMethod: 'inlineMethod
									| temp temp1 |
									self foo.
									temp1 := self foo; inlineMethod; bar.
									temp := self bar.
									^temp')!

testModelInlineRecursiveMethod
	| refactoring class |
	class := model classNamed: #Object.
	class compile: 'foo self bar. self foo. self bar' classified: #(#accessing).
	refactoring := InlineMethodRefactoring 
				model: model
				inline: (15 to: 23)
				inMethod: #foo
				forClass: class.
	self executeRefactoring: refactoring.
	self 
		assert: (class parseTreeFor: #foo) = (RBParser 
						parseMethod: 'foo self bar. self bar. self foo. self bar. self bar')!

testNonExistantSelector
	self shouldFail: (InlineMethodRefactoring 
				inline: (14 to: 17)
				inMethod: #checkClass1:
				forClass: RefactoryTestDataApp)!

testPrimitive
	self shouldFail: (InlineMethodRefactoring 
				inline: (self convertInterval: (14 to: 23)
						for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
				inMethod: #testMethod
				forClass: RefactoryTestDataApp)!

testReturn
	self shouldFail: (InlineMethodRefactoring 
				inline: (self convertInterval: (418 to: 485)
						for: (BasicLintRuleTest class sourceCodeAt: #utilityMethods))
				inMethod: #utilityMethods
				forClass: BasicLintRuleTest class)! !
!InlineMethodTest categoriesFor: #testBadInterval!failure tests!public! !
!InlineMethodTest categoriesFor: #testInlineMethod3!public!tests! !
!InlineMethodTest categoriesFor: #testInlineMethodForSuperSend!public!tests! !
!InlineMethodTest categoriesFor: #testInlineMethodForSuperSendThatAlsoSendsSuper!failure tests!public! !
!InlineMethodTest categoriesFor: #testInlineRecursiveCascadedMethod!public!tests! !
!InlineMethodTest categoriesFor: #testModelInlineRecursiveMethod!public!tests! !
!InlineMethodTest categoriesFor: #testNonExistantSelector!failure tests!public! !
!InlineMethodTest categoriesFor: #testPrimitive!failure tests!public! !
!InlineMethodTest categoriesFor: #testReturn!failure tests!public! !

