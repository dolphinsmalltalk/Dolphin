"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #RenameClassTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RenameClassTest guid: (GUID fromString: '{1c8b1cc4-4d25-46fc-9e56-b959e7a8e2f1}')!
RenameClassTest comment: ''!
!RenameClassTest categoriesForClass!Refactory-Testing! !
!RenameClassTest methodsFor!

testBadName
	self
		shouldFail: (RenameClassRefactoring rename: LintRuleTest
					to: self objectClassVariable);
		shouldFail: (RenameClassRefactoring rename: LintRuleTest to: #'Ob ject')!

testExistingName
	self shouldFail: (RenameClassRefactoring rename: self class to: #Object)!

testMetaClassFailure
	self 
		shouldFail: (RenameClassRefactoring rename: self class class to: #Foo)!

testModelRenameClass
	| refactoring class |
	model
		defineClass: 'Object subclass: #Foo instanceVariableNames: ''a'' classVariableNames: '''' poolDictionaries: '''''.
	class := model classNamed: #Foo.
	class
		compile: 'foo	^Object' classified: #(#accessing);
		compile: 'objectName ^#(Object)' classified: #(#accessing).
	refactoring := RenameClassRefactoring
				model: model
				rename: Object
				to: #Thing.
	self executeRefactoring: refactoring.
	self assert: (model includesClassNamed: #Thing).
	self deny: (model includesClassNamed: #Object).
	self assert: (class parseTreeFor: #foo) equals: (RBParser parseMethod: 'foo ^Thing').
	self assert: (class parseTreeFor: #objectName)
		equals: (RBParser parseMethod: 'objectName ^#(Thing)').
	self assert: class superclass name equals: #Thing!

testRenameClass
	| refactoring class |
	refactoring := RenameClassRefactoring rename: ('Class' , 'ToRename') asQualifiedReference value
				to: 'New' , 'ClassName' asSymbol.
	self executeRefactoring: refactoring.
	self assert: ((refactoring model classNamed: ('New' , 'ClassName') asSymbol) parseTreeFor: #method1)
		equals: (RBParser parseMethod: 'method1
	^self method2').
	self deny: (refactoring model includesClassNamed: ('Class' , 'ToRename') asSymbol).
	class := refactoring model classNamed: ('Subclass' , 'OfClassToRename') asSymbol.
	self assert: class superclass equals: (refactoring model classNamed: ('New' , 'ClassName') asSymbol).
	self assert: (class parseTreeFor: #symbolReference)
		equals: (RBParser parseMethod: 'symbolReference
								^#NewClassName').
	self assert: (class parseTreeFor: #reference)
		equals: (RBParser parseMethod: 'reference
								^NewClassName new')! !
!RenameClassTest categoriesFor: #testBadName!failure tests!public! !
!RenameClassTest categoriesFor: #testExistingName!failure tests!public! !
!RenameClassTest categoriesFor: #testMetaClassFailure!failure tests!public! !
!RenameClassTest categoriesFor: #testModelRenameClass!public!tests! !
!RenameClassTest categoriesFor: #testRenameClass!public!tests! !

