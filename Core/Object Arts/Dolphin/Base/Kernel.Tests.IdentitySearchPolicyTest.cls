"Filed out from Dolphin Smalltalk 7"!

Core.Tests.SearchPolicyTest subclass: #'Kernel.Tests.IdentitySearchPolicyTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.IdentitySearchPolicyTest guid: (Core.GUID fromString: '{05134366-7e1d-469d-98b0-5b757f38592b}')!
Kernel.Tests.IdentitySearchPolicyTest comment: ''!
!Kernel.Tests.IdentitySearchPolicyTest categoriesForClass!Unclassified! !
!Kernel.Tests.IdentitySearchPolicyTest methodsFor!

policyClass
	^IdentitySearchPolicy!

testCompareWith
	self assert: (policy compare: false with: false).
	self assert: (policy compare: false with: true) not.
	self assert: (policy compare: true with: false) not.
	self assert: (policy compare: true with: true).
	"Due to an optimisation in Dophin's compiler this will be true"
	self assert: (policy compare: 'a' with: 'a').
	self assert: (policy compare: (String with: $a) with: (String with: $a)) not.
	self assert: (policy compare: 'a' with: 'A') not.
	self assert: (policy compare: 'a' with: 'b') not.
	self assert: (policy compare: 1 with: 1).
	self assert: (policy compare: 1 with: 2) not.
	self assert: (policy compare: 2 with: 1) not.
	self assert: (policy compare: nil with: nil).
	self assert: (policy compare: Object new with: Object new) not.
	self assert: (policy compare: String new with: String new) not.
	self assert: (policy compare: #hash with: #hash).
	self assert: (policy compare: 'hash' with: 'hash' copy) not.
	self assert: (policy compare: $a with: $a).
	self assert: (policy compare: $a with: $b) not! !
!Kernel.Tests.IdentitySearchPolicyTest categoriesFor: #policyClass!public!unit tests! !
!Kernel.Tests.IdentitySearchPolicyTest categoriesFor: #testCompareWith!public!unit tests! !

