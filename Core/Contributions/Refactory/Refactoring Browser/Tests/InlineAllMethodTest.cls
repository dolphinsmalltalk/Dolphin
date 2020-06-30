"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #InlineAllMethodTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
InlineAllMethodTest guid: (GUID fromString: '{c022453d-1c4d-4bf0-a604-9abd6f068965}')!
InlineAllMethodTest comment: ''!
!InlineAllMethodTest categoriesForClass!Refactory-Testing! !
!InlineAllMethodTest methodsFor!

testInlineMethodWithMultipleSendersInMethod
	| refactoring |
	refactoring := InlineAllSendersRefactoring sendersOf: #caller2 in: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #RefactoryTestDataApp) parseTreeFor: #inlineLast)
		equals: (RBParser
				parseMethod: 'inlineLast
	5 = 3 ifTrue: [^self caller] ifFalse: [^(1 to: 10) inject: 1 into: [:sum :each | sum * (self foo: each)]] ').
	self assert: ((refactoring model classNamed: #RefactoryTestDataApp) parseTreeFor: #multipleCalls)
		equals: (RBParser
				parseMethod: 'multipleCalls
	(1 to: 10) inject: 1 into: [:sum :each | sum * (self foo: each)].
	(1 to: 10) inject: 1 into: [:sum1 :each1 | sum1 * (self foo: each1)]')!

testRecursiveMethod
	| class |
	model := RBNamespace new.
	class := model classNamed: self class name.
	class
		compile: 'foo ^self foo' classified: #(#accessing);
		compile: 'bar ^self foo' classified: #(#accessing).
	self executeRefactoring: (InlineAllSendersRefactoring
				model: model
				sendersOf: #foo
				in: class).
	self assert: (class parseTreeFor: #foo) equals: (RBParser parseMethod: 'foo ^self foo').
	self assert: (class parseTreeFor: #bar) equals: (RBParser parseMethod: 'bar ^self foo')! !
!InlineAllMethodTest categoriesFor: #testInlineMethodWithMultipleSendersInMethod!public!tests! !
!InlineAllMethodTest categoriesFor: #testRecursiveMethod!public!tests! !

