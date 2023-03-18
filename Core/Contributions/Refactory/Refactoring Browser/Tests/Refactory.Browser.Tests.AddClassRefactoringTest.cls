"Filed out from Dolphin Smalltalk"!

Refactory.Browser.Tests.RefactoringTest
	subclass: #'Refactory.Browser.Tests.AddClassRefactoringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Refactory.Browser.Tests.AddClassRefactoringTest guid: (Core.GUID fromString: '{2113113d-2508-4856-9ae0-868f9af9ac5c}')!
Refactory.Browser.Tests.AddClassRefactoringTest comment: ''!
!Refactory.Browser.Tests.AddClassRefactoringTest categoriesForClass!Refactory-Testing! !
!Refactory.Browser.Tests.AddClassRefactoringTest methodsFor!

setUp
	super setUp.
	model := self abstractVariableTestData!

testAddClass
	| categoryNames refactoring newClass superClass classTest |
	categoryNames := #('Refactory-Testing' 'Blah').
	refactoring := AddClassRefactoring
				addClass: 'Refactory.Browser.Tests.FooTest'
				superclass: RefactoringTest
				subclasses: {self class}
				categories: categoryNames.
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: 'Refactory.Browser.Tests.FooTest'.
	superClass := refactoring model classNamed: 'Refactory.Browser.Tests.RefactoringTest'.
	classTest := refactoring model classNamed: self class fullName.
	self assert: newClass superclass equals: superClass.
	self assert: (superClass subclasses includes: newClass).
	self assert: newClass metaclass superclass equals: superClass metaclass.
	self assert: (superClass metaclass subclasses includes: newClass metaclass).
	self assert: classTest superclass equals: newClass.
	self assert: (newClass subclasses includes: classTest).
	self assert: classTest metaclass superclass equals: newClass metaclass.
	self assert: (newClass metaclass subclasses includes: classTest metaclass).
	self assert: newClass categoryNames equals: categoryNames!

testAddNamespaceClass
	| refactoring newClass superClass |
	refactoring := AddClassRefactoring
				addClass: 'Refactory.Browser.TestData.FooTest'
				superclass: Refactory.Browser.TestData
				subclasses: #()
				categories: #('Refactory-Testing').
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: 'Refactory.Browser.TestData.FooTest'.
	superClass := refactoring model classFor: Refactory.Browser.TestData.
	self assert: newClass superclass equals: superClass.
	self assert: (superClass subclasses includes: newClass).
	self assert: newClass metaclass superclass equals: superClass metaclass.
	self assert: (superClass metaclass subclasses includes: newClass metaclass).
	self assert: newClass subclasses isEmpty.
	self assert: newClass metaclass subclasses isEmpty.
	self assert: newClass kindOfSubclass equals: 'subclass:'.
	self assert: newClass isNonInstantiable!

testAddRootClass
	| refactoring newClass classTest classClass |
	refactoring := AddClassRefactoring
				addClass: 'Refactory.Browser.Tests.FooTest'
				superclass: nil
				subclasses: {ProtoObject}
				categories: #('Refactory-Testing').
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: 'Refactory.Browser.Tests.FooTest'.
	classTest := refactoring model classFor: ProtoObject.
	self assertIsNil: newClass superclass.
	self assert: (refactoring model rootClasses includes: newClass).
	self deny: (refactoring model rootClasses includes: classTest).
	classClass := refactoring model classFor: Class.
	self assert: newClass metaclass superclass equals: classClass.
	self assert: (classClass subclasses includes: newClass metaclass).
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
				categories: #('Refactory-Testing').
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: #FooTest.
	superClass := refactoring model classFor: ByteArray.
	self assert: newClass superclass equals: superClass.
	self assert: (superClass subclasses includes: newClass).
	self assert: newClass metaclass superclass equals: superClass metaclass.
	self assert: (superClass metaclass subclasses includes: newClass metaclass).
	self assert: newClass subclasses isEmpty.
	self assert: newClass metaclass subclasses isEmpty.
	self assert: newClass kindOfSubclass equals: 'variableByteSubclass:'.
	self deny: newClass isNonInstantiable!

testAddVariableClass
	| refactoring newClass superClass |
	refactoring := AddClassRefactoring
				addClass: #FooTest
				superclass: Array
				subclasses: #()
				categories: #('Refactory-Testing').
	self executeRefactoring: refactoring.
	newClass := refactoring model classNamed: #FooTest.
	superClass := refactoring model classFor: Array.
	self assert: newClass superclass equals: superClass.
	self assert: (superClass subclasses includes: newClass).
	self assert: newClass metaclass superclass equals: superClass metaclass.
	self assert: (superClass metaclass subclasses includes: newClass metaclass).
	self assert: newClass subclasses isEmpty.
	self assert: newClass metaclass subclasses isEmpty.
	self assert: newClass kindOfSubclass equals: 'variableSubclass:'.
	self deny: newClass isNonInstantiable!

testExistingClassName
	self shouldFail: (AddClassRefactoring
				addClass: #'Core.Object'
				superclass: self class
				subclasses: #()
				categories: #('Refactory-Testing'))
		existingVariable: 'Core.Object'!

testExistingName
	self shouldFail: (AddClassRefactoring
				addClass: #'Core.Object'
				superclass: self class
				subclasses: #()
				categories: #('Refactory-Testing'))
		existingVariable: 'Core.Object'!

testExistingVariableName
	self shouldFail: (AddClassRefactoring
				addClass: #'Kernel.SourceFiles'
				superclass: self class
				subclasses: #()
				categories: #('Refactory-Testing'))
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
				categories: #('Refactory-Testing').
	self executeRefactoring: refactoring.
	newClass := model classNamed: #FooTest.
	self assert: newClass superclass equals: superClass.
	self assert: (superClass subclasses includes: newClass).
	self assert: newClass metaclass superclass equals: superClass metaclass.
	self assert: (superClass metaclass subclasses includes: newClass metaclass).
	self assert: subclass superclass equals: newClass.
	self assert: (newClass subclasses includes: subclass).
	self assert: subclass metaclass superclass equals: newClass metaclass.
	self assert: (newClass metaclass subclasses includes: subclass metaclass).
	self assert: newClass kindOfSubclass equals: 'subclass:'.
	self deny: newClass isNonInstantiable!

testModelExistingClassName
	self shouldFail: (AddClassRefactoring
				model: model
				addClass: #Foo
				superclass: Object
				subclasses: #()
				categories: #('Refactory-Testing'))
		existingVariable: #Foo!

testModelNonImmediateSubclass
	| refactoring |
	refactoring := AddClassRefactoring
				model: model
				addClass: #Foo2
				superclass: Object
				subclasses: {model classNamed: #Bar}
				categories: #('Refactory-Testing').
	self shouldFail: refactoring withMessage: 'Bar is not an immediate subclass of Core.Object'!

testNonImmediateSubclass
	self shouldFail: (AddClassRefactoring
				addClass: #Foo
				superclass: CompositeLintRuleTestData
				subclasses: {BasicLintRuleTestData}
				categories: #('Refactory-Tesing'))
		withMessage: 'Refactory.Browser.TestData.BasicLintRuleTestData is not an immediate subclass of Refactory.Browser.TestData.CompositeLintRuleTestData'!

testSubclassIsMetaclass
	self shouldFail: (AddClassRefactoring
				addClass: #Foo
				superclass: LintRuleTestData
				subclasses: {CompositeLintRuleTestData class}
				categories: #('Refactory-Testing'))
		withMessage: 'Subclass must not be a metaclass'!

testSuperclassIsMetaclass
	self shouldFail: (AddClassRefactoring
				addClass: #Foo
				superclass: self class class
				subclasses: #()
				categories: #('Refactory-Testing'))
		withMessage: 'Superclass must not be a metaclass'! !
!Refactory.Browser.Tests.AddClassRefactoringTest categoriesForMethods!
setUp!public!set up! !
testAddClass!public!tests! !
testAddNamespaceClass!public!tests! !
testAddRootClass!public!tests! !
testAddVariableByteClass!public!tests! !
testAddVariableClass!public!tests! !
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

