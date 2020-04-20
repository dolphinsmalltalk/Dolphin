"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #AddParameterTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AddParameterTest guid: (GUID fromString: '{b520d120-f80f-4ce2-b6be-e01706dc902b}')!
AddParameterTest comment: ''!
!AddParameterTest categoriesForClass!Refactory-Testing! !
!AddParameterTest methodsFor!

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
	class := refactoring model classNamed: #RefactoryTestDataApp.
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
	class := refactoring model classNamed: #RefactoryTestDataApp.
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
	class := refactoring model classNamed: #RefactoryTestDataApp.
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
	class := refactoring model classNamed: #RefactoryTestDataApp.
	self assert: (class parseTreeFor: #testFoo:bar:)
		equals: (RBParser
				parseMethod: 'testFoo: anObject bar: aString

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
	model removeClassNamed: #Refactoring.
	refactoring := AddParameterRefactoring 
				model: model
				addParameterToMethod: #name1
				in: LintRuleTest
				newSelector: #name1:
				initializer: 'AddParameterRefactoring new'.
	self shouldFail: refactoring!

testModelNonExistantName
	| refactoring |
	(model classNamed: #LintRuleTest) removeMethod: #name.
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
	(model classNamed: #Object) 
		compile: 'foo <primitive: 100> ^#() primitiveFailed'
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
	self shouldFail: refactoring.! !
!AddParameterTest categoriesFor: #setUp!public!set up! !
!AddParameterTest categoriesFor: #testAddParameterForTwoArgumentMessage!public!tests! !
!AddParameterTest categoriesFor: #testAddParameterThatReferencesGlobalAndLiteral!public!tests! !
!AddParameterTest categoriesFor: #testAddParameterThatReferencesInstanceVariable!public! !
!AddParameterTest categoriesFor: #testAddParameterThatReferencesModelGlobal!public!tests! !
!AddParameterTest categoriesFor: #testAddParameterThatReferencesSelf!public!tests! !
!AddParameterTest categoriesFor: #testBadInitializationCode!failure tests!public! !
!AddParameterTest categoriesFor: #testModelBadInitializationCode!failure tests!public! !
!AddParameterTest categoriesFor: #testModelNonExistantName!failure tests!public! !
!AddParameterTest categoriesFor: #testNonExistantName!failure tests!public! !
!AddParameterTest categoriesFor: #testPrimitiveMethods!failure tests!public! !

