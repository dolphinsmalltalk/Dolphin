"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest subclass: #'Refactory.Browser.Tests.AddClassTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddClassTest guid: (Core.GUID fromString: '{2113113d-2508-4856-9ae0-868f9af9ac5c}')!
Refactory.Browser.Tests.AddClassTest comment: ''!
!Refactory.Browser.Tests.AddClassTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AddClassTest methodsFor!

setUp
	super setUp.
	model := self abstractVariableTestData!

testAddClass
	| refactoring newClass superClass classTest |
	refactoring := AddClassRefactoring
				addClass: #FooTest
				superclass: RefactoringTest
				subclasses: {self class}
				category: #'Refactory-Testing'.
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: #FooTest.
	superClass := refactoring model classNamed: #'Refactory.Browser.Tests.RefactoringTest'.
	classTest := refactoring model classNamed: self class fullName.
	self assert: newClass superclass equals: superClass.
	self assert: (superClass subclasses includes: newClass).
	self assert: newClass metaclass superclass equals: superClass metaclass.
	self assert: (superClass metaclass subclasses includes: newClass metaclass).
	self assert: classTest superclass equals: newClass.
	self assert: (newClass subclasses includes: classTest).
	self assert: classTest metaclass superclass equals: newClass metaclass.
	self assert: (newClass metaclass subclasses includes: classTest metaclass)!

testAddVariableByteClass
	| refactoring newClass superClass |
	refactoring := AddClassRefactoring
				addClass: #FooTest
				superclass: ByteArray
				subclasses: #()
				category: #'Refactory-Testing'.
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: #FooTest.
	superClass := refactoring model classFor: ByteArray.
	self assert: newClass superclass equals: superClass.
	self assert: (superClass subclasses includes: newClass).
	self assert: newClass metaclass superclass equals: superClass metaclass.
	self assert: (superClass metaclass subclasses includes: newClass metaclass).
	self assert: newClass subclasses isEmpty.
	self assert: newClass metaclass subclasses isEmpty.
	self assert: newClass kindOfSubclass equals: 'variableByteSubclass:'!

testAddVariableClass
	| refactoring newClass superClass |
	refactoring := AddClassRefactoring
				addClass: #FooTest
				superclass: Array
				subclasses: #()
				category: #'Refactory-Testing'.
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: #FooTest.
	superClass := refactoring model classFor: Array.
	self assert: newClass superclass equals: superClass.
	self assert: (superClass subclasses includes: newClass).
	self assert: newClass metaclass superclass equals: superClass metaclass.
	self assert: (superClass metaclass subclasses includes: newClass metaclass).
	self assert: newClass subclasses isEmpty.
	self assert: newClass metaclass subclasses isEmpty.
	self assert: newClass kindOfSubclass equals: 'variableSubclass:'!

testEmptyCategory
	self shouldFail: (AddClassRefactoring
				addClass: #FooTest
				superclass: RefactoringTest
				subclasses: {self class}
				category: #'')
		withMessage: 'Invalid category name'!

testExistingClassName
	self shouldFail: (AddClassRefactoring
				addClass: #'Core.Object'
				superclass: self class
				subclasses: #()
				category: #'Refactory-Testing')
		existingVariable: 'Core.Object'!

testExistingName
	self shouldFail: (AddClassRefactoring
				addClass: #'Core.Object'
				superclass: self class
				subclasses: #()
				category: #'Refactory-Testing')
		existingVariable: 'Core.Object'!

testExistingVariableName
	self shouldFail: (AddClassRefactoring
				addClass: #'Kernel.SourceFiles'
				superclass: self class
				subclasses: #()
				category: #'Refactory-Testing')
		existingVariable: 'Kernel.SourceFiles'!

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

testModelExistingClassName
	self shouldFail: (AddClassRefactoring
				model: model
				addClass: #Foo
				superclass: Object
				subclasses: #()
				category: #'Refactory-Testing')
		existingVariable: #Foo!

testModelNonImmediateSubclass
	| refactoring |
	refactoring := AddClassRefactoring
				model: model
				addClass: #Foo2
				superclass: Object
				subclasses: {model classNamed: #Bar}
				category: #'Refactory-Tesing'.
	self shouldFail: refactoring withMessage: 'Bar is not an immediate subclass of Core.Object'!

testNonImmediateSubclass
	self shouldFail: (AddClassRefactoring
				addClass: #Foo
				superclass: CompositeLintRuleTestData
				subclasses: {BasicLintRuleTestData}
				category: #'Refactory-Tesing')
		withMessage: 'Refactory.Browser.TestData.BasicLintRuleTestData is not an immediate subclass of Refactory.Browser.TestData.CompositeLintRuleTestData'!

testSubclassIsMetaclass
	self shouldFail: (AddClassRefactoring
				addClass: #Foo
				superclass: LintRuleTestData
				subclasses: {CompositeLintRuleTestData class}
				category: #'Refactory-Testing')
		withMessage: 'Subclass must not be a metaclass'!

testSuperclassIsMetaclass
	self shouldFail: (AddClassRefactoring
				addClass: #Foo
				superclass: self class class
				subclasses: #()
				category: #'Refactory-Testing')
		withMessage: 'Superclass must not be a metaclass'! !
!Refactory.Browser.Tests.AddClassTest categoriesForMethods!
setUp!public!set up! !
testAddClass!public!tests! !
testAddVariableByteClass!public!tests! !
testAddVariableClass!public!tests! !
testEmptyCategory!public!tests! !
testExistingClassName!failure tests!public! !
testExistingName!failure tests!public! !
testExistingVariableName!failure tests!public! !
testModelAddClass!public!tests! !
testModelExistingClassName!failure tests!public! !
testModelNonImmediateSubclass!failure tests!public! !
testNonImmediateSubclass!failure tests!public! !
testSubclassIsMetaclass!failure tests!public! !
testSuperclassIsMetaclass!failure tests!public! !
!

