"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.PushUpMethodRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.PushUpMethodRefactoringTest guid: (Core.GUID fromString: '{890376aa-d3a6-46bb-badd-a03b14ffd1cd}')!
Refactory.Browser.Tests.PushUpMethodRefactoringTest comment: ''!
!Refactory.Browser.Tests.PushUpMethodRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.PushUpMethodRefactoringTest methodsFor!

testPushUpAndCopyDown
	| class refactoring |
	model
		defineClass: 'Core.Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	model
		defineClass: 'SomeClass subclass: #SomeSubclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model
		defineClass: 'SomeSubclass subclass: #Foo1 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model
		defineClass: 'SomeSubclass subclass: #Foo2 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	class := model classNamed: #Foo1.
	class compile: 'yourself ^1' classified: #accessing.
	refactoring := PushUpMethodRefactoring
				model: model
				pushUp: #(#yourself)
				from: class.
	refactoring setOption: #copyDownSuperclassMethod
		toUse: 
			[:rcvr :selector |
			self assert: selector identicalTo: #yourself.
			true].
	self executeRefactoring: refactoring.
	self assert: (class superclass parseTreeFor: #yourself) equals: (self parseMethod: 'yourself ^1').
	self deny: (class directlyDefinesMethod: #yourself).
	class := model classNamed: #Foo2.
	self assert: (class directlyDefinesMethod: #yourself).
	self assert: (class parseTreeFor: #yourself)
		equals: ((model classNamed: #'Core.Object') parseTreeFor: #yourself)!

testPushUpClassMethod
	| class |
	class := model classNamed: #'Core.Object'.
	class addClassVariable: #Foo.
	class metaclass compile: 'foo ^Foo' classified: #accessing.
	self shouldFail: (PushUpMethodRefactoring
				model: model
				pushUp: #(#foo)
				from: class metaclass)
		withMessage: '#foo refers to Foo which is defined in Core.Object class'!

testPushUpMethodWithCopyOverriddenMethodsDown
	| refactoring |
	refactoring := PushUpMethodRefactoring pushUp: #(#isComposite) from: CompositeLintRuleTestData.
	refactoring setOption: #copyDownSuperclassMethod
		toUse: 
			[:rcvr :selector |
			self assert: selector identicalTo: #isComposite.
			true].
	self executeRefactoring: refactoring.
	self
		assert: ((refactoring model classNamed: BasicLintRuleTestData fullName) parseTreeFor: #isComposite)
		equals: (self parseMethod: 'isComposite ^false').
	self assert: ((refactoring model classNamed: 'Refactory.Browser.TestData.Foo' , 'LintRuleTestData')
				parseTreeFor: #isComposite)
		equals: (self parseMethod: 'isComposite ^false').
	self assert: ((refactoring model classNamed: LintRuleTestData fullName) parseTreeFor: #isComposite)
		equals: (self parseMethod: 'isComposite ^true').
	self deny: ((refactoring model classNamed: CompositeLintRuleTestData fullName)
				directlyDefinesMethod: #isComposite)!

testPushUpReferencesInstVar
	self shouldFail: (PushUpMethodRefactoring pushUp: #(#checkClass:) from: BasicLintRuleTestData)
		withMessage: '#checkClass: refers to classBlock which is defined in Refactory.Browser.TestData.BasicLintRuleTestData'!

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
	(model classNamed: #Foo2) compile: 'yourself ^super yourself + 1' classified: #accessing.
	class := model classNamed: #Foo1.
	class compile: 'yourself ^1' classified: #accessing.
	self shouldFail: (PushUpMethodRefactoring
				model: model
				pushUp: #(#yourself)
				from: class)
		withMessage: 'Cannot push up #yourself since Foo2>>yourself sends a super message to it.'!

testPushUpWithMethodThatCannotBePushedDown
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	(model classNamed: #SomeClass) compile: 'yourself ^54' classified: #accessing.
	self shouldFail: (PushUpMethodRefactoring
				model: model
				pushUp: #(#yourself)
				from: (model classNamed: #SomeClass))
		withMessage: 'Non-abstract class Core.Object or one of its superclasses already define #yourself'!

testPushUpWithSuperSendThatCannotBeCopiedDown
	| class |
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	(model classNamed: #'Core.Object') compile: 'foo ^3' classified: #accessing.
	model
		defineClass: 'SomeClass subclass: #Subclass instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(model classNamed: #Subclass) compile: 'foo ^super foo' classified: #accessing.
	model
		defineClass: 'Subclass subclass: #Foo1 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	model
		defineClass: 'Subclass subclass: #Foo2 instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''''.
	(class := model classNamed: #Foo2) compile: 'foo ^1' classified: #accessing.
	self shouldFail: (PushUpMethodRefactoring
				model: model
				pushUp: #(#foo)
				from: class)
		withMessage: 'The #foo method in superclass Subclass must be copied down to its other subclasses, but sends a super message that will be overridden.'! !
!Refactory.Browser.Tests.PushUpMethodRefactoringTest categoriesForMethods!
testPushUpAndCopyDown!public!tests! !
testPushUpClassMethod!failure tests!public! !
testPushUpMethodWithCopyOverriddenMethodsDown!public!tests! !
testPushUpReferencesInstVar!failure tests!public! !
testPushUpWithInvalidSuperSend!failure tests!public! !
testPushUpWithMethodThatCannotBePushedDown!failure tests!public! !
testPushUpWithSuperSendThatCannotBeCopiedDown!failure tests!public! !
!

