"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SearchPolicyTest
	instanceVariableNames: 'policy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!SearchPolicyTest categoriesFor: #policyClass!private!unit tests! !
!SearchPolicyTest categoriesFor: #setUp!public!unit tests! !
!SearchPolicyTest categoriesFor: #testNewLookupTable!public!unit tests! !

