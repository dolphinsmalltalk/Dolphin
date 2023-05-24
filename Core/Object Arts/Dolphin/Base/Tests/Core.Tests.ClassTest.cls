"Filed out from Dolphin Smalltalk"!

Core.Tests.ClassDescriptionTest
	subclass: #'Core.Tests.ClassTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.ClassTest guid: (Core.GUID fromString: '{3c2fe318-ee64-4a1e-8b1a-8bf38c6d1803}')!
Core.Tests.ClassTest comment: ''!
!Core.Tests.ClassTest methodsFor!

allClassHierarchyInstancesDo: aMonadicValuable
	Smalltalk allClasses do: aMonadicValuable!

testAllRoots
	| roots |
	roots := Class allRoots.
	self assert: roots first identicalTo: Object.
	roots do: [:each | self assertIsNil: each superclass]!

testClassBindingNames
	self assert: Object classBindingNames asSortedArray
		equals: #('_AssertionFailureSignal' '_DependentsRegister' '_EventsRegister' '_PropertyRegister')!

testClassPoolsWellFormed
	"https://github.com/dolphinsmalltalk/Dolphin/issues/562"

	| badPools |
	badPools := Smalltalk allClasses reject: 
					[:each |
					| classVars |
					classVars := each classPool.
					classVars class == Dictionary and: 
							[each classPool associations
								allSatisfy: [:v | v class == VariableBinding and: [v environment == each]]]].
	self assert: badPools asArray equals: #()!

testClassVariableNames
	self assert: Object classVariableNames asSortedArray
		equals: #('_AssertionFailureSignal' '_DependentsRegister' '_EventsRegister' '_PropertyRegister').
	self assert: Kernel classVariableNames equals: #()!

testComparing
	"See also testLessOrEqual - here we are mainly interested in testing the spaceship operators"
	| tempClass tempNamespace |
	self assert: Kernel.MemoryManager <= Kernel.MemoryManager.
	self assert: Kernel.MemoryManager <=> Kernel.MemoryManager equals: 0.
	self assert: Kernel.MemoryManager <==> Kernel.MemoryManager equals: 0.
	self assert: Kernel.MemoryManager <= Core.Message.
	self assert: Kernel.MemoryManager <=> Core.Message equals: -1.
	self assert: Kernel.MemoryManager <==> Core.Message equals: -1.
	self deny: Kernel.MemoryManager <= Core.Magnitude.
	self assert: Kernel.MemoryManager <=> Core.Magnitude equals: 1.
	self assert: Kernel.MemoryManager <==> Core.Magnitude equals: 1.
	"Same short name"
	self assert: Core.Tests <= Kernel.Tests.
	self assert: Core.Tests <=> Kernel.Tests equals: -1.
	self assert: Core.Tests <==> Kernel.Tests equals: -1.
	self deny: Kernel.Tests <= Core.Tests.
	self assert: Kernel.Tests <=> Core.Tests equals: 1.
	self assert: Kernel.Tests <==> Core.Tests equals: 1.
	"class cf Meta"
	self assert: Core.Tests <= Core.Tests class.
	self assert: Core.Tests <=> Core.Tests class equals: -1.
	self assert: Core.Tests <==> Core.Tests class equals: -1.
	self deny: Core.Tests class <= Core.Tests.
	self assert: Core.Tests class <=> Core.Tests equals: 1.
	self assert: Core.Tests class <==> Core.Tests equals: 1.
	"Case difference in short name only"
	tempClass := self class newAnonymousSubclass.
	tempClass setName: #Classtest environment: Core.Tests.
	self deny: self class <= tempClass.
	self assert: self class <=> tempClass equals: 0.
	self assert: self class <==> tempClass equals: 1.
	self assert: tempClass <= self class.
	self assert: tempClass <=> self class equals: 0.
	self assert: tempClass <==> self class equals: -1.
	"Case different in environment name (only)"
	tempNamespace := Core.Tests newAnonymousSubclass.
	tempNamespace setName: #tests environment: Core.
	tempClass setName: #ClassTest environment: tempNamespace.
	self deny: self class <= tempClass.
	self assert: self class <=> tempClass equals: 0.
	self assert: self class <==> tempClass equals: 1.
	self assert: tempClass <= self class.
	self assert: tempClass <=> self class equals: 0.
	self assert: tempClass <==> self class equals: -1.!

testImportsValid
	Smalltalk allClasses do: [:each | self assert: (each imports allSatisfy: [:i | i isDefined])]!

testIncludesNamespace
	self assert: (Root includesNamespace: Root).
	self assert: (Root includesNamespace: nil).
	self deny: (Root includesNamespace: Smalltalk).
	self assert: (Smalltalk includesNamespace: Root).
	self assert: (Smalltalk includesNamespace: nil).
	self assert: (Core includesNamespace: Core).
	self assert: (Core includesNamespace: Root).
	self deny: (Core includesNamespace: Kernel).
	self deny: (Core includesNamespace: Smalltalk).
	self assert: (Core.Tests includesNamespace: Core).
	self assert: (Core.Tests includesNamespace: Root).
	self assert: (Class includesNamespace: Class).
	self assert: (Class includesNamespace: ClassDescription).
	self assert: (Class includesNamespace: Behavior).
	self assert: (Class includesNamespace: Object).
	self assert: (Class includesNamespace: nil).

!

testLessOrEqual
	self assert: ArithmeticError <= ArithmeticError description: 'Classes must be <= to themselves'.
	self assert: ArithmeticError <= ArithmeticError class
		description: 'Classes must be <= their Metaclass'.
	self assert: ArithmeticError <= ArithmeticValue.
	self assert: ArithmeticError <= ArithmeticValue class.
	self deny: ArithmeticValue <= ArithmeticError.
	self deny: ArithmeticValue <= ArithmeticError class.
	self assert: Behavior <= Class.
	self assert: Behavior <= Behavior.
	self deny: Behavior <= Array.
	"Namespaces"
	self assert: Root <= Smalltalk.
	self assert: Root <= Root.
	self deny: Root <= Core.
	self assert: Core <= Root.
	self assert: Smalltalk <= Smalltalk.
	self deny: Smalltalk <= Root.
	self assert: Core <= Kernel.
	self deny: Kernel <= Core.
	self assert: Core <= Core.
	"Classes in Namespaces"
	self assert: Core.Tests <= Kernel.Tests.
	self assert: Core.Tests <= Core.Tests.
	self deny: Kernel.Tests <= Core.Tests.
	self assert: TestCase <= TestCaseResult!

testNestedClasses
	| expected actual |
	expected := (Smalltalk allClasses select: [:each | each environment == Smalltalk]) asSet.
	actual := Smalltalk nestedClasses.
	self assert: actual size equals: expected size.
	self assert: actual asSet equals: expected!

testPoolBinding
	"Should be able to resolve imported pool bindings from the class"

	self assert: (Exception fullBindingFor: 'WS_CHILD') notNil.
	"But the imports are private, and so not be exported as externally resolvable names"
	self assert: (Smalltalk fullBindingFor: 'Exception.WS_CHILD') isNil!

testShortName
	"The short name of a class is the minimally qualified name required to bind it starting from the Smalltalk namespace"

	"Object, a root class, is in Core, which is imported into Smalltalk, so bindable using its unqualified name"

	self assert: Object shortName equals: 'Object'.
	"Non-root imported classes"
	self assert: Kernel.CompiledMethod shortName equals: #CompiledMethod.
	self assert: External.DynamicLinkLibraryStub shortName equals: #DynamicLinkLibraryStub.
	"Class requireing a fully-qualified short name"
	self assert: TestRunConsoleLogger shortName equals: 'XProgramming.SUnit.TestRunConsoleLogger'.
	"Aliased class"
	self assert: Smalltalk.ExternalAddress shortName equals: #Address.
	"The short name of a class in a nested namespace should be qualified with the short name of its namespace, not necessarily the full name"
	self assert: self class shortName equals: 'Tests.ClassTest'.
	"Core is imported before Kernel, so Tests in Core is bindable unqualified, but Kernel.Tests is not"
	self assert: Kernel.Tests.NamespaceTest shortName equals: 'Kernel.Tests.NamespaceTest'! !
!Core.Tests.ClassTest categoriesForMethods!
allClassHierarchyInstancesDo:!helpers!private! !
testAllRoots!public!unit tests! !
testClassBindingNames!public! !
testClassPoolsWellFormed!public!unit tests! !
testClassVariableNames!public! !
testComparing!public! !
testImportsValid!public!unit tests! !
testIncludesNamespace!public!unit tests! !
testLessOrEqual!public!unit tests! !
testNestedClasses!public!unit tests! !
testPoolBinding!public!unit tests! !
testShortName!public!unit tests! !
!

