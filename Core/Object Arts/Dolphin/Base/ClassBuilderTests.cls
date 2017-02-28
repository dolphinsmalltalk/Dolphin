"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ClassBuilderTests
	instanceVariableNames: 'wasOAD'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ClassBuilderTests guid: (GUID fromString: '{889CED5D-011B-4995-82EC-DCC53EE38DA2}')!
ClassBuilderTests comment: ''!
!ClassBuilderTests categoriesForClass!Tests-Kernel-Classes! !
!ClassBuilderTests methodsFor!

classBuilderTestClass
	^ClassBuilderTestClasses current testClass!

classBuilderTestSubclass1
	^ClassBuilderTestClasses current testSubclass1!

classBuilderTestSubclass2
	^ClassBuilderTestClasses current testSubclass2!

makeCleanClasses
	Object
		subclass: #ClassBuilderTestClass
		instanceVariableNames: 'var1 var2'
		classVariableNames: ''
		poolDictionaries: 'ClassBuilderTestPool1'
		category: 'Tests-Kernel-Classes'.
	self classBuilderTestClass
		subclass: #ClassBuilderTestSubClass
		instanceVariableNames: 'var3 var4'
		classVariableNames: ''
		poolDictionaries: 'ClassBuilderTestPool2'
		category: 'Tests-Kernel-Classes'.
	self classBuilderTestClass
		subclass: #ClassBuilderTestSubClass2
		instanceVariableNames: 'var3 var4'
		classVariableNames: ''
		poolDictionaries: 'ClassBuilderTestPool3 ClassBuilderTestPool2'
		category: 'Tests-Kernel-Classes'!

setUp
	self makeCleanClasses.
	wasOAD := SmalltalkSystem current isOAD.
	SmalltalkSystem current isOAD: false!

tearDown
	"make sure we're up to date here"

	SmalltalkSystem current isOAD: wasOAD.
	^super tearDown!

testAddRemovePools
	self assert: #(#ClassBuilderTestPool2 #ClassBuilderTestPool1) , Object sharedPoolNames
		equals: self classBuilderTestSubclass1 allSharedPoolNames.
	self assert: 'ClassBuilderTestPool2.PoolVar1'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar1') value.
	"PoolVar1 is defined in local pool, TestPool2, but also in inherited pool, TestPool1"
	"PoolVar2 is inherited from ref to TestPool1 in base class"
	self assert: 'ClassBuilderTestPool1.PoolVar2'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar2') value.
	"Ditto PoolVar3"
	self assert: 'ClassBuilderTestPool1.PoolVar3'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar3') value.
	"And pool var 4 is from local ref to TestPool2"
	self assert: 'ClassBuilderTestPool2.PoolVar4'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar4') value.
	self classBuilderTestClass
		subclass: #ClassBuilderTestSubClass
		instanceVariableNames: 'var3 var4'
		classVariableNames: ''
		poolDictionaries: 'ClassBuilderTestPool1 ClassBuilderTestPool2'
		classInstanceVariableNames: ''.
	"Names remain the same, but in reverse order because we added previously inherited pool first"
	self assert: #(#ClassBuilderTestPool1 #ClassBuilderTestPool2) , Object sharedPoolNames
		equals: self classBuilderTestSubclass1 allSharedPoolNames.
	self assert: 'ClassBuilderTestPool1.PoolVar1'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar1') value.
	"Because we have added TestPool1 before TestPool2, we will now bind to PoolVar1 from there."
	self assert: 'ClassBuilderTestPool1.PoolVar2'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar2') value.
	self assert: 'ClassBuilderTestPool1.PoolVar3'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar3') value.
	self assert: 'ClassBuilderTestPool2.PoolVar4'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar4') value.
	self classBuilderTestClass
		subclass: #ClassBuilderTestSubClass
		instanceVariableNames: 'var3 var4'
		classVariableNames: ''
		poolDictionaries: 'ClassBuilderTestPool2 ClassBuilderTestPool3'
		classInstanceVariableNames: ''.
	self assert: #(#ClassBuilderTestPool2 #ClassBuilderTestPool3 #ClassBuilderTestPool1)
				, Object sharedPoolNames
		equals: self classBuilderTestSubclass1 allSharedPoolNames.
	self assert: 'ClassBuilderTestPool2.PoolVar1'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar1') value.
	self assert: 'ClassBuilderTestPool3.PoolVar2'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar2') value.
	self assert: 'ClassBuilderTestPool1.PoolVar3'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar3') value.
	self assert: 'ClassBuilderTestPool2.PoolVar4'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar4') value.
	"Remove all the locally referenced pools, so only inheriting TestPool1"
	self classBuilderTestClass
		subclass: #ClassBuilderTestSubClass
		instanceVariableNames: 'var3 var4'
		classVariableNames: ''
		poolDictionaries: ''
		classInstanceVariableNames: ''.
	self assert: #(#ClassBuilderTestPool1) , Object sharedPoolNames
		equals: self classBuilderTestSubclass1 allSharedPoolNames.
	self assert: 'ClassBuilderTestPool1.PoolVar1'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar1') value.
	self assert: 'ClassBuilderTestPool1.PoolVar2'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar2') value.
	self assert: 'ClassBuilderTestPool1.PoolVar3'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar3') value.
	self assert: nil equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar4')!

testMoveClassToSuperclassWithInstVars
	| newClass |
	ClassBuilder moveClass: self classBuilderTestSubclass1 toSuperclass: Object.
	newClass := self classBuilderTestSubclass1.
	self assert: newClass superclass == Object.
	self assert: newClass instVarNames = #('var3' 'var4').
	self assert: newClass instSize = 2!

testMoveClassToSuperclassWithNoInstVars
	| newClass |
	self classBuilderTestClass
		subclass: #ClassBuilderTestSubClass
		instanceVariableNames: ''
		classVariableNames: ''
		poolDictionaries: ''.
	ClassBuilder moveClass: self classBuilderTestSubclass1 toSuperclass: Object.
	newClass := self classBuilderTestSubclass1.
	self assert: newClass superclass == Object.
	self assert: newClass instVarNames = #().
	self assert: newClass instSize = 0!

testMoveVariable
	"test moving an iVar up, sideways and down"

	self assert: self classBuilderTestClass instVarNames = #('var1' 'var2').
	self assert: self classBuilderTestSubclass1 instVarNames = #('var3' 'var4').
	self assert: self classBuilderTestSubclass2 instVarNames = #('var3' 'var4').
	Object 
		subclass: #ClassBuilderTestClass
		instanceVariableNames: 'var1 testVar var2'
		classVariableNames: ''
		poolDictionaries: ''
		category: 'Tests-Kernel-Classes'.
	self assert: self classBuilderTestClass instVarNames = #('var1' 'testVar' 'var2').
	self assert: self classBuilderTestSubclass1 instVarNames = #('var3' 'var4').
	self assert: self classBuilderTestSubclass2 instVarNames = #('var3' 'var4')!

testPoolVariablePrecedence
	"Base class has only pool1"

	self assert: #(#ClassBuilderTestPool1) , Object sharedPoolNames
		equals: self classBuilderTestClass allSharedPoolNames.
	self assert: 'ClassBuilderTestPool1.PoolVar1'
		equals: (self classBuilderTestClass bindingFor: 'PoolVar1') value.
	self assert: 'ClassBuilderTestPool1.PoolVar2'
		equals: (self classBuilderTestClass bindingFor: 'PoolVar2') value.
	self assert: 'ClassBuilderTestPool1.PoolVar3'
		equals: (self classBuilderTestClass bindingFor: 'PoolVar3') value.
	"Subclass1 has pool2 and inherits pool1"
	self assert: #(#ClassBuilderTestPool2 #ClassBuilderTestPool1) , Object sharedPoolNames
		equals: self classBuilderTestSubclass1 allSharedPoolNames.
	self assert: 'ClassBuilderTestPool2.PoolVar1'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar1') value.
	self assert: 'ClassBuilderTestPool1.PoolVar2'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar2') value.
	self assert: 'ClassBuilderTestPool1.PoolVar3'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar3') value.
	self assert: 'ClassBuilderTestPool2.PoolVar4'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar4') value.
	self assert: 'ClassBuilderTestPool2.PoolVar5'
		equals: (self classBuilderTestSubclass1 bindingFor: 'PoolVar5') value.
	"Subclass2 has pools3 and 2 (in that order), and inherits pool1"
	self assert: #(#ClassBuilderTestPool3 #ClassBuilderTestPool2 #ClassBuilderTestPool1)
				, Object sharedPoolNames
		equals: self classBuilderTestSubclass2 allSharedPoolNames.
	self assert: 'ClassBuilderTestPool2.PoolVar1'
		equals: (self classBuilderTestSubclass2 bindingFor: 'PoolVar1') value.
	self assert: 'ClassBuilderTestPool3.PoolVar2'
		equals: (self classBuilderTestSubclass2 bindingFor: 'PoolVar2') value.
	self assert: 'ClassBuilderTestPool1.PoolVar3'
		equals: (self classBuilderTestSubclass2 bindingFor: 'PoolVar3') value.
	self assert: 'ClassBuilderTestPool3.PoolVar4'
		equals: (self classBuilderTestSubclass2 bindingFor: 'PoolVar4') value.
	self assert: 'ClassBuilderTestPool2.PoolVar5'
		equals: (self classBuilderTestSubclass2 bindingFor: 'PoolVar5') value.
	self assert: 'ClassBuilderTestPool3.PoolVar6'
		equals: (self classBuilderTestSubclass2 bindingFor: 'PoolVar6') value!

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
	self assert: testClass instSize = 4.
	self assert: testClass instVarNames = #('var1' 'var2' 'var3' 'var4').
	self assert: testClass allInstVarNames = #('var1' 'var2' 'var3' 'var4').

	"test transparency of mapping. Accessors for var1 and var2 were inherited, so are no longer available."
	self assert: testInstance var3 = 'foo'.
	self assert: testInstance var4 = #bar.
	self assert: (testInstance instVarAt: 1) = 42.
	self assert: (testInstance instVarAt: 2) = 'hello'.
	self assert: (testInstance instVarAt: 3) = 'foo'.
	self assert: (testInstance instVarAt: 4) = #bar!

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
	newMeta := newClass class.

	"test transparency of mapping"
	self assert: testInstance var1 = 42.
	self assert: testInstance var2 = 'hello'.
	self assert: (testInstance instVarAt: 1) isNil.
	self assert: (testInstance instVarAt: 2) = 42.
	self assert: (testInstance instVarAt: 3) isNil.
	self assert: (testInstance instVarAt: 4) = 'hello'.
	self assert: (testInstance instVarAt: 5) isNil.

	"test transparency of reshapes"
	self assert: testInstance class == newClass.
	self assert: testClass == newClass.
	"Issue: Dolphin's ClassBuilder fails here because it does not become over the metaclasses, only the classes."
	(self runKnownBug: 'ClassBuilder does not "become" metaclass' test: #testReshapeClass) 
		ifTrue: [self assert: testMeta == newMeta]!

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
	self assert: (testInstance perform: 'var1' asSymbol) = 42.
	self assert: (testInstance perform: 'var2' asSymbol) = 'hello'.
	self assert: (testInstance instVarAt: 1) = 'hello'.
	self assert: (testInstance instVarAt: 2) isNil.
	self assert: (testInstance instVarAt: 3) isNil.
	self assert: (testInstance instVarAt: 4) isNil.
	self assert: (testInstance instVarAt: 5) = 42.

	"test transparency of reshapes"
	self assert: testInstance class == newClass.
	self assert: testClass == newClass.
	"Dolphin's class builder fails because it does not become over the metaclasses."
	(self runKnownBug: 'ClassBuilder does not "become" metaclass'
		test: #testReshapeClassWithJugglingInstVars) ifTrue: [self assert: testMeta == newMeta]!

testReshapeSubClass
	"see if reshaping a class updates the instances of its subclass correctly"

	| testInstance testClass testMeta |
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
	self assert: testInstance var1 = 42.
	self assert: testInstance var2 = 'hello'.
	self assert: testInstance var3 = 'foo'.
	self assert: testInstance var4 = #bar.
	self assert: (testInstance instVarAt: 1) = 42.
	self assert: (testInstance instVarAt: 2) isNil.
	self assert: (testInstance instVarAt: 3) = 'hello'.
	self assert: (testInstance instVarAt: 4) isNil.
	self assert: (testInstance instVarAt: 5) isNil.
	self assert: (testInstance instVarAt: 6) = 'foo'.
	self assert: (testInstance instVarAt: 7) = #bar.

	"test transparency of reshapes"
	self assert: testInstance class == self classBuilderTestSubclass1.
	self assert: testClass == self classBuilderTestSubclass1.
	"Dolphin's class builder fails because it does not become over the metaclasses."
	(self runKnownBug: 'ClassBuilder does not "become" metaclass' test: #testReshapeSubClass) 
		ifTrue: [self assert: testMeta == self classBuilderTestSubclass1 class]!

testUnderscoreWarning
	"#1419"

	| testClass warning |
	testClass := self classBuilderTestClass.
	self assert: testClass classPool isEmpty.
	
	[testClass := Object 
				subclass: #ClassBuilderTestClass
				instanceVariableNames: 'var1 var2'
				classVariableNames: 'A'
				poolDictionaries: ''
				classInstanceVariableNames: ''] 
			on: Warning
			do: [:ex | warning := ex].
	self assert: warning isNil.
	
	[testClass := Object 
				subclass: #ClassBuilderTestClass
				instanceVariableNames: 'var1 var2'
				classVariableNames: '_A'
				poolDictionaries: ''
				classInstanceVariableNames: ''] 
			on: Warning
			do: [:ex | warning := ex].
	self deny: warning isNil! !
!ClassBuilderTests categoriesFor: #classBuilderTestClass!public!unit tests! !
!ClassBuilderTests categoriesFor: #classBuilderTestSubclass1!public!unit tests! !
!ClassBuilderTests categoriesFor: #classBuilderTestSubclass2!public!unit tests! !
!ClassBuilderTests categoriesFor: #makeCleanClasses!private!Running! !
!ClassBuilderTests categoriesFor: #setUp!public!Running! !
!ClassBuilderTests categoriesFor: #tearDown!public!Running! !
!ClassBuilderTests categoriesFor: #testAddRemovePools!public!Running! !
!ClassBuilderTests categoriesFor: #testMoveClassToSuperclassWithInstVars!public!Running! !
!ClassBuilderTests categoriesFor: #testMoveClassToSuperclassWithNoInstVars!public!Running! !
!ClassBuilderTests categoriesFor: #testMoveVariable!public!Running! !
!ClassBuilderTests categoriesFor: #testPoolVariablePrecedence!public!Running! !
!ClassBuilderTests categoriesFor: #testReparentSubClassWithSameAllInstVars!public!Running! !
!ClassBuilderTests categoriesFor: #testReshapeClass!public!Running! !
!ClassBuilderTests categoriesFor: #testReshapeClassWithJugglingInstVars!public!Running! !
!ClassBuilderTests categoriesFor: #testReshapeSubClass!public!Running! !
!ClassBuilderTests categoriesFor: #testUnderscoreWarning!public!Running! !

!ClassBuilderTests class methodsFor!

resources
	^Array with: ClassBuilderTestClasses! !
!ClassBuilderTests class categoriesFor: #resources!Accessing!public! !

