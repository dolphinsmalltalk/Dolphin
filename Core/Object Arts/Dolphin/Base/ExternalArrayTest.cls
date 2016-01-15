"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #ExternalArrayTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalArrayTest guid: (GUID fromString: '{356DAC42-9B9C-4970-87D2-BFD4846FAFA4}')!
ExternalArrayTest comment: ''!
!ExternalArrayTest categoriesForClass!Unclassified! !
!ExternalArrayTest methodsFor!

arrayClass
	^self subclassResponsibility!

canonicalizeValue: anObject 
	^self elementToValue: (self elementFromValue: anObject)!

elementFromValue: anObject 
	^anObject!

elementToValue: element 
	^element!

newArrayOfIntegers: anArray 
	^self arrayClass withAll: anArray!

newNumericArray: anInteger 
	^self newArrayOfIntegers: (1 to: anInteger)!

testAtAndAtPut
	| array |
	array := self newNumericArray: 0.
	#(-1 0 1 2) do: 
			[:each | 
			self should: [array at: each] raise: BoundsError.
			self should: [array at: each put: (self elementFromValue: each)] raise: BoundsError].
	array := self newNumericArray: 1.
	#(-1 0 2 3) do: 
			[:each | 
			self should: [array at: each] raise: BoundsError.
			self should: [array at: each put: (self elementFromValue: each)] raise: BoundsError].
	#(1) do: 
			[:each | 
			| elem |
			elem := self elementFromValue: each.
			self assert: (array at: each put: elem) = elem.
			self assert: (self elementToValue: (array at: each)) = each].
	array := self newNumericArray: 2.
	#(-1 0 3) do: 
			[:each | 
			self should: [array at: each] raise: BoundsError.
			self should: [array at: each put: (self elementFromValue: each)] raise: BoundsError].
	#(1 2) do: 
			[:each | 
			| elem |
			elem := self elementFromValue: each.
			self assert: (array at: each put: elem) = elem.
			self assert: (self elementToValue: (array at: each)) = each].
	array := self newNumericArray: 3.
	#(-1 0 4) do: 
			[:each | 
			self should: [array at: each] raise: BoundsError.
			self should: [array at: each put: (self elementFromValue: each)] raise: BoundsError].
	#(1 2 3) do: 
			[:each | 
			| elem |
			elem := self elementFromValue: each.
			self assert: (array at: each put: elem) = elem.
			self assert: (self elementToValue: (array at: each)) = each]!

testFromToKeysAndValuesDo
	"Empty array"

	| array pairs |
	array := self newNumericArray: 0.
	pairs := OrderedCollection new.
	#(#(1 0)) do: 
			[:each | 
			array 
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue].
			self assert: pairs isEmpty].
	#(#(0 -1) #(-1 0) #(0 1) #(1 1) #(2 2) #(2 1) #(3 2)) do: 
			[:each | 
			self should: 
					[array 
						from: each first
						to: each last
						keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue]]
				raise: BoundsError.
			self assert: pairs isEmpty].
	"Array of 1 element"
	array := self newNumericArray: 1.
	#(#(1 0) #(2 1)) do: 
			[:each | 
			array 
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue].
			self assert: pairs isEmpty].
	#(#(1 1)) do: 
			[:each | 
			| expected |
			pairs := OrderedCollection new.
			array 
				from: 1
				to: 1
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString].
			expected := (each first to: each last) collect: [:i | i -> (self canonicalizeValue: i) printString].
			self assert: pairs asArray = expected].
	#(#(1 2) #(2 2) #(3 2)) do: 
			[:each | 
			self should: 
					[array 
						from: each first
						to: each last
						keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString]]
				raise: BoundsError].
	pairs := OrderedCollection new.
	"Array of two elements"
	array := self newNumericArray: 2.
	#(#(1 0) #(2 1) #(3 2)) do: 
			[:each | 
			array 
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString].
			self assert: pairs isEmpty].
	#(#(1 1) #(1 2) #(2 2)) do: 
			[:each | 
			| expected |
			pairs := OrderedCollection new.
			array 
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString].
			expected := (each first to: each last) collect: [:i | i -> (self canonicalizeValue: i) printString].
			self assert: pairs asArray = expected].
	#(#(1 3) #(2 3) #(3 3)) do: 
			[:each | 
			self should: 
					[array 
						from: each first
						to: each last
						keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString]]
				raise: BoundsError].
	"Array of three elements"
	pairs := OrderedCollection new.
	array := self newNumericArray: 3.
	#(#(1 0) #(2 1) #(3 2) #(4 3)) do: 
			[:each | 
			array 
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString].
			self assert: pairs isEmpty].
	#(#(1 1) #(1 2) #(2 2) #(1 3) #(2 3) #(3 3)) do: 
			[:each | 
			| expected |
			pairs := OrderedCollection new.
			array 
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString].
			expected := (each first to: each last) collect: [:i | i -> (self canonicalizeValue: i) printString].
			self assert: pairs asArray = expected].
	#(#(1 4) #(2 4) #(3 4) #(4 4)) do: 
			[:each | 
			self should: 
					[array 
						from: each first
						to: each last
						keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString]]
				raise: BoundsError]! !
!ExternalArrayTest categoriesFor: #arrayClass!constants!private! !
!ExternalArrayTest categoriesFor: #canonicalizeValue:!private!unit tests! !
!ExternalArrayTest categoriesFor: #elementFromValue:!private!unit tests! !
!ExternalArrayTest categoriesFor: #elementToValue:!private!unit tests! !
!ExternalArrayTest categoriesFor: #newArrayOfIntegers:!helpers!private! !
!ExternalArrayTest categoriesFor: #newNumericArray:!helpers!private! !
!ExternalArrayTest categoriesFor: #testAtAndAtPut!public!unit tests! !
!ExternalArrayTest categoriesFor: #testFromToKeysAndValuesDo!public!unit tests! !

!ExternalArrayTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!ExternalArrayTest class categoriesFor: #isAbstract!public!Testing! !

