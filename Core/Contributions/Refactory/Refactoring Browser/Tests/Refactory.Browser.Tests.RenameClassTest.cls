"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.RenameClassTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.RenameClassTest guid: (Core.GUID fromString: '{1c8b1cc4-4d25-46fc-9e56-b959e7a8e2f1}')!
Refactory.Browser.Tests.RenameClassTest comment: ''!
!Refactory.Browser.Tests.RenameClassTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.RenameClassTest methodsFor!

compile: aString in: class
	^class compile: (RBParser parseMethod: aString) formattedCode classified: #'test model methods'!

defineClass: aString
	model defineClass: (RBParser parseExpression: aString) formattedCode!

showChanges
	"Private - Diagnostic aid"

	UI.Keyboard default isShiftDown ifTrue: [Tools.RewriteChangesBrowser showOn: model changes]!

tearDown

	^super tearDown!

testBadName
	#namespaceToDo.	"First case bodged to pass by forcing to a full name for the target; if passed an unqualified name RenameClassRefactoring has been modified to assume the namespace is not being changed, so it prepends the existing class namespace."
	self
		shouldFail: (RenameClassRefactoring rename: LintRuleTestData to: 'Object.' , self objectClassVariable)
			withMessage: 'Object._EventsRegister is a class or global variable';
		shouldFail: (RenameClassRefactoring rename: LintRuleTestData to: #'Ob ject')
			withMessage: '#''Refactory.Browser.Tests.Ob ject'' is not a valid class name'!

testExistingName
	self shouldFail: (RenameClassRefactoring model: model rename: self class to: #'Core.Object')
		withMessage: 'Core.Object is a class or global variable'!

testMetaClassFailure
	self shouldFail: (RenameClassRefactoring model: model rename: self class class to: #Foo)
		withMessage: '<1s> class is not an existing class' << self class fullName!

testModelRenameClass
	| refactoring class |
	model
		defineClass: 'Core.Object subclass: #''Core.Foo'' instanceVariableNames: ''a'' classVariableNames: '''' poolDictionaries: ''Core.Object'''.
	class := model classNamed: #'Core.Foo'.
	class compile: 'referencesToClass	^{Object. Core.Object}' classified: #accessing.
	"Method referencing the class name symbol embedded in an array"
	class compile: 'referencesToClassByName ^#(Object #''Core.Object'' #{Object} #{Core.Object})'
		classified: #accessing.
	"Ensure the test covers renaming a class import too"
	self assert: (class imports includes: #{Core.Object}).
	refactoring := RenameClassRefactoring
				model: model
				rename: Object
				to: #Thing.
	self executeRefactoring: refactoring.
	"Object should be renamed in the model"
	self assert: (model includesClassNamed: #'Core.Thing').
	self deny: (model includesClassNamed: Object fullName).
	"References to the class in methods should be renamed - note that the redundant qualification is removed as the names are minimised"
	self
		verifyMethod: #referencesToClass
		of: class
		equals: 'referencesToClass ^{Thing. Thing}'.
	"References to the class name that would actually bind to the class in the context, whether full or partial, must be renamed too"
	self
		verifyMethod: #referencesToClassByName
		of: class
		equals: 'referencesToClassByName ^#(Thing #''Core.Thing'' #{Thing} #{Core.Thing})'.
	self assert: class superclass name equals: #'Core.Thing'.
	self assert: (class imports includes: #{Core.Thing})!

testModelRenameSequenceClass
	model := RBModel new.
	model
		defineClass: 'Object subclass: #Foo1 
			instanceVariableNames: '''' 
			classVariableNames: '''' poolDictionaries: ''''
			category: #''Refactory-Test data'''.
	(model classNamed: #Foo1)
		compile: 'foo	 ^ Foo1' classified: #accessing;
		compile: 'objectName ^ #(Foo1)' classified: #accessing.
	self executeRefactoring: (RenameClassRefactoring
				model: model
				rename: (model classNamed: #Foo1)
				to: #Foo2).
	self deny: (model includesClassNamed: #Foo1).
	self assert: (model includesClassNamed: #Foo2).
	self
		verifyMethod: #foo
		of: (model classNamed: #Foo2)
		equals: 'foo ^ Foo2'.
	self executeRefactoring: (RenameClassRefactoring
				model: model
				rename: (model classNamed: #Foo2)
				to: #Foo3).
	self deny: (model includesClassNamed: #Foo1).
	self deny: (model includesClassNamed: #Foo2).
	self assert: (model includesClassNamed: #Foo3).
	self
		verifyMethod: #foo
		of: (model classNamed: #Foo3)
		equals: 'foo ^ Foo3'.
	self
		verifyMethod: #objectName
		of: (model classNamed: #Foo3)
		equals: 'objectName ^ #(Foo3)'!

testModelRenameUpdatesUnqualifiedBindingReference
	"Test the case of renaming a class to a new name that shadows an imported class, changing the binding of existing unqualified/part-qualified references to the imported class."

	| fooClass refactoring barClass |
	model := RBModel new.
	self
		defineClass: 'Kernel.Object subclass: #''Kernel.Foo'' instanceVariableNames: '''' classVariableNames: '''' imports: #() classInstanceVariableNames: '''' classConstants: {}'.
	fooClass := model classNamed: #'Kernel.Foo'.
	self
		defineClass: 'Core.Object subclass: #''Core.Bar'' instanceVariableNames: '''' classVariableNames: '''' imports: #() classInstanceVariableNames: '''' classConstants: {}'.
	barClass := model classNamed: #'Core.Bar'.
	self compile: 'qualifiedReference ^#{Foo}' in: barClass.
	"Now rename Foo"
	refactoring := RenameClassRefactoring
				model: model
				rename: fooClass
				to: #'Core.FooBar'.
	self executeRefactoring: refactoring.
self halt.
	self
		verifyMethod: #qualifiedReference
		of: barClass
		equals: 'qualifiedReference ^#{FooBar}'!

testRenameChangeNamespace
	"Tests a rename that changes a class' namespace, but not it's unqualified name"

	| refactoring subclass oldName newName newClass classToRename foo smalltalk |
	model := RBModel new.	"Makes the test restartable - would be better not done in setUp"
	oldName := 'Refactory.Browser.Tests.' , 'ClassToRename'.
	#('Foo' 'Kernel.Bar' 'Refactory.Browser.Tests.FooBar') do: 
			[:each |
			model
				defineClass: 'Object subclass: #<1p><n>	instanceVariableNames: ''''<n>	classVariableNames: ''''<n>	poolDictionaries: ''''<n>	category: #''Refactory-Test data'''
						<< each.
			(model classNamed: each) compile: 'foo<n>	 ^<1s>' << oldName classified: #accessing].
	"Some sanity checks"
	foo := model classNamed: 'Foo'.
	smalltalk := model classFor: Smalltalk.
	self assert: foo environment identicalTo: smalltalk.
	self assert: (smalltalk localBindingFor: 'Foo') value identicalTo: foo.
	"Now rename Refactory.Browser.Tests.ClassToRename to Smalltalk.ClassToRename, effectively changing just its namespace"
	classToRename := oldName asQualifiedReference value.
	newName := 'Smalltalk.' , 'ClassToRename'.
	refactoring := RenameClassRefactoring
				model: model
				rename: classToRename
				to: newName.
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: newName.
	self denyIsNil: newClass.
	self deny: (refactoring model includesClassNamed: oldName).
	self
		verifyMethod: #method1
		of: newClass
		equals: 'method1 ^self method2' expandMacros.
	"Model class Foo was defined in Smalltalk, so can rewrite to an unqualified name"
	self
		verifyMethod: #foo
		of: foo
		equals: 'foo ^ClassToRename'.
	"Model class Bar was defined in Kernel, so must still use a fully-qualified name (no change)"
	self
		verifyMethod: #foo
		of: (model classNamed: 'Kernel.Bar')
		equals: 'foo ^<1s>' << newName.
	"Model class FooBar was defined in original namespace, not the one the renamed class is moved to, so rewrite to fully-qualified name here"
	self
		verifyMethod: #foo
		of: (model classNamed: 'Refactory.Browser.Tests.FooBar')
		equals: 'foo ^<1s>' << newName.

	"The subclass is now in a different namespace, so all the references from it should have become fully qualified"
	subclass := refactoring model classNamed: SubclassOfClassToRename fullName.
	self assert: subclass superclass equals: newClass.
	self assert: (subclass parseTreeFor: #symbolicReferences)
		equals: (self parseMethod: ('unqualifiedSymbolReference
	^<1p>' expandMacrosWith: newName asSymbol)).
	self assert: (subclass parseTreeFor: #reference)
		equals: (self parseMethod: ('reference
	^<1s> new' expandMacrosWith: newName)).
	self assert: (subclass parseTreeFor: #fullyQualifiedReference)
		equals: (self parseMethod: ('fullyQualifiedReference
	^<1s> new' expandMacrosWith: newName)).
	"Partially qualified refs will always be renamed to fully-qualified if not accessible with unqualified name, which is always true in this test"
	self assert: (subclass parseTreeFor: #partiallyQualifiedReference1)
		equals: (self parseMethod: ('partiallyQualifiedReference1
	^<1s> new' expandMacrosWith: newName)).
	self assert: (subclass parseTreeFor: #partiallyQualifiedReference2)
		equals: (self parseMethod: ('partiallyQualifiedReference2
	^<1s> new' expandMacrosWith: newName)).
	self assert: (subclass parseTreeFor: #externalReference:_:)
		equals: (self
				parseMethod: ('externalReference: aClassToRename _: aClassToRename2
	%<stdcall: <1s>* dummy <1s> <1s>*>'
						expandMacrosWith: newName))!

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
	self executeRefactoring: refactoring.
	newClass := model classNamed: newFullName.
	self denyIsNil: newClass.
	self assert: (newClass parseTreeFor: #method1) equals: (self parseMethod: 'method1
	^self method2').
	self deny: (model includesClassNamed: oldName).
	"The subclass is now in a different namespace, but has a reachable import of the new namespace (Core) so all the references should be unqualified"
	subclass := model classNamed: SubclassOfClassToRename fullName.
	self assert: subclass superclass equals: newClass.
	"Variable references are replaced with the minimal qualification required"
	self
		verifyMethod: #qualifiedReferences
		of: subclass
		equals: 'qualifiedReferences<n>	^{ClassToRename new.<n>		ClassToRename new.<n>		ClassToRename new.<n>	ClassToRename new}'.
	self
		verifyMethod: #symbolicReferences
		of: subclass
		equals: 'symbolicReferences<n>	^#(#ClassToRename #''Core.ClassToRename'' #''Tools.ClassToRename'' #''Core.ClassToRename'')'.
	"References in FFI function descriptors (equivalent to variable references)"
	self assert: (subclass parseTreeFor: #externalReference:_:)
		equals: (self
				parseMethod: ('externalReference: aClassToRename _: aClassToRename2
	%<stdcall: <1s>* dummy <1s> <1s>*>'
						expandMacrosWith: unqualifiedName
						with: newFullName))!

testRenameClass
	"Test the relatively simple case of renaming an existing class' unqualified name, without changing its namespace. The class has a variety of references from a subclass that exists (no model only classes in this test)"

	| refactoring class oldName newFullName newClass classToRename ast |
	oldName := 'Refactory.Browser.Tests.ClassToRename'.
	classToRename := oldName asQualifiedReference value.
	refactoring := RenameClassRefactoring
				model: model
				rename: classToRename
				to: 'NewClassName'.
	self executeRefactoring: refactoring.
	self showChanges.
	newFullName := oldName asQualifiedReference environment fullNameFor: 'NewClassName'.
	self assert: newFullName equals: 'Refactory.Browser.Tests.NewClassName'.
	newClass := model classNamed: newFullName.
	self denyIsNil: newClass.
	self
		verifyMethod: #method1
		of: newClass
		equals: 'method1 ^self method2'.
	self deny: (model includesClassNamed: oldName).
	class := model classFor: SubclassOfClassToRename.
	self assert: class superclass equals: newClass.
	self assert: (class imports includes: #{Refactory.Browser.Tests.NewClassName private}).
	"The symbolic refs should only be renamed if they are unqualified (legacy behaviour) or fully qualified."
	self
		verifyMethod: #symbolicReferences
		of: class
		equals: 'symbolicReferences ^#(#NewClassName #''Tests.ClassToRename'' #''Refactory.Browser.Tests.NewClassName'' #''Tools.ClassToRename'' #''Smalltalk.ClassToRename'')'.
	self
		verifyMethod: #qualifiedReferences
		of: class
		equals: 'qualifiedReferences ^{NewClassName new. NewClassName new. NewClassName new. NewClassName new}'.
	ast := class parseTreeFor: #externalReference:_:.
	self assert: ast
		equals: (self
				parseMethod: 'externalReference: aClassToRename _: aClassToRename2 <stdcall: NewClassName* dummy NewClassName NewClassName*>').
	"Check that the name does bind, but of course it isn't a structure type so we expect another type of semantic error"
	self
		should: [ast analyze]
		raise: Parser notificationClass
		matching: [:ex | ex displayString = 'Error: invalid structure class type ''NewClassName*''']!

testRenameClassShadowingImported
	"Test the case of renaming a class to a new name that shadows an imported class, changing the binding of existing unqualified/part-qualified references to the imported class."

	| class refactoring |
	model := RBModel new.
	self
		defineClass: 'Core.Object subclass: #''Core.Foo'' instanceVariableNames: '''' classVariableNames: '''' imports: #(#{Refactory.Browser.Tests}) classInstanceVariableNames: '''' classConstants: {}'.
	class := model classNamed: #'Core.Foo'.
	self compile: 'referencesToImportedClass ^{RenameClassTest. #{RenameClassTest} #{Foo}}' in: class.
	"Currently the Foo method should be binding the test class"
	self assert: (class fullBindingFor: 'RenameClassTest') value
		identicalTo: (model classFor: self class).
	"Now rename Foo to shadow out the test class"
	refactoring := RenameClassRefactoring
				model: model
				rename: class
				to: #'Core.RenameClassTest'.
	self executeRefactoring: refactoring.
	"self showChanges"!

verifyMethod: aSymbol of: aRBClass equals: aString
	| ast |
	ast := aRBClass parseTreeFor: aSymbol.
	[ast analyze] on: Parser notificationClass do: [:ex | self fail: ex displayString].
	self assert: ast equals: (self parseMethod: aString)! !
!Refactory.Browser.Tests.RenameClassTest categoriesForMethods!
compile:in:!helpers!private! !
defineClass:!helpers!private! !
showChanges!helpers!private! !
tearDown!public!set up! !
testBadName!failure tests!public! !
testExistingName!failure tests!public! !
testMetaClassFailure!failure tests!public! !
testModelRenameClass!public!tests! !
testModelRenameSequenceClass!public!tests! !
testModelRenameUpdatesUnqualifiedBindingReference!public!tests! !
testRenameChangeNamespace!public!tests! !
testRenameChangeNamespaceToImported!public!tests! !
testRenameClass!public!tests! !
testRenameClassShadowingImported!public!tests! !
verifyMethod:of:equals:!helpers!private! !
!

