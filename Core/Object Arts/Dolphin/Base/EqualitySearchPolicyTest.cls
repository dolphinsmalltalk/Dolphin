"Filed out from Dolphin Smalltalk 7"!

SearchPolicyTest subclass: #EqualitySearchPolicyTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
EqualitySearchPolicyTest guid: (GUID fromString: '{753e6e11-d8ca-4aa8-a751-8b5031838d22}')!
EqualitySearchPolicyTest comment: ''!
!EqualitySearchPolicyTest categoriesForClass!Unclassified! !
!EqualitySearchPolicyTest methodsFor!

policyClass
	^EqualitySearchPolicy!

testCompareWith
	self assert: (policy compare: false with: false).
	self assert: (policy compare: false with: true) not.
	self assert: (policy compare: true with: false) not.
	self assert: (policy compare: true with: true).
	self assert: (policy compare: 'a' with: 'a').
	self assert: (policy compare: (String with: $a) with: (String with: $a)).
	self assert: (policy compare: 'a' with: 'A') not.
	self assert: (policy compare: 'a' with: 'b') not.
	self assert: (policy compare: 1 with: 1).
	self assert: (policy compare: 1 with: 2) not.
	self assert: (policy compare: 2 with: 1) not.
	self assert: (policy compare: nil with: nil).
	self assert: (policy compare: Object new with: Object new) not.
	self assert: (policy compare: String new with: String new).
	self assert: (policy compare: #hash with: #hash).
	self deny: (policy compare: #hash with: #identityHash).
	self assert: (policy compare: $a with: $a).
	self assert: (policy compare: $a with: $b) not! !
!EqualitySearchPolicyTest categoriesFor: #policyClass!public!unit tests! !
!EqualitySearchPolicyTest categoriesFor: #testCompareWith!public!unit tests! !

