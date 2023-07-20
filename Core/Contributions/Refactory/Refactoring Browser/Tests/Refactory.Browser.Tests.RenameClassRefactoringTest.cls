"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.RenameClassRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RenameClassRefactoringTest guid: (Core.GUID fromString: '{1c8b1cc4-4d25-46fc-9e56-b959e7a8e2f1}')!
Refactory.Browser.Tests.RenameClassRefactoringTest comment: ''!
!Refactory.Browser.Tests.RenameClassRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RenameClassRefactoringTest methodsFor!

compile: aString in: class
	^class compile: (Parser parseMethod: aString in: class) formattedCode classified: #'test model methods'!

defineClass: aString
	model defineClass: (Parser parseExpression: aString) formattedCode!

testBadName
	| existing |
	existing := 'Object.' , self objectClassVariable.
	self
		shouldFail: (RenameClassRefactoring rename: LintRuleTestData to: existing)
			existingVariable: existing;
		shouldFail: (RenameClassRefactoring rename: LintRuleTestData to: #'Ob ject')
			withMessage: '''Smalltalk.Ob ject'' is not a valid class name'!

testExistingClassVariableName
	| refactoring subclass |
	refactoring := RenameClassRefactoring
				model: model
				rename: ClassToRename
				to: (ClassToRename environment fullNameFor: 'ClassVar1').
	refactoring setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | true].
	self executeRefactoring: refactoring.
	"The renamed class now has the same name as a class variable that is referred to in a subclass - the subclass references will now need to be qualified to avoid binding to the class variable instead."
	subclass := model classFor: SubclassOfClassToRename.
	self
		verifyMethod: #refersToClassUnqualified
		of: subclass
		equals: 'refersToClassUnqualified ^Tests.ClassVar1'.
	self
		verifyMethod: #refersToClassUnqualifiedBinding
		of: subclass
		equals: 'refersToClassUnqualifiedBinding ^#{_.Tests.ClassVar1}'.
	"But the class variable reference doesn't need qualification, even though the name is ambiguous, because the class vars bind more tightly."
	#(#refersToInheritedClassVariableFullyQualified #refersToInheritedClassVariableQualifiedByOwnName)
		do: 
			[:each |
			self
				verifyMethod: each
				of: subclass
				equals: '<1s> ^ClassVar1' << each].
	"Except in the case where we have deliberately contrived to shadow the class variable with a local temp"
	self
		verifyMethod: #refersToInheritedClassVariableWithShadowing
		of: subclass
		equals: 'refersToInheritedClassVariableWithShadowing
	| ClassVar1 |
	ClassVar1 := Tests.ClassVar1.ClassVar1, Tests.ClassVar1.ClassVar1.
	^ClassVar1'.
	self
		verifyMethod: #refersToInheritedClassVariableUnqualifiedBinding
		of: subclass
		equals: 'refersToInheritedClassVariableUnqualifiedBinding ^#{ClassVar1}'.
	"Fully-qualified binding references, are left fully-qualified though"
	self
		verifyMethod: #refersToInheritedClassVariableFullyQualifiedBinding
		of: subclass
		equals: 'refersToInheritedClassVariableFullyQualifiedBinding ^#{Refactory.Browser.Tests.ClassVar1.ClassVar1}'!

testExistingName
	self shouldFail: (RenameClassRefactoring
				model: model
				rename: self class
				to: 'Core.Object')
		existingVariable: 'Core.Object'!

testFixedName
	self shouldFail: (RenameClassRefactoring
				model: model
				rename: Smalltalk
				to: #Foo)
		withMessage: 'The Smalltalk namespace cannot be renamed'.
	self shouldFail: (RenameClassRefactoring
				model: model
				rename: (Root classInModel: model)
				to: #Foo)
		withMessage: 'The Root namespace cannot be renamed'!

testMetaClassFailure
	self shouldFail: (RenameClassRefactoring
				model: model
				rename: self class class
				to: #Foo)
		withMessage: '<1s> class is not an existing class' << self class fullName!

testModelRenameClass
	<knownSlowTest>
	| refactoring fooClass change |
	model
		defineClass: 'Core.Object subclass: #''Core.Foo'' instanceVariableNames: ''a'' classVariableNames: '''' poolDictionaries: ''Core.Object'''.
	fooClass := model classNamed: #'Core.Foo'.
	fooClass compile: 'refersToClass ^{Object. Core.Object}' classified: #accessing.
	"Relative and fully-qualified binding references"
	fooClass compile: 'refersToClassBinding ^#(#{Object} #{Core.Object})' classified: #accessing.
	"Method referencing the class name symbol embedded in an array"
	fooClass compile: 'refersToClassName ^#(Object #''Core.Object'')' classified: #accessing.
	"Ensure the test covers renaming a class import too"
	self assert: (fooClass imports includes: #{Core.Object}).
	refactoring := RenameClassRefactoring
				model: model
				rename: Object
				to: 'Core.Thing'.
	refactoring setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | true].
	self executeRefactoring: refactoring.
	"Object should be renamed in the model"
	self assert: (model includesClassNamed: #'Core.Thing').
	self deny: (model includesClassNamed: Object fullName).
	self assert: fooClass superclass name equals: #'Core.Thing'.
	self assert: (fooClass imports includes: #{Core.Thing}).
	change := model changes
				lastChangeMatching: [:each | (each isKindOf: ClassImportsChange) and: [each imports includes: #{Core.Thing}]].
	self assertNotNil: change.
	self assert: (change imports allSatisfy: [:each | each isKindOf: FullBindingReference]).
	"References to the class in methods should be renamed - note that the redundant qualification is removed as the names are minimised"
	self
		verifyMethod: #refersToClass
		of: fooClass
		equals: 'refersToClass ^{Thing. Thing}'.
	"Qualified references"
	self
		verifyMethod: #refersToClassBinding
		of: fooClass
		equals: 'refersToClassBinding ^#(#{Thing} #{Core.Thing})'.
	"References to the class name, whether unqualified or fully qualified, are no longer renamed."
	self
		verifyMethod: #refersToClassName
		of: fooClass
		equals: 'refersToClassName ^#(#Object #''Core.Object'')'!

testModelRenameSequenceClass
	| refactoring symbolicRefs refactoring2 foo2 foo3 |
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
	foo2 := model classNamed: #Foo2.
	self assertNotNil: foo2.
	self
		verifyMethod: #foo
		of: foo2
		equals: 'foo ^ Foo2'.
	refactoring2 := RenameClassRefactoring
				model: model
				rename: foo2
				to: #Foo3.
	refactoring2 setOption: #ignoreSymbolicClassReferences
		toUse: 
			[:rename :refs |
			symbolicRefs := refs.
			true].
	self executeRefactoring: refactoring2.
	self assert: (symbolicRefs
				anySatisfy: [:each | each methodClass realClass == self class and: [each selector == self selector]]).
	self deny: (model includesClassNamed: #Foo1).
	self deny: (model includesClassNamed: #Foo2).
	foo3 := model classNamed: #Foo3.
	self assertNotNil: foo3.
	self
		verifyMethod: #foo
		of: foo3
		equals: 'foo ^ Foo3'.
	"Symbols are not renamed anymore"
	self
		verifyMethod: #objectName
		of: foo3
		equals: 'objectName ^ #(Foo1)'!

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
		equals: 'refersToClassUnqualifiedBinding ^#{FooBar}'!

testNoRename
	| refactoring class |
	class := 'Refactory.Browser.Tests.ClassToRename' asQualifiedReference value.
	refactoring := RenameClassRefactoring
				model: model
				rename: class
				to: class fullName.
	"Maybe this should just do nothing, but it has always thrown a RefactoringError because of the precondition that the target does not exist. It does mean that the refactoring can always assume that the name has been changed during transform."
	self shouldFail: refactoring existingVariable: class fullName!

testRenameAmbiguousClassName
	| class refactoring |
	model := RBModel onEnvironment: (BrowserEnvironment new
						forClasses: (#(#{Graphics.GraphicsTool} #{Graphics.Image} #{Graphics.Bitmap} #{Graphics.Gdiplus.Bitmap} #{Graphics.Tests.BitmapTest} #{Graphics.Gdiplus.Tests.BitmapTest})
								collect: [:each | each value])).
	class := model classNamed: #'Graphics.Bitmap'.
	refactoring := RenameClassRefactoring
				model: model
				rename: class
				to: #'UI.Bitmap'.
	self executeRefactoring: refactoring.
	self
		verifyMethod: #subjectClass
		of: #{Graphics.Gdiplus.Tests.BitmapTest} value
		equals: 'subjectClass ^Bitmap'.
	self
		verifyMethod: #gdiBitmapClass
		of: #{Graphics.Gdiplus.Tests.BitmapTest} value
		equals: 'gdiBitmapClass ^UI.Bitmap'!

testRenameChangeNamespace
	"Tests a rename that changes a class' namespace (i.e. moves it to a new namespace), but not it's unqualified name"

	| refactoring oldName newClass classToRename foo smalltalk change package method |
	oldName := 'Refactory.Browser.Tests.ClassToRename'.
	classToRename := oldName asQualifiedReference value.
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
	package := (classToRename >> #testFailure) owningPackage name.
	self assert: package equals: 'RBTests'.
	"Now rename Refactory.Browser.Tests.ClassToRename to Smalltalk.ClassToRename, effectively changing just its namespace"
	refactoring := RenameClassRefactoring
				model: model
				rename: classToRename
				to: 'Smalltalk.ClassToRename'.
	refactoring setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | true].
	self executeRefactoring: refactoring.
	newClass := model classNamed: 'Smalltalk.ClassToRename'.
	self denyIsNil: newClass.
	self deny: (model includesClassNamed: oldName).
	self
		verifyMethod: #method1
		of: newClass
		equals: 'method1 ^self method2'.
	"An extension method with an unqualified external reference that must be qualified after the rename out of a namespace that imports XProgramming.SUnit"
	self assertIsNil: (newClass fullBindingFor: 'TestFailure').
	self
		verifyMethod: #testFailure
		of: newClass
		equals: 'testFailure ^XProgramming.SUnit.TestFailure'.
	self assert: (newClass methodFor: #testFailure) owningPackageIfLoose name equals: 'RBTests'.
	change := model changes changeForClassNamed: newClass fullyQualifiedReference selector: #testFailure.
	"Check that a change to a method of the renamed class has the correct (new) namespace (nil, so the class' namespace is used), and that the package is preserved"
	self assertIsNil: change environment.
	self assert: change packageName equals: 'RBTests'.
	"An extension method containing an unqualified external reference relying on package default namespace to bind"
	self assertIsNil: (newClass fullBindingFor: 'RefactoryTestDataApp').
	self
		verifyMethod: #refersToClassInPackageDefaultNamespace
		of: newClass
		equals: 'refersToClassInPackageDefaultNamespace ^{ RefactoryTestDataApp. BasicLintRuleTestData }'.
	method := newClass methodFor: #refersToClassInPackageDefaultNamespace.
	self assert: method owningPackageIfLoose name equals: 'RBTestMethodsExtra'.
	self assert: method environment equals: (Refactory.Browser.TestData classInModel: model).
	change := model changes changeForClassNamed: newClass fullyQualifiedReference
				selector: #refersToClassInPackageDefaultNamespace.
	"Check that a change to a method of the renamed class has the correct (new) namespace (nil, so the class' namespace is used), and that the package is preserved"
	self assert: change environment equals: Refactory.Browser.TestData.
	self assert: change packageName equals: 'RBTestMethodsExtra'.
	"Model class Foo was defined in Smalltalk, so it can now reference Smalltalk.ClassToRename using just its unqualified name"
	self
		verifyMethod: #foo
		of: foo
		equals: 'foo ^ClassToRename'.
	"Model class Bar was defined in Kernel, so must still use a fully-qualified name (no change)"
	self
		verifyMethod: #foo
		of: (model classNamed: 'Kernel.Bar')
		equals: 'foo ^Smalltalk.ClassToRename'.
	"Model class FooBar was defined in the original namespace, not the one the renamed class is moved to, so the unqualified referenced must be rewritten to fully-qualified to remain bindable, i.e. Smalltalk.ClassToRename"
	self
		verifyMethod: #foo
		of: (model classNamed: 'Refactory.Browser.Tests.FooBar')
		equals: 'foo ^Smalltalk.ClassToRename'.

	"The subclass is now in a different namespace, so all the references from it should have become fully qualified"
	self assert: (model classNamed: SubclassOfClassToRename fullName) superclass equals: newClass.
	self
		verifyRenames: newClass
		unqualified: newClass fullName
		full: newClass fullName
		partial: newClass fullName!

testRenameChangeNamespaceToImported
	| refactoring oldName unqualifiedName newFullName newClass classToRename |
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
		equals: 'method1 ^self method2'.
	self deny: (model includesClassNamed: oldName).
	"The subclass is now in a different namespace, but has a reachable import of the new namespace (Core) so all the references should be unqualified"
	self assert: (model classFor: SubclassOfClassToRename) superclass equals: newClass.
	self
		verifyRenames: newClass
		unqualified: newClass unqualifiedName
		full: newClass unqualifiedName
		partial: newClass unqualifiedName!

testRenameClass
	"Test the relatively simple case of renaming an existing class' unqualified name, without changing its namespace. The class has a variety of references from a subclass that exists (no model only classes in this test)"

	| refactoring oldName newFullName newClass classToRename symbolicRefs |
	oldName := 'Refactory.Browser.Tests.ClassToRename'.
	classToRename := oldName asQualifiedReference value.
	refactoring := RenameClassRefactoring
				model: model
				rename: classToRename
				to: 'Refactory.Browser.Tests.NewClassName'.
	refactoring setOption: #ignoreSymbolicClassReferences
		toUse: 
			[:rename :refs |
			symbolicRefs := refs collect: [:each | each method].
			true].
	self executeRefactoring: refactoring.
	"model browseChanges."
	newFullName := oldName asQualifiedReference environment fullNameFor: 'NewClassName'.
	self assert: newFullName equals: 'Refactory.Browser.Tests.NewClassName'.
	newClass := model classNamed: newFullName.
	self denyIsNil: newClass.
	self
		verifyMethod: #method1
		of: newClass
		equals: 'method1 ^self method2'.
	self deny: (model includesClassNamed: oldName).
	self assert: (model classFor: SubclassOfClassToRename) superclass equals: newClass.
	self
		verifyRenames: newClass
		unqualified: newClass unqualifiedName
		full: newClass fullName
		partial: 'Tests.' , newClass unqualifiedName.
	self assert: symbolicRefs asSortedArray
		equals: {RefactoryTestDataApp >> #refersToClassUnqualifiedName.
				RefactoryTestDataApp >> #refersToClassUnqualifiedNameInArray.
				SubclassOfClassToRename >> #refersToClassUnqualifiedName}!

testRenameClassShadowedByClassVariable
	"Test renaming a class to have the same unqualified name as a class variable in one of the referencing classes, requiring that any references to the class become fully qualified or they will be shadowed."

	| refactoring oldName newFullName newClass classToRename refactoryTestDataApp partiallyQualifiedBinding newUnqualified newPartial newName |
	oldName := 'Refactory.Browser.Tests.ClassToRename'.
	newUnqualified := 'ClassVar1'.
	newName := 'Refactory.Browser.Tests.' , newUnqualified.
	classToRename := oldName asQualifiedReference value.
	refactoring := RenameClassRefactoring
				model: model
				rename: classToRename
				to: newName.
	refactoring setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | true].
	self executeRefactoring: refactoring.
	newFullName := oldName asQualifiedReference environment fullNameFor: newUnqualified.
	
	self assert: newFullName equals: newName.
	newClass := model classNamed: newFullName.
	self denyIsNil: newClass.
	self deny: (model includesClassNamed: oldName).
	refactoryTestDataApp := model classFor: RefactoryTestDataApp.
	newPartial := 'Tests.' , newUnqualified.
	"The class is now shadowed by its own class variable which has the same name as itself, so even a self reference needs to be fully qualified."
	self
		verifyMethod: #selfReference
		of: newClass
		equals: 'selfReference ^' , newPartial , ' new'.
	"Similarly the sub-class will bind the class variable more tightly, so its reference to its superclass needs to be fully qualified"
	self
		verifyMethod: #refersToClassUnqualified
		of: newClass subclasses first
		equals: 'refersToClassUnqualified ^' , newPartial.
	"Variable references are renamed to unqualified if possible, otherwise as qualified as they need to be to bind correctly."
	self
		verifyMethod: #refersToClassUnqualified
		of: refactoryTestDataApp
		equals: 'refersToClassUnqualified <namespace: Refactory.Browser.Tests> ^' , newPartial.
	#(#refersToClassFullyQualified #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2)
		do: 
			[:each |
			self
				verifyMethod: each
				of: refactoryTestDataApp
				equals: '<1s> ^<2s>' << {each. newPartial}].
	#(#refersToClassVariablePartiallyQualified #refersToClassVariableFullyQualified) do: 
			[:each |
			self
				verifyMethod: each
				of: refactoryTestDataApp
				equals: '<1s> ^<2s>.ClassVar1' << {each. newPartial}].

	"Relative binding references are kept as short as they can be. Fully-qualified remain so."
	partiallyQualifiedBinding := #{_.Tests.ClassVar1}.
	self
		verifyMethod: #refersToClassUnqualifiedBinding
		of: refactoryTestDataApp
		equals: 'refersToClassUnqualifiedBinding %<namespace: Refactory.Browser.Tests> ^<1p>'
				<< partiallyQualifiedBinding private.
	{#refersToClassPartiallyQualifiedBinding1.
		partiallyQualifiedBinding.
		#refersToClassPartiallyQualifiedBinding2.
		partiallyQualifiedBinding.
		#refersToClassFullyQualifiedBinding.
		newFullName asQualifiedReference} pairsDo: 
				[:selector :expected |
				self
					verifyMethod: selector
					of: refactoryTestDataApp
					equals: '<1s> ^<2p>' << {selector. expected}].
	self
		verifyMethod: #refersToClassUnqualifiedBindingInArray
		of: refactoryTestDataApp
		equals: 'refersToClassUnqualifiedBindingInArray %<namespace: Refactory.Browser.Tests> ^#(<1p>)'
				<< partiallyQualifiedBinding meta!

testRenameClassShadowingImported
	"Test the case of renaming a class to a new name that shadows an imported class, changing the binding of existing unqualified/part-qualified references to the imported class."

	| fooClass refactoring myClass |
	self
		defineClass: 'Core.Object subclass: #''Core.Foo'' instanceVariableNames: '''' classVariableNames: '''' imports: #(#{Refactory.Browser.Tests}) classInstanceVariableNames: '''' classConstants: {}'.
	fooClass := model classNamed: #'Core.Foo'.
	self
		compile: 'referencesToImportedClass ^{RenameClassRefactoringTest. #{RenameClassRefactoringTest}. #RenameClassRefactoringTest. #{Foo}}'
		in: fooClass.
	"Currently the Foo method should be binding the test class"
	myClass := model classFor: self class.
	self assert: (fooClass fullBindingFor: 'RenameClassRefactoringTest') value identicalTo: myClass.
	self assert: (fooClass whichMethodsReferToClass: myClass) asArray
		equals: {fooClass methodFor: #referencesToImportedClass}.
	"Now rename Foo to shadow to have the same name as the test class, shading it out. The unqualified references to the test class must be replaced with fully-qualified references."
	refactoring := RenameClassRefactoring
				model: model
				rename: fooClass
				to: #'Core.RenameClassRefactoringTest'.
	refactoring setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | true].
	self executeRefactoring: refactoring.
	"Note that symbolic names are no longer changed"
	self
		verifyMethod: #referencesToImportedClass
		of: fooClass
		equals: 'referencesToImportedClass ^{Refactory.Browser.Tests.RenameClassRefactoringTest. #{Refactory.Browser.Tests.RenameClassRefactoringTest}. #RenameClassRefactoringTest. #{RenameClassRefactoringTest}}'!

testRenameLegacyClass
	"Tests a rename that changes a class' namespace from Smalltalk will upgrade the owning package to the new source format"

	| refactoring newClass scribble smalltalk change package packageToUpgrade |
	scribble := model classNamed: 'Scribble'.
	package := scribble owningPackage.
	self assert: package paxVersion equals: 1.
	self assertNotNil: package.
	smalltalk := model classFor: Smalltalk.
	self assert: scribble environment identicalTo: smalltalk.
	"Now rename Refactory.Browser.Tests.ClassToRename to Smalltalk.ClassToRename, effectively changing just its namespace"
	refactoring := RenameClassRefactoring
				model: model
				rename: scribble
				to: 'UI.Examples.Scribble'.
	packageToUpgrade := nil.
	refactoring setOption: #upgradeLegacyPackages
		toUse: 
			[:rename :pkg |
			packageToUpgrade := pkg.
			false].
	self
		should: [self executeRefactoring: refactoring]
		raise: Refactoring abortSignal
		matching: [:ex | ex description = 'Rename class Smalltalk.Scribble to UI.Examples.Scribble aborted'].
	self assert: packageToUpgrade identicalTo: package.
	packageToUpgrade := nil.
	refactoring := RenameClassRefactoring
				model: model
				rename: scribble
				to: 'UI.Examples.Scribble'.
	refactoring
		setOption: #upgradeLegacyPackages
			toUse: 
				[:rename :pkg |
				packageToUpgrade := pkg.
				true];
		setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | true].
	self executeRefactoring: refactoring.
	newClass := model classNamed: 'UI.Examples.Scribble'.
	self denyIsNil: newClass.
	self deny: (model includesClassNamed: 'Scribble').
	self assert: packageToUpgrade identicalTo: package.
	change := model changes lastChangeMatching: [:each | each isKindOf: PackageVersionChange].
	self assert: change package equals: package.
	self assert: change version equals: Package paxVersion!

testRenameNamespace
	"Renaming a Namespace is like a normal Class rename for direct references, but there could also be indirect references. In fact all the classes in the Namespace are effectively being renamed. This means we need to consider all references to all classes in the namespace, including any sub-namespace classes, and any classes in those sub-namespaces, and so on."

	| namespaceToRename refactoring subclassOfClassToRename testDataApp classToRename subjectClass |
	namespaceToRename := 'Refactory.Browser.Tests' asQualifiedReference value.
	subclassOfClassToRename := model classFor: SubclassOfClassToRename.
	testDataApp := model classFor: RefactoryTestDataApp.
	refactoring := RenameClassRefactoring
				model: model
				rename: namespaceToRename
				to: 'Refactory.Browser.Tests2'.
	classToRename := model classFor: ClassToRename.
	subjectClass := model classFor: RenameClassRefactoring.
	subjectClass compile: 'correspondingTestCase ^Tests.RenameClassRefactoringTest'.
	refactoring setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | true].
	self executeRefactoring: refactoring.
	"The classes in the renamed namespace won't be locatable from the real class now, so if any of the subclasses are still using the 'lookup superclass' mode, then the superclass will come back nil."
	self assert: subclassOfClassToRename superclass identicalTo: classToRename.
	self assert: classToRename subclasses equals: {subclassOfClassToRename}.
	"Partially qualified reference from a model method of the tested class in Refactory.Browser to this test class, gets renamed"
	self
		verifyMethod: #correspondingTestCase
		of: subjectClass
		equals: 'correspondingTestCase ^Tests2.RenameClassRefactoringTest'.
	"The unecessary fully/partially-qualified references to a class in the same (renamed) namespace get shortened"
	#(#refersToClassFullyQualified #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2)
		do: 
			[:each |
			self
				verifyMethod: each
				of: subclassOfClassToRename
				equals: '<1s> ^ClassToRename' << each].
	"Fully qualified binding reference remains so, even if could be unqualified or partially-qualified"
	#(#refersToClassFullyQualifiedBinding) do: 
			[:each |
			self
				verifyMethod: each
				of: subclassOfClassToRename
				equals: '<1s> ^#{Refactory.Browser.Tests2.ClassToRename}' << each].
	#(#refersToClassPartiallyQualifiedBinding1 #refersToClassPartiallyQualifiedBinding2) do: 
			[:each |
			self
				verifyMethod: each
				of: subclassOfClassToRename
				equals: '<1s> ^#{ClassToRename}' << each].
	#(#refersToInheritedClassVariable #refersToInheritedClassVariableFullyQualified) do: 
			[:each |
			self
				verifyMethod: each
				of: subclassOfClassToRename
				equals: '<1s> ^ClassVar1' << each].
	"RefactoryTestDataApp is in a different namespace"
	self
		verifyMethod: #refersToClassVariablePartiallyQualified
		of: testDataApp
		equals: 'refersToClassVariablePartiallyQualified ^Tests2.ClassToRename.ClassVar1'.
	self
		verifyMethod: #refersToClassConstantPartiallyQualifiedWithNamespace
		of: testDataApp
		equals: 'refersToClassConstantPartiallyQualifiedWithNamespace <namespace: Refactory.Browser.Tests2> ^ClassToRename.ClassConst1'.
	self
		verifyMethod: #refersToClassConstantFullyQualified
		of: testDataApp
		equals: 'refersToClassConstantFullyQualified ^Tests2.ClassToRename.ClassConst1'.
	#(#refersToClassFullyQualified #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2)
		do: 
			[:each |
			self
				verifyMethod: each
				of: testDataApp
				equals: '<1s> ^Tests2.ClassToRename' << each].
	#(#refersToClassUnqualifiedBindingInArray) do: 
			[:each |
			self
				verifyMethod: each
				of: testDataApp
				equals: '<1s> %<namespace: Refactory.Browser.Tests2>^#(#{ClassToRename class})' << each].
	self
		verifyMethod: #refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation
		of: testDataApp
		equals: 'refersToClassUnqualifiedWithPartiallyQualifiedNamespaceAnnotation <namespace: Refactory.Browser.Tests2>^ClassToRename'.
	self
		verifyMethod: #refersToClassVariablePartiallyQualifiedBinding
		of: testDataApp
		equals: 'refersToClassVariablePartiallyQualifiedBinding ^#{_.Tests2.ClassToRename.ClassVar1} binding'.
	#(#refersToClassPartiallyQualifiedBinding1 #refersToClassPartiallyQualifiedBinding2) do: 
			[:each |
			self
				verifyMethod: each
				of: testDataApp
				equals: '<1s> ^#{_.Tests2.ClassToRename}' << each]!

testRenameOfClassWithMethodInPackageNamespace
	| refactoring conditionClass change selector class method |
	conditionClass := model classFor: RBCondition.
	refactoring := RenameClassRefactoring
				model: model
				rename: conditionClass
				to: 'Refactory.RBCondition'.
	refactoring setOption: #ignoreSymbolicClassReferences toUse: [:rename :refs | true].
	self executeRefactoring: refactoring.
	class := model classFor: MethodRefactoring.
	"This method references RBCondition, and also its class is in Refactory.Browser, the method is loose in a tools package with the Tools default namespace, so it needs to refer to RBCondition using a fully-qualified name. The rename will have to update this variable reference. The method also references a class in Tools (MethodNameDialog) that is not visible directly in Refactory.Browser, but because of the method namespace this is still bindable using its unqualified name."
	selector := #getOptionNewMethodName:classes:.
	"Custom namespace and package of the renamed loose method should be preserved"
	method := class methodFor: selector.
	self assert: method owningPackageIfLoose name equals: 'Dolphin Refactoring Browser'.
	self assert: method environment equals: (Tools classInModel: model).
	change := model changes changeForClassNamed: class fullyQualifiedReference selector: selector.
	"Check that a change to a method of the renamed class has the correct (new) namespace (nil, so the class' namespace is used), and that the package is preserved"
	self assert: change environment identicalTo: Tools.
	self assert: change package name equals: 'Dolphin Refactoring Browser'.
	self
		verifyMethod: selector
		of: class
		equals: ((MethodRefactoring >> selector) getSource copyReplaceAll: 'Refactory.Browser.'
				with: 'Refactory.')!

verifyRenames: aRBClass unqualified: unqualified full: fullyQualified partial: partial
	| subclassInNamespace classInOtherNamespace ast expectedSource |
	subclassInNamespace := model classFor: SubclassOfClassToRename.
	self assert: subclassInNamespace superclass equals: aRBClass.
	classInOtherNamespace := model classFor: RefactoryTestDataApp.
	self assert: subclassInNamespace superclass equals: aRBClass.
	"The symbolic refs should no longer be renamed."
	{subclassInNamespace. classInOtherNamespace} do: 
			[:eachClass |
			#(#refersToClassUnqualifiedName #refersToClassPartiallyQualifiedName #refersToOtherClassPartiallyQualifiedName #refersToClassFullyQualifiedName)
				do: 
					[:selector |
					self
						verifyMethod: selector
						of: eachClass
						equals: (eachClass realClass >> selector) getSource]].
	"Variable references are replaced with the minimal qualification required - in this case unqualified new name"
	#(#refersToClassUnqualified #refersToClassFullyQualified #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2)
		do: 
			[:each |
			self
				verifyMethod: each
				of: subclassInNamespace
				equals: '<1s> ^<2s>' << {each. unqualified}].
	self
		verifyMethod: #refersToClassUnqualifiedStaticExpression
		of: subclassInNamespace
		equals: 'refersToClassUnqualifiedStaticExpression ^##(<1s> fullName)' << unqualified.
	self
		verifyMethod: #refersToClassUnqualifiedHybrid
		of: subclassInNamespace
		equals: 'refersToClassUnqualifiedHybrid ^##(<1s> fullName) -> <1s>' << unqualified.
	self
		verifyMethod: #refersToClassUnqualified
		of: classInOtherNamespace
		equals: 'refersToClassUnqualified %<namespace: Refactory.Browser.Tests> ^<1s>' << unqualified.
	"The fully and partially qualified names will be as minimal as possible"
	#(#refersToClassFullyQualified #refersToClassPartiallyQualified1 #refersToClassPartiallyQualified2)
		do: 
			[:each |
			self
				verifyMethod: each
				of: classInOtherNamespace
				equals: '<1s> ^<2s>' << {each. partial}].
	"BindingReferences should basically behave as static variable references, but fully-qualified bindings are not simplified, although the partially qualified relative bindings will be."
	#(#refersToClassUnqualifiedBinding #refersToClassPartiallyQualifiedBinding1 #refersToClassPartiallyQualifiedBinding2)
		do: 
			[:each |
			self
				verifyMethod: each
				of: subclassInNamespace
				equals: '<1s> ^#{<2s>}' << {each. unqualified}].
	self
		verifyMethod: #refersToClassFullyQualifiedBinding
		of: subclassInNamespace
		equals: 'refersToClassFullyQualifiedBinding ^#{<1s>}' << aRBClass fullName.
	self
		verifyMethod: #refersToClassUnqualifiedBinding
		of: classInOtherNamespace
		equals: 'refersToClassUnqualifiedBinding %<namespace: Refactory.Browser.Tests> ^#{<1s> private}'
				<< unqualified.
	self
		verifyMethod: #refersToClassFullyQualifiedBinding
		of: classInOtherNamespace
		equals: 'refersToClassFullyQualifiedBinding ^#{<1s>}' << aRBClass fullName.
	"Partially qualified names will be converted to fully qualified, even when they need not be"
	#(#refersToClassPartiallyQualifiedBinding1 #refersToClassPartiallyQualifiedBinding2) do: 
			[:each |
			self
				verifyMethod: each
				of: classInOtherNamespace
				equals: '<1s> ^#{<3?:_.><2s>}' << {each. partial. partial = fullyQualified}].
	self
		verifyMethod: #refersToOtherClassPartiallyQualifiedBinding
		of: classInOtherNamespace
		equals: (classInOtherNamespace realClass >> #refersToOtherClassPartiallyQualifiedBinding) getSource.
	"Refs in FFI calls should be renamed too"
	expectedSource := 'externalReference: aClassToRename _: aClassToRename2
	%<stdcall: <1s>* dummy <1s> <1s>**>'
				<< unqualified.
	self assert: (subclassInNamespace methodFor: #externalReference:_:) source trimBlanks
		equals: expectedSource.
	ast := subclassInNamespace parseTreeFor: #externalReference:_:.
	self assert: ast newSource trimBlanks equals: expectedSource.
	self assert: ast formattedCode trimBlanks equals: expectedSource.
	self assert: ast equals: (self parseMethod: expectedSource).
	"Check that the name does bind"
	self shouldnt: [RBVariableAnalyser analyseParseTree: ast] raise: Parser notificationClass! !
!Refactory.Browser.Tests.RenameClassRefactoringTest categoriesForMethods!
compile:in:!helpers!private! !
defineClass:!helpers!private! !
testBadName!public!unit tests! !
testExistingClassVariableName!public!unit tests! !
testExistingName!public!unit tests! !
testFixedName!public!unit tests! !
testMetaClassFailure!public!unit tests! !
testModelRenameClass!public!unit tests! !
testModelRenameSequenceClass!public!unit tests! !
testModelRenameUpdatesUnqualifiedBindingReference!public!unit tests! !
testNoRename!public!unit tests! !
testRenameAmbiguousClassName!public!unit tests! !
testRenameChangeNamespace!public!unit tests! !
testRenameChangeNamespaceToImported!public!unit tests! !
testRenameClass!public!unit tests! !
testRenameClassShadowedByClassVariable!public!unit tests! !
testRenameClassShadowingImported!public!unit tests! !
testRenameLegacyClass!public!unit tests! !
testRenameNamespace!public!unit tests! !
testRenameOfClassWithMethodInPackageNamespace!public!unit tests! !
verifyRenames:unqualified:full:partial:!helpers!private! !
!

