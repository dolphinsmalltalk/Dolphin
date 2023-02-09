"Filed out from Dolphin Smalltalk"!

Core.Tests.AbstractSetTest subclass: #'Core.Tests.PluggableSetTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.PluggableSetTest guid: (Core.GUID fromString: '{d17cbd2e-3c2c-4508-af21-db2755f8fdc7}')!
Core.Tests.PluggableSetTest comment: ''!
!Core.Tests.PluggableSetTest methodsFor!

assertIs: copySet deepCopyOf: sourceSet
	super assertIs: copySet deepCopyOf: sourceSet.
	"Identity of search policy is preserved"
	self assert: copySet searchPolicy identicalTo: sourceSet searchPolicy!

collectionClass
	^PluggableSet!

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
	self assert: subject asArray equals: {element1}! !
!Core.Tests.PluggableSetTest categoriesForMethods!
assertIs:deepCopyOf:!private!unit tests! !
collectionClass!helpers!private! !
testAddIfAbsent!public! !
!

