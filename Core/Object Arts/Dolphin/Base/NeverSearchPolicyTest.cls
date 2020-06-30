"Filed out from Dolphin Smalltalk 7"!

SearchPolicyTest subclass: #NeverSearchPolicyTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
NeverSearchPolicyTest guid: (GUID fromString: '{64679112-614d-4f64-b585-6f9ef68a703d}')!
NeverSearchPolicyTest comment: ''!
!NeverSearchPolicyTest categoriesForClass!Unclassified! !
!NeverSearchPolicyTest methodsFor!

policyClass
	^NeverSearchPolicy!

testCompareWith
	self assert: (policy compare: false with: false) not.
	self assert: (policy compare: false with: true) not.
	self assert: (policy compare: true with: false) not.
	self assert: (policy compare: true with: true) not.
	self assert: (policy compare: 'a' with: 'a') not.
	self assert: (policy compare: 'a' with: 'A') not.
	self assert: (policy compare: 'a' with: 'b') not.
	self assert: (policy compare: 1 with: 1) not.
	self assert: (policy compare: 1 with: 2) not.
	self assert: (policy compare: 2 with: 1) not.
	self assert: (policy compare: nil with: nil) not.
	self assert: (policy compare: Object new with: Object new) not.
	self assert: (policy compare: #hash with: #hash) not.
	self assert: (policy compare: #hash with: #identityHash) not.
	self assert: (policy compare: $a with: $a) not.
	self assert: (policy compare: $a with: $b) not! !
!NeverSearchPolicyTest categoriesFor: #policyClass!private!unit tests! !
!NeverSearchPolicyTest categoriesFor: #testCompareWith!public!unit tests! !

