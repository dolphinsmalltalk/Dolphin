"Filed out from Dolphin Smalltalk 7"!

DolphinTestClassResource subclass: #ClassBuilderTestClasses
	instanceVariableNames: 'testClass testSubclass1 testSubclass2'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassBuilderTestClasses guid: (GUID fromString: '{B9045F26-8B7D-468F-969A-7E228869FE20}')!
ClassBuilderTestClasses comment: ''!
!ClassBuilderTestClasses categoriesForClass!Unclassified! !
!ClassBuilderTestClasses methodsFor!

createClasses
	testClass := self 
				createClass: #ClassBuilderTestClass
				superclass: Object
				instVars: 'var1 var2'.
	self compileAccessorsFor: testClass.
	testSubclass1 := self 
				createClass: #ClassBuilderTestSubClass
				superclass: testClass
				instVars: 'var3 var4'.
	self compileAccessorsFor: testSubclass1.
	testSubclass2 := self 
				createClass: #ClassBuilderTestSubClass2
				superclass: testClass
				instVars: 'var3 var4'.
	self compileAccessorsFor: testSubclass2!

isAvailable
	^testClass notNil!

tearDown
	super tearDown.
	testClass := testSubclass1 := testSubclass2 := nil!

testClass
	^testClass!

testSubclass1
	^testSubclass1!

testSubclass2
	^testSubclass2! !
!ClassBuilderTestClasses categoriesFor: #createClasses!public!unit tests! !
!ClassBuilderTestClasses categoriesFor: #isAvailable!public!Testing! !
!ClassBuilderTestClasses categoriesFor: #tearDown!public!Running! !
!ClassBuilderTestClasses categoriesFor: #testClass!accessing!public! !
!ClassBuilderTestClasses categoriesFor: #testSubclass1!accessing!public! !
!ClassBuilderTestClasses categoriesFor: #testSubclass2!accessing!public! !

