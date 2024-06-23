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
	| class refactoring method |
	class := model classNamed: #'Core.Object'.
	class addClassVariable: #Foo.
	class metaclass compile: 'foo ^Foo' classified: #accessing.
	self assert: ((model classFor: Object class) directlyDefinesMethod: #foo).
	refactoring := PushUpMethodRefactoring
				model: model
				pushUp: #(#foo)
				from: class metaclass.
	self executeRefactoring: refactoring.
	method := (model classFor: Class) methodFor: #foo.
	self assert: method boundParseTree equals: (self parseMethod: 'foo ^Foo').
	self deny: ((model classFor: Object class) directlyDefinesMethod: #foo)!

testPushUpExtensionMethodWithPackageNamespace
	"Tests pushing up an extension method relying on its package default namespace to bind an external variable reference."

	| refactoring targetClass pushedUp pushedUp2 expectedAst sourceClass selector |
	sourceClass := model classFor: ClassToRename.
	selector := 'refersToClassInPackageDefaultNamespace' asSymbol.
	refactoring := PushUpMethodRefactoring
				model: model
				pushUp: { selector }
				from: sourceClass.
	self executeRefactoring: refactoring.
	targetClass := model classFor: Model.
	pushedUp := targetClass methodFor: selector.
	self assertNotNil: pushedUp.
	self deny: (sourceClass directlyDefinesMethod: selector).
	expectedAst := self
				parseMethod: 'refersToClassInPackageDefaultNamespace ^{RefactoryTestDataApp. BasicLintRuleTestData}'.
	self assert: pushedUp boundParseTree equals: expectedAst.
	self assertIsNil: pushedUp realMethod.
	"Existing package association must be carried with the pushed-up method"
	self assert: pushedUp customEnvironment equals: (Refactory.Browser.TestData classInModel: model).
	self assert: pushedUp owningPackageIfLoose equals: (ClassToRename >> selector) owningPackage.
	"Now push it up again (so now a model only method)"
	refactoring := PushUpMethodRefactoring
				model: model
				pushUp: { selector }
				from: Model.
	self executeRefactoring: refactoring.
	pushedUp2 := (model classFor: Object) methodFor: selector.
	self assertNotNil: pushedUp.
	self deny: (targetClass directlyDefinesMethod: selector).
	self assert: pushedUp2 boundParseTree equals: expectedAst.
	self assertIsNil: pushedUp2 realMethod.
	self assert: pushedUp customEnvironment equals: (Refactory.Browser.TestData classInModel: model).
	self assert: pushedUp owningPackageIfLoose equals: (ClassToRename >> selector) owningPackage!

testPushUpMethodReferencingClassVariable
	"This used to be blocked, but is possible in Dolphin 8 (and actually earlier) by using qualified names, if the class variable in question is not private. The reference to the subclass class variable is just made qualified (enough) so that it binds in the superclass. The result is still a pure refactoring, although not necessarily a desirable end state. The subclass class variable can then be pulled up, if desired."

	| refactoring method |
	refactoring := PushUpMethodRefactoring
				model: model
				pushUp: #(#runRecursiveSelfRule:)
				from: TransformationRuleTestData.
	self executeRefactoring: refactoring.
	method := (model classFor: FooLintRuleTestData) methodFor: #runRecursiveSelfRule:.
	self assert: method boundParseTree
		equals: (self
				parseMethod: 'runRecursiveSelfRule: aParseTree ^TransformationRuleTestData.RecursiveSelfRule executeTree: aParseTree initialAnswer: false').
	self
		deny: ((model classFor: TransformationRuleTestData) directlyDefinesMethod: #runRecursiveSelfRule:)!

testPushUpMethodTwice
	| refactoring |
	refactoring := PushUpMethodRefactoring
				model: model
				pushUp: #(#runRecursiveSelfRule:)
				from: TransformationRuleTestData.
	self executeRefactoring: refactoring.
	refactoring := PushUpMethodRefactoring
				model: model
				pushUp: #(#runRecursiveSelfRule:)
				from: TransformationRuleTestData.
	self shouldFail: refactoring withMessage: 'TransformationRuleTestData does not define #runRecursiveSelfRule:'!

testPushUpMethodWithCopyOverriddenMethodsDown
	| refactoring |
	refactoring := PushUpMethodRefactoring
				model: model
				pushUp: #(#isComposite)
				from: CompositeLintRuleTestData.
	refactoring setOption: #copyDownSuperclassMethod
		toUse: 
			[:rcvr :selector |
			self assert: selector identicalTo: #isComposite.
			true].
	self executeRefactoring: refactoring.
	self assert: ((model classNamed: BasicLintRuleTestData fullName) parseTreeFor: #isComposite)
		equals: (self parseMethod: 'isComposite ^false').
	self assert: ((model classNamed: 'Refactory.Browser.TestData.Foo' , 'LintRuleTestData')
				parseTreeFor: #isComposite)
		equals: (self parseMethod: 'isComposite ^false').
	self assert: ((model classNamed: LintRuleTestData fullName) parseTreeFor: #isComposite)
		equals: (self parseMethod: 'isComposite ^true').
	self
		deny: ((model classNamed: CompositeLintRuleTestData fullName) directlyDefinesMethod: #isComposite)!

testPushUpMethodWithCustomEnvironment
	| refactoring targetClass pushedUp pushedUp2 source expectedAst sourceClass |
	sourceClass := model classFor: TransformationRuleTestData.
	refactoring := PushUpMethodRefactoring
				model: model
				pushUp: #(#unqualifiedRefToClassInCustomNamespace)
				from: sourceClass.
	self executeRefactoring: refactoring.
	targetClass := model classFor: FooLintRuleTestData.
	pushedUp := targetClass methodFor: #unqualifiedRefToClassInCustomNamespace.
	self assertNotNil: pushedUp.
	self deny: (sourceClass directlyDefinesMethod: #unqualifiedRefToClassInCustomNamespace).
	source := (TransformationRuleTestData >> #unqualifiedRefToClassInCustomNamespace) getSource.
	expectedAst := self parseMethod: source.
	self assert: pushedUp boundParseTree equals: expectedAst.
	self assertIsNil: pushedUp realMethod.
	"Existing package association must be carried with the pushed-up method"
	self assert: pushedUp customEnvironment equals: (Tools classInModel: model).
	self assert: pushedUp owningPackageIfLoose equals: self class owningPackage.
	"Now push it up again (so now a model only method)"
	refactoring := PushUpMethodRefactoring
				model: model
				pushUp: #(#unqualifiedRefToClassInCustomNamespace)
				from: FooLintRuleTestData.
	self executeRefactoring: refactoring.
	pushedUp2 := (model classFor: LintRuleTestData) methodFor: #unqualifiedRefToClassInCustomNamespace.
	self assertNotNil: pushedUp.
	self deny: (targetClass directlyDefinesMethod: #unqualifiedRefToClassInCustomNamespace).
	self assert: pushedUp2 boundParseTree equals: expectedAst.
	self assertIsNil: pushedUp2 realMethod.
	self assert: pushedUp2 customEnvironment equals: (Tools classInModel: model).
	self assert: pushedUp2 owningPackageIfLoose equals: self class owningPackage!

testPushUpMethodWithImportedVariableExpandingImports
	| refactoring targetClass pushedUp |
	refactoring := PushUpMethodRefactoring
				model: model
				pushUp: #(#sharedVarRefs)
				from: BasicLintRuleTestData.
	refactoring setOption: #addImports
		toUse: 
			[:ref :vars |
			self assert: (vars collect: [:each | each realReference]) asSortedArray
				equals: #(#{OS.FacilityCodes} #{OS.Win32Errors}).
			true].
	self executeRefactoring: refactoring.
	targetClass := model classFor: LintRuleTestData.
	pushedUp := targetClass methodFor: #sharedVarRefs.
	self assert: pushedUp boundParseTree
		equals: (self
				parseMethod: 'sharedVarRefs
	^{
		ENOENT.
		ERROR_FILE_NOT_FOUND.
		BasicLintRuleTestData.ERROR_FILE_EXISTS.
		ERROR_FILE_EXISTS.
		FACILITY_WIN32.
		OS.FacilityCodes.FACILITY_WIN32
	}').
	self deny: ((model classFor: BasicLintRuleTestData) directlyDefinesMethod: #sharedVarRefs)!

testPushUpMethodWithImportedVariableNotExpandingImports
	| refactoring pushedUp targetClass |
	refactoring := PushUpMethodRefactoring
				model: model
				pushUp: #(#sharedVarRefs)
				from: BasicLintRuleTestData.
	refactoring setOption: #addImports
		toUse: 
			[:ref :vars |
			self assert: (vars collect: [:each | each realReference]) asSortedArray
				equals: #(#{OS.FacilityCodes} #{OS.Win32Errors}).
			false].
	self executeRefactoring: refactoring.
	false ifTrue: [model browseChanges].
	targetClass := model classFor: LintRuleTestData.
	pushedUp := targetClass methodFor: #sharedVarRefs.
	self assert: pushedUp boundParseTree
		equals: (self
				parseMethod: 'sharedVarRefs
	^{
		ENOENT.
		OS.Win32Errors.ERROR_FILE_NOT_FOUND.
		BasicLintRuleTestData.ERROR_FILE_EXISTS.
		OS.Win32Errors.ERROR_FILE_EXISTS.
		FACILITY_WIN32.
		OS.FacilityCodes.FACILITY_WIN32
	}').
	self deny: ((model classFor: BasicLintRuleTestData) directlyDefinesMethod: #sharedVarRefs)!

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
		withMessage: 'Cannot push up #yourself since Foo2>>yourself sends a super message to Object that would be intercepted'!

testPushUpWithMethodThatCannotBePushedDown
	model
		defineClass: 'Object subclass: #SomeClass instanceVariableNames: '''' classVariableNames: ''Foo'' poolDictionaries: '''''.
	(model classNamed: #SomeClass) compile: 'yourself ^54' classified: #accessing.
	self shouldFail: (PushUpMethodRefactoring
				model: model
				pushUp: #(#yourself)
				from: (model classNamed: #SomeClass))
		withMessage: 'Non-abstract class Object or one of its superclasses already define #yourself'!

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
testPushUpExtensionMethodWithPackageNamespace!public!tests! !
testPushUpMethodReferencingClassVariable!public!tests! !
testPushUpMethodTwice!public!tests! !
testPushUpMethodWithCopyOverriddenMethodsDown!public!tests! !
testPushUpMethodWithCustomEnvironment!public!tests! !
testPushUpMethodWithImportedVariableExpandingImports!public!tests! !
testPushUpMethodWithImportedVariableNotExpandingImports!public!tests! !
testPushUpReferencesInstVar!failure tests!public! !
testPushUpWithInvalidSuperSend!failure tests!public! !
testPushUpWithMethodThatCannotBePushedDown!failure tests!public! !
testPushUpWithSuperSendThatCannotBeCopiedDown!failure tests!public! !
!

