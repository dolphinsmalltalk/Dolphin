"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.AddParameterRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Refactory.Browser.Tests.AddParameterRefactoringTest guid: (Core.GUID fromString: '{b520d120-f80f-4ce2-b6be-e01706dc902b}')!

Refactory.Browser.Tests.AddParameterRefactoringTest comment: ''!

!Refactory.Browser.Tests.AddParameterRefactoringTest categoriesForClass!Refactory-Testing! !

!Refactory.Browser.Tests.AddParameterRefactoringTest methodsFor!

setUp
	super setUp.
	model := self abstractVariableTestData!

testAddParameterForTwoArgumentMessage
	| refactoring class |
	refactoring := AddParameterRefactoring
				addParameterToMethod: ('called:' , 'on:') asSymbol
				in: RefactoryTestDataApp
				newSelector: #called:bar:on:
				initializer: '#(1.0)'.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: RefactoryTestDataApp.
	self assert: (class parseTreeFor: #called:bar:on:)
		equals: (self
				parseMethod: 'called: anObject bar: aBlock on: anArrayOfFloat
							Transcript
								show: anObject printString;
								cr.
								aBlock value').
	self assert: (class parseTreeFor: #caller)
		equals: (self
				parseMethod: 'caller
							| anObject |
							anObject := 5.
							self 
								called: anObject + 1
								bar: [^anObject] on: #(1.0)').
	self deny: (class directlyDefinesMethod: ('called:' , 'on:') asSymbol)!

testAddParameterThatReferencesGlobalAndLiteral
	| refactoring class |
	refactoring := AddParameterRefactoring
				addParameterToMethod: ('test' , 'Foo:') asSymbol
				in: RefactoryTestDataApp
				newSelector: #testFoo:bar:
				initializer: 'OrderedCollection new: 5'.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: RefactoryTestDataApp.
	self assert: (class parseTreeFor: #testFoo:bar:)
		equals: (self
				parseMethod: 'testFoo: anObject bar: anOrderedCollection
								^self class + anObject').
	self assert: (class parseTreeFor: #callFoo)
		equals: (self parseMethod: 'callFoo ^self testFoo: 5 bar: (OrderedCollection new: 5)').
	self deny: (class directlyDefinesMethod: ('test' , 'Foo:') asSymbol)!

testAddParameterThatReferencesInstanceVariable
	| refactoring class |
	refactoring := AddParameterRefactoring
				addParameterToMethod: ('test' , 'Foo:') asSymbol
				in: RefactoryTestDataApp
				newSelector: #testFoo:bar:
				initializer: 'temporaryVariable'.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: RefactoryTestDataApp.
	self assert: (class parseTreeFor: #testFoo:bar:)
		equals: (self parseMethod: 'testFoo:
anObject bar: anObject1
^self class
+ anObject').
	self assert: (class parseTreeFor: #callFoo)
		equals: (self parseMethod: 'callFoo ^self
testFoo: 5 bar: temporaryVariable').
	self deny: (class directlyDefinesMethod: ('test' , 'Foo:') asSymbol)!

testAddParameterThatReferencesModelGlobal
	| refactoring class |
	refactoring := AddParameterRefactoring
				model: model
				addParameterToMethod: ('test' , 'Foo:') asSymbol
				in: RefactoryTestDataApp
				newSelector: #testFoo:bar:
				initializer: 'Bar new'.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: RefactoryTestDataApp.
	self assert: (class parseTreeFor: #testFoo:bar:)
		equals: (self parseMethod: 'testFoo: anObject bar: anObject1
								^self class + anObject').
	self assert: (class parseTreeFor: #callFoo)
		equals: (self parseMethod: 'callFoo ^self testFoo: 5 bar: (Bar new)').
	self deny: (class directlyDefinesMethod: ('test' , 'Foo:') asSymbol)!

testAddParameterThatReferencesSelf
	| refactoring class |
	refactoring := AddParameterRefactoring
				addParameterToMethod: ('test' , 'Foo:') asSymbol
				in: RefactoryTestDataApp
				newSelector: #testFoo:bar:
				initializer: 'self printString'.
	self executeRefactoring: refactoring.
	class := refactoring model classFor: RefactoryTestDataApp.
	self assert: (class parseTreeFor: #testFoo:bar:)
		equals: (self parseMethod: 'testFoo: anObject bar: aString

								^self class + anObject').
	self assert: (class parseTreeFor: #callFoo)
		equals: (self parseMethod: 'callFoo ^self testFoo: 5 bar: (self printString)').
	self deny: (class directlyDefinesMethod: ('test' , 'Foo:') asSymbol)!

testBadInitializationCode
	self
		shouldFail: (AddParameterRefactoring
					addParameterToMethod: #name
					in: LintRuleTestData
					newSelector: #name:
					initializer: 'foo:')
			withMessage: 'invalid expression start';
		shouldFail: (AddParameterRefactoring
					addParameterToMethod: #name
					in: LintRuleTestData
					newSelector: #name:
					initializer: 'foo')
			withMessage: '''foo'' is not defined in *'!

testModelBadInitializationCode
	| refactoring |
	model removeClassNamed: #'Refactory.Browser.Refactoring'.
	refactoring := AddParameterRefactoring
				model: model
				addParameterToMethod: #name1
				in: LintRuleTestData
				newSelector: #name1:
				initializer: 'AddParameterRefactoring new'.
	"The error will report that AppParameterRefactoring is not defined in one of the classes sending #name1 in the model. There are at least two senders, and we may get any of them."
	self shouldFail: refactoring
		withMessage: '''AddParameterRefactoring'' is not defined in Refactory.Browser.Tests.*Test'!

testModelNonExistantName
	| refactoring |
	(model classFor: LintRuleTestData) removeSelector: #name.
	refactoring := AddParameterRefactoring
				model: model
				addParameterToMethod: #name
				in: LintRuleTestData
				newSelector: #nameNew:
				initializer: 'nil'.
	self shouldFail: refactoring withMessage: 'LintRuleTestData does not define #name'!

testNonExistantName
	self shouldFail: (AddParameterRefactoring
				addParameterToMethod: #name1
				in: LintRuleTestData
				newSelector: #name1:
				initializer: 'nil')
		withMessage: 'LintRuleTestData does not define #name1'!

testPrimitiveMethods
	| refactoring |
	(model classNamed: #'Core.Object') compile: 'foo <primitive: 100> ^#() primitiveFailed'
		classified: #accessing.
	refactoring := AddParameterRefactoring
				model: model
				addParameterToMethod: #foo
				in: Object
				newSelector: #foo123124321s:
				initializer: '1'.
	refactoring setOption: #renameAllDefinitions
		toUse: 
			[:ref :classes :selector |
			self assert: selector identicalTo: #foo.
			#(#'Core.Object' #Foo #Bar #'Foo class')
				do: [:each | self assert: (classes includes: (model classNamed: each))].
			true].
	self shouldFail: refactoring withMessage: '*''s implementation of #foo is a primitive'.


	"There are many implementors of #at:, some of which are primitives."
	refactoring := AddParameterRefactoring
				addParameterToMethod: #at:
				in: Object
				newSelector: #at:foo:
				initializer: '1'.
	refactoring setOption: #renameAllDefinitions
		toUse: 
			[:ref :classes :sel |
			self assert: sel identicalTo: #at:.
			classes do: [:each | self assertNotNil: (each parseTreeFor: sel)].
			true].
	self shouldFail: refactoring withMessage: '*''s implementation of #at: is a primitive'! !

!Refactory.Browser.Tests.AddParameterRefactoringTest categoriesForMethods!
setUp!public!set up! !
testAddParameterForTwoArgumentMessage!public!tests! !
testAddParameterThatReferencesGlobalAndLiteral!public!tests! !
testAddParameterThatReferencesInstanceVariable!public! !
testAddParameterThatReferencesModelGlobal!public!tests! !
testAddParameterThatReferencesSelf!public!tests! !
testBadInitializationCode!failure tests!public! !
testModelBadInitializationCode!failure tests!public! !
testModelNonExistantName!failure tests!public! !
testNonExistantName!failure tests!public! !
testPrimitiveMethods!failure tests!public! !
!

