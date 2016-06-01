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

assimilate: aSmallInteger 
	^aSmallInteger!

assimilateElements: aCollection 
	^aCollection asArray collect: [:each | self assimilate: each]!

newCollection: aCollection
	^self collectionClass withAll: (self assimilateElements: aCollection)!

testDistinct
	| result |
	#(#() #($a) #($a $a) #($a $b) #($a $b $a) #($a $b $c $a $e)) do: 
			[:array |
			| testSubject |
			testSubject := self newCollection: array.
			result := testSubject distinct.
			self assert: testSubject species = result species.
			self assert: testSubject asSet size = result size.
			self assert: (result noDifference: testSubject asSet).
			(result class conformsToProtocol: #sequencedReadableCollection)
				ifTrue: 
					["Order should be preserved"
					self assert: testSubject asSet asSortedCollection asArray = result asArray]]!

testFold
	| result |
	#(#($c) #($c $e) #($e $c) #($c $b $e) #($e $b $c) #($b $e $c) #($b $c $e)) do: 
			[:array |
			| expected testSubject |
			testSubject := self newCollection: array.
			result := testSubject fold: [:max :each | each max: max].
			expected := testSubject asArray asSortedCollection last.
			self assert: result = expected].
	self should: [(self newCollection: #()) fold: [:a :b | a max b]] raise: Error.
	1 to: 100
		do: 
			[:i |
			result := (1 to: i) fold: [:product :each | product * each].
			self assert: result = i factorial]! !
!DolphinCollectionTest categoriesFor: #assimilate:!private!unit tests! !
!DolphinCollectionTest categoriesFor: #assimilateElements:!helpers!private! !
!DolphinCollectionTest categoriesFor: #newCollection:!helpers!private! !
!DolphinCollectionTest categoriesFor: #testDistinct!public!unit tests! !
!DolphinCollectionTest categoriesFor: #testFold!public!unit tests! !

!DolphinCollectionTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!DolphinCollectionTest class categoriesFor: #isAbstract!public!Testing! !

