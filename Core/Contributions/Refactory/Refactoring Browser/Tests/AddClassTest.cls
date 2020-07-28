"Filed out from Dolphin Smalltalk 7"!

RefactoringTest subclass: #AddClassTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AddClassTest guid: (GUID fromString: '{2113113d-2508-4856-9ae0-868f9af9ac5c}')!
AddClassTest comment: ''!
!AddClassTest categoriesForClass!Refactory-Testing! !
!AddClassTest methodsFor!

setUp
	super setUp.
	model := Compiler evaluate: (self readFile: 'AbstractVariableTestData.st')!

testAddClass
	| refactoring newClass superClass classTest |
	refactoring := AddClassRefactoring
				addClass: #FooTest
				superclass: RefactoringTest
				subclasses: {self class}
				category: #'Refactory-Testing'.
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: #FooTest.
	superClass := refactoring model classNamed: #RefactoringTest.
	classTest := refactoring model classNamed: self class name.
	self assert: newClass superclass equals: superClass.
	self assert: (superClass subclasses includes: newClass).
	self assert: newClass metaclass superclass equals: superClass metaclass.
	self assert: (superClass metaclass subclasses includes: newClass metaclass).
	self assert: classTest superclass equals: newClass.
	self assert: (newClass subclasses includes: classTest).
	self assert: classTest metaclass superclass equals: newClass metaclass.
	self assert: (newClass metaclass subclasses includes: classTest metaclass)!

testExistingName
	self shouldFail: (AddClassRefactoring 
				addClass: #Object
				superclass: self class
				subclasses: #()
				category: #'Refactory-Testing')!

testInvalidSubclass
	self shouldFail: (AddClassRefactoring
				addClass: #Foo
				superclass: CompositeLintRuleTest
				subclasses: {BasicLintRuleTest}
				category: #'Refactory-Tesing')!

testMetaClassFailure
	self shouldFail: (AddClassRefactoring 
				addClass: #Foo
				superclass: self class class
				subclasses: #()
				category: #'Refactory-Testing')!

testModelAddClass
	| refactoring newClass superClass subclass |
	subclass := model classNamed: #Bar.
	superClass := model classNamed: #Foo.
	refactoring := AddClassRefactoring
				model: model
				addClass: #FooTest
				superclass: superClass
				subclasses: {subclass}
				category: #'Refactory-Testing'.
	self executeRefactoring: refactoring.
	newClass := model classNamed: #FooTest.
	self assert: newClass superclass equals: superClass.
	self assert: (superClass subclasses includes: newClass).
	self assert: newClass metaclass superclass equals: superClass metaclass.
	self assert: (superClass metaclass subclasses includes: newClass metaclass).
	self assert: subclass superclass equals: newClass.
	self assert: (newClass subclasses includes: subclass).
	self assert: subclass metaclass superclass equals: newClass metaclass.
	self assert: (newClass metaclass subclasses includes: subclass metaclass)!

testModelExistingName
	| refactoring |
	refactoring := AddClassRefactoring 
				model: model
				addClass: #Foo
				superclass: Object
				subclasses: #()
				category: #'Refactory-Testing'.
	self shouldFail: refactoring!

testModelInvalidSubclass
	| refactoring |
	refactoring := AddClassRefactoring
				model: model
				addClass: #Foo2
				superclass: Object
				subclasses: {model classNamed: #Bar}
				category: #'Refactory-Tesing'.
	self shouldFail: refactoring! !
!AddClassTest categoriesFor: #setUp!public!set up! !
!AddClassTest categoriesFor: #testAddClass!public!tests! !
!AddClassTest categoriesFor: #testExistingName!failure tests!public! !
!AddClassTest categoriesFor: #testInvalidSubclass!failure tests!public! !
!AddClassTest categoriesFor: #testMetaClassFailure!failure tests!public! !
!AddClassTest categoriesFor: #testModelAddClass!public!tests! !
!AddClassTest categoriesFor: #testModelExistingName!failure tests!public! !
!AddClassTest categoriesFor: #testModelInvalidSubclass!failure tests!public! !

