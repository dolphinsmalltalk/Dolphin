"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.InlineAllSendersRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.InlineAllSendersRefactoringTest guid: (Core.GUID fromString: '{c022453d-1c4d-4bf0-a604-9abd6f068965}')!
Refactory.Browser.Tests.InlineAllSendersRefactoringTest comment: ''!
!Refactory.Browser.Tests.InlineAllSendersRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.InlineAllSendersRefactoringTest methodsFor!

testInlineMethodWithMultipleSendersInMethod
	| refactoring |
	refactoring := InlineAllSendersRefactoring sendersOf: #caller2 in: RefactoryTestDataApp.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classFor: RefactoryTestDataApp) parseTreeFor: #inlineLast)
		equals: (self
				parseMethod: 'inlineLast
	5 = 3 ifTrue: [^self caller] ifFalse: [^(1 to: 10) inject: 1 into: [:sum :each | sum * (self foo: each)]] ').
	self assert: ((refactoring model classFor: RefactoryTestDataApp) parseTreeFor: #multipleCalls)
		equals: (self
				parseMethod: 'multipleCalls
	(1 to: 10) inject: 1 into: [:sum :each | sum * (self foo: each)].
	(1 to: 10) inject: 1 into: [:sum1 :each1 | sum1 * (self foo: each1)]')!

testRecursiveMethod
	| class |
	model := RBModel new.
	class := model classNamed: self class fullName.
	class
		compile: 'foo ^self foo' classified: #accessing;
		compile: 'bar ^self foo' classified: #accessing.
	self executeRefactoring: (InlineAllSendersRefactoring
				model: model
				sendersOf: #foo
				in: class).
	self assert: (class parseTreeFor: #foo) equals: (self parseMethod: 'foo ^self foo').
	self assert: (class parseTreeFor: #bar) equals: (self parseMethod: 'bar ^self foo')! !
!Refactory.Browser.Tests.InlineAllSendersRefactoringTest categoriesForMethods!
testInlineMethodWithMultipleSendersInMethod!public!tests! !
testRecursiveMethod!public!tests! !
!

