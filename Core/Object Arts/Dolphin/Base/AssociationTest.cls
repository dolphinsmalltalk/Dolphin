"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #AssociationTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AssociationTest guid: (GUID fromString: '{c99d4b53-db6c-4b09-9f2a-7a914d14a0d1}')!
AssociationTest comment: ''!
!AssociationTest categoriesForClass!Unclassified! !
!AssociationTest methodsFor!

testIsSelfEvaluating
	| subject |
	subject := #'1' -> 2.
	self assert: subject isSelfEvaluating.
	subject value: subject.
	self deny: subject isSelfEvaluating
	

!

testPrintOn
	| subject |
	subject := #'1' -> 2.
	self assert: subject printString equals: '#''1'' -> 2'.
	subject key: #a.
	subject value: subject.
	self assert: subject printString equals: '#a -> ... a cyclic ref to an Association...'! !
!AssociationTest categoriesFor: #testIsSelfEvaluating!public! !
!AssociationTest categoriesFor: #testPrintOn!public! !

