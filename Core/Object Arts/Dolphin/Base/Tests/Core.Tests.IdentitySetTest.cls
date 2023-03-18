"Filed out from Dolphin Smalltalk"!

Core.Tests.AbstractSetTest
	subclass: #'Core.Tests.IdentitySetTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.IdentitySetTest guid: (Core.GUID fromString: '{4c3d7f4f-1cd5-4604-9ab0-a069e23eac65}')!
Core.Tests.IdentitySetTest comment: ''!
!Core.Tests.IdentitySetTest methodsFor!

collectionClass
	^IdentitySet!

testAddIfAbsent
	| subject element1 element2 |
	subject := self newEmpty.
	element1 := 'a'.
	self assert: (subject addIfAbsent: element1) identicalTo: 'a'.
	self assert: subject asArray equals: {element1}.
	self assert: (subject addIfAbsent: element1) identicalTo: 'a'.
	element2 := String with: $a.
	self assert: (subject addIfAbsent: element2) identicalTo: element2.
	self assert: (subject includes: element2).
	self assert: subject asArray equals: {element1. element2}! !
!Core.Tests.IdentitySetTest categoriesForMethods!
collectionClass!helpers!private! !
testAddIfAbsent!public! !
!

