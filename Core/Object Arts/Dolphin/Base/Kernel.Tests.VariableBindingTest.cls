"Filed out from Dolphin Smalltalk 7"!

AssociationTest subclass: #VariableBindingTest
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
VariableBindingTest guid: (GUID fromString: '{dcc8c223-2afb-4398-8a76-d777493f6b70}')!
VariableBindingTest comment: ''!
!VariableBindingTest categoriesForClass!Unclassified! !
!VariableBindingTest methodsFor!

testAbsoluteName
	self assert: Object binding absoluteName equals: Object absoluteName.
	self assert: (_PrimitiveFailureCode bindingAt: 'InvalidParameter') absoluteName
		equals: 'Root.Smalltalk._PrimitiveFailureCode.InvalidParameter'!

testFullName
	self assert: Object binding fullName equals: Object fullName.
	self assert: (_PrimitiveFailureCode bindingAt: 'InvalidParameter') fullName
		equals: '_PrimitiveFailureCode.InvalidParameter'! !
!VariableBindingTest categoriesFor: #testAbsoluteName!public!unit tests! !
!VariableBindingTest categoriesFor: #testFullName!public! !

