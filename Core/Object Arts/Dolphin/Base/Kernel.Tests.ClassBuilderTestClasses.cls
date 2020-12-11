"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTestClassResource subclass: #'Kernel.Tests.ClassBuilderTestClasses'
	instanceVariableNames: 'testClass testSubclass1 testSubclass2 testPool1 testPool2 testPool3 classesDirtied'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.ClassBuilderTestClasses guid: (Core.GUID fromString: '{b9045f26-8b7d-468f-969a-7e228869fe20}')!
Kernel.Tests.ClassBuilderTestClasses comment: ''!
!Kernel.Tests.ClassBuilderTestClasses categoriesForClass!Unclassified! !
!Kernel.Tests.ClassBuilderTestClasses methodsFor!

compileMethods
	self compileAccessorsFor: testClass.
	self compileAccessorsFor: testSubclass1.
	self compileAccessorsFor: testSubclass2!

createClasses
	classesDirtied := false.
	testClass := self
				createClass: #ClassBuilderTestClass
				superclass: Object
				instVars: 'var1 var2'
				pools: 'ClassBuilderTestPool1'
				classVars: 'Var1 Var2'.
	testSubclass1 := self
				createClass: #'Kernel.Tests.ClassBuilderTestSubClass'
				superclass: testClass
				instVars: 'var3 var4'
				pools: 'ClassBuilderTestPool2'
				classVars: ''.
	testSubclass2 := self
				createClass: #'Root.ClassBuilderTestSubClass2'
				superclass: testClass
				instVars: 'var3 var4'
				pools: 'ClassBuilderTestPool3 ClassBuilderTestPool2'
				classVars: ''!

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

makeCleanClasses
	classesDirtied := true!

tearDown
	super tearDown.
	testClass := testSubclass1 := testSubclass2 := nil!

testClass
	classesDirtied ifTrue: [self createClasses].
	^testClass!

testSubclass1
	classesDirtied ifTrue: [self createClasses].
	^testSubclass1!

testSubclass2
	classesDirtied ifTrue: [self createClasses].
	^testSubclass2! !
!Kernel.Tests.ClassBuilderTestClasses categoriesFor: #compileMethods!public!unit tests! !
!Kernel.Tests.ClassBuilderTestClasses categoriesFor: #createClasses!private!unit tests! !
!Kernel.Tests.ClassBuilderTestClasses categoriesFor: #createPools!Init / Release!private! !
!Kernel.Tests.ClassBuilderTestClasses categoriesFor: #isAvailable!public!Testing! !
!Kernel.Tests.ClassBuilderTestClasses categoriesFor: #makeCleanClasses!private!unit tests! !
!Kernel.Tests.ClassBuilderTestClasses categoriesFor: #tearDown!public!Running! !
!Kernel.Tests.ClassBuilderTestClasses categoriesFor: #testClass!accessing!public! !
!Kernel.Tests.ClassBuilderTestClasses categoriesFor: #testSubclass1!accessing!public! !
!Kernel.Tests.ClassBuilderTestClasses categoriesFor: #testSubclass2!accessing!public! !

