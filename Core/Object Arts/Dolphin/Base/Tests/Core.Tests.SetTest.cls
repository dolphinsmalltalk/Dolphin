"Filed out from Dolphin Smalltalk"!

Core.Tests.AbstractSetTest
	subclass: #'Core.Tests.SetTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.SetTest guid: (Core.GUID fromString: '{2108692a-0ee3-46ea-a9d6-46b3227871c6}')!

Core.Tests.SetTest comment: ''!

!Core.Tests.SetTest methodsFor!

collectionClass
	^Set!

testAddIfAbsent
	| subject element1 element2 |
	subject := self newEmpty.
	element1 := 'a'.
	self assert: (subject addIfAbsent: element1) identicalTo: 'a'.
	self assert: subject asArray equals: {element1}.
	self assert: (subject addIfAbsent: element1) identicalTo: 'a'.
	element2 := String with: $a.
	self assert: (subject addIfAbsent: element2) identicalTo: element1.
	self assert: (subject includes: element2).
	self assert: subject asArray equals: {element1}!

testAllHealthy
	"Test whether all subinstances are correctly hashed."

	| unhealthy |
	unhealthy := Set primAllSubinstances reject: [:each | each isHealthy].
	self assert: unhealthy equals: #()!

testEquals
	"Sets and IdentitySets are equal if they have the same elements"

	| set setb |
	super testEquals.
	"Elements are compared with #=; Integer 1 is equal to Float 1.0"
	set := self newSet: #(1).
	setb := self newSet: #(1.0).
	self assertCommutativelyEqual: set other: setb! !

!Core.Tests.SetTest categoriesForMethods!
collectionClass!helpers!private! !
testAddIfAbsent!public! !
testAllHealthy!public! !
testEquals!public!unit tests! !
!

