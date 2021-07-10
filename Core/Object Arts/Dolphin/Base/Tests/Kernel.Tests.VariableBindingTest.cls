"Filed out from Dolphin Smalltalk"!

Core.Tests.AssociationTest subclass: #'Kernel.Tests.VariableBindingTest'
	instanceVariableNames: ''
	classVariableNames: 'TestClassVar'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'TestClassConst' -> 16r1
	}!
Kernel.Tests.VariableBindingTest guid: (Core.GUID fromString: '{dcc8c223-2afb-4398-8a76-d777493f6b70}')!
Kernel.Tests.VariableBindingTest comment: ''!
!Kernel.Tests.VariableBindingTest categoriesForClass!Unclassified! !
!Kernel.Tests.VariableBindingTest methodsFor!

testAbsoluteName
	self assert: Object binding absoluteName equals: Object absoluteName.
	self assert: (_PrimitiveFailureCode bindingFor: 'InvalidParameter') absoluteName
		equals: 'Root.Kernel._PrimitiveFailureCode.InvalidParameter'!

testFullName
	self assert: Object binding fullName equals: Object fullName.
	self assert: (_PrimitiveFailureCode bindingFor: 'InvalidParameter') fullName
		equals: 'Kernel._PrimitiveFailureCode.InvalidParameter'!

testFullyQualifiedReference
	{Object. XProgramming.SUnit. XProgramming.SUnit.TestCase. Root. Smalltalk}
		do: [:each | self assert: each binding fullyQualifiedReference equals: each fullyQualifiedReference]!

testRefersToLiteral
	| method subject |
	method := self class lookupMethod: testSelector.
	self assert: (method refersToLiteral: Object binding).
	"Shouldn't matter that the ref is fully qualified (makes no difference to compiled literals)"
	self assert: (method refersToLiteral: Core.Association binding).
	"We don't want a ref to a class in a namespace to be treated as implicit reference to the namespace - not for general reference searches anyway"
	self deny: (method refersToLiteral: Core.Association environment).
	"Neither do we want a ref to a class variable that is 'local' (i.e. defined in the class hierarchy) to be recorded as a reference to itself."
	TestClassVar ifNil: [TestClassConst] ifNotNil: [OS.Win32Constants.GENERIC_READ].
	self deny: (method refersToLiteral: (self class fullBindingFor: 'OS')).
	self assert: (method refersToLiteral: (self class bindingFor: 'TestClassVar')).
	self assert: (method refersToLiteral: (self class bindingFor: 'TestClassConst')).
	self deny: (method refersToLiteral: self class).
	"But we do want a ref to a class variable not defined in the same class hierarchy to be recorded as a reference to the environment of the class var as well as the class var itself."
	subject := self class fullBindingFor: 'OS.Win32Constants.GENERIC_READ'.
	self assert: (method refersToLiteral: subject).
	self assert: (method refersToLiteral: subject environment).
	self deny: (method refersToLiteral: subject environment environment).
	self deny: (method refersToLiteral: subject environment environment environment)! !
!Kernel.Tests.VariableBindingTest categoriesForMethods!
testAbsoluteName!public!unit tests! !
testFullName!public! !
testFullyQualifiedReference!public! !
testRefersToLiteral!public!unit tests! !
!

