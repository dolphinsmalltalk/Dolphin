"Filed out from Dolphin Smalltalk"!

Core.Tests.AssociationTest
	subclass: #'Kernel.Tests.VariableBindingTest'
	instanceVariableNames: ''
	classVariableNames: 'TestClassVar'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'TestClassConst' -> 16r1 }!
Kernel.Tests.VariableBindingTest guid: (Core.GUID fromString: '{dcc8c223-2afb-4398-8a76-d777493f6b70}')!
Kernel.Tests.VariableBindingTest comment: ''!
!Kernel.Tests.VariableBindingTest methodsFor!

testAbsoluteName
	self assert: Object binding absoluteName equals: 'Root.Core.Object'.
	self assert: (_PrimitiveFailureCode bindingFor: 'InvalidParameter') absoluteName
		equals: 'Root.Kernel._PrimitiveFailureCode.InvalidParameter'!

testFullName
	self assert: Object binding fullName equals: 'Core.Object'.
	self assert: (_PrimitiveFailureCode bindingFor: 'InvalidParameter') fullName
		equals: 'Kernel._PrimitiveFailureCode.InvalidParameter'!

testFullyQualifiedReference
	{Object. XProgramming.SUnit. XProgramming.SUnit.TestCase. Root. Smalltalk}
		do: [:each | self assert: each binding fullyQualifiedReference equals: each fullyQualifiedReference]!

testIsClassBinding
	| subject |
	subject := Object binding.
	self assert: subject isClassBinding.
	self assert: subject identicalTo: (Core localBindingFor: #Object).
	self assert: Smalltalk binding isClassBinding.
	self assert: (Root bindingFor: #Core) isClassBinding.
	self assert: Root binding isClassBinding.
	"A traditional global variable that is not a class"
	self deny: (Core bindingFor: #Processor) isClassBinding.
	"An 'old-name' alias for a class"
	self deny: (Smalltalk bindingFor: #ExternalHandle) isClassBinding!

testRefersToLiteral
	| method subject |
	method := self class lookupMethod: testSelector.
	subject := Object binding.
	self assert: (method refersToLiteral: subject).
	self assert: (subject refersToLiteral: subject ).
	self assert: (subject refersToLiteral: Object ).
	"Shouldn't matter that the ref is fully qualified (makes no difference to compiled literals)"
	self assert: (method refersToLiteral: Core.Association).
	self assert: (method refersToLiteral: Core.Association binding).
	"A ref to a class in a namespace is implicitly a reference to the namespace - necessary for refactorings to find all references that may need renaming when renaming a namespace (for example)"
	self assert: (method refersToLiteral: Core.Association environment).
	"But the browser's search for references to VariableBindings, which means we don't want to see these"
	self deny: (method refersToLiteral: Core.Association environment binding).

	"We need even a ref to a class variable that is 'local' (i.e. defined in the class hierarchy) to be recorded as a reference to itself."
	TestClassVar ifNil: [TestClassConst] ifNotNil: [OS.Win32Constants.GENERIC_READ].
	self deny: (method refersToLiteral: (self class fullBindingFor: 'OS')).
	self assert: (method refersToLiteral: (self class bindingFor: 'TestClassVar')).
	self assert: (method refersToLiteral: (self class bindingFor: 'TestClassConst')).
	self assert: (method refersToLiteral: self class).
	self assert: (method refersToLiteral: self class environment).

	"And we need a ref to a class variable not defined in the same class hierarchy to be recorded as a reference to the environment of the class var as well as the class var itself."
	subject := self class fullBindingFor: 'OS.Win32Constants.GENERIC_READ'.
	self assert: (method refersToLiteral: subject).
	self assert: (method refersToLiteral: subject environment).
	self assert: (method refersToLiteral: subject environment environment).
	self assert: (method refersToLiteral: subject environment environment environment)!

testShortName
	self assert: (Smalltalk bindings select: [:each | BindingReference isQualifiedName: each shortName])
		equals: #().

	"Root vars are bindable unqualified"
	self assert: (Root bindings select: [:each | BindingReference isQualifiedName: each shortName])
		equals: #().

	"Class in Core, imported into Smalltalk so bindable using an unqualified name"
	self assert: Object binding shortName equals: #Object.

	"Ditto namespace variable in Core"
	self assert: (Core bindingFor: #Processor) shortName equals: #Processor.

	"Class var or a class in Kernel, which is imported, so partially qualified name is bindable"
	self assert: (_PrimitiveFailureCode bindingFor: 'InvalidParameter') shortName
		equals: '_PrimitiveFailureCode.InvalidParameter'.

	"Class in child namespace of a Smalltalk imported namespace where the imported binding is ambiguous"
	self assert: Core.Tests binding shortName equals: #Tests.
	self assert: Core.Tests.ClassTest binding shortName equals: 'Tests.ClassTest'.
	self assert: self class environment binding shortName equals: 'Kernel.Tests'.
	self assert: self class binding shortName equals: 'Kernel.Tests.VariableBindingTest'!

testStbConvertFromVersion0_Class
	| bytes subject |
	bytes := #[33 83 84 66 32 52 32 6 2 15 0 86 97 114 105 97 98 108 101 66 105 110 100 105 110 103 178 0 0 0 6 0 0 0 79 98 106 101 99 116 154 0 0 0 18 1 0 0 7 0 0 0 68 111 108 112 104 105 110 18 1 0 0 6 0 0 0 79 98 106 101 99 116].
	self isDebug ifTrue: [Tools.STBDebugger dumpToTranscript: bytes readStream].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: VariableBinding.
	self assert: subject key identicalTo: #Object.
	self assert: subject value identicalTo: Object.
	self assert: subject isClassBinding.
	self deny: subject isClassVariable.
	self assert: subject environment identicalTo: Core!

testStbConvertFromVersion0_ClassVariable
	| bytes subject |
	bytes := #[33 83 84 66 32 52 32 6 2 15 0 86 97 114 105 97 98 108 101 66 105 110 100 105 110 103 82 0 0 0 23 0 0 0 95 65 115 115 101 114 116 105 111 110 70 97 105 108 117 114 101 83 105 103 110 97 108 6 2 6 0 83 105 103 110 97 108 82 0 0 0 17 0 0 0 97 115 115 101 114 116 105 111 110 32 102 97 105 108 117 114 101 16 0 0 0].
	self isDebug ifTrue: [Tools.STBDebugger dumpToTranscript: bytes readStream].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: VariableBinding.
	self assert: subject key equals: '_AssertionFailureSignal'.
	self assert: subject value isKindOf: Signal.
	self assert: subject value description equals: 'assertion failure'.
	self deny: subject isClassBinding.
	self assert: subject isClassVariable.
	"It's a class variable of Object of course, but we don't know that from the key/value we have, not for certain"
	self assertIsNil: subject environment!

testStbConvertFromVersion0_Global
	| bytes subject |
	bytes := #[33 83 84 66 32 52 32 6 2 15 0 86 97 114 105 97 98 108 101 66 105 110 100 105 110 103 178 0 0 0 9 0 0 0 80 114 111 99 101 115 115 111 114 64 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: VariableBinding.
	self assert: subject key identicalTo: #Processor.
	self assert: subject value identicalTo: Processor.
	self deny: subject isClassBinding.
	self deny: subject isClassVariable.
	self assert: subject environment equals: Core!

testStbConvertFromVersion0_SharedPool
	| bytes subject |
	bytes := #[33 83 84 66 32 52 32 6 2 15 0 86 97 114 105 97 98 108 101 66 105 110 100 105 110 103 178 0 0 0 22 0 0 0 95 73 110 115 116 97 110 99 101 66 101 104 97 118 105 111 114 77 97 115 107 115 202 0 0 0 154 0 0 0 18 1 0 0 7 0 0 0 68 111 108 112 104 105 110 18 1 0 0 23 0 0 0 80 111 111 108 67 111 110 115 116 97 110 116 115 68 105 99 116 105 111 110 97 114 121 98 0 0 0 4 0 0 0 146 1 0 0 82 0 0 0 13 0 0 0 95 80 111 105 110 116 101 114 115 77 97 115 107 5 0 0 0 146 1 0 0 82 0 0 0 13 0 0 0 95 70 105 110 97 108 105 122 101 77 97 115 107 17 0 0 0 146 1 0 0 82 0 0 0 15 0 0 0 95 71 101 116 83 112 101 99 105 97 108 77 97 115 107 1 254 1 0 146 1 0 0 82 0 0 0 9 0 0 0 95 87 101 97 107 77 97 115 107 37 0 0 0].
	self isDebug ifTrue: [Tools.STBDebugger dumpToTranscript: bytes readStream].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: VariableBinding.
	self assert: subject key identicalTo: #_InstanceBehaviorMasks.
	self assert: subject value isKindOf: Smalltalk.PoolConstantsDictionary.
	subject value associations sort
		with: { '_FinalizeMask' -> 8. '_GetSpecialMask' -> 65280. '_PointersMask' -> 2. '_WeakMask' -> 18 }
		do: 
			[:v1 :v2 |
			self assert: v1 key equals: v2 key.
			self assert: v1 value equals: v2 value.
			self assert: v1 environment identicalTo: subject value].
	self deny: subject isClassBinding.
	self deny: subject isClassVariable.
	self assert: subject environment identicalTo: Smalltalk!

testStbConvertFromVersion2_Class
	| bytes subject |
	bytes := #[33 83 84 66 32 54 32 70 4 22 0 2 0 0 0 75 101 114 110 101 108 46 86 97 114 105 97 98 108 101 66 105 110 100 105 110 103 178 0 0 0 6 0 0 0 79 98 106 101 99 116 146 0 0 0 18 1 0 0 7 0 0 0 68 111 108 112 104 105 110 18 1 0 0 11 0 0 0 67 111 114 101 46 79 98 106 101 99 116 146 0 0 0 18 1 0 0 7 0 0 0 68 111 108 112 104 105 110 18 1 0 0 4 0 0 0 67 111 114 101 1 0 0 0].
	self isDebug ifTrue: [Tools.STBDebugger dumpToTranscript: bytes readStream].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: VariableBinding.
	self assert: subject key identicalTo: #Object.
	self assert: subject value identicalTo: Object.
	self assert: subject isClassBinding.
	self deny: subject isClassVariable.
	self assert: subject environment identicalTo: Core!

testStbConvertFromVersion2_ClassVariable
	| bytes subject |
	bytes := #[33 83 84 66 32 54 32 70 4 22 0 2 0 0 0 75 101 114 110 101 108 46 86 97 114 105 97 98 108 101 66 105 110 100 105 110 103 18 1 0 0 23 0 0 0 95 65 115 115 101 114 116 105 111 110 70 97 105 108 117 114 101 83 105 103 110 97 108 6 2 11 0 67 111 114 101 46 83 105 103 110 97 108 18 1 0 0 17 0 0 0 97 115 115 101 114 116 105 111 110 32 102 97 105 108 117 114 101 16 0 0 0 146 0 0 0 18 1 0 0 7 0 0 0 68 111 108 112 104 105 110 18 1 0 0 11 0 0 0 67 111 114 101 46 79 98 106 101 99 116 5 0 0 0].
	self isDebug ifTrue: [Tools.STBDebugger dumpToTranscript: bytes readStream].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: VariableBinding.
	self assert: subject key equals: '_AssertionFailureSignal'.
	self assert: subject value isKindOf: Signal.
	self assert: subject value description equals: 'assertion failure'.
	self deny: subject isClassBinding.
	self assert: subject isClassVariable.
	"It's a class variable of Object"
	self assert: subject environment identicalTo: Object!

testStbConvertFromVersion2_Global
	| bytes subject |
	bytes := #[33 83 84 66 32 54 32 70 4 22 0 2 0 0 0 75 101 114 110 101 108 46 86 97 114 105 97 98 108 101 66 105 110 100 105 110 103 178 0 0 0 9 0 0 0 80 114 111 99 101 115 115 111 114 64 0 0 0 146 0 0 0 18 1 0 0 7 0 0 0 68 111 108 112 104 105 110 18 1 0 0 4 0 0 0 67 111 114 101 1 0 0 0].
	self isDebug ifTrue: [Tools.STBDebugger dumpToTranscript: bytes readStream].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: VariableBinding.
	self assert: subject key identicalTo: #Processor.
	self assert: subject value identicalTo: Processor.
	self deny: subject isClassBinding.
	self deny: subject isClassVariable.
	self assert: subject environment equals: Core!

testStbConvertFromVersion2_SharedPool
	| bytes subject pool var |
	bytes := #[33 83 84 66 32 54 32 70 4 22 0 2 0 0 0 75 101 114 110 101 108 46 86 97 114 105 97 98 108 101 66 105 110 100 105 110 103 178 0 0 0 1 0 0 0 65 38 1 21 0 75 101 114 110 101 108 46 80 111 111 108 68 105 99 116 105 111 110 97 114 121 3 0 0 0 146 1 0 0 18 1 0 0 4 0 0 0 115 101 108 102 208 1 0 0 208 1 0 0 1 0 0 0 146 1 0 0 18 1 0 0 1 0 0 0 97 247 0 0 0 208 1 0 0 1 0 0 0 146 1 0 0 18 1 0 0 1 0 0 0 98 145 3 0 0 208 1 0 0 1 0 0 0 48 0 0 0 1 0 0 0].
	self isDebug ifTrue: [Tools.STBDebugger dumpToTranscript: bytes readStream].
	subject := Object fromBinaryStoreBytes: bytes.
	self assert: subject isKindOf: VariableBinding.
	self assert: subject key identicalTo: #A.
	self assert: subject environment identicalTo: Smalltalk.
	pool := subject value.
	self assert: pool isKindOf: PoolDictionary.
	var := pool associationAt: 'b'.
	self assert: var isKindOf: VariableBinding.
	self assert: var environment identicalTo: pool.
	self assert: var key equals: 'b'.
	self assert: var value equals: 456.
	self deny: var isClassVariable.
	var := pool associationAt: 'self'.
	self assert: var isKindOf: VariableBinding.
	self assert: var environment identicalTo: pool.
	self assert: var key equals: 'self'.
	self assert: var value identicalTo: pool.
	self deny: var isClassVariable! !
!Kernel.Tests.VariableBindingTest categoriesForMethods!
testAbsoluteName!public!unit tests! !
testFullName!public! !
testFullyQualifiedReference!public! !
testIsClassBinding!public! !
testRefersToLiteral!public!unit tests! !
testShortName!public! !
testStbConvertFromVersion0_Class!public!unit tests! !
testStbConvertFromVersion0_ClassVariable!public!unit tests! !
testStbConvertFromVersion0_Global!public!unit tests! !
testStbConvertFromVersion0_SharedPool!public!unit tests! !
testStbConvertFromVersion2_Class!public!unit tests! !
testStbConvertFromVersion2_ClassVariable!public!unit tests! !
testStbConvertFromVersion2_Global!public!unit tests! !
testStbConvertFromVersion2_SharedPool!public!unit tests! !
!

