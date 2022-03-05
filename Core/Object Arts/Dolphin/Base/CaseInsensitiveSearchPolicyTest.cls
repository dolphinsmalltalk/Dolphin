"Filed out from Dolphin Smalltalk"!

SearchPolicyTest subclass: #CaseInsensitiveSearchPolicyTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CaseInsensitiveSearchPolicyTest guid: (GUID fromString: '{9f0abf77-47aa-49cb-8b9b-96343696cb2e}')!
CaseInsensitiveSearchPolicyTest comment: ''!
!CaseInsensitiveSearchPolicyTest categoriesForClass!Unclassified! !
!CaseInsensitiveSearchPolicyTest methodsFor!

policyClass
	^CaseInsensitiveSearchPolicy!

testCompareWith
	self assert: (policy compare: 'aa' with: 'aa').
	self assert: (policy compare: 'aa' with: 'Aa').
	self assert: (policy compare: 'Aa' with: 'aa').
	self deny: (policy compare: 'Aa' with: 'a').
	self deny: (policy compare: 'a' with: 'b').
	self deny: (policy compare: 'a' with: 'ab').
! !
!CaseInsensitiveSearchPolicyTest categoriesForMethods!
policyClass!private!unit tests! !
testCompareWith!public!unit tests! !
!

