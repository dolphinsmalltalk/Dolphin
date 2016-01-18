"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SearchPolicyTest
	instanceVariableNames: 'policy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SearchPolicyTest guid: (GUID fromString: '{D8A1527D-15C9-47F0-AFBC-F7BFE4D759A5}')!
SearchPolicyTest comment: ''!
!SearchPolicyTest categoriesForClass!Unclassified! !
!SearchPolicyTest methodsFor!

policyClass
	^self subclassResponsibility!

setUp
	policy := self policyClass new!

testNewLookupTable
	self assert: policy newLookupTable searchPolicy class == self policyClass! !
!SearchPolicyTest categoriesFor: #policyClass!private!unit tests! !
!SearchPolicyTest categoriesFor: #setUp!public!unit tests! !
!SearchPolicyTest categoriesFor: #testNewLookupTable!public!unit tests! !

!SearchPolicyTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!SearchPolicyTest class categoriesFor: #isAbstract!public!Testing! !

