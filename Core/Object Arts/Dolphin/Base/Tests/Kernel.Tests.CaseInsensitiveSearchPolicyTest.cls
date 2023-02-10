"Filed out from Dolphin Smalltalk"!

Core.Tests.SearchPolicyTest
	subclass: #'Kernel.Tests.CaseInsensitiveSearchPolicyTest'
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
	self assert: (policy compare: 'i' with: 'I').
	self assert: (policy compare: 'I' with: 'i').
	self assert: (policy compare: $ě with: $Ě).
	"linguistic comparison - German double-s is mapped"
	self assert: (policy compare: 'ß' with: 'ss').
	"Also ligatures, e.g. U+FB03 - Latin Small Ligature Ffi"
	self assert: (policy compare: $ﬃ asString with: 'ffi')!

testHash
	self assert: (policy hash: 'aa') equals: (policy hash: 'Aa').
	self deny: (policy hash: 'aa') equals: (policy hash: 'Ab').
	self assert: (policy hash: 'i') equals: (policy hash: 'I').
	self deny: (policy hash: 'İ') equals: (policy hash: 'i').
	"Multi-character mapping"
	self assert: (policy hash: 'ß') equals: (policy hash: 'ss').
	"Also ligatures, e.g. U+FB03 - Latin Small Ligature Ffi should have same hash as individual letters"
	self assert: (policy hash: $ﬃ asString) equals: (policy hash: 'ffi')! !
!Kernel.Tests.CaseInsensitiveSearchPolicyTest categoriesForMethods!
policyClass!private!unit tests! !
testCompareWith!public!unit tests! !
testHash!public!unit tests! !
!

