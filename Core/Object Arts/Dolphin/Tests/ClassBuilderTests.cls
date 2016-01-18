"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ClassBuilderTests
	instanceVariableNames: ''
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
		poolDictionaries: ''
		category: 'Tests-Kernel-Classes'.
	self classBuilderTestClass 
		subclass: #ClassBuilderTestSubClass
		instanceVariableNames: 'var3 var4'
		classVariableNames: ''
		poolDictionaries: ''
		category: 'Tests-Kernel-Classes'.
	self classBuilderTestClass 
		subclass: #ClassBuilderTestSubClass2
		instanceVariableNames: 'var3 var4'
		classVariableNames: ''
		poolDictionaries: ''
		category: 'Tests-Kernel-Classes'!

setUp
	self makeCleanClasses.
	SmalltalkSystem current isOAD: false
!

tearDown	"make sure we're up to date here"
	self makeCleanClasses.
	SmalltalkSystem current isOAD: SessionManager current isOAD!

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

testRecompileArray
     self shouldnt: [ ArrayedCollection variableSubclass: #Array
                                        instanceVariableNames: ''
                                        classVariableNames: ''
                                        poolDictionaries: '' 
                                        category: 'Collections-Arrayed'
                                   ] raise: Error.
!

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
!ClassBuilderTests categoriesFor: #makeCleanClasses!public!Running! !
!ClassBuilderTests categoriesFor: #setUp!public!Running! !
!ClassBuilderTests categoriesFor: #tearDown!public!Running! !
!ClassBuilderTests categoriesFor: #testMoveVariable!public!Running! !
!ClassBuilderTests categoriesFor: #testRecompileArray!public!Running! !
!ClassBuilderTests categoriesFor: #testReshapeClass!public!Running! !
!ClassBuilderTests categoriesFor: #testReshapeClassWithJugglingInstVars!public!Running! !
!ClassBuilderTests categoriesFor: #testReshapeSubClass!public!Running! !
!ClassBuilderTests categoriesFor: #testUnderscoreWarning!public!Running! !

