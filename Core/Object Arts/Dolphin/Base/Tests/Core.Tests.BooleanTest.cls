"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.BooleanTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.BooleanTest guid: (Core.GUID fromString: '{5aa57122-600d-4018-870d-8425b90179b2}')!
Core.Tests.BooleanTest isNonInstantiable: true!
Core.Tests.BooleanTest comment: ''!
!Core.Tests.BooleanTest methodsFor!

subjectClass
	^self subclassResponsibility!

testNew
	self should: [self subjectClass new] raise: Error! !
!Core.Tests.BooleanTest categoriesForMethods!
subjectClass!constants!private! !
testNew!public!testing! !
!

