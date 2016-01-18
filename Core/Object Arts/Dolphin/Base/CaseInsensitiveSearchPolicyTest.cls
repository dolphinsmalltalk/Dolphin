"Filed out from Dolphin Smalltalk 7"!

SearchPolicyTest subclass: #CaseInsensitiveSearchPolicyTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
CaseInsensitiveSearchPolicyTest guid: (GUID fromString: '{9F0ABF77-47AA-49CB-8B9B-96343696CB2E}')!
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
!CaseInsensitiveSearchPolicyTest categoriesFor: #policyClass!private!unit tests! !
!CaseInsensitiveSearchPolicyTest categoriesFor: #testCompareWith!public!unit tests! !

