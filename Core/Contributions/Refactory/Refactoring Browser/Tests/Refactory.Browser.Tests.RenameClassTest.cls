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
	self assert: (class imports includes: #'Core.Object' asQualifiedReference).
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
	self assert: (class imports includes: #'Core.Thing' asQualifiedReference)!

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
	self executeRefactoring: (RenameClassRefactoring
				model: model
				rename: (model classNamed: #Foo2)
				to: #Foo3).
	self deny: (model includesClassNamed: #Foo1).
	self deny: (model includesClassNamed: #Foo2).
	self assert: (model includesClassNamed: #Foo3).
	self assert: ((model classNamed: #Foo3) parseTreeFor: #foo) = (RBParser parseMethod: 'foo ^ Foo3').
	self assert: ((model classNamed: #Foo3) parseTreeFor: #objectName)
				= (RBParser parseMethod: 'objectName ^ #(Foo3)')!

testRenameClass
	| refactoring class oldName newName newFullName newClass |
	oldName := ClassToRename fullName.
	newName := 'New' , 'ClassName'.
	refactoring := RenameClassRefactoring rename: ClassToRename to: newName.
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
								^<1s> new' expandMacrosWith: newName))! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testBadName!failure tests!public! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testExistingName!failure tests!public! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testMetaClassFailure!failure tests!public! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testModelRenameClass!public!tests! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testModelRenameSequenceClass!public!tests! !
!Refactory.Browser.Tests.RenameClassTest categoriesFor: #testRenameClass!public!tests! !

