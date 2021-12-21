"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Tools.Tests.RenameClassRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{Refactory.Browser} #{Refactory.Browser.Tests})
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.RenameClassRefactoringTest guid: (Core.GUID fromString: '{1c8b1cc4-4d25-46fc-9e56-b959e7a8e2f1}')!
Tools.Tests.RenameClassRefactoringTest comment: ''!
!Tools.Tests.RenameClassRefactoringTest categoriesForClass!Refactory-Testing! !
!Tools.Tests.RenameClassRefactoringTest methodsFor!

compile: aString in: class
	^class compile: (Parser parseMethod: aString in: class) formattedCode classified: #'test model methods'!

defineClass: aString
	model defineClass: (Parser parseExpression: aString) formattedCode!

showChanges
	"Private - Diagnostic aid"

	UI.Keyboard default isShiftDown ifTrue: [model browseChanges]!

testBadName
	#namespaceToDo.	"First case bodged to pass by forcing to a full name for the target; if passed an unqualified name RenameClassRefactoring has been modified to assume the namespace is not being changed, so it prepends the existing class namespace."
	self
		shouldFail: (RenameClassRefactoring rename: Refactory.Browser.Tests.LintRuleTestData to: 'Object.' , self objectClassVariable)
			withMessage: 'Object._EventsRegister is a class or global variable';
		shouldFail: (RenameClassRefactoring rename: Refactory.Browser.Tests.LintRuleTestData to: #'Ob ject')
			withMessage: '''Refactory.Browser.Tests.Ob ject'' is not a valid class name'!

testExistingName
	self shouldFail: (RenameClassRefactoring
				model: model
				rename: self class
				to: 'Core.Object')
		withMessage: 'Core.Object is a class or global variable'!

testMetaClassFailure
	self shouldFail: (RenameClassRefactoring
				model: model
				rename: self class class
				to: #Foo)
		withMessage: '<1s> class is not an existing class' << self class fullName!

testModelRenameClass
	| refactoring class |
	model
		defineClass: 'Core.Object subclass: #''Core.Foo'' instanceVariableNames: ''a'' classVariableNames: '''' poolDictionaries: ''Core.Object'''.
	class := model classNamed: #'Core.Foo'.
	class compile: 'refersToClass ^{Object. Core.Object}' classified: #accessing.
	"Relative and fully-qualified binding references"
	class compile: 'refersToClassBinding ^#(#{Object} #{Core.Object})' classified: #accessing.
	"Method referencing the class name symbol embedded in an array"
	class compile: 'refersToClassName ^#(Object #''Core.Object'')' classified: #accessing.
	"Ensure the test covers renaming a class import too"
	self assert: (class imports includes: #{Core.Object}).
	refactoring := RenameClassRefactoring
				model: model
				rename: Object
				to: #Thing.
	refactoring setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | true].
	self executeRefactoring: refactoring.
	"Object should be renamed in the model"
	self assert: (model includesClassNamed: #'Core.Thing').
	self deny: (model includesClassNamed: Object fullName).
	self assert: class superclass name equals: #'Core.Thing'.
	self assert: (class imports includes: #{Core.Thing}).
	"References to the class in methods should be renamed - note that the redundant qualification is removed as the names are minimised"
	self
		verifyMethod: #refersToClass
		of: class
		equals: '<1s> ^{Thing. Thing}'.
	"Qualified references"
	self
		verifyMethod: #refersToClassBinding
		of: class
		equals: '<1s> ^#(#{Thing} #{Core.Thing})'.
	"References to the class name, whether unqualified or fully qualified, are no longer renamed."
	self
		verifyMethod: #refersToClassName
		of: class
		equals: '<1s> ^#(#Object #''Core.Object'')'!

testModelRenameSequenceClass
	| refactoring symbolicRefs refactoring2 |
	model
		defineClass: 'Object subclass: #Foo1 
			instanceVariableNames: '''' 
			classVariableNames: '''' poolDictionaries: ''''
			category: #''Refactory-Test data'''.
	(model classNamed: #Foo1)
		compile: 'foo	 ^ Foo1' classified: #accessing;
		compile: 'objectName ^ #(Foo1)' classified: #accessing.
	refactoring := RenameClassRefactoring
				model: model
				rename: (model classNamed: #Foo1)
				to: #Foo2.
	refactoring setOption: #ignoreSymbolicClassReferences
		toUse: 
			[:rename :refs |
			symbolicRefs := refs.
			true].
	self executeRefactoring: refactoring.
	self assert: (symbolicRefs
				anySatisfy: [:each | each methodClass realClass == self class and: [each selector == self selector]]).
	self deny: (model includesClassNamed: #Foo1).
	self assert: (model includesClassNamed: #Foo2).
	self
		verifyMethod: #foo
		of: (model classNamed: #Foo2)
		equals: '<1s> ^ Foo2'.
	refactoring := RenameClassRefactoring
				model: model
				rename: (model classNamed: #Foo2)
				to: #Foo3.
	refactoring setOption: #ignoreSymbolicClassReferences
		toUse: 
			[:rename :refs |
			symbolicRefs := refs.
			true].
	self executeRefactoring: refactoring.
	self assert: (symbolicRefs
				anySatisfy: [:each | each methodClass realClass == self class and: [each selector == self selector]]).
	self deny: (model includesClassNamed: #Foo1).
	self deny: (model includesClassNamed: #Foo2).
	self assert: (model includesClassNamed: #Foo3).
	self
		verifyMethod: #foo
		of: (model classNamed: #Foo3)
		equals: 'foo ^ Foo3'.
	"Symbols are not renamed anymore"
	self
		verifyMethod: #objectName
		of: (model classNamed: #Foo3)
		equals: '<1s> ^ #(Foo1)'!

testModelRenameUpdatesUnqualifiedBindingReference
	| fooClass refactoring barClass |
	self
		defineClass: 'Kernel.Object subclass: #''Kernel.Foo'' instanceVariableNames: '''' classVariableNames: '''' imports: #() classInstanceVariableNames: '''' classConstants: {}'.
	fooClass := model classNamed: #'Kernel.Foo'.
	self
		defineClass: 'Core.Object subclass: #''Core.Bar'' instanceVariableNames: '''' classVariableNames: '''' imports: #() classInstanceVariableNames: '''' classConstants: {}'.
	barClass := model classNamed: #'Core.Bar'.
	self compile: 'refersToClassUnqualifiedBinding ^#{Foo}' in: barClass.
	"Now rename Foo"
	refactoring := RenameClassRefactoring
				model: model
				rename: fooClass
				to: #'Core.FooBar'.
	refactoring setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | true].
	self executeRefactoring: refactoring.
	self
		verifyMethod: #refersToClassUnqualifiedBinding
		of: barClass
		equals: '<1s> ^#{FooBar}'!

testNoRename
	| refactoring class |
	class := 'Refactory.Browser.Tests.ClassToRename' asQualifiedReference value.
	refactoring := RenameClassRefactoring
				model: model
				rename: class
				to: class fullName.
	"Maybe this should just do nothing, but it has always thrown a RefactoringError because of the precondition that the target does not exist. It does mean that the refactoring can always assume that the name has been changed during transform."
	self shouldFail: refactoring withMessage: '<1s> is a class or global variable' << class fullName!

testRenameAmbiguousClassName
	| class refactoring |
	model := RBModel onEnvironment: (BrowserEnvironment new
						forClasses: {Bitmap. Gdiplus.Bitmap. Graphics.Tests.BitmapTest. Graphics.Gdiplus.Tests.BitmapTest}).
	class := model classNamed: #'Graphics.Bitmap'.
	refactoring := RenameClassRefactoring
				model: model
				rename: class
				to: #'UI.Bitmap'.
	self executeRefactoring: refactoring.
	self verifyMethod: #subjectClass of: (model classFor: Graphics.Gdiplus.Tests.BitmapTest) equals: '<1s> ^Bitmap'.
	self verifyMethod: #gdiBitmapClass of: (model classFor: Graphics.Gdiplus.Tests.BitmapTest) equals: '<1s> ^UI.Bitmap'!

testRenameChangeNamespace
	"Tests a rename that changes a class' namespace (i.e. moves it to a new namespace), but not it's unqualified name"

	| refactoring subclass oldName newClass classToRename foo smalltalk symbolicRefs |
	oldName := 'Refactory.Browser.Tests.ClassToRename'.
	#('Foo' 'Kernel.Bar' 'Refactory.Browser.Tests.FooBar') do: 
			[:each |
			model
				defineClass: 'Core.Object subclass: #<1p> instanceVariableNames: '''' classVariableNames: '''' poolDictionaries: '''' category: #''Refactory-Test data'''
						<< each.
			(model classNamed: each) compile: 'foo<n>	 ^<1s>' << oldName classified: #accessing].
	"Some sanity checks"
	foo := model classNamed: 'Foo'.
	smalltalk := model classFor: Smalltalk.
	self assert: foo environment identicalTo: smalltalk.
	self assert: (smalltalk localBindingFor: 'Foo') value identicalTo: foo.
	"Now rename Refactory.Browser.Tests.ClassToRename to Smalltalk.ClassToRename, effectively changing just its namespace"
	classToRename := oldName asQualifiedReference value.
	refactoring := RenameClassRefactoring
				model: model
				rename: classToRename
				to: 'Smalltalk.ClassToRename'.
	refactoring setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | symbolicRefs := refs. true].
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: 'Smalltalk.ClassToRename'.
	self denyIsNil: newClass.
	self deny: (refactoring model includesClassNamed: oldName).
	self
		verifyMethod: #method1
		of: newClass
		equals: '<1s> ^self method2'.
	"Model class Foo was defined in Smalltalk, so it can now reference Smalltalk.ClassToRename using just its unqualified name"
	self
		verifyMethod: #foo
		of: foo
		equals: '<1s> ^ClassToRename'.
	"Model class Bar was defined in Kernel, so must still use a fully-qualified name (no change)"
	self
		verifyMethod: #foo
		of: (model classNamed: 'Kernel.Bar')
		equals: '<1s> ^Smalltalk.ClassToRename'.
	"Model class FooBar was defined in the original namespace, not the one the renamed class is moved to, so the unqualified referenced must be rewritten to fully-qualified to remain bindable, i.e. Smalltalk.ClassToRename"
	self
		verifyMethod: #foo
		of: (model classNamed: 'Refactory.Browser.Tests.FooBar')
		equals: '<1s> ^Smalltalk.ClassToRename'.

	"The subclass is now in a different namespace, so all the references from it should have become fully qualified"
	subclass := refactoring model classNamed: Refactory.Browser.Tests.SubclassOfClassToRename fullName.
	self assert: subclass superclass equals: newClass.
	self
		verifyRenames: newClass
		unqualified: newClass fullName
		full: newClass fullName!

testRenameChangeNamespaceToImported
	| refactoring subclass oldName unqualifiedName newFullName newClass classToRename |
	unqualifiedName := 'ClassToRename'.
	oldName := 'Refactory.Browser.Tests.' , unqualifiedName.
	classToRename := oldName asQualifiedReference value.
	newFullName := 'Core.' , unqualifiedName.
	refactoring := RenameClassRefactoring
				model: model
				rename: classToRename
				to: newFullName.
	refactoring setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | true].
	self executeRefactoring: refactoring.
	newClass := model classNamed: newFullName.
	self denyIsNil: newClass.
	self
		verifyMethod: #method1
		of: newClass
		equals: '<1s> ^self method2'.
	self deny: (model includesClassNamed: oldName).
	"The subclass is now in a different namespace, but has a reachable import of the new namespace (Core) so all the references should be unqualified"
	subclass := model classFor: Refactory.Browser.Tests.SubclassOfClassToRename.
	self assert: subclass superclass equals: newClass.
	self
		verifyRenames: newClass
		unqualified: newClass unqualifiedName
		full: newClass fullName!

testRenameClass
	"Test the relatively simple case of renaming an existing class' unqualified name, without changing its namespace. The class has a variety of references from a subclass that exists (no model only classes in this test)"

	| refactoring subclass oldName newFullName newClass classToRename symbolicRefs |
	oldName := 'Refactory.Browser.Tests.ClassToRename'.
	classToRename := oldName asQualifiedReference value.
	refactoring := RenameClassRefactoring
				model: model
				rename: classToRename
				to: 'NewClassName'.
	refactoring setOption: #ignoreSymbolicClassReferences
		toUse: 
			[:rename :refs |
			symbolicRefs := refs collect: [:each | each method].
			true].
	self executeRefactoring: refactoring.
	self showChanges.
	newFullName := oldName asQualifiedReference environment fullNameFor: 'NewClassName'.
	self assert: newFullName equals: 'Refactory.Browser.Tests.NewClassName'.
	newClass := model classNamed: newFullName.
	self denyIsNil: newClass.
	self
		verifyMethod: #method1
		of: newClass
		equals: '<1s> ^self method2'.
	self deny: (model includesClassNamed: oldName).
	subclass := model classFor: Refactory.Browser.Tests.SubclassOfClassToRename.
	self assert: subclass superclass equals: newClass.
	self assert: subclass superclass equals: newClass.
	self
		verifyRenames: newClass
		unqualified: newClass unqualifiedName
		full: newClass fullName.
	self assert: symbolicRefs asArray sort equals: {RefactoryTestDataApp>>#refersToClassUnqualifiedName.  RefactoryTestDataApp>>#refersToClassUnqualifiedNameInArray. SubclassOfClassToRename>>#refersToClassUnqualifiedName}!

testRenameClassShadowingImported
	"Test the case of renaming a class to a new name that shadows an imported class, changing the binding of existing unqualified/part-qualified references to the imported class."

	| class refactoring myClass |
	self
		defineClass: 'Core.Object subclass: #''Core.Foo'' instanceVariableNames: '''' classVariableNames: '''' imports: #(#{Tools.Tests}) classInstanceVariableNames: '''' classConstants: {}'.
	class := model classNamed: #'Core.Foo'.
	self
		compile: 'referencesToImportedClass ^{RenameClassRefactoringTest. #{RenameClassRefactoringTest}. #RenameClassRefactoringTest. #{Foo}}'
		in: class.
	"Currently the Foo method should be binding the test class"
	myClass := model classFor: self class.
	self assert: (class fullBindingFor: 'RenameClassRefactoringTest') value identicalTo: myClass.
	self assert: (class whichMethodsReferToClass: myClass) asArray
		equals: {class methodFor: #referencesToImportedClass}.
	"Now rename Foo to shadow to have the same name as the test class, shading it out. The unqualified references to the test class must be replaced with fully-qualified references."
	refactoring := RenameClassRefactoring
				model: model
				rename: class
				to: #'Core.RenameClassRefactoringTest'.
	refactoring setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | true].
	self executeRefactoring: refactoring.
	self showChanges.
	"Note that symbolic names are no longer changed"
	self
		verifyMethod: #referencesToImportedClass
		of: class
		equals: '<1s> ^{Tools.Tests.RenameClassRefactoringTest. #{Tools.Tests.RenameClassRefactoringTest}. #RenameClassRefactoringTest. #{RenameClassRefactoringTest}}'!

testRenameNamespace
	"Renaming a Namespace is like a normal Class rename for direct references, but there could also be indirect references. In fact all the classes in the Namespace are effectively being renamed. This means we need to consider all references to all classes in the namespace, including any sub-namespace classes, and any classes in those sub-namespaces, and so on. Some cases to consider:
	- Renamed Namespace is part of the path of fully or partially qualified references to classes or variables"

	#namespaceToDo!

verifyRenames: aRBClass unqualified: unqualified full: fullyQualified
	| subclass class ast |
	subclass := model classFor: Refactory.Browser.Tests.SubclassOfClassToRename.
	self assert: subclass superclass equals: aRBClass.
	class := model classFor: Refactory.Browser.Tests.RefactoryTestDataApp.
	self assert: subclass superclass equals: aRBClass.
	"The symbolic refs should no longer be renamed."
	{subclass. class} do: 
			[:eachClass |
			{#refersToClassUnqualifiedName.
				'ClassToRename' asSymbol.
				#refersToClassPartiallyQualifiedName.
				#'Tests.ClassToRename'.
				#refersToOtherClassPartiallyQualifiedName.
				#'Tools.ClassToRename'.
				#refersToClassFullyQualifiedName.
				'Refactory.Browser.Tests.ClassToRename' asSymbol} pairsDo: 
						[:selector :expected |
						self
							verifyMethod: selector
							of: eachClass
							equals: '<1s> ^' , expected printString]].
	"Variable references are replaced with the minimal qualification required - in this case unqualified"
	{subclass. class} do: 
			[:eachClass |
			#(#refersToClassUnqualified #refersToClassFullyQualified #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2)
				do: 
					[:each |
					self
						verifyMethod: each
						of: eachClass
						equals: '<1s> ^' , unqualified]].
	{subclass. class} do: 
			[:eachClass |
			{#refersToClassUnqualifiedBinding.
				unqualified asQualifiedReference.
				#refersToClassPartiallyQualifiedBinding1.
				unqualified asQualifiedReference.
				#refersToClassPartiallyQualifiedBinding2.
				unqualified asQualifiedReference.
				#refersToOtherClassPartiallyQualifiedBinding.
				#{_.Tools.ClassToRename}.
				#refersToClassFullyQualifiedBinding.
				fullyQualified asQualifiedReference} pairsDo: 
						[:selector :expected |
						self
							verifyMethod: selector
							of: eachClass
							equals: '<1s> ^' , expected printString]].
	ast := subclass parseTreeFor: #externalReference:_:.
	self assert: ast
		equals: (self
				parseMethod: 'externalReference: aClassToRename _: aClassToRename2 %<stdcall: <1s>* dummy <1s> <1s>*>'
						<< unqualified).
	"Check that the name does bind, but of course it isn't a structure type so we expect another type of semantic error"
	self
		should: [ast analyze]
		raise: Parser notificationClass
		matching: [:ex | ex displayString = ('Error: invalid structure class type ''<1s>*''' << unqualified)]! !
!Tools.Tests.RenameClassRefactoringTest categoriesForMethods!
compile:in:!helpers!private! !
defineClass:!helpers!private! !
showChanges!helpers!private! !
testBadName!failure tests!public! !
testExistingName!failure tests!public! !
testMetaClassFailure!failure tests!public! !
testModelRenameClass!public!tests! !
testModelRenameSequenceClass!public!tests! !
testModelRenameUpdatesUnqualifiedBindingReference!public!tests! !
testNoRename!failure tests!public! !
testRenameAmbiguousClassName!public!tests! !
testRenameChangeNamespace!public!tests! !
testRenameChangeNamespaceToImported!public!tests! !
testRenameClass!public!tests! !
testRenameClassShadowingImported!public!tests! !
testRenameNamespace!failure tests!public! !
verifyRenames:unqualified:full:!helpers!private! !
!

