"Filed out from Dolphin Smalltalk"!

DolphinTestClassResource subclass: #ClassBuilderTestClasses
	instanceVariableNames: 'testClass testSubclass1 testSubclass2 testPool1 testPool2 testPool3'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassBuilderTestClasses guid: (GUID fromString: '{b9045f26-8b7d-468f-969a-7e228869fe20}')!
ClassBuilderTestClasses comment: ''!
!ClassBuilderTestClasses categoriesForClass!Unclassified! !
!ClassBuilderTestClasses methodsFor!

compileMethods
	self compileAccessorsFor: testClass.
	self compileAccessorsFor: testSubclass1.
	self compileAccessorsFor: testSubclass2!

createClasses
	testClass := self
				createClass: #ClassBuilderTestClass
				superclass: Object
				instVars: 'var1 var2'
				pools: 'ClassBuilderTestPool1'.
	testSubclass1 := self
				createClass: #ClassBuilderTestSubClass
				superclass: testClass
				instVars: 'var3 var4'
				pools: 'ClassBuilderTestPool2'.
	testSubclass2 := self
				createClass: #ClassBuilderTestSubClass2
				superclass: testClass
				instVars: 'var3 var4'
				pools: 'ClassBuilderTestPool3 ClassBuilderTestPool2'!

createPools
	testPool1 := self createPool: #ClassBuilderTestPool1.
	testPool1
		at: 'PoolVar1' put: 'ClassBuilderTestPool1.PoolVar1';
		at: 'PoolVar2' put: 'ClassBuilderTestPool1.PoolVar2';
		at: 'PoolVar3' put: 'ClassBuilderTestPool1.PoolVar3'.
	testPool2 := self createPool: #ClassBuilderTestPool2.
	testPool2
		at: 'PoolVar1' put: 'ClassBuilderTestPool2.PoolVar1';
		at: 'PoolVar4' put: 'ClassBuilderTestPool2.PoolVar4';
		at: 'PoolVar5' put: 'ClassBuilderTestPool2.PoolVar5'.
	testPool3 := self createPool: #ClassBuilderTestPool3.
	testPool3
		at: 'PoolVar2' put: 'ClassBuilderTestPool3.PoolVar2';
		at: 'PoolVar4' put: 'ClassBuilderTestPool3.PoolVar4';
		at: 'PoolVar6' put: 'ClassBuilderTestPool3.PoolVar6'!

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
!ClassBuilderTestClasses categoriesForMethods!
compileMethods!public!unit tests! !
createClasses!private!unit tests! !
createPools!Init / Release!private! !
isAvailable!public!Testing! !
tearDown!public!Running! !
testClass!accessing!public! !
testSubclass1!accessing!public! !
testSubclass2!accessing!public! !
!

