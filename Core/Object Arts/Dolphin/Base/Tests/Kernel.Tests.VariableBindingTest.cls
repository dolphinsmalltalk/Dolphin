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
	self assert: (subject refersTo: subject asLiteralOf: method).
	self assert: (subject refersTo: Object asLiteralOf: method).
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
	self assert: (method refersToLiteral: subject environment environment environment)! !
!Kernel.Tests.VariableBindingTest categoriesForMethods!
testAbsoluteName!public!unit tests! !
testFullName!public! !
testFullyQualifiedReference!public! !
testIsClassBinding!public! !
testRefersToLiteral!public!unit tests! !
!

