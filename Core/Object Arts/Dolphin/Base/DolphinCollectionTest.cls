"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #DolphinCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinCollectionTest guid: (GUID fromString: '{C0608062-BC41-43CF-AEFC-C89E6B500E6D}')!
DolphinCollectionTest comment: ''!
!DolphinCollectionTest categoriesForClass!Unclassified! !
!DolphinCollectionTest methodsFor!

testFold
	| result |
	#(#(3) #(3 5) #(5 3) #(3 2 5) #(5 2 3) #(2 5 3) #(2 3 5)) do: 
			[:array | 
			| expected |
			result := array fold: [:max :each | each max: max].
			expected := array asSortedCollection last.
			self assert: result = expected.
			result := array asSet fold: [:max :each | each max: max].
			self assert: result = expected].
	self should: [#() fold: [:a :b | a max b]] raise: Error.
	1 to: 100
		do: 
			[:i | 
			result := (1 to: i) fold: [:product :each | product * each].
			self assert: result = i factorial]!

testIsNilOrEmpty
	self assert: #() isNilOrEmpty.
	self deny: #(nil) isNilOrEmpty.! !
!DolphinCollectionTest categoriesFor: #testFold!public!unit tests! !
!DolphinCollectionTest categoriesFor: #testIsNilOrEmpty!public!testing / testing! !

