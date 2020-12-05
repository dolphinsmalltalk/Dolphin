"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.AddParameterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddParameterTest guid: (Core.GUID fromString: '{b520d120-f80f-4ce2-b6be-e01706dc902b}')!
Refactory.Browser.Tests.AddParameterTest comment: ''!
!Refactory.Browser.Tests.AddParameterTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AddParameterTest methodsFor!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')!

testAddParameterForTwoArgumentMessage
	| refactoring class |
	refactoring := AddParameterRefactoring
				addParameterToMethod: ('called:' , 'on:') asSymbol
				in: RefactoryTestDataApp
				newSelector: #called:bar:on:
				initializer: '#(1.0)'.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp'.
	self assert: (class parseTreeFor: #called:bar:on:)
		equals: (RBParser
				parseMethod: 'called: anObject bar: aBlock on: anArrayOfFloat
							Transcript
								show: anObject printString;
								cr.
								aBlock value').
	self assert: (class parseTreeFor: #caller)
		equals: (RBParser
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
	class := refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp'.
	self assert: (class parseTreeFor: #testFoo:bar:)
		equals: (RBParser
				parseMethod: 'testFoo: anObject bar: anOrderedCollection
								^self class + anObject').
	self assert: (class parseTreeFor: #callFoo)
		equals: (RBParser parseMethod: 'callFoo ^self testFoo: 5 bar: (OrderedCollection new: 5)').
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
		equals: (RBParser parseMethod: 'testFoo:
anObject bar: anObject1
^self class
+ anObject').
	self assert: (class parseTreeFor: #callFoo)
		equals: (RBParser parseMethod: 'callFoo ^self
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
	class := refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp'.
	self assert: (class parseTreeFor: #testFoo:bar:)
		equals: (RBParser parseMethod: 'testFoo: anObject bar: anObject1
								^self class + anObject').
	self assert: (class parseTreeFor: #callFoo)
		equals: (RBParser parseMethod: 'callFoo ^self testFoo: 5 bar: (Bar new)').
	self deny: (class directlyDefinesMethod: ('test' , 'Foo:') asSymbol)!

testAddParameterThatReferencesSelf
	| refactoring class |
	refactoring := AddParameterRefactoring
				addParameterToMethod: ('test' , 'Foo:') asSymbol
				in: RefactoryTestDataApp
				newSelector: #testFoo:bar:
				initializer: 'self printString'.
	self executeRefactoring: refactoring.
	class := refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp'.
	self assert: (class parseTreeFor: #testFoo:bar:)
		equals: (RBParser parseMethod: 'testFoo: anObject bar: aString

								^self class + anObject').
	self assert: (class parseTreeFor: #callFoo)
		equals: (RBParser parseMethod: 'callFoo ^self testFoo: 5 bar: (self printString)').
	self deny: (class directlyDefinesMethod: ('test' , 'Foo:') asSymbol)!

testBadInitializationCode
	self
		shouldFail: (AddParameterRefactoring
					addParameterToMethod: #name
					in: LintRuleTest
					newSelector: #name:
					initializer: 'foo:');
		shouldFail: (AddParameterRefactoring
					addParameterToMethod: #name
					in: LintRuleTest
					newSelector: #name:
					initializer: 'foo')!

testModelBadInitializationCode
	| refactoring |
	model removeClassNamed: #'Refactory.Browser.Refactoring'.
	refactoring := AddParameterRefactoring
				model: model
				addParameterToMethod: #name1
				in: LintRuleTest
				newSelector: #name1:
				initializer: 'AddParameterRefactoring new'.
	self shouldFail: refactoring!

testModelNonExistantName
	| refactoring |
	(model classNamed: #'Refactory.Browser.Tests.LintRuleTest') removeMethod: #name.
	refactoring := AddParameterRefactoring
				model: model
				addParameterToMethod: #name
				in: LintRuleTest
				newSelector: #nameNew:
				initializer: 'nil'.
	self shouldFail: refactoring!

testNonExistantName
	self shouldFail: (AddParameterRefactoring
				addParameterToMethod: #name1
				in: LintRuleTest
				newSelector: #name1:
				initializer: 'nil')!

testPrimitiveMethods
	| refactoring |
	(model classNamed: #'Core.Object') compile: 'foo <primitive: 100> ^#() primitiveFailed'
		classified: #(#accessing).
	refactoring := AddParameterRefactoring
				model: model
				addParameterToMethod: #foo
				in: Object
				newSelector: #foo123124321s:
				initializer: '1'.
	self shouldFail: refactoring.
	refactoring := AddParameterRefactoring
				addParameterToMethod: #at:
				in: Object
				newSelector: #at:foo:
				initializer: '1'.
	self shouldFail: refactoring! !
!Refactory.Browser.Tests.AddParameterTest categoriesFor: #setUp!public!set up! !
!Refactory.Browser.Tests.AddParameterTest categoriesFor: #testAddParameterForTwoArgumentMessage!public!tests! !
!Refactory.Browser.Tests.AddParameterTest categoriesFor: #testAddParameterThatReferencesGlobalAndLiteral!public!tests! !
!Refactory.Browser.Tests.AddParameterTest categoriesFor: #testAddParameterThatReferencesInstanceVariable!public! !
!Refactory.Browser.Tests.AddParameterTest categoriesFor: #testAddParameterThatReferencesModelGlobal!public!tests! !
!Refactory.Browser.Tests.AddParameterTest categoriesFor: #testAddParameterThatReferencesSelf!public!tests! !
!Refactory.Browser.Tests.AddParameterTest categoriesFor: #testBadInitializationCode!failure tests!public! !
!Refactory.Browser.Tests.AddParameterTest categoriesFor: #testModelBadInitializationCode!failure tests!public! !
!Refactory.Browser.Tests.AddParameterTest categoriesFor: #testModelNonExistantName!failure tests!public! !
!Refactory.Browser.Tests.AddParameterTest categoriesFor: #testNonExistantName!failure tests!public! !
!Refactory.Browser.Tests.AddParameterTest categoriesFor: #testPrimitiveMethods!failure tests!public! !

