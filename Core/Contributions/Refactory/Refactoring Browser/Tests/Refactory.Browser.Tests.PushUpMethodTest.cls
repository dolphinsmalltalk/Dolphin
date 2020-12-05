"Filed out from Dolphin Smalltalk 7"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.PushUpMethodTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.PushUpMethodTest guid: (Core.GUID fromString: '{890376aa-d3a6-46bb-badd-a03b14ffd1cd}')!
Refactory.Browser.Tests.PushUpMethodTest comment: ''!
!Refactory.Browser.Tests.PushUpMethodTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.PushUpMethodTest methodsFor!

testPushUpAndCopyDown
	| class |
	model
		defineClass: 'Core.Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	model
		defineClass: 'SomeClass subclass: #SomeSubclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model
		defineClass: 'SomeSubclass subclass: #Foo1 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model
		defineClass: 'SomeSubclass subclass: #Foo2 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	class := model classNamed: #Foo1.
	class compile: 'yourself ^1' classified: #(#accessing).
	self executeRefactoring: (PushUpMethodRefactoring
				model: model
				pushUp: #(#yourself)
				from: class).
	self assert: (class superclass parseTreeFor: #yourself)
		equals: (RBParser parseMethod: 'yourself ^1').
	self deny: (class directlyDefinesMethod: #yourself).
	class := model classNamed: #Foo2.
	self assert: (class directlyDefinesMethod: #yourself).
	self assert: (class parseTreeFor: #yourself)
		equals: ((model classNamed: #'Core.Object') parseTreeFor: #yourself)!

testPushUpClassMethod
	| class |
	class := model classNamed: #'Core.Object'.
	class addClassVariable: #Foo.
	class metaclass compile: 'foo ^Foo' classified: #(#accessing).
	self shouldFail: (PushUpMethodRefactoring
				model: model
				pushUp: #(#foo)
				from: class metaclass)!

testPushUpMethodWithCopyOverriddenMethodsDown
	| refactoring |
	self proceedThroughWarning: 
			[refactoring := PushUpMethodRefactoring pushUp: #(#isComposite) from: CompositeLintRuleTest.
			self executeRefactoring: refactoring].
	self assert: ((refactoring model classNamed: BasicLintRuleTest fullName) parseTreeFor: #isComposite)
		equals: (RBParser parseMethod: 'isComposite ^false').
	self assert: ((refactoring model classNamed: FooLintRuleTest fullName) parseTreeFor: #isComposite)
		equals: (RBParser parseMethod: 'isComposite ^false').
	self assert: ((refactoring model classNamed: LintRuleTest fullName) parseTreeFor: #isComposite)
		equals: (RBParser parseMethod: 'isComposite ^true').
	self deny: ((refactoring model classNamed: CompositeLintRuleTest fullName)
				directlyDefinesMethod: #isComposite)!

testPushUpReferencesInstVar
	self shouldFail: (PushUpMethodRefactoring pushUp: #(#checkClass:) from: BasicLintRuleTest)!

testPushUpWithInvalidSuperSend
	| class |
	model
		defineClass: 'Core.Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model
		defineClass: 'Subclass subclass: #Foo1 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model
		defineClass: 'Subclass subclass: #Foo2 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model classNamed: #Foo2) compile: 'yourself ^super yourself + 1' classified: #(#accessing).
	class := model classNamed: #Foo1.
	class compile: 'yourself ^1' classified: #(#accessing).
	self shouldFail: (PushUpMethodRefactoring
				model: model
				pushUp: #(#yourself)
				from: class)!

testPushUpWithMethodThatCannotBePushedDown
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	(model classNamed: #SomeClass) compile: 'yourself ^54' classified: #(#accessing).
	self shouldFail: (PushUpMethodRefactoring
				model: model
				pushUp: #(#yourself)
				from: (model classNamed: #SomeClass))!

testPushUpWithSuperSendThatCannotBeCopiedDown
	| class |
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	(model classNamed: #'Core.Object') compile: 'foo ^3' classified: #(#accessing).
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model classNamed: #Subclass) compile: 'foo ^super foo' classified: #(#accessing).
	model
		defineClass: 'Subclass subclass: #Foo1 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model
		defineClass: 'Subclass subclass: #Foo2 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(class := model classNamed: #Foo2) compile: 'foo ^1' classified: #(#accessing).
	self shouldFail: (PushUpMethodRefactoring
				model: model
				pushUp: #(#foo)
				from: class)! !
!Refactory.Browser.Tests.PushUpMethodTest categoriesFor: #testPushUpAndCopyDown!public!tests! !
!Refactory.Browser.Tests.PushUpMethodTest categoriesFor: #testPushUpClassMethod!failure tests!public! !
!Refactory.Browser.Tests.PushUpMethodTest categoriesFor: #testPushUpMethodWithCopyOverriddenMethodsDown!public!tests! !
!Refactory.Browser.Tests.PushUpMethodTest categoriesFor: #testPushUpReferencesInstVar!failure tests!public! !
!Refactory.Browser.Tests.PushUpMethodTest categoriesFor: #testPushUpWithInvalidSuperSend!failure tests!public! !
!Refactory.Browser.Tests.PushUpMethodTest categoriesFor: #testPushUpWithMethodThatCannotBePushedDown!failure tests!public! !
!Refactory.Browser.Tests.PushUpMethodTest categoriesFor: #testPushUpWithSuperSendThatCannotBeCopiedDown!failure tests!public! !

