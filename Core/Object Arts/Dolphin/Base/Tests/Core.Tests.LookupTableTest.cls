"Filed out from Dolphin Smalltalk"!

Core.Tests.AbstractDictionaryTest
	subclass: #'Core.Tests.LookupTableTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.LookupTableTest guid: (Core.GUID fromString: '{5c366850-2830-493e-a387-2a621f4bc8b2}')!
Core.Tests.LookupTableTest comment: ''!
!Core.Tests.LookupTableTest methodsFor!

assertIs: copyDictionary deepCopyOf: sourceDictionary
	| visited |
	self deny: copyDictionary identicalTo: sourceDictionary.
	self deny: copyDictionary basicValues identicalTo: sourceDictionary basicValues.
	visited := IdentityDictionary with: copyDictionary -> sourceDictionary.
	self
		assertIs: copyDictionary keys asSortedArray
		deepCopyOf: sourceDictionary keys asSortedArray
		visited: visited.
	self
		assertIs: copyDictionary values asSortedArray
		deepCopyOf: sourceDictionary values asSortedArray
		visited: visited!

collectionClass
	^LookupTable!

testImmutability
	| subject |
	subject := self newDictionary.
	subject isImmutable: true.
	"Attempt to add new key"
	self should: [subject at: #key2 put: (self assimilate: 2)] raise: Processor constWriteSignal.
	"Attempt to modify value associated with existing key - checks that the values are immutable too"
	self should: [subject at: #key put: (self assimilate: 1.2)] raise: Processor constWriteSignal.
	self deny: (subject includesKey: #key2).
	self assert: (subject at: #key) equals: 1.
	subject isImmutable: false.
	subject at: #key2 put: (self assimilate: 2).
	self assert: (subject at: #key2) equals: 2.
	subject at: #key put: (self assimilate: 1.2).
	self assert: (subject at: #key) equals: 1.2
! !
!Core.Tests.LookupTableTest categoriesForMethods!
assertIs:deepCopyOf:!private!unit tests! !
collectionClass!helpers!private! !
testImmutability!public! !
!

