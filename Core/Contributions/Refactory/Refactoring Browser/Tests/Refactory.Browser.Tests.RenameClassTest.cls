"Filed out from Dolphin Smalltalk 7"!

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

testBadName
	#namespaceToDo. "First case bodged to pass by forcing to a full name for the target; if passed an unqualified name RenameClassRefactoring has been modified to assume the namespace is not being changed, so it prepends the existing class namespace."
	self
		shouldFail: (RenameClassRefactoring rename: LintRuleTest to: 'Object.', self objectClassVariable);
		shouldFail: (RenameClassRefactoring rename: LintRuleTest to: #'Ob ject')!

testExistingName
	self shouldFail: (RenameClassRefactoring rename: self class to: #'Core.Object')!

testMetaClassFailure
	self shouldFail: (RenameClassRefactoring rename: self class class to: #Foo)!

testModelRenameClass
	| refactoring class |
	model
		defineClass: 'Core.Object subclass: #''Core.Foo'' instanceVariableNames: ''a'' classVariableNames: '''' poolDictionaries: ''Core.Object'''.
	class := model classNamed: #'Core.Foo'.
	class
		compile: 'foo	^Object' classified: #(#accessing);
		compile: 'objectName ^#(Object)' classified: #(#accessing).
	"Ensure the test covers renaming an imported class"
	self assert: (class imports includes: #{Core.Object}).
	refactoring := RenameClassRefactoring
				model: model
				rename: Object
				to: #Thing.
	self executeRefactoring: refactoring.
	self assert: (model includesClassNamed: #'Core.Thing').
	self deny: (model includesClassNamed: Object fullName).
	self assert: (class parseTreeFor: #foo) equals: (RBParser parseMethod: 'foo ^Thing').
	self assert: (class parseTreeFor: #objectName)
		equals: (RBParser parseMethod: 'objectName ^#(Thing)').
	self assert: class superclass name equals: #'Core.Thing'.
	self assert: (class imports includes: #{Core.Thing})!

testModelRenameSequenceClass
	model
		defineClass: 'Object subclass: #Foo1 
			instanceVariableNames: '''' 
			classVariableNames: '''' poolDictionaries: ''''
			category: #''Refactory-Test data'''.
	(model classNamed: #Foo1)
		compile: 'foo	 ^ Foo1' classified: #(#accessing);
		compile: 'objectName ^ #(Foo1)' classified: #(#accessing).
	self executeRefactoring: (RenameClassRefactoring
				model: model
				rename: (model classNamed: #Foo1)
				to: #Foo2).
	self deny: (model includesClassNamed: #Foo1).
	self assert: (model includesClassNamed: #Foo2).
	self assert: ((model classNamed: #Foo2) parseTreeFor: #foo) equals: (RBParser parseMethod: 'foo ^ Foo2').
	self executeRefactoring: (RenameClassRefactoring
				model: model
				rename: (model classNamed: #Foo2)
				to: #Foo3).
	self deny: (model includesClassNamed: #Foo1).
	self deny: (model includesClassNamed: #Foo2).
	self assert: (model includesClassNamed: #Foo3).
	self assert: ((model classNamed: #Foo3) parseTreeFor: #foo) equals: (RBParser parseMethod: 'foo ^ Foo3').
	self assert: ((model classNamed: #Foo3) parseTreeFor: #objectName)
				= (RBParser parseMethod: 'objectName ^ #(Foo3)')!

testRenameChangeNamespace
	| refactoring subclass oldName unqualifiedName newName newClass classToRename |
	unqualifiedName := 'ClassToRename'.
	oldName := 'Refactory.Browser.Tests.' , unqualifiedName.
	#('Foo' 'Kernel.Bar' 'Refactory.Browser.Tests.FooBar') do: 
			[:each |
			model
				defineClass: 'Object subclass: #<1p>
			instanceVariableNames: '''' 
			classVariableNames: '''' poolDictionaries: ''''
			category: #''Refactory-Test data'''
						<< each.
			(model classNamed: each) compile: 'foo	 ^<1s>' << oldName classified: #(#accessing)].
	classToRename := oldName asQualifiedReference value.
	newName := 'Smalltalk.' , unqualifiedName.
	refactoring := RenameClassRefactoring
				model: model
				rename: classToRename
				to: newName.
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: newName.
	self denyIsNil: newClass.
	self assert: (newClass parseTreeFor: #method1)
		equals: (RBParser parseMethod: 'method1
	^self method2').
	self deny: (refactoring model includesClassNamed: oldName).
	"Model class Foo was defined in Smalltalk, so can now reference using unqualified name"
	self assert: ((model classNamed: 'Foo') parseTreeFor: #foo)
		equals: (RBParser parseMethod: ('foo ^<1s>' expandMacrosWith: unqualifiedName)).
	"Model class Bar was defined in Kernel, so must still use qualified name"
	self assert: ((model classNamed: 'Kernel.Bar') parseTreeFor: #foo)
		equals: (RBParser parseMethod: ('foo ^<1s>' expandMacrosWith: newName)).
	"Model class FooBar was defined in original namespace, so must use fully-qualified name"
	self assert: ((model classNamed: 'Refactory.Browser.Tests.FooBar') parseTreeFor: #foo)
		equals: (RBParser parseMethod: ('foo ^<1s>' expandMacrosWith: newName)).

	"The subclass is now in a different namespace, so all the references from it should have become fully qualified"
	subclass := refactoring model classNamed: SubclassOfClassToRename fullName.
	self assert: subclass superclass equals: newClass.
	self assert: (subclass parseTreeFor: #symbolReference)
		equals: (RBParser parseMethod: ('symbolReference
	^<1p>' expandMacrosWith: newName asSymbol)).
	self assert: (subclass parseTreeFor: #reference)
		equals: (RBParser parseMethod: ('reference
	^<1s> new' expandMacrosWith: newName)).
	self assert: (subclass parseTreeFor: #fullyQualifiedReference)
		equals: (RBParser parseMethod: ('fullyQualifiedReference
	^<1s> new' expandMacrosWith: newName)).
	"Partially qualified refs will always be renamed to fully-qualified if not accessible with unqualified name, which is always true in this test"
	self assert: (subclass parseTreeFor: #partiallyQualifiedReference1)
		equals: (RBParser parseMethod: ('partiallyQualifiedReference1
	^<1s> new' expandMacrosWith: newName)).
	self assert: (subclass parseTreeFor: #partiallyQualifiedReference2)
		equals: (RBParser parseMethod: ('partiallyQualifiedReference2
	^<1s> new' expandMacrosWith: newName)).
	self assert: (subclass parseTreeFor: #externalReference:_:)
		equals: (RBParser
				parseMethod: ('externalReference: aClassToRename _: aClassToRename2
	%<stdcall: <1s>* dummy <1s> <1s>*>'
						expandMacrosWith: newName))!

testRenameChangeNamespaceToImported
	| refactoring subclass oldName unqualifiedName newFullName newClass classToRename |
	unqualifiedName := 'ClassToRename'.
	oldName := 'Refactory.Browser.Tests.' , unqualifiedName.
	classToRename := oldName asQualifiedReference value.
	newFullName := 'Core.' , unqualifiedName.
	refactoring := RenameClassRefactoring rename: classToRename to: newFullName.
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: newFullName.
	self denyIsNil: newClass.
	self assert: (newClass parseTreeFor: #method1)
		equals: (RBParser parseMethod: 'method1
	^self method2').
	self deny: (refactoring model includesClassNamed: oldName).
	"The subclass is now in a different namespace, but has a reachable import of the new namespace (Core) so all the references should be unqualified"
	subclass := refactoring model classNamed: SubclassOfClassToRename fullName.
	self assert: subclass superclass equals: newClass.
	self assert: (subclass parseTreeFor: #symbolReference)
		equals: (RBParser parseMethod: ('symbolReference
	^<1p>' expandMacrosWith: unqualifiedName asSymbol)).
	self assert: (subclass parseTreeFor: #reference)
		equals: (RBParser parseMethod: ('reference
	^<1s> new' expandMacrosWith: unqualifiedName)).
	"This reference was fully qualified before, but it gets reduced by the refactoring. Might be nice to keep it as it was."
	self assert: (subclass parseTreeFor: #fullyQualifiedReference)
		equals: (RBParser
				parseMethod: ('fullyQualifiedReference
	^<1s> new' expandMacrosWith: unqualifiedName)).
	"Partially qualified refs will always be renamed to fully-qualified/unqualified."
	self assert: (subclass parseTreeFor: #partiallyQualifiedReference1)
		equals: (RBParser
				parseMethod: ('partiallyQualifiedReference1
	^<1s> new' expandMacrosWith: unqualifiedName)).
	self assert: (subclass parseTreeFor: #partiallyQualifiedReference2)
		equals: (RBParser
				parseMethod: ('partiallyQualifiedReference2
	^<1s> new' expandMacrosWith: unqualifiedName)).
	self assert: (subclass parseTreeFor: #externalReference:_:)
		equals: (RBParser
				parseMethod: ('externalReference: aClassToRename _: aClassToRename2
	%<stdcall: <1s>* dummy <1s> <1s>*>'
						expandMacrosWith: unqualifiedName
						with: newFullName))!

testRenameClass
	| refactoring class oldName newName newFullName newClass classToRename |
	oldName := 'Refactory.Browser.Tests.ClassToRename'.
	classToRename := oldName asQualifiedReference value.
	newName := 'New' , 'ClassName'.
	refactoring := RenameClassRefactoring rename: classToRename to: newName.
	self executeRefactoring: refactoring.
	newFullName := oldName asQualifiedReference namespace fullNameFor: newName.
	newClass := refactoring model classNamed: newFullName.
	self denyIsNil: newClass.
	self assert: (newClass parseTreeFor: #method1)
		equals: (RBParser parseMethod: 'method1
	^self method2').
	self deny: (refactoring model includesClassNamed: oldName).
	class := refactoring model classNamed: SubclassOfClassToRename fullName.
	self assert: class superclass equals: newClass.
	self assert: (class parseTreeFor: #symbolReference)
		equals: (RBParser parseMethod: ('symbolReference
	^<1p>' expandMacrosWith: newName asSymbol)).
	self assert: (class parseTreeFor: #reference)
		equals: (RBParser parseMethod: ('reference
	^<1s> new' expandMacrosWith: newName)).
	self assert: (class parseTreeFor: #fullyQualifiedReference)
		equals: (RBParser
				parseMethod: ('fullyQualifiedReference
	^<2s>.<1s> new' expandMacrosWith: newName
						with: classToRename environment fullName)).
	self assert: (class parseTreeFor: #partiallyQualifiedReference1)
		equals: (RBParser
				parseMethod: ('partiallyQualifiedReference1
	^Tests.<1s> new' expandMacrosWith: newName)).
	self assert: (class parseTreeFor: #partiallyQualifiedReference2)
		equals: (RBParser parseMethod: ('partiallyQualifiedReference2
	^Browser.Tests.<1s> new'
						expandMacrosWith: newName)).
	self assert: (class parseTreeFor: #externalReference:_:)
		equals: (RBParser
				parseMethod: ('externalReference: aClassToRename _: aClassToRename2
	%<stdcall: <1s>* dummy <2s>.<1s> Tests.<1s>*>'
						expandMacrosWith: newName
						with: classToRename environment fullName))! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testBadName!failure tests!public! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testExistingName!failure tests!public! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testMetaClassFailure!failure tests!public! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testModelRenameClass!public!tests! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testModelRenameSequenceClass!public!tests! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testRenameChangeNamespace!public!tests! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testRenameChangeNamespaceToImported!public!tests! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testRenameClass!public!tests! !

