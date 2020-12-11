"Filed out from Dolphin Smalltalk 7"!

Core.Tests.AssociationTest subclass: #'Kernel.Tests.VariableBindingTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
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
		do: [:each | self assert: each binding fullyQualifiedReference equals: each fullyQualifiedReference]! !
!Kernel.Tests.VariableBindingTest categoriesFor: #testAbsoluteName!public!unit tests! !
!Kernel.Tests.VariableBindingTest categoriesFor: #testFullName!public! !
!Kernel.Tests.VariableBindingTest categoriesFor: #testFullyQualifiedReference!public! !

