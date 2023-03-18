"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.SearchPolicyTest'
	instanceVariableNames: 'policy'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.SearchPolicyTest guid: (Core.GUID fromString: '{d8a1527d-15c9-47f0-afbc-f7bfe4d759a5}')!
Core.Tests.SearchPolicyTest isNonInstantiable: true!
Core.Tests.SearchPolicyTest comment: ''!
!Core.Tests.SearchPolicyTest methodsFor!

policyClass
	^self subclassResponsibility!

setUp
	policy := self policyClass new!

testNewLookupTable
	self assert: policy newLookupTable searchPolicy class identicalTo: self policyClass! !
!Core.Tests.SearchPolicyTest categoriesForMethods!
policyClass!private!unit tests! !
setUp!public!unit tests! !
testNewLookupTable!public!unit tests! !
!

