"Filed out from Dolphin Smalltalk"!

DolphinTest subclass: #SearchPolicyTest
	instanceVariableNames: 'policy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SearchPolicyTest guid: (GUID fromString: '{d8a1527d-15c9-47f0-afbc-f7bfe4d759a5}')!

SearchPolicyTest isAbstract: true!

SearchPolicyTest comment: ''!

!SearchPolicyTest categoriesForClass!Unclassified! !

!SearchPolicyTest methodsFor!

policyClass
	^self subclassResponsibility!

setUp
	policy := self policyClass new!

testNewLookupTable
	self assert: policy newLookupTable searchPolicy class identicalTo: self policyClass! !

!SearchPolicyTest categoriesForMethods!
policyClass!private!unit tests! !
setUp!public!unit tests! !
testNewLookupTable!public!unit tests! !
!

