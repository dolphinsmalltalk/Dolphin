"Filed out from Dolphin Smalltalk"!

Core.Tests.SearchPolicyTest subclass: #'Kernel.Tests.CaseInsensitiveSearchPolicyTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.CaseInsensitiveSearchPolicyTest guid: (Core.GUID fromString: '{9f0abf77-47aa-49cb-8b9b-96343696cb2e}')!
Kernel.Tests.CaseInsensitiveSearchPolicyTest comment: ''!
!Kernel.Tests.CaseInsensitiveSearchPolicyTest methodsFor!

policyClass
	^CaseInsensitiveSearchPolicy!

testCompareWith
	self assert: (policy compare: 'aa' with: 'aa').
	self assert: (policy compare: 'aa' with: 'Aa').
	self assert: (policy compare: 'Aa' with: 'aa').
	self deny: (policy compare: 'Aa' with: 'a').
	self deny: (policy compare: 'a' with: 'b').
	self deny: (policy compare: 'a' with: 'ab').
	"Ordinal, not a linguistic comparison"
	self assert: (policy compare: 'i' with: 'I').
	self assert: (policy compare: 'I' with: 'i').
	self deny: (policy compare: ((Locale named: 'tr-Tr') uppercaseString: 'i') with: 'I')!

testHash
	self assert: (policy hash: 'aa') equals: (policy hash: 'Aa').
	self deny: (policy hash: 'aa') equals: (policy hash: 'Ab').
	"Ordinal, not a linguistic comparison"
	self assert: (policy hash: 'i') equals: (policy hash: 'I').
	self deny: (policy hash: ((Locale named: 'tr-Tr') uppercaseString: 'i')) equals: (policy hash: 'I')! !
!Kernel.Tests.CaseInsensitiveSearchPolicyTest categoriesForMethods!
policyClass!private!unit tests! !
testCompareWith!public!unit tests! !
testHash!public!unit tests! !
!

