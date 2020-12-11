"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.AssociationTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.AssociationTest guid: (Core.GUID fromString: '{c99d4b53-db6c-4b09-9f2a-7a914d14a0d1}')!
Core.Tests.AssociationTest comment: ''!
!Core.Tests.AssociationTest categoriesForClass!Unclassified! !
!Core.Tests.AssociationTest methodsFor!

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
!Core.Tests.AssociationTest categoriesFor: #testIsSelfEvaluating!public! !
!Core.Tests.AssociationTest categoriesFor: #testPrintOn!public! !

