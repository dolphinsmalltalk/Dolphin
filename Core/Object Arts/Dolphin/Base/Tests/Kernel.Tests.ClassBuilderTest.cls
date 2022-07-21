"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest subclass: #'Kernel.Tests.ClassBuilderTest'
	instanceVariableNames: 'wasOAD dirtiedClasses'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.ClassBuilderTest guid: (Core.GUID fromString: '{889ced5d-011b-4995-82ec-dcc53ee38da2}')!
Kernel.Tests.ClassBuilderTest comment: ''!
!Kernel.Tests.ClassBuilderTest categoriesForClass!Tests-Kernel-Classes! !
!Kernel.Tests.ClassBuilderTest methodsFor!

classBuilderTestClass
	| tc |
	tc := ClassBuilderTestClasses current testClass.
	"Sanity check that the test class is correctly packaged so will be uninstalled on tear down of the resource"
	self assert: tc owningPackage identicalTo: tc owningPackage.
	"Also that the class pool is well formed"
	self assert: tc classPool isHealthy.
	tc bindingsDo: 
			[:each |
			self assert: each isKindOf: VariableBinding.
			self assert: each environment identicalTo: tc.
			self assert: each isClassVariable].
	^tc!

classBuilderTestSubclass1
	^ClassBuilderTestClasses current testSubclass1!

classBuilderTestSubclass2
	^ClassBuilderTestClasses current testSubclass2!

newTestSubjectToModify: aClass
	^(ClassBuilder forModifying: aClass)
		beQuiet;
		yourself!

setUp
	dirtiedClasses := false.
	wasOAD := Smalltalk developmentSystem isOAD.
	Smalltalk developmentSystem isOAD: false!

tearDown
	"make sure we're up to date here"

	dirtiedClasses ifTrue: [ClassBuilderTestClasses current makeCleanClasses].
	Smalltalk developmentSystem isOAD: wasOAD.
	^super tearDown!

testAddClassInstVars
	| testClass testMeta offset |
	testClass := self classBuilderTestClass.
	testMeta := testClass class.
	testMeta instanceVariableNames: ''.
	self assert: testMeta instanceVariableString equals: ''.
	"Due to a known bug, we have to regrab the Metaclass instance each time"
	testMeta := testClass class.
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

testAddInstVarName
	| testClass obj inst |
	testClass := self classBuilderTestClass.
	testClass addInstVarName: 'foo' asUtf16String.
	testClass compile: 'foo: anObject foo := anObject';
		compile: 'foo ^foo'.
	obj := Object new.
	inst := testClass new foo: obj.
	self assert: inst foo identicalTo: obj
	!

testAddRemoveImports
	| imports subclass |
	imports := self classBuilderTestSubclass1 allImports.
	self assert: (imports allSatisfy: [:each | each isKindOf: NamespaceImport]).
	self assert: imports
		equals: #(#{Smalltalk.ClassBuilderTestPool2} #{Smalltalk.ClassBuilderTestPool1}) , Object imports.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool2.PoolVar1'.
	"PoolVar1 is defined in local pool, TestPool2, but also in inherited pool, TestPool1"
	"PoolVar2 is inherited from ref to TestPool1 in base class"
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool1.PoolVar2'.
	"Ditto PoolVar3"
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	"And pool var 4 is from local ref to TestPool2"
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar4') value
		equals: 'ClassBuilderTestPool2.PoolVar4'.
	subclass := (self newTestSubjectToModify: self classBuilderTestSubclass1)
				instanceVariables: #('var3' 'var4');
				imports: #(#{ClassBuilderTestPool1} #{ClassBuilderTestPool2});
				modifyOrCreate.
	dirtiedClasses := true.
	self assert: subclass identicalTo: self classBuilderTestSubclass1.
	"Names remain the same, but in reverse order because we added previously inherited pool first"
	imports := subclass allImports.
	self assert: (imports allSatisfy: [:each | each isKindOf: NamespaceImport]).
	self assert: imports
		equals: #(#{Smalltalk.ClassBuilderTestPool1} #{Smalltalk.ClassBuilderTestPool2}) , Object imports.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool1.PoolVar1'.
	"Because we have added TestPool1 before TestPool2, we will now bind to PoolVar1 from there."
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool1.PoolVar2'.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar4') value
		equals: 'ClassBuilderTestPool2.PoolVar4'.
	subclass := (self newTestSubjectToModify: subclass)
				imports: #(#{ClassBuilderTestPool2} #{ClassBuilderTestPool3} #{ClassBuilderTestPoolMissing});
				modifyOrCreate.
	self assert: subclass identicalTo: self classBuilderTestSubclass1.
	imports := subclass allImports.
	self assert: (imports allSatisfy: [:each | each isKindOf: NamespaceImport]).
	self assert: imports
		equals: #(#{Smalltalk.ClassBuilderTestPool2} #{Smalltalk.ClassBuilderTestPool3} #{Smalltalk.ClassBuilderTestPoolMissing} #{Smalltalk.ClassBuilderTestPool1})
				, Object imports.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool2.PoolVar1'.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool3.PoolVar2'.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar4') value
		equals: 'ClassBuilderTestPool2.PoolVar4'.
	"Remove all the locally referenced pools, so only inheriting TestPool1"
	subclass := (self newTestSubjectToModify: subclass)
				imports: #();
				modifyOrCreate.
	self assert: subclass identicalTo: self classBuilderTestSubclass1.
	imports := subclass allImports.
	self assert: (imports allSatisfy: [:each | each isKindOf: NamespaceImport]).
	self assert: imports equals: #(#{Smalltalk.ClassBuilderTestPool1}) , Object imports.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool1.PoolVar1'.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool1.PoolVar2'.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar4') equals: nil.
	dirtiedClasses := true!

testBuildAnonymous
	| anon base instance |
	base := self classBuilderTestClass.
	anon := base newAnonymousSubclass.
	self assert: anon environment identicalTo: base environment.
	self assert: anon name equals: 'a subclass of ', base name.
	self assert: anon fullName equals: 'a subclass of ', base fullName.
	self assert: anon superclass identicalTo: base.
	self deny: (base subclasses includes: anon).
	self assert: anon class superclass identicalTo: base class.
	self deny: (base class subclasses includes: anon).
	base basicCompile: 'x ^1'.
	anon basicCompile: 'x ^2'.
	instance := anon new.
	self assert: instance isKindOf: base.
	self assert: instance class identicalTo: anon.
	self assert: instance x equals: 2
!

testBuildAnonymousInRootNamespace
	| anon base |
	base := self class.
	anon := (ClassBuilder forAnonymousSubclassOf: base)
				environment: Root;
				createNewClass.
	self assert: anon environment identicalTo: Root.
	self assert: anon name equals: 'a subclass of ' , base name.
	self assert: anon fullName equals: 'a subclass of ' , base fullName.
	self
		should: [anon basicCompile: 'x ^Object']
		raise: Kernel.CompilerErrorNotification
		matching: [:ex | ex errorCode = Kernel.ParseErrorCodes.CErrUndeclared]!

testBuildAnonymousRootClass
	"Be very careful in creating root classes - the class is missing most required behaviour and it is very easy to crash the VM after creating instances of an insufficiently defined root class."

	| anon instance |
	anon := AnonymousClassBuilder new createNewClass.
	self deny: (Class allRoots includes: anon).
	self assert: anon name equals: 'a subclass of nil'.
	self assertIsNil: anon superclass.
	anon compile: 'printString ^''anon'''.
	instance := anon new.
	self assert: instance printString equals: 'anon'!

testClassVars
	| testClass |
	testClass := self classBuilderTestClass.
	self
		assert: ((testClass classVariables collect: 
					[:each |
					self assert: each isKindOf: VariableBinding.
					self assert: each environment identicalTo: testClass.
					self assert: each isClassVariable.
					each key])
				noDifference: #('Var1' 'Var2')).
	#namespaceToDo	"Test add/remove class variable, add/remove class constant, change immediate constant to variable, change constant to variable, change variable to immediate constant, change variable to constant."!

testCreateSubclassWithSameUnqualifiedName
	| testSubclass subject |
	subject := ClassBuilder new
				superclass: self classBuilderTestSubclass1;
				className: #ClassBuilderTestSubClass;
				beQuiet;
				yourself.
	testSubclass := subject modifyOrCreate.
	ClassBuilder removeClass: testSubclass!

testFullName
	self assert: self classBuilderTestClass fullName equals: 'Smalltalk.ClassBuilderTestClass'.
	self assert: self classBuilderTestSubclass1 fullName equals: 'Kernel.Tests.ClassBuilderTestSubClass'.
	self assert: self classBuilderTestSubclass2 fullName equals: 'ClassBuilderTestSubClass2'!

testIsValidIdentifier
	#('' ' ' '9' '9a' '?' 'a?' '_' 'a ' ' a')
		do: [:each | self deny: (ClassBuilder isValidIdentifier: each)].
	#('_a' 'a' 'aAZz' 'a9_') do: [:each | self assert: (ClassBuilder isValidIdentifier: each)]!

testMoveClassToSuperclassWithInstVars
	| newClass oldClass namespace |
	oldClass := self classBuilderTestSubclass1.
	namespace := oldClass environment.
	ClassBuilder moveClass: oldClass toSuperclass: Object.
	newClass := self classBuilderTestSubclass1.
	self assert: newClass superclass identicalTo: Object.
	self assert: newClass instanceVariableNames equals: #('var3' 'var4').
	self assert: newClass instSize equals: 2.
	self assert: newClass environment identicalTo: namespace.
	dirtiedClasses := true!

testMoveClassToSuperclassWithNoInstVars
	| newClass |
	(self newTestSubjectToModify: self classBuilderTestSubclass1)
		instanceVariables: #();
		modifyOrCreate.
	newClass := (self newTestSubjectToModify: self classBuilderTestSubclass1)
				superclass: Object;
				modifyOrCreate.
	self assert: newClass superclass identicalTo: Object.
	self assert: newClass instanceVariableNames equals: #().
	self assert: newClass instSize equals: 0.
	dirtiedClasses := true!

testMoveVariable
	"test moving an iVar up, sideways and down"

	self assert: self classBuilderTestClass instanceVariableNames equals: #('var1' 'var2').
	self assert: self classBuilderTestSubclass1 instanceVariableNames equals: #('var3' 'var4').
	self assert: self classBuilderTestSubclass2 instanceVariableNames equals: #('var3' 'var4').
	(ClassBuilder forModifying: self classBuilderTestClass)
		instanceVariables: #('var1' 'testVar' 'var2');
		beQuiet;
		modifyOrCreate.
	self assert: self classBuilderTestClass instanceVariableNames equals: #('var1' 'testVar' 'var2').
	self assert: self classBuilderTestSubclass1 instanceVariableNames equals: #('var3' 'var4').
	self assert: self classBuilderTestSubclass2 instanceVariableNames equals: #('var3' 'var4').
	dirtiedClasses := true!

testPoolVariablePrecedence
	"Base class has only pool1"

	self assert: self classBuilderTestClass allSharedPoolNames
		equals: #(#ClassBuilderTestPool1) , Object sharedPoolNames.
	self assert: (self classBuilderTestClass fullBindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool1.PoolVar1'.
	self assert: (self classBuilderTestClass fullBindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool1.PoolVar2'.
	self assert: (self classBuilderTestClass fullBindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	"Subclass1 has pool2 and inherits pool1"
	self assert: self classBuilderTestSubclass1 allSharedPoolNames
		equals: #(#ClassBuilderTestPool2 #ClassBuilderTestPool1) , Object sharedPoolNames.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool2.PoolVar1'.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool1.PoolVar2'.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar4') value
		equals: 'ClassBuilderTestPool2.PoolVar4'.
	self assert: (self classBuilderTestSubclass1 fullBindingFor: 'PoolVar5') value
		equals: 'ClassBuilderTestPool2.PoolVar5'.
	"Subclass2 has pools3 and 2 (in that order), and inherits pool1"
	self assert: self classBuilderTestSubclass2 allSharedPoolNames
		equals: #(#ClassBuilderTestPool3 #ClassBuilderTestPool2 #ClassBuilderTestPool1)
				, Object sharedPoolNames.
	self assert: (self classBuilderTestSubclass2 fullBindingFor: 'PoolVar1') value
		equals: 'ClassBuilderTestPool2.PoolVar1'.
	self assert: (self classBuilderTestSubclass2 fullBindingFor: 'PoolVar2') value
		equals: 'ClassBuilderTestPool3.PoolVar2'.
	self assert: (self classBuilderTestSubclass2 fullBindingFor: 'PoolVar3') value
		equals: 'ClassBuilderTestPool1.PoolVar3'.
	self assert: (self classBuilderTestSubclass2 fullBindingFor: 'PoolVar4') value
		equals: 'ClassBuilderTestPool3.PoolVar4'.
	self assert: (self classBuilderTestSubclass2 fullBindingFor: 'PoolVar5') value
		equals: 'ClassBuilderTestPool2.PoolVar5'.
	self assert: (self classBuilderTestSubclass2 fullBindingFor: 'PoolVar6') value
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
	(self newTestSubjectToModify: testClass)
		instanceVariables: #('var1' 'var2' 'var3' 'var4');
		superclass: Object;
		modifyOrCreate.

	"test state of new class"
	self assert: testClass instSize equals: 4.
	self assert: testClass instanceVariableNames equals: #('var1' 'var2' 'var3' 'var4').
	self assert: testClass allInstanceVariableNames equals: #('var1' 'var2' 'var3' 'var4').

	"test transparency of mapping. Accessors for var1 and var2 were inherited, so are no longer available."
	self assert: testInstance var3 equals: 'foo'.
	self assert: testInstance var4 equals: #bar.
	self assert: (testInstance instVarAt: 1) equals: 42.
	self assert: (testInstance instVarAt: 2) equals: 'hello'.
	self assert: (testInstance instVarAt: 3) equals: 'foo'.
	self assert: (testInstance instVarAt: 4) equals: #bar.
	dirtiedClasses := true!

testReshapeClass
	"see if reshaping classes works"

	| testInstance testClass testMeta newClass newMeta |
	testClass := self classBuilderTestClass.
	testMeta := testClass class.
	testInstance := testClass new.
	testInstance var1: 42.
	testInstance var2: 'hello'.
	newClass := (self newTestSubjectToModify: testClass)
				instanceVariables: #('foo' 'var1' 'bar' 'var2' 'mumble');
				modifyOrCreate.
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
	self assert: testMeta identicalTo: newMeta.
	dirtiedClasses := true!

testReshapeClassWithJugglingInstVars
	"see if reshapes of classes juggle their instVars correctly"

	| testInstance testClass testMeta newClass newMeta |
	testClass := self classBuilderTestClass.
	testMeta := testClass class.
	testInstance := testClass new.
	testInstance perform: 'var1:' asSymbol with: 42.
	testInstance perform: 'var2:' asSymbol with: 'hello'.
	newClass := (self newTestSubjectToModify: testClass)
				instanceVariables: #('var2' 'foo' 'bar' 'mumble' 'var1');
				modifyOrCreate.
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
	self assert: testMeta identicalTo: newMeta.
	dirtiedClasses := true!

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
	(self newTestSubjectToModify: self classBuilderTestClass)
		instanceVariables: #('var1' 'foo' 'var2' 'bar' 'mumble');
		modifyOrCreate.
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
	self assert: testMeta identicalTo: self classBuilderTestSubclass1 class.
	dirtiedClasses := true!

testValidateImports
	| subject |
	subject := self newTestSubjectToModify: self class.
	subject imports: (Compiler
				evaluate: '#(#{Tests.DolphinTest private} #{TestCase private} #{Core.Tests.DolphinTest} #{DolphinTest} #{SUnit.TestCase private})').
	subject validateImports.
	"The final import is unbindable, and left unchanged. If imported privately and non-privately, the private import should be dropped."
	self assert: subject imports
		equals: #(#{Core.Tests.DolphinTest} #{XProgramming.SUnit.TestCase private} #{SUnit.TestCase private})! !
!Kernel.Tests.ClassBuilderTest categoriesForMethods!
classBuilderTestClass!public!unit tests! !
classBuilderTestSubclass1!public!unit tests! !
classBuilderTestSubclass2!public!unit tests! !
newTestSubjectToModify:!helpers!private! !
setUp!public!Running! !
tearDown!public!Running! !
testAddClassInstVars!public!unit tests! !
testAddInstVarName!public!unit tests! !
testAddRemoveImports!public!unit tests! !
testBuildAnonymous!public!unit tests! !
testBuildAnonymousInRootNamespace!public!unit tests! !
testBuildAnonymousRootClass!public!unit tests! !
testClassVars!public!unit tests! !
testCreateSubclassWithSameUnqualifiedName!public!unit tests! !
testFullName!public!unit tests! !
testIsValidIdentifier!public!unit tests! !
testMoveClassToSuperclassWithInstVars!public!unit tests! !
testMoveClassToSuperclassWithNoInstVars!public!unit tests! !
testMoveVariable!public!unit tests! !
testPoolVariablePrecedence!public!unit tests! !
testReparentSubClassWithSameAllInstVars!public!unit tests! !
testReshapeClass!public!unit tests! !
testReshapeClassWithJugglingInstVars!public!unit tests! !
testReshapeSubClass!public!unit tests! !
testValidateImports!public!unit tests! !
!

!Kernel.Tests.ClassBuilderTest class methodsFor!

resources
	^{ClassBuilderTestClasses}! !
!Kernel.Tests.ClassBuilderTest class categoriesForMethods!
resources!Accessing!public! !
!

