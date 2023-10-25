"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.InlineMethodRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.InlineMethodRefactoringTest guid: (Core.GUID fromString: '{f70132aa-f38c-4f5d-ad58-1801c2c8f8b1}')!
Refactory.Browser.Tests.InlineMethodRefactoringTest comment: ''!
!Refactory.Browser.Tests.InlineMethodRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.InlineMethodRefactoringTest methodsFor!

expected
	^self
		parseMethod: 'inlineWithNamespace ^{ Tests.ClassToRename. #(#{Refactory.Browser.Tests.ClassToRename}) }'!

testBadInterval
	self
		shouldFail: (InlineMethodRefactoring
					inline: (self convertInterval: (13 to: 23) for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					inMethod: #testMethod
					forClass: RefactoryTestDataApp)
			withMessage: 'The selection doesn''t appear to be a message send';
		shouldFail: (InlineMethodRefactoring
					inline: (self convertInterval: (14 to: 17) for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					inMethod: #testMethod
					forClass: RefactoryTestDataApp)
			withMessage: 'The selection doesn''t appear to be a message send';
		shouldFail: (InlineMethodRefactoring
					inline: (self convertInterval: (24 to: 30) for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					inMethod: #testMethod
					forClass: RefactoryTestDataApp)
			withMessage: 'The selection doesn''t appear to be a message send';
		shouldFail: (InlineMethodRefactoring
					inline: (self convertInterval: (1 to: 30) for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
					inMethod: #testMethod
					forClass: RefactoryTestDataApp)
			withMessage: 'The selection doesn''t appear to be a message send'!

testInlineAccessor
	| refactoring actual expected source |
	source := RefactoryTestDataApp sourceCodeAt: #temporaryVariable2.
	refactoring := InlineMethodRefactoring
				inline: ((source indexOf: $^) + 1 to: (source indexOf: $+) - 1)
				inMethod: #temporaryVariable2
				forClass: RefactoryTestDataApp.
	self setupInlineExpressionFor: refactoring toReturn: false.
	self executeRefactoring: refactoring.
	actual := (refactoring model classFor: RefactoryTestDataApp) compiledMethodAt: #temporaryVariable2.
	expected := self parseMethod: 'temporaryVariable2  ^temporaryVariable + self temporaryVariable'.
	self assert: actual parseTree equals: expected.
	self deny: (actual source includes: $🐬).
	self assert: (actual source includes: $🐭)!

testInlineEmptyInterval
	| source |
	self shouldFail: (InlineMethodRefactoring
				inline: (35 to: 34)
				inMethod: #inlineMethod
				forClass: RefactoryTestDataApp)
		withMessage: 'Source interval (35 to: 34) is empty'!

testInlineMethod
	| refactoring |
	refactoring := InlineMethodRefactoring
				inline: (self convertInterval: (455 to: 504)
						for: (BasicLintRuleTestData class sourceCodeAt: #sentNotImplementedInApplication))
				inMethod: #sentNotImplementedInApplication
				forClass: BasicLintRuleTestData class.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model metaclassNamed: #'Refactory.Browser.TestData.BasicLintRuleTestData')
				parseTreeFor: #sentNotImplementedInApplication)
		equals: (self
				parseMethod: 'sentNotImplementedInApplication
									| detector |
									detector := self new.
									detector name: ''Messages sent but not implemented in application''.
									detector methodBlock: 
											[:context :result | 
											| message class block |
											message := context messages 
														detect: [:each | (context isItem: each in: context application) not]
														ifNone: [nil].
											class := context selectedClass.
											block := 
													[:each | 
													| app methodApp root |
													app := context application.
													((class canUnderstand: each) 
														ifTrue: 
															[root := app rootApplication.
															methodApp := ((class whichClassIncludesSelector: each) 
																		compiledMethodAt: each) application 
																		rootApplication.
															methodApp == root or: [root isBasedOn: methodApp]]
														ifFalse: [false]) not].
											message isNil 
												ifTrue: [message := context selfMessages detect: block ifNone: [nil]].
											message isNil 
												ifTrue: 
													[class := class superclass.
													class isNil 
														ifTrue: 
															[context superMessages isEmpty 
																ifFalse: [message := context superMessages asArray first]]
														ifFalse: [message := context superMessages detect: block ifNone: [nil]]].
											message notNil 
												ifTrue: 
													[result addSearchString: message.
													result addClass: context selectedClass selector: context selector]].
									^detector')!

testInlineMethod1
	| refactoring actual expected |
	refactoring := InlineMethodRefactoring
				inline: (self convertInterval: (39 to: 84) for: (RefactoryTestDataApp sourceCodeAt: #caller))
				inMethod: #caller
				forClass: RefactoryTestDataApp.
	self setupInlineExpressionFor: refactoring toReturn: false.
	self executeRefactoring: refactoring.
	actual := (refactoring model classFor: RefactoryTestDataApp) compiledMethodAt: #caller.
	expected := self
				parseMethod: 'caller 
									| anObject anObject1 | 
									anObject := 5.
									anObject1 := anObject + 1.
									Transcript
										show: anObject1 printString;
										cr.
									^anObject'.
	self assert: actual parseTree equals: expected.
	self deny: (actual source includes: $🐬)!

testInlineMethod2
	| refactoring |
	refactoring := InlineMethodRefactoring
				inline: (self convertInterval: (40 to: 120) for: (RefactoryTestDataApp sourceCodeAt: #caller1))
				inMethod: #caller1
				forClass: RefactoryTestDataApp.
	self setupInlineExpressionFor: refactoring toReturn: false.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classFor: RefactoryTestDataApp) parseTreeFor: #caller1)
		equals: (self
				parseMethod: 'caller1 
								| anObject each1 anObject1 | 
								anObject := 5.
								anObject1 := anObject + 1.
								each1 := anObject1 printString.
								Transcript
									show: each1;
									cr.
								[:each | each printString. ^anObject] value: each1')!

testInlineMethod3
	| refactoring actual expected |
	refactoring := InlineMethodRefactoring
				inline: (self convertInterval: (58 to: 73) for: (RefactoryTestDataApp sourceCodeAt: #caller2))
				inMethod: #caller2
				forClass: RefactoryTestDataApp.
	self setupInlineExpressionFor: refactoring toReturn: false.
	self executeRefactoring: refactoring.
	actual := (refactoring model classFor: RefactoryTestDataApp) compiledMethodAt: #caller2.
	expected := self
				parseMethod: 'caller2
								^(1 to: 10) inject: 1 into: [:sum :each | sum * ((1 to: 10) inject: each into: [:sum1 :each1 | sum1 + each1])]	'.
	self assert: actual parseTree equals: expected.
	self deny: (actual source includes: $🐬).
	self assert: (actual source includes: $🐭)!

testInlineMethod4
	| refactoring |
	refactoring := InlineMethodRefactoring
				inline: (self convertInterval: (31 to: 112) for: (RefactoryTestDataApp sourceCodeAt: #inlineJunk))
				inMethod: #inlineJunk
				forClass: RefactoryTestDataApp.
	self setupInlineExpressionFor: refactoring toReturn: false.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classFor: RefactoryTestDataApp) parseTreeFor: #inlineJunk)
		equals: (self
				parseMethod: 'inlineJunk
										| asdf bar1 baz1 asdf1 |
										bar1 := 
												[:each | 
												| temp |
												temp := each.
												temp , temp] value: self.
										baz1 := bar1 + bar1.
										asdf1 := baz1 + bar1.
										asdf := asdf1.
										^asdf foo: 
												[:bar | 
												| baz |
												baz := bar.
												baz * baz]')!

testInlineMethod5
	| refactoring |
	refactoring := InlineMethodRefactoring
				inline: (self convertInterval: (53 to: 64) for: (RefactoryTestDataApp sourceCodeAt: #inlineLast))
				inMethod: #inlineLast
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classFor: RefactoryTestDataApp) parseTreeFor: #inlineLast)
		equals: (self
				parseMethod: 'inlineLast
									5 = 3 ifTrue: [^self caller] ifFalse: [^	(1 to: 10) inject: 1 into: [:sum :each | sum * (self foo: each)]]')!

testInlineMethodForSuperSend
	| refactoring |
	model := self inlineMethodTestData.
	(model classNamed: #RenameVariableChange) removeSelector: #executeNotifying:.
	refactoring := InlineMethodRefactoring
				model: model
				inline: (self convertInterval: (102 to: 131)
						for: ((model classNamed: #RenameInstanceVariableChange) sourceCodeFor: #executeNotifying:))
				inMethod: #executeNotifying:
				forClass: (model classNamed: #RenameInstanceVariableChange).
	self executeRefactoring: refactoring.
	self assert: ((model classNamed: #RenameInstanceVariableChange) parseTreeFor: #executeNotifying:)
		equals: (self
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
	model := self inlineMethodTestData.
	refactoring := InlineMethodRefactoring
				inline: (102 to: 131)
				inMethod: #executeNotifying:
				forClass: (model classNamed: #'Refactory.Browser.RenameInstanceVariableChange').
	self shouldFail: refactoring
		withMessage: 'RenameInstanceVariableChange does not define #executeNotifying:'!

testInlineNotImplemented
	| source |
	source := (RefactoryTestDataApp >> #inlineMethod) getSource.
	self shouldFail: (InlineMethodRefactoring
				inline: ((source indexOfSubCollection: 'self') to: (source indexOf: $;) - 1)
				inMethod: #inlineMethod
				forClass: RefactoryTestDataApp)
		withMessage: 'Refactory.Browser.TestData.RefactoryTestDataApp and its superclasses do not define method foo'!

testInlineRecursiveCascadedMethod
	| refactoring |
	refactoring := InlineMethodRefactoring
				inline: (self convertInterval: (33 to: 62) for: (RefactoryTestDataApp sourceCodeAt: #inlineMethod))
				inMethod: #inlineMethod
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classFor: RefactoryTestDataApp) parseTreeFor: #inlineMethod)
		equals: (self
				parseMethod: 'inlineMethod
									| temp temp1 |
									self foo.
									temp1 := self foo; inlineMethod; bar.
									temp := self bar.
									^temp')!

testInlineWithNamespace
	"Inlining a method with a custom namespace may require additional qualifications for static variable refs in the inlined code"

	| refactoring refDataApp source actual |
	refDataApp := model classFor: RefactoryTestDataApp.
	source := refDataApp sourceCodeFor: #inlineWithNamespace.
	refactoring := InlineMethodRefactoring
				model: model
				inline: ((source indexOf: ${) + 2 to: (source indexOf: $.) - 1)
				inMethod: #inlineWithNamespace
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: (refDataApp parseTreeFor: #inlineWithNamespace)
		equals: (self
				parseMethod: 'inlineWithNamespace ^{ Tests.ClassToRename . self refersToClassFullyQualifiedBindingInArray } ').
	source := refDataApp sourceCodeFor: #inlineWithNamespace.
	refactoring := InlineMethodRefactoring
				model: model
				inline: ((source indexOfSubCollection: '. ') + 2 to: (source indexOf: $}) - 2)
				inMethod: #inlineWithNamespace
				forClass: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	actual := (model classFor: RefactoryTestDataApp) parseTreeFor: #inlineWithNamespace.
	self assert: actual equals: self expected.
	self deny: (actual formattedCode includes: $🐬).
	self assert: (actual formattedCode includes: $🐭)!

testModelInlineRecursiveMethod
	| refactoring class |
	class := model classNamed: #'Core.Object'.
	class compile: 'foo self bar. self foo. self bar' classified: #accessing.
	refactoring := InlineMethodRefactoring
				model: model
				inline: (15 to: 23)
				inMethod: #foo
				forClass: class.
	"Somebody may have added other foo methods into the system, and we don't care about those so proceed through the prompt"
	refactoring setOption: #inlineOverridden toUse: [true].
	self executeRefactoring: refactoring.
	self assert: (class parseTreeFor: #foo)
		equals: (self parseMethod: 'foo self bar. self bar. self foo. self bar. self bar')!

testNonExistantSelector
	self shouldFail: (InlineMethodRefactoring
				inline: (14 to: 17)
				inMethod: #checkClass1:
				forClass: RefactoryTestDataApp)
		withMessage: 'RefactoryTestDataApp does not define #checkClass1:'!

testOverriden
	| refactoring |
	refactoring := InlineMethodRefactoring
				inline: (self convertInterval: (15 to: 26) for: (LintRuleTestData sourceCodeAt: #failedRules))
				inMethod: #failedRules
				forClass: LintRuleTestData.
	refactoring setOption: #inlineOverridden
		toUse: 
			[:rcvr :symbol :class |
			self assert: class equals: (refactoring model classFor: LintRuleTestData).
			self assert: symbol equals: #isEmpty.
			true].
	self executeRefactoring: refactoring!

testOverridenAbort
	| refactoring |
	refactoring := InlineMethodRefactoring
				inline: (self convertInterval: (15 to: 26) for: (LintRuleTestData sourceCodeAt: #failedRules))
				inMethod: #failedRules
				forClass: LintRuleTestData.
	refactoring setOption: #inlineOverridden
		toUse: 
			[:rcvr :symbol :class |
			self assert: symbol identicalTo: #isEmpty.
			self assert: class identicalTo: (rcvr model classFor: LintRuleTestData).
			false].
	self shouldAbort: refactoring!

testPrimitive
	self shouldFail: (InlineMethodRefactoring
				inline: (self convertInterval: (14 to: 23) for: (RefactoryTestDataApp sourceCodeAt: #testMethod))
				inMethod: #testMethod
				forClass: RefactoryTestDataApp)
		withMessage: 'Cannot inline primitives'!

testReturn
	self shouldFail: (InlineMethodRefactoring
				inline: (self convertInterval: (418 to: 485)
						for: (BasicLintRuleTestData class sourceCodeAt: #utilityMethods))
				inMethod: #utilityMethods
				forClass: BasicLintRuleTestData class)
		withMessage: 'The selection doesn''t appear to be a message send'! !
!Refactory.Browser.Tests.InlineMethodRefactoringTest categoriesForMethods!
expected!public!tests! !
testBadInterval!failure tests!public! !
testInlineAccessor!public!tests! !
testInlineEmptyInterval!public! !
testInlineMethod!public!tests! !
testInlineMethod1!public!tests! !
testInlineMethod2!public!tests! !
testInlineMethod3!public!tests! !
testInlineMethod4!public!tests! !
testInlineMethod5!public!tests! !
testInlineMethodForSuperSend!public!tests! !
testInlineMethodForSuperSendThatAlsoSendsSuper!failure tests!public! !
testInlineNotImplemented!failure tests!public! !
testInlineRecursiveCascadedMethod!public!tests! !
testInlineWithNamespace!public!tests! !
testModelInlineRecursiveMethod!public!tests! !
testNonExistantSelector!failure tests!public! !
testOverriden!failure tests!public! !
testOverridenAbort!failure tests!public! !
testPrimitive!failure tests!public! !
testReturn!failure tests!public! !
!

