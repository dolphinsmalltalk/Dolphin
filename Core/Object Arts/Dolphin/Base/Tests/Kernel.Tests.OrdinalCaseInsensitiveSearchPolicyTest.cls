"Filed out from Dolphin Smalltalk"!

Core.Tests.SearchPolicyTest
	subclass: #'Kernel.Tests.OrdinalCaseInsensitiveSearchPolicyTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Kernel.Tests.OrdinalCaseInsensitiveSearchPolicyTest guid: (Core.GUID fromString: '{9f0abf77-47aa-49cb-8b9b-96343696cb2e}')!

Kernel.Tests.OrdinalCaseInsensitiveSearchPolicyTest comment: ''!

!Kernel.Tests.OrdinalCaseInsensitiveSearchPolicyTest methodsFor!

policyClass
	^OrdinalCaseInsensitiveSearchPolicy!

testCompareWith
	self assert: (policy compare: 'aa' with: 'aa').
	self assert: (policy compare: 'aa' with: 'Aa').
	self assert: (policy compare: 'Aa' with: 'aa').
	self deny: (policy compare: 'Aa' with: 'a').
	self deny: (policy compare: 'a' with: 'b').
	self deny: (policy compare: 'a' with: 'ab').
	self assert: (policy compare: 'i' with: 'I').
	self assert: (policy compare: 'I' with: 'i').
	self assert: (policy compare: $ě with: $Ě).
	"non-linguistic comparison, so German double-s not mapped"
	self deny: (policy compare: 'ß' with: 'ss')!

testHash
	self assert: (policy hash: 'aa') equals: (policy hash: 'Aa').
	self deny: (policy hash: 'aa') equals: (policy hash: 'Ab').
	self assert: (policy hash: 'i') equals: (policy hash: 'I').
	"Ordinal, not a linguistic comparison"
	self deny: (policy hash: ('i' asUppercase: (Locale named: 'tr-Tr'))) equals: (policy hash: 'I')! !

!Kernel.Tests.OrdinalCaseInsensitiveSearchPolicyTest categoriesForMethods!
policyClass!private!unit tests! !
testCompareWith!public!unit tests! !
testHash!public!unit tests! !
!

