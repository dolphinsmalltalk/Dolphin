"Filed out from Dolphin Smalltalk"!

Core.Tests.LookupTableTest
	subclass: #'Core.Tests.DeferredValueTableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.DeferredValueTableTest guid: (Core.GUID fromString: '{f7404400-6b8f-4fd7-ae47-8018e8aacb30}')!
Core.Tests.DeferredValueTableTest comment: ''!
!Core.Tests.DeferredValueTableTest methodsFor!

assimilate: anObject
	^[anObject]!

collectionClass
	^DeferredValueTable!

testAdd
	| subject assoc1 assoc2 |
	subject := self newDictionary.
	assoc1 := subject newAssociation: #key2 value: (self assimilate: 2).
	subject add: assoc1.
	self assert: (subject associationAt: #key2) value equals: assoc1 value value.
	assoc2 := subject newAssociation: #key value: (self assimilate: 3).
	subject add: assoc2.
	self assert: (subject associationAt: #key) value equals: assoc2 value value! !
!Core.Tests.DeferredValueTableTest categoriesForMethods!
assimilate:!private!unit tests! !
collectionClass!helpers!private! !
testAdd!public!unit tests! !
!

!Core.Tests.DeferredValueTableTest class methodsFor!

allTestSelectors
	^super allTestSelectors
		remove: #testStrongTalkTests;
		yourself! !
!Core.Tests.DeferredValueTableTest class categoriesForMethods!
allTestSelectors!Accessing!public! !
!

