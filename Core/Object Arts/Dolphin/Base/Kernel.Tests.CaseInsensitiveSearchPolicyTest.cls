"Filed out from Dolphin Smalltalk 7"!

Core.Tests.SearchPolicyTest subclass: #'Kernel.Tests.CaseInsensitiveSearchPolicyTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Kernel.Tests.CaseInsensitiveSearchPolicyTest guid: (Core.GUID fromString: '{9f0abf77-47aa-49cb-8b9b-96343696cb2e}')!
Kernel.Tests.CaseInsensitiveSearchPolicyTest comment: ''!
!Kernel.Tests.CaseInsensitiveSearchPolicyTest categoriesForClass!Unclassified! !
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
! !
!Kernel.Tests.CaseInsensitiveSearchPolicyTest categoriesFor: #policyClass!private!unit tests! !
!Kernel.Tests.CaseInsensitiveSearchPolicyTest categoriesFor: #testCompareWith!public!unit tests! !

