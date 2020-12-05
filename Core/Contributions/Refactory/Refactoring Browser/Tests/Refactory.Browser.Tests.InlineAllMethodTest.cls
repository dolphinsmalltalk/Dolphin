"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.InlineAllMethodTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.InlineAllMethodTest guid: (Core.GUID fromString: '{c022453d-1c4d-4bf0-a604-9abd6f068965}')!
Refactory.Browser.Tests.InlineAllMethodTest comment: ''!
!Refactory.Browser.Tests.InlineAllMethodTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.InlineAllMethodTest methodsFor!

testInlineMethodWithMultipleSendersInMethod
	| refactoring |
	refactoring := InlineAllSendersRefactoring sendersOf: #caller2 in: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp')
				parseTreeFor: #inlineLast)
		equals: (RBParser
				parseMethod: 'inlineLast
	5 = 3 ifTrue: [^self caller] ifFalse: [^(1 to: 10) inject: 1 into: [:sum :each | sum * (self foo: each)]] ').
	self assert: ((refactoring model classNamed: #'Refactory.Browser.Tests.RefactoryTestDataApp')
				parseTreeFor: #multipleCalls)
		equals: (RBParser
				parseMethod: 'multipleCalls
	(1 to: 10) inject: 1 into: [:sum :each | sum * (self foo: each)].
	(1 to: 10) inject: 1 into: [:sum1 :each1 | sum1 * (self foo: each1)]')!

testRecursiveMethod
	| class |
	model := RBNamespace new.
	class := model classNamed: self class fullName.
	class
		compile: 'foo ^self foo' classified: #(#accessing);
		compile: 'bar ^self foo' classified: #(#accessing).
	self executeRefactoring: (InlineAllSendersRefactoring
				model: model
				sendersOf: #foo
				in: class).
	self assert: (class parseTreeFor: #foo) equals: (RBParser parseMethod: 'foo ^self foo').
	self assert: (class parseTreeFor: #bar) equals: (RBParser parseMethod: 'bar ^self foo')! !
!Refactory.Browser.Tests.InlineAllMethodTest categoriesFor: #testInlineMethodWithMultipleSendersInMethod!public!tests! !
!Refactory.Browser.Tests.InlineAllMethodTest categoriesFor: #testRecursiveMethod!public!tests! !

