"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #ClassBuilderTests
	instanceVariableNames: 'wasOAD'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ClassBuilderTests guid: (GUID fromString: '{889ced5d-011b-4995-82ec-dcc53ee38da2}')!

ClassBuilderTests comment: ''!

!ClassBuilderTests categoriesForClass!Tests-Kernel-Classes! !

!ClassBuilderTests methodsFor!

classBuilderTestClass
	| tc |
	tc := ClassBuilderTestClasses current testClass.
	"Sanity check that the test class is correctly packaged so will be uninstalled on tear down of the resource"
	self assert: tc owningPackage identicalTo: tc owningPackage.
	^tc!

classBuilderTestSubclass1
	^ClassBuilderTestClasses current testSubclass1!

classBuilderTestSubclass2
	^ClassBuilderTestClasses current testSubclass2!

makeCleanClasses
	ClassBuilderTestClasses isAvailable ifTrue: [ClassBuilderTestClasses current createClasses]!

setUp
	wasOAD := SmalltalkSystem current isOAD.
	SmalltalkSystem current isOAD: false!

tearDown
	"make sure we're up to date here"

	SmalltalkSystem current isOAD: wasOAD.
	^super tearDown!

testAddClassInstVars
	| testClass testMeta offset |
	testClass := self classBuilderTestClass.
	testMeta := testClass class.
	testMeta instanceVariableNames: ''.
	self assert: testMeta instanceVariableString equals: ''.
	"Due to a known bug, we have to regrab the Metaclass instance each time"
	testMeta :=testClass class.
	offset := Class instSize.
	self assert: testMeta instSize equals: offset.
	testMeta instanceVariableNames: 'a b'.
	testMeta := testClass class.
	self assert: testMeta instanceVariableString equals: 'a b'.
	self assert: testMeta instSize equals: offset + 2.
	testMeta withAllSubclasses
		do: [:each | offset + 1 to: each instSize do: [:i | each instanceClass instVarAt: i put: i]].
	testMeta instanceVariableNames: 'b c a'.
	testMeta := testClass class.
	self assert: testMeta instanceVariableString equals: 'b c a'.
	self assert: testMeta instSize equals: offset + 3.
	testMeta withAllSubclasses do: 
			[:each |
			self assert: (each instanceClass instVarAt: offset + 1) equals: offset + 2.
			self assert: (each instanceClass instVarAt: offset + 2) equals: nil.
			self assert: (each instanceClass instVarAt: offset + 3) equals: offset + 1]!

testAddRemovePools
	self assert: self classBuilderTestSubclass1 allSharedPoolNames
		equals: #(#ClassBuilderTestPool2 #ClassBuilderTestPool1) , Object sharedPoolNames.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool2.PoolVar1'.
	"PoolVar1 is defined in local pool, TestPool2, but also in inherited pool, TestPool1"
	"PoolVar2 is inherited from ref to TestPool1 in base class"
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool1.PoolVar2'.
	"Ditto PoolVar3"
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	"And pool var 4 is from local ref to TestPool2"
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar4') value
		equals: 'ClassBuilderTestPool2.PoolVar4'.
	self classBuilderTestClass
		subclass: #ClassBuilderTestSubClass
		instanceVariableNames: 'var3 var4'
		classVariableNames: ''
		poolDictionaries: 'ClassBuilderTestPool1 ClassBuilderTestPool2'
		classInstanceVariableNames: ''.
	"Names remain the same, but in reverse order because we added previously inherited pool first"
	self assert: self classBuilderTestSubclass1 allSharedPoolNames
		equals: #(#ClassBuilderTestPool1 #ClassBuilderTestPool2) , Object sharedPoolNames.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool1.PoolVar1'.
	"Because we have added TestPool1 before TestPool2, we will now bind to PoolVar1 from there."
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool1.PoolVar2'.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar4') value
		equals: 'ClassBuilderTestPool2.PoolVar4'.
	self classBuilderTestClass
		subclass: #ClassBuilderTestSubClass
		instanceVariableNames: 'var3 var4'
		classVariableNames: ''
		poolDictionaries: 'ClassBuilderTestPool2 ClassBuilderTestPool3'
		classInstanceVariableNames: ''.
	self assert: self classBuilderTestSubclass1 allSharedPoolNames
		equals: #(#ClassBuilderTestPool2 #ClassBuilderTestPool3 #ClassBuilderTestPool1)
				, Object sharedPoolNames.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool2.PoolVar1'.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool3.PoolVar2'.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar4') value
		equals: 'ClassBuilderTestPool2.PoolVar4'.
	"Remove all the locally referenced pools, so only inheriting TestPool1"
	self classBuilderTestClass
		subclass: #ClassBuilderTestSubClass
		instanceVariableNames: 'var3 var4'
		classVariableNames: ''
		poolDictionaries: ''
		classInstanceVariableNames: ''.
	self assert: self classBuilderTestSubclass1 allSharedPoolNames
		equals: #(#ClassBuilderTestPool1) , Object sharedPoolNames.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool1.PoolVar1'.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool1.PoolVar2'.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar4') equals: nil!

testBuildAnonymous
	| anon base instance |
	base := self classBuilderTestClass.
	anon := base newAnonymousSubclass.
	self assert: anon name equals: 'a subclass of ClassBuilderTestClass'.
	self assert: anon superclass identicalTo: base.
	self deny: (base subclasses includes: anon).
	self assert: anon class superclass identicalTo: base class.
	self deny: (base class subclasses includes: anon).
	base compile: 'x ^1'.
	anon compile: 'x ^2'.
	instance := anon new.
	self assert: instance isKindOf: base.
	self assert: instance class identicalTo: anon.
	self assert: instance x equals: 2
!

testBuildAnonymousRoot
	"Be very careful in creating root classes - the class is missing most required behaviour and it is very easy to crash the VM after creating instances of an insufficiently defined root class."

	| anon instance |
	anon := AnonymousClassBuilder new createNewClass.
	self deny: (Class allRoots includes: anon).
	self assert: anon name equals: 'a subclass of nil'.
	self assertIsNil: anon superclass.
	anon compile: 'printString ^''anon'''.
	instance := anon new.
	self assert: instance printString equals: 'anon'

!

testMoveClassToSuperclassWithInstVars
	| newClass |
	ClassBuilder moveClass: self classBuilderTestSubclass1 toSuperclass: Object.
	newClass := self classBuilderTestSubclass1.
	self assert: newClass superclass identicalTo: Object.
	self assert: newClass instVarNames equals: #('var3' 'var4').
	self assert: newClass instSize equals: 2!

testMoveClassToSuperclassWithNoInstVars
	| newClass |
	self classBuilderTestClass
		subclass: #ClassBuilderTestSubClass
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''.
	ClassBuilder moveClass: self classBuilderTestSubclass1 toSuperclass: Object.
	newClass := self classBuilderTestSubclass1.
	self assert: newClass superclass identicalTo: Object.
	self assert: newClass instVarNames equals: #().
	self assert: newClass instSize equals: 0!

testMoveVariable
	"test moving an iVar up, sideways and down"

	self makeCleanClasses.
	self assert: self classBuilderTestClass instVarNames equals: #('var1' 'var2').
	self assert: self classBuilderTestSubclass1 instVarNames equals: #('var3' 'var4').
	self assert: self classBuilderTestSubclass2 instVarNames equals: #('var3' 'var4').
	Object
		subclass: #ClassBuilderTestClass
		instanceVariableNames: 'var1 testVar var2'
		classVariableNames: ''
		poolDictionaries: ''
		category: 'Tests-Kernel-Classes'.
	self assert: self classBuilderTestClass instVarNames equals: #('var1' 'testVar' 'var2').
	self assert: self classBuilderTestSubclass1 instVarNames equals: #('var3' 'var4').
	self assert: self classBuilderTestSubclass2 instVarNames equals: #('var3' 'var4')!

testPoolVariablePrecedence
	"Base class has only pool1"

	self makeCleanClasses.
	self assert: self classBuilderTestClass allSharedPoolNames
		equals: #(#ClassBuilderTestPool1) , Object sharedPoolNames.
	self assert: (self classBuilderTestClass bindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool1.PoolVar1'.
	self assert: (self classBuilderTestClass bindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool1.PoolVar2'.
	self assert: (self classBuilderTestClass bindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	"Subclass1 has pool2 and inherits pool1"
	self assert: self classBuilderTestSubclass1 allSharedPoolNames
		equals: #(#ClassBuilderTestPool2 #ClassBuilderTestPool1) , Object sharedPoolNames.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool2.PoolVar1'.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool1.PoolVar2'.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar4') value
		equals: 'ClassBuilderTestPool2.PoolVar4'.
	self assert: (self classBuilderTestSubclass1 bindingFor: 'PoolVar5') value
		equals: 'ClassBuilderTestPool2.PoolVar5'.
	"Subclass2 has pools3 and 2 (in that order), and inherits pool1"
	self assert: self classBuilderTestSubclass2 allSharedPoolNames
		equals: #(#ClassBuilderTestPool3 #ClassBuilderTestPool2 #ClassBuilderTestPool1)
				, Object sharedPoolNames.
	self assert: (self classBuilderTestSubclass2 bindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool2.PoolVar1'.
	self assert: (self classBuilderTestSubclass2 bindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool3.PoolVar2'.
	self assert: (self classBuilderTestSubclass2 bindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	self assert: (self classBuilderTestSubclass2 bindingFor: 'PoolVar4') value
		equals: 'ClassBuilderTestPool3.PoolVar4'.
	self assert: (self classBuilderTestSubclass2 bindingFor: 'PoolVar5') value
		equals: 'ClassBuilderTestPool2.PoolVar5'.
	self assert: (self classBuilderTestSubclass2 bindingFor: 'PoolVar6') value
		equals: 'ClassBuilderTestPool3.PoolVar6'!

testReparentSubClassWithSameAllInstVars
	| testClass testInstance |
	testClass := self classBuilderTestSubclass1.
	testInstance := testClass new.
	testInstance var1: 42.
	testInstance var2: 'hello'.
	testInstance var3: 'foo'.
	testInstance var4: #bar.
	"Change the superclass and instVars of the class at the same time, such that the answer to #allInstVarNames does not change."
	Object
		subclass: #ClassBuilderTestSubClass
		instanceVariableNames: 'var1 var2 var3 var4'
		classVariableNames: ''
		poolDictionaries: ''
		category: 'Tests-Kernel-Classes'.

	"test state of new class"
	self assert: testClass instSize equals: 4.
	self assert: testClass instVarNames equals: #('var1' 'var2' 'var3' 'var4').
	self assert: testClass allInstVarNames equals: #('var1' 'var2' 'var3' 'var4').

	"test transparency of mapping. Accessors for var1 and var2 were inherited, so are no longer available."
	self assert: testInstance var3 equals: 'foo'.
	self assert: testInstance var4 equals: #bar.
	self assert: (testInstance instVarAt: 1) equals: 42.
	self assert: (testInstance instVarAt: 2) equals: 'hello'.
	self assert: (testInstance instVarAt: 3) equals: 'foo'.
	self assert: (testInstance instVarAt: 4) equals: #bar!

testReshapeClass
	"see if reshaping classes works"

	| testInstance testClass testMeta newClass newMeta |
	testClass := self classBuilderTestClass.
	testMeta := testClass class.
	testInstance := testClass new.
	testInstance var1: 42.
	testInstance var2: 'hello'.
	newClass := Object
				subclass: #ClassBuilderTestClass
				instanceVariableNames: 'foo var1 bar var2 mumble'
				classVariableNames: ''
				poolDictionaries: ''
				category: 'Tests-Kernel-Classes'.
	self assert: newClass owningPackage identicalTo: ClassBuilderTestClasses current package.
	newMeta := newClass class.

	"test transparency of mapping"
	self assert: testInstance var1 equals: 42.
	self assert: testInstance var2 equals: 'hello'.
	self assertIsNil: (testInstance instVarAt: 1).
	self assert: (testInstance instVarAt: 2) equals: 42.
	self assertIsNil: (testInstance instVarAt: 3).
	self assert: (testInstance instVarAt: 4) equals: 'hello'.
	self assertIsNil: (testInstance instVarAt: 5).

	"test transparency of reshapes"
	self assert: testInstance class identicalTo: newClass.
	self assert: testClass identicalTo: newClass.
	self assert: testMeta identicalTo: newMeta!

testReshapeClassWithJugglingInstVars
	"see if reshapes of classes juggle their instVars correctly"

	| testInstance testClass testMeta newClass newMeta |
	testClass := self classBuilderTestClass.
	testMeta := testClass class.
	testInstance := testClass new.
	testInstance perform: 'var1:' asSymbol with: 42.
	testInstance perform: 'var2:' asSymbol with: 'hello'.
	newClass := Object
				subclass: #ClassBuilderTestClass
				instanceVariableNames: 'var2 foo bar mumble var1'
				classVariableNames: ''
				poolDictionaries: ''
				category: 'Tests-Kernel-Classes'.
	newMeta := newClass class.

	"test transparency of mapping"
	self assert: (testInstance perform: 'var1' asSymbol) equals: 42.
	self assert: (testInstance perform: 'var2' asSymbol) equals: 'hello'.
	self assert: (testInstance instVarAt: 1) equals: 'hello'.
	self assertIsNil: (testInstance instVarAt: 2).
	self assertIsNil: (testInstance instVarAt: 3).
	self assertIsNil: (testInstance instVarAt: 4).
	self assert: (testInstance instVarAt: 5) equals: 42.

	"test transparency of reshapes"
	self assert: testInstance class identicalTo: newClass.
	self assert: testClass identicalTo: newClass.
	self assert: testMeta identicalTo: newMeta!

testReshapeSubClass
	"see if reshaping a class updates the instances of its subclass correctly"

	| testInstance testClass testMeta |
	self makeCleanClasses.
	testClass := self classBuilderTestSubclass1.
	testMeta := testClass class.
	testInstance := testClass new.
	testInstance var1: 42.
	testInstance var2: 'hello'.
	testInstance var3: 'foo'.
	testInstance var4: #bar.
	Object
		subclass: #ClassBuilderTestClass
		instanceVariableNames: 'var1 foo var2 bar mumble '
		classVariableNames: ''
		poolDictionaries: ''
		category: 'Tests-Kernel-Classes'.

	"test transparency of mapping"
	self assert: testInstance var1 equals: 42.
	self assert: testInstance var2 equals: 'hello'.
	self assert: testInstance var3 equals: 'foo'.
	self assert: testInstance var4 equals: #bar.
	self assert: (testInstance instVarAt: 1) equals: 42.
	self assertIsNil: (testInstance instVarAt: 2).
	self assert: (testInstance instVarAt: 3) equals: 'hello'.
	self assertIsNil: (testInstance instVarAt: 4).
	self assertIsNil: (testInstance instVarAt: 5).
	self assert: (testInstance instVarAt: 6) equals: 'foo'.
	self assert: (testInstance instVarAt: 7) equals: #bar.

	"test transparency of reshapes"
	self assert: testInstance class identicalTo: self classBuilderTestSubclass1.
	self assert: testClass identicalTo: self classBuilderTestSubclass1.
	self assert: testMeta identicalTo: self classBuilderTestSubclass1 class! !

!ClassBuilderTests categoriesForMethods!
classBuilderTestClass!public!unit tests! !
classBuilderTestSubclass1!public!unit tests! !
classBuilderTestSubclass2!public!unit tests! !
makeCleanClasses!private!Running! !
setUp!public!Running! !
tearDown!public!Running! !
testAddClassInstVars!public!unit tests! !
testAddRemovePools!public!unit tests! !
testBuildAnonymous!public!unit tests! !
testBuildAnonymousRoot!public!unit tests! !
testMoveClassToSuperclassWithInstVars!public!unit tests! !
testMoveClassToSuperclassWithNoInstVars!public!unit tests! !
testMoveVariable!public!unit tests! !
testPoolVariablePrecedence!public!unit tests! !
testReparentSubClassWithSameAllInstVars!public!unit tests! !
testReshapeClass!public!unit tests! !
testReshapeClassWithJugglingInstVars!public!unit tests! !
testReshapeSubClass!public!unit tests! !
!

!ClassBuilderTests class methodsFor!

resources
	^Array with: ClassBuilderTestClasses! !

!ClassBuilderTests class categoriesForMethods!
resources!Accessing!public! !
!

